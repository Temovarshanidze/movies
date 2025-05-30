
import UIKit

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callAllFuncs()
    }
    private func  callAllFuncs() {
        configTabBar()
    }
    let moviesViewModel = MoviesViewModel()
    
    private func configTabBar() {
        let homePageVC = UINavigationController(rootViewController: HomePageVC(viewModel: moviesViewModel))
        let searchVC = UINavigationController(rootViewController: SearchVC(viewModel: moviesViewModel))
        let favoriteVC = UINavigationController(rootViewController: FavouritesVC(viewModel: moviesViewModel))
        let profileVC = UINavigationController(rootViewController: LogInVC())
        
        homePageVC.tabBarItem.image = UIImage(named: "homeicon")
        searchVC.tabBarItem.image = UIImage(named: "searchicon")
        favoriteVC.tabBarItem.image = UIImage(named: "favoritesicon")
        profileVC.tabBarItem.image = UIImage(systemName: "person.circle")
        
        homePageVC.title = "Home"
        searchVC.title = "Search"
        favoriteVC.title = "Favourites"
        profileVC.title = "Profile"
        
        tabBar.tintColor = .cyan
        tabBar.barTintColor = .black
        
       // UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        setViewControllers([homePageVC, searchVC, favoriteVC, profileVC], animated: true)
        
    }
    
}
