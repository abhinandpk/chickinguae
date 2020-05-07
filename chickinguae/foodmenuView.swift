//
//  foodmenuView.swift
//  chickinguae
//
//  Created by MacBook on 07/05/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class foodmenuView: UIViewController {

    @IBOutlet weak var categoryCollectionView: UICollectionView!

    @IBOutlet weak var productListCollectionView: UICollectionView!
    @IBOutlet weak var homeBannerScrollView: UIScrollView!
    
    
    let const = Constants()
        let deBug = debug()
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
    var scrollWidth : CGFloat = 343
    var scrollHeight : CGFloat = 182
    var productId = Int()

        override func viewDidLoad() {
            banners()
            super.viewDidLoad()
            
        }
    func pageView() {
        
        homeBannerScrollView?.contentSize = CGSize(width: (scrollWidth * CGFloat(bannerDetails.count)), height: scrollHeight)
        print("le",scrollWidth)
        homeBannerScrollView?.delegate = self // as? UIScrollViewDelegate;
        homeBannerScrollView?.isPagingEnabled = true
        homeBannerScrollView?.showsHorizontalScrollIndicator = false
        homeBannerScrollView?.showsVerticalScrollIndicator = false
    
        //homeBannerPageController.numberOfPages = bannerDetails.count
        print("wew",bannerDetails.count)
        for i in 0...bannerDetails.count - 1
        {
            let imgView = UIImageView.init()
            imgView.frame = CGRect(x: scrollWidth * CGFloat (i), y: 0, width: scrollWidth,height: scrollHeight )
            //  imgView.contentMode = UIView.ContentMode.scaleAspectFit
            let imageUrl = bannerDetails[i].bannerImage
            print("sd",imageUrl)
            //  imgView.imageFromServerURL(urlString: imageUrl as! String )
            imgView.sd_setImage(with: URL(string:const.bannerUrl + imageUrl), placeholderImage: UIImage(named: "logo"))
            
            homeBannerScrollView?.addSubview(imgView)
            
            
        }
//        var tapGesture = UITapGestureRecognizer()
//        tapGesture = UITapGestureRecognizer(target: self, action: #selector(Home.myviewTapped(_:)))
//        tapGesture.numberOfTapsRequired = 1
//        tapGesture.numberOfTouchesRequired = 1
//        homeBannerScrollview.addGestureRecognizer(tapGesture)
//        homeBannerScrollview.isUserInteractionEnabled = true
        
    }
    
    @objc func moveToNextPage () {
        let pageWidth:CGFloat = self.homeBannerScrollView.frame.width
        let maxWidth:CGFloat = pageWidth * CGFloat(bannerDetails.count)
        var contentOffset:CGFloat = self.homeBannerScrollView.contentOffset.x
        
        
        var slideToX = contentOffset + pageWidth
        
        
        if  contentOffset + pageWidth == maxWidth {
            slideToX = 0
            contentOffset = contentOffset - pageWidth
            
        }
        
        self.homeBannerScrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.homeBannerScrollView.frame.height), animated: true)
        
        let page = (homeBannerScrollView?.contentOffset.x)!/scrollWidth
       // homeBannerPageController?.currentPage = Int(page)
        
    }
        func categoryList() {
             // Activity indicator
    //         activityIndicator.center =  CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
    //         self.view.addSubview(activityIndicator)
    //        activityIndicator.color = self.const.activityIndColor
    //         self.activityIndicator.startAnimating()
             
    AF.request(const.baseUrl+"listAllCakeCategory",method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON
         {
         response in
         switch response.result {
         case let .success(datavalue):
            let data = datavalue as AnyObject
            let status = data.value(forKey: "status") as! String
            if status == "ok" {
            self.productLists()
            let Categories = data.value(forKey: "data") as! [AnyObject]
               for CategoriesList in Categories {
               let categoryId = CategoriesList["id"]as! Int
               let title = CategoriesList["title"]as! String
                let categoryData = category(categoryId: categoryId, categoryName: title)
                catergoryDetails.append(categoryData)
                self.categoryCollectionView.reloadData()
                self.productId = 7
                self.productLists()

                }
            }
             print(datavalue)
         case let .failure(error):
             print(error)
         }

         }
         }
        func banners() {
             // Activity indicator
    //         activityIndicator.center =  CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
    //         self.view.addSubview(activityIndicator)
    //        activityIndicator.color = self.const.activityIndColor
    //         self.activityIndicator.startAnimating()
             
    AF.request(const.baseUrl+"banners/cake",method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON
         {
         response in
         switch response.result {
         case let .success(datavalue):
            let data = datavalue as AnyObject
            let status = data.value(forKey: "status") as! String
            if status == "ok" {
            self.categoryList()
            let bannerImages = data.value(forKey: "data") as! [AnyObject]
               for bannerList in bannerImages {
               let bannerId = bannerList["id"]as! Int
               let bannerImage = bannerList["image"]as! String
                let bannerData = banner(bannerId: bannerId, bannerImage: bannerImage)
                bannerDetails.append(bannerData)
                self.pageView()
                
                }
            }
             print(datavalue)
         case let .failure(error):
             print(error)
         }

         }
         }
        func productLists() {
             // Activity indicator
    //         activityIndicator.center =  CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
    //         self.view.addSubview(activityIndicator)
    //        activityIndicator.color = self.const.activityIndColor
    //         self.activityIndicator.startAnimating()
      print("dd",productId)
    AF.request(const.baseUrl+"listCakesByCategory/+\(productId)",method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON
         {
         response in
         switch response.result {
         case let .success(datavalue):
            let data = datavalue as AnyObject
            let status = data.value(forKey: "status") as! String
            if status == "ok" {
            let products = data.value(forKey: "data") as! [AnyObject]
               for productList in products {
               let productId = productList["id"]as! Int
               let productName = productList["title"]as! String
               let productImage = productList["image"]as! String
               let productPrice = productList["price"]as! String
                let productData = product(productId: productId, productName: productName, productImage: productImage, productPrice: productPrice)
                ProductDetails.append(productData)
                self.productListCollectionView.reloadData()
                }
            }
             print(datavalue)
         case let .failure(error):
             print(error)
         }

         }
         }
    @objc func categoryBtPressed(_ sender: AnyObject) {
        let button = sender as? UIButton
        let cell = button?.superview?.superview as? CategoryCollectionViewCell
       // catergoryDetails.removeAll()
        for cate in catergoryDetails {
            cell?.backgroundColor = UIColor.white
            
        }
        cell?.categoryName.textColor = UIColor.white
        cell?.backgroundColor = hexStringToUIColor(hex: "#8b0000")
      }

    }
    public struct category: Codable {
        public let categoryId: Int
        public let categoryName: String
    }
    var catergoryDetails = [category]()

public struct product: Codable {
    public let productId: Int
    public let productName: String
    public let productImage: String
    public let productPrice: String
}
var ProductDetails = [product]()

public struct banner: Codable {
    public let bannerId: Int
    public let bannerImage: String
}
var bannerDetails = [banner]()


    extension foodmenuView:UICollectionViewDelegate,UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView == categoryCollectionView {
            return catergoryDetails.count
            }
            else {
                return ProductDetails.count
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            cell.categoryName.text = catergoryDetails[indexPath.row].categoryName
                cell.contentView.layer.cornerRadius = 15g.0
                cell.contentView.layer.borderWidth = 2.0
                cell.contentView.layer.borderColor = UIColor.clear.cgColor
                cell.contentView.layer.masksToBounds = false
                cell.layer.shadowColor = UIColor.gray.cgColor
                cell.layer.shadowOffset = CGSize(width: 0, height: 0.5)
                cell.layer.shadowRadius = 3.0
                cell.layer.shadowOpacity = 0.5
                cell.layer.masksToBounds = false
                cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
                cell.categoryBt.addTarget(self, action: #selector(categoryBtPressed), for: .touchUpInside)
            return cell
            }
            else {
               let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "productCollectionViewCell", for: indexPath) as! productCollectionViewCell
                let productImages = String(ProductDetails[indexPath.row].productImage)
                cell1.productImage.sd_setImage(with: URL(string: const.imageUrl + productImages), placeholderImage: UIImage(named: "placeholder.png"))
                cell1.productName.text = ProductDetails[indexPath.row].productName
                let price = String(ProductDetails[indexPath.row].productPrice)
                cell1.productPrice.text = price
                cell1.contentView.layer.cornerRadius = 5.0
                cell1.contentView.layer.borderWidth = 1.0
                cell1.contentView.layer.borderColor = UIColor.clear.cgColor
                cell1.contentView.layer.masksToBounds = false
                cell1.layer.shadowColor = UIColor.gray.cgColor
                cell1.layer.shadowOffset = CGSize(width: 0, height: 0.5)
                cell1.layer.shadowRadius = 1.0
                cell1.layer.shadowOpacity = 0.5
                cell1.layer.masksToBounds = false
                cell1.layer.shadowPath = UIBezierPath(roundedRect: cell1.bounds, cornerRadius: cell1.contentView.layer.cornerRadius).cgPath
                return cell1
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCollectionViewCell", for: indexPath) as! productCollectionViewCell
            return cell
        }
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            self.productId = catergoryDetails[indexPath.row].categoryId
            productLists()
        }

}
