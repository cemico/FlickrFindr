//
//  SearchViewController.swift
//  Flickr Findr
//
//  Created by Dave Rogers on 7/21/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    // outlets
    @IBOutlet weak var loadingView: SearchLoadingView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout! {
        
        didSet {
            
            // sticky header
            collectionViewFlowLayout?.sectionHeadersPinToVisibleBounds = true
        }
    }
    
    // enums
    private enum SearchScopeStates: String {
        
        // values displayed for search bar cancel button
        case search = "Search"
        case history = "Select"
        case recent = "Show"
    }
    
    private enum SearchScopes: String, CaseIterable {
        
        // values displayed in search bar segment scope control
        case search, history, community
        var cap: String { return self.rawValue.capitalized }
    }
    
    // properties
    private var latestPhotosModel: (model: Decodable, state: SearchScopeStates)?
    private var latestTags = ""
    private var data: [FlickrPhoto] = []

    private typealias SearchScopeData = (text: String, state: SearchScopeStates)
    private let scopeData: [SearchScopeData] = [
        
        // ordered data for search bar
        SearchScopeData(text: SearchScopes.search.cap, state: .search),
        SearchScopeData(text: SearchScopes.history.cap, state: .history),
        SearchScopeData(text: SearchScopes.community.cap, state: .recent)
    ]
    
    // references self, so must be delayed init, i.e. lazy
    private lazy var search: UISearchController = {
        
        // where the magic begins
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.searchBar.placeholder = "Photo Tags (comma separated)"

        // no UI on top of main view
        search.obscuresBackgroundDuringPresentation = false
        
        // use of scopes via segment control under search bar, nice use of map
        search.searchBar.scopeButtonTitles = scopeData.map({ $0.text })
        search.searchBar.delegate = self
        
        // be nice and sync our search bar to same tint as nav bar
        search.searchBar.tintColor = navigationController?.navigationBar.tintColor
        
        // integrate with nav bar
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        
        return search
    }()
    
    var lastCollectionHeaderView: SearchCollectionHeaderView?
    var collectionHeaderView: SearchCollectionHeaderView? {
        
        let kind = UICollectionView.elementKindSectionHeader
        let indexPath = IndexPath(row: 0, section: 0)
        
        // if created, should return
        let header = collectionView.supplementaryView(forElementKind: kind,
                                                      at: indexPath) as? SearchCollectionHeaderView

        if header == nil {
            
            return lastCollectionHeaderView
        }
        
        return header
    }
    
    // actions
    @IBAction func onRefresh(_ sender: Any) {
        
        // mode:
        //  a) showing community, refresh recent posts, replace data
        //  b) showing search, new search with same tags, replace data
        guard let latest = latestPhotosModel else { return }
        if latest.state == .recent {
            
            loadRecent(clear: true, page: 1)
        }
        else {
            
            loadSearch(clear: true, tags: latestTags, page: 1)
        }
        
        print(#function)
    }
    
    // view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup and attach now that self and screen items are created
        _ = search
        
        // calc the optimum cell size given the device size
        let numberThumbsHorizontally = UserDefaults.standard.numThumbImagesPerRow
        var deviceWidth = UIScreen.main.bounds.width.intValue
        let insets = collectionViewFlowLayout.sectionInset
        deviceWidth -= (numberThumbsHorizontally - 1 + 2) * insets.left.intValue
        let maxThumbWidth = deviceWidth / numberThumbsHorizontally
        
        collectionViewFlowLayout.itemSize = CGSize(width: maxThumbWidth, height: maxThumbWidth)
        collectionViewFlowLayout.invalidateLayout()
        
        // since we have custom collection view, which is setup
        // during the first reload, let's get it in place right
        // away so when real data comes back, there isn't a timing issue
//        collectionView.reloadData()
        
        // fire off recent community pics while user searches
        loadRecent(clear: true, page: 1)
    }
}

//
// private search support
//

extension SearchViewController {
    
    private func loadMore(clear: Bool) {
    
        guard let latest = latestPhotosModel else {
            
            // no previous ... shouldn't happen, but load initial recent community view
            loadRecent(clear: true, page: 1)
            return
        }
        
        if latest.state == .recent {
            
            // check if all done
            guard let model = latest.model as? FlickrRecent else { return }
            guard data.count < model.photos.total else {

                // sanity check
                assert(getDups().count == 0, "dups photos in data storage")
                return
            }
            
            // more recent
            loadRecent(clear: false, page: model.photos.page + 1)
        }
        else {
            
            // check if all done
            guard let model = latest.model as? FlickrSearch else { return }
            guard data.count < model.photos.total else { return }
            
            // load tags
            loadSearch(clear: false, tags: latestTags, page: model.photos.page + 1)
        }
    }
    
    private func loadRecent(clear: Bool, page: Int) {
        
        // load recent
        loadingView.blink(true)
        UIApplication.shared.apiService.recent(page: page) { [weak self] results in
            
            switch results {
                
            case .success(let model):
                guard let strongSelf = self else { return }
                strongSelf.handleSuccess(model: model,
                                         photos: model.photos,
                                         clear: clear,
                                         page: page,
                                         state: .recent)
                
            case .failure(let error):
                print(error)
            }
        }
    }

    private func loadSearch(clear: Bool, tags: String, page: Int) {
        
        // load recent
        loadingView.blink(true)
        UIApplication.shared.apiService.search(with: tags, exclusive: false, page: page) { [weak self] results in
            
            switch results {
                
            case .success(let model):
                guard let strongSelf = self else { return }
                strongSelf.handleSuccess(model: model,
                                         photos: model.photos,
                                         clear: clear,
                                         page: page,
                                         state: .search)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func handleSuccess<T: Decodable>(model: T,
                                             photos: FlickrPhotos,
                                             clear: Bool,
                                             page: Int,
                                             state: SearchScopeStates) {
        print("success model \(type(of: model.self)):", model)

        // multi-thread safe
        NSLock().synchronized {
            
            // save state
            latestPhotosModel = (model, state)
            
            if clear {
                
                // set
                data = photos.photo
            }
            else {
                
                // append
                data += photos.photo
                
                // sanity check, when requesting more pages, guessing
                // more photos could have been added, pushing down the
                // top photos, such that if you request the same page,
                // might get some dups - keep our list dup-free
                // note: a user can post the same photo multiple times
                //       so it is possible to get "dups" from valid
                //       different files IDs being same image.  or,
                //       multiple people could post the same photo.
                //       (maybe raw bytes image compare could eliminate,
                //        but that'd be an *expensive* operation)
                let dictDupsIds = getDups()
                
                for (id, count) in dictDupsIds {
                    
                    // leave 1 / original there, remove rest
                    var numToRemove = count - 1
                    while numToRemove > 0 {
                        
                        guard let index = data.lastIndex(where: { $0.id == id }) else { break }
                        data.remove(at: index)
                        numToRemove -= 1
                        print("removed dup:", id)
                    }
                }
            }
        }
        
        // update dipslay
        DispatchQueue.main.mainInline { [weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.collectionView.reloadData()
            
            if page == 1 {
                
                // start at top
                strongSelf.collectionView.contentOffset.y = 0
            }
            
            let count = strongSelf.data.count
            let total = photos.total
            strongSelf.setHeader(state: state,
                                 count: count,
                                 total: total)

            // stop loading and fade it away while collection redraws
            strongSelf.loadingView.blink(false, hideAfterStop: false)
            strongSelf.loadingView.fadeHide()
        }
    }
    
    private func getDups() -> [String: Int] {
        
        let dictDupsIds = self.data
            .reduce(into: [:], { ids, model in ids[model.id, default: 0] += 1 })
            .filter({ $0.value > 1 })
        return dictDupsIds
    }
    
    private func setHeader(state: SearchScopeStates, count: Int, total: Int) {
        
        DispatchQueue.main.mainInline { [weak self] in
            
            guard let strongSelf = self else { return }
            if let header = strongSelf.collectionHeaderView {
                
                switch state {
                    
                case .recent:   header.headerLabel.text = "Recent Community Photos"
                default:        header.headerLabel.text = "Tags: \(strongSelf.latestTags)"
                }
                
                // extreme checking
                if count == 0 || total == 0 {
                    
                    // note: 25 at a time, can get count to exceed total ... no check on that
                    header.countLabel.isHidden = true
                    print("header unexpected counts, count=", count, ", total=", total)
                }
                else {
                    
                    // in small space plus make nicer for user to read in shorter format
                    header.countLabel.text = "\(count.shortFormat) of \(total.shortFormat)"
                    header.countLabel.isHidden = false
                }
            }
            else {
                
                print("header not available")
            }
        }
    }
    
    private func updateSearchCancelButton(state: SearchScopeStates) {
        
        // key-value compliant access to button
        if let cancelButton = search.searchBar.value(forKey: "_cancelButton") as? UIButton {
            
            cancelButton.setTitle(state.rawValue, for: .normal)
        }
        else {
            
            assertionFailure("KVO value for UISearchBar Cancel button changed")
        }
    }
}

//
// search bar support
//

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        // per char update
        guard let text = searchController.searchBar.text else { return }
        print(text.isEmpty ? "(empty)" : text)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    // delegage overrides
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print(#function, "\(selectedScope)")
        
        // sync states
        updateCancelButton(with: selectedScope, for: searchBar)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        
        // multi-use "cancel" button - search
        if searchBar.selectedScopeButtonIndex == 0 {
            
            latestTags = searchBar.text ?? ""
            loadSearch(clear: true, tags: latestTags, page: 1)
        }
        else {
            
            if searchBar.selectedScopeButtonIndex == 2 {
                
                loadRecent(clear: true, page: 1)
            }
            
            searchBar.selectedScopeButtonIndex = 0
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        
        // enter key - search
        latestTags = searchBar.text ?? ""
        
        // end search controller
        search.isActive = false
        
        loadSearch(clear: true, tags: latestTags, page: 1)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {

        // ensure "cancel" showing
        searchBar.showsCancelButton = true
        
        if search.isActive && searchBar.selectedScopeButtonIndex != 0 {
            
            return false
        }
        searchBar.selectedScopeButtonIndex = 0
        updateSearchCancelButton(state: .search)

        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        // show tiny cancel button during text entry
        searchBar.showsCancelButton = true
    }
    
    // private helpers
    private func updateCancelButton(with scope: Int, for searchBar: UISearchBar) {
        
        // custom "cancel" buttons per scope
        let scopeItem = scopeData[scope]
        
        // update cancel
        updateSearchCancelButton(state: scopeItem.state)
        
        // update responder
        if scopeItem.state == .search {
            
            searchBar.becomeFirstResponder()
        }
        else {
            
            searchBar.resignFirstResponder()
        }
    }
}

//
// collection support
//

extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.className, for: indexPath)
        
        if let searchCell = cell as? SearchCollectionViewCell {
        
            // supply cell with what it needs to display itself
            searchCell.model = data[indexPath.row]
        }
        
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        // show details for selected photo
        let model = data[indexPath.row]
        let viewModel = FlickrPhotoVM(model: model)
        let vc = PhotoInfoViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        // see if *near* last item and not actively loading
        let bufferToEndToPrefetchMore = 5
        let thresholdToFetchMore = data.count - bufferToEndToPrefetchMore
        guard loadingView.isHidden && indexPath.row + 1 >= thresholdToFetchMore else { return }
        
        // hit the end - load up more
        loadMore(clear: false)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        // create "generic" always passes view
        let reusableView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SearchCollectionHeaderView.className,
            for: indexPath)

        // add specific items to view
        if kind == UICollectionView.elementKindSectionHeader,
            let headerView = reusableView as? SearchCollectionHeaderView {
            
            // custom header
            lastCollectionHeaderView = headerView
        }
        
        return reusableView
    }
}
