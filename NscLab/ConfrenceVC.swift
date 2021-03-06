//
//  ConfrenceVC.swift
//  NscLab
//
//  Created by Sanjay Bhatia on 08/11/19.
//  Copyright © 2019 Sanjay Bhatia. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ConfrenceVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
   
    

    //-------------------
    // MARK: Outlets
    //-------------------
    
   
    @IBOutlet weak var btnLogout: UIButton!
    
    @IBOutlet weak var HeaderView: UIView!
    
    @IBOutlet weak var tblUpcomingView: UITableView!
   
    @IBOutlet weak var tblAttending: UITableView!
    
    @IBOutlet weak var tblPastEvents: UITableView!
    
    //------------------------
        // MARK: Identifiers
        //------------------------
    
  
    var scrollBarTimer = Timer()
    
    var upcomingConferenceData = JSON()
    var attendingConferenceData = JSON()
    var pastconferenceData = JSON()
    
    var conferenceData = JSON()
    
    var sections = ["Upcoming Conference","Attending Conference","Past Events"]
            
    
    var timer = Timer()
    

    //------------------------
      // MARK: View Life Cycle
      //------------------------
      
    override func viewDidLoad() {
        super.viewDidLoad()

        print(conferenceId)
        
        HeaderView.backgroundColor = Colors.HeaderColor
      
        
        
           
        
       
        
        btnLogout.changeButtonImageColor(color: UIColor.white, mode: .normal)
    
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        upcomingConferenceApi()
        pastConferenceApi()
                
        attendingConferenceApi()
    }
    
    override func viewDidAppear(_ animated: Bool)
      {
          //scrollBarTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(showScrollBar), userInfo: nil, repeats: true)
          startTimerForShowScrollIndicator()
          
      }
    
        //--------------------------
        // MARK: Table View Methods
       //---------------------------
       
    
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        if section == 0
//        {
//              return sections[section]
//        }
//        else if section == 1
//        {
//        return sections[section]
//        }
//        else
//        {
//             return sections[section]
//        }
//
//     }
     
//     func numberOfSections(in tableView: UITableView) -> Int {
//         return self.sections.count
//     }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            switch (tableView.tag)
            {
               case 0:
                  print(upcomingConferenceData.count)
                return upcomingConferenceData.count// == 0 ? 2 : upcomingConferenceData.count
             
            case 1:
            print(attendingConferenceData.count)
                return attendingConferenceData.count// == 0 ? 2 : attendingConferenceData.count
                
            case 2:
                print(pastconferenceData.count)
                 return pastconferenceData.count// == 0 ? 2 : pastconferenceData.count
             
            default:
                
                return section
                 
            }


        }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
       {
       
        let cell = tblUpcomingView.dequeueReusableCell(withIdentifier: "tblUpcomingCell") as! tblUpcomingCell
       
        switch (tableView.tag) {
           case 0:
            if upcomingConferenceData.count == 0
            {
                cell.accessoryType = .none
                cell.lblTittle.text = ""
                
                cell.lblDate.text = ""

                
                cell.imgCon.isHidden = true
                    cell.lblCalenderDate.text = ""
            }
            else
            {
                cell.accessoryType = .disclosureIndicator
                cell.lblTittle.text =   upcomingConferenceData[indexPath.row]["topic"].stringValue
                
                cell.lblDate.text = dmyFormat.string(from: ymdFormat.date(from: upcomingConferenceData[indexPath.row]["date"].string ?? "") ?? Date())

                let strarray = upcomingConferenceData[indexPath.row]["date"].string!.components(separatedBy: "-")
                cell.imgCon.isHidden = false
                print(strarray)
                    cell.imgWidth.constant = 50
                    cell.lblCalenderDate.text = strarray[2]
                cell.lblCalenderDate.isHidden = false
            }
                

           case 1:
              
            
            if attendingConferenceData.count == 0
            {
                cell.accessoryType = .none
                cell.lblTittle.text = ""
                
                cell.lblDate.text = ""

                cell.imgCon.isHidden = true
                    cell.lblCalenderDate.text = ""
            }
            else
            {
                cell.accessoryType = .disclosureIndicator
                cell.lblTittle.text =   attendingConferenceData[indexPath.row]["topic"].stringValue
                
                cell.lblDate.text = dmyFormat.string(from: ymdFormat.date(from: attendingConferenceData[indexPath.row]["date"].string ?? "") ?? Date())
                
                let strarray = attendingConferenceData[indexPath.row]["date"].string!.components(separatedBy: "-")

                print(strarray)
                cell.imgWidth.constant = 50
                cell.lblCalenderDate.text = strarray[2]
                cell.imgCon.isHidden = false
                cell.lblCalenderDate.isHidden = false
            }
            

            
        case 2:
            
            if pastconferenceData.count == 0
            {
                cell.accessoryType = .none
                cell.lblTittle.text = ""
                
                cell.lblDate.text = ""

                cell.imgCon.isHidden = true
                    cell.lblCalenderDate.text = ""
            }
            else
            {
                
                cell.accessoryType = .none
                cell.lblTittle.text = pastconferenceData[indexPath.row]["topic"].stringValue
                
                cell.lblDate.text = dmyFormat.string(from: ymdFormat.date(from: pastconferenceData[indexPath.row]["date"].string ?? "") ?? Date())
                
                
                let strarray = pastconferenceData[indexPath.row]["date"].string!.components(separatedBy: "-")

                print(strarray)
                cell.imgWidth.constant = 0
                cell.lblCalenderDate.text = strarray[2]
                cell.imgCon.isHidden = true
                cell.lblCalenderDate.isHidden = true
                
            }
            
            
            
        default: break
            
            
               
        }
     
       return cell
       }
  
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        switch (tableView.tag)
                      {
                                 case 0:
                                    if upcomingConferenceData.count != 0
                                    {
                                        let obj = storyboard?.instantiateViewController(withIdentifier: "ConferenceDetailVC") as! ConferenceDetailVC

                                         obj.topic = upcomingConferenceData[indexPath.row]["topic"].stringValue
                                          obj.des = upcomingConferenceData[indexPath.row]["description"].stringValue
                                        obj.date = upcomingConferenceData[indexPath.row]["date"].stringValue

                                        conferenceId = upcomingConferenceData[indexPath.row]["conference_id"].stringValue
                                        obj.isAttending = upcomingConferenceData[indexPath.row]["attend"].intValue == 0 ? false : true


                                        navigationController?.pushViewController(obj, animated: true)
                                    }
                                  
                            
                            case 1:
                                     if attendingConferenceData.count != 0
                                     {
                                        let obj = storyboard?.instantiateViewController(withIdentifier: "CyberMissionsVC") as! CyberMissionsVC

                                              obj.tittleName = attendingConferenceData[indexPath.row]["topic"].stringValue

                                              conferenceId = attendingConferenceData[indexPath.row]["conference_id"].stringValue

                                               print(conferenceId)

                                        navigationController?.pushViewController(obj, animated: true)
                                     }
                                 
                                 
                         default: break
    }

    }
      
    
      func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            
    //        view.tintColor = UIColor.lightGray
            
            let header = view as! UITableViewHeaderFooterView
            
            header.textLabel?.textColor = Colors.HeaderColor
        }
  
       //-----------------------------
       // MARK: User Defined Function
       //-----------------------------
       
    
    @objc func showScrollBar()
     {
        
        tblUpcomingView.flashScrollIndicators()
        tblAttending.flashScrollIndicators()
        tblPastEvents.flashScrollIndicators()
        
    
     }
     @objc func showScrollIndicatorsInContacts()
     {
         UIView.animate(withDuration: 0.0001)
         {
            self.tblUpcomingView.flashScrollIndicators()
            self.tblAttending.flashScrollIndicators()
             self.tblPastEvents.flashScrollIndicators()
            
          
    
         }
     }
     func startTimerForShowScrollIndicator() {
         self.scrollBarTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.showScrollIndicatorsInContacts), userInfo: nil, repeats: true)
     }
       @objc func upcomingConferenceInternetAvailable()
                {
                    if Connectivity.isConnectedToInternet()
                    {
                       upcomingConferenceApi()
                    }
                    else
                    {
                        self.stopAnimating()
                      PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
                    }
                }
//
    @objc func attendingConferenceInternetAvailable()
           {
               if Connectivity.isConnectedToInternet()
               {
                  attendingConferenceApi()
               }
               else
               {
                   self.stopAnimating()
                 PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
               }
           }

       @objc func pastConferenceInternetAvailable()
       {
           if Connectivity.isConnectedToInternet()
           {
              pastConferenceApi()

           }
           else
           {
               self.stopAnimating()
             PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
           }
       }
       
       
       
  
       //-----------------------
       // MARK: Button Action
       //-----------------------
       

    @IBAction func btnLogoutTUI(_ sender: UIButton)
    {
        let obj = storyboard?.instantiateViewController(withIdentifier: "LoginVc") as! LoginVc

         UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        
        navigationController?.pushViewController(obj, animated: true)
    }
    
       //-----------------------
       // MARK: Web Service
       //-----------------------
       
       func upcomingConferenceApi()
           {

               if Connectivity.isConnectedToInternet()
               {
            
                 let   parameter = ["type":"upcomingConferenceList","attendees_id": UserDefaults.standard.integer(forKey: "attendeesid")] as [String : Any]

                
                print(parameter)
                   timer.invalidate()
                   self.start()
                
                let url = appDelegate.ApiBaseUrl + parameterConvert(pram: parameter)
                   print("Conference List ==>> " + url)
                   Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
                       {
                           response in
                           switch response.result
                           {
                           case .success:
                            if response.response?.statusCode == 200
                            {

                                let result = JSON(response.value!)
        
                            print(result)
                            if result["status"].boolValue == false
                               {
//                                self.tblUpcomingView.contentSize.height = 0
                             //    PopUp(Controller: self, title:  "opps!!", message: result["msg"].string!, type: .error, time: 2)
                              
                                   self.stopAnimating()
                               }
                               else
                               {
                                   self.stopAnimating()

                                self.upcomingConferenceData = result["conference_list"]
                                    print( self.upcomingConferenceData)
                                                       
                           
                                
                                 self.tblUpcomingView.reloadData()
                                
                         
                                
                           
                               }
                            }
                           case .failure(let error):
                               print(error)
                           }
                   }

               }
               else
               {
                   self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.upcomingConferenceInternetAvailable), userInfo: nil, repeats: true)
                   PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
               }
           }
//
//
//
//
       func attendingConferenceApi()
       {

           if Connectivity.isConnectedToInternet()
           {

            let parameter = ["type":"attendingConferenceList","attendees_id": UserDefaults.standard.integer(forKey: "attendeesid")] as [String : Any]

            print(parameter)
               timer.invalidate()
               self.start()

            let url = appDelegate.ApiBaseUrl + parameterConvert(pram: parameter)
               print("Attending Conference List ==>> " + url)
               Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
                   {
                       response in
                       switch response.result
                       {
                       case .success:
                        if response.response?.statusCode == 200
                        {

                            let result = JSON(response.value!)

                        print(result)
                        if result["status"].boolValue == false
                           {


                           //  PopUp(Controller: self, title:  "opps!!", message: result["msg"].string!, type: .error, time: 2)

                               self.stopAnimating()
                           }
                           else
                           {
                               self.stopAnimating()

                           self.attendingConferenceData = result["conference_list"]

                            print( self.attendingConferenceData)


                          self.tblAttending.reloadData()


                           }
                        }
                       case .failure(let error):
                           print(error)
                       }
               }

           }
           else
           {
               self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.attendingConferenceInternetAvailable), userInfo: nil, repeats: true)
               PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
           }
       }





    func pastConferenceApi()
         {

             if Connectivity.isConnectedToInternet()
             {

              let parameter = ["type":"pastConferenceList","attendees_id": UserDefaults.standard.integer(forKey: "attendeesid")] as [String : Any]

              print(parameter)
                 timer.invalidate()
                 self.start()

              let url = appDelegate.ApiBaseUrl + parameterConvert(pram: parameter)
                print("Past Conference List ==>> " + url)
                 Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON
                     {
                         response in
                         switch response.result
                         {
                         case .success:
                          if response.response?.statusCode == 200
                          {

                              let result = JSON(response.value!)

                          print(result)
                          if result["status"].boolValue == false
                             {

                            //   PopUp(Controller: self, title:  "opps!!", message: result["msg"].string!, type: .error, time: 2)

                                 self.stopAnimating()
                             }
                             else
                             {
                                 self.stopAnimating()

                             self.pastconferenceData = result["conference_list"]

                              print( self.pastconferenceData)


                             self.tblPastEvents.reloadData()

                             }
                          }
                         case .failure(let error):
                             print(error)
                         }
                 }

             }
             else
             {
                 self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.pastConferenceInternetAvailable), userInfo: nil, repeats: true)
                 PopUp(Controller: self, title: "Internet Connectivity", message: "Internet Not Available", type: .error, time: 2)
             }
         }
         
}
