//
//  ViewController.swift
//  servicios1
//
//  Created by Antonio Franco on 17/12/15.
//  Copyright © 2015 José Antonio Franco Cortés. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var ingresarISBN: UITextField!
    @IBOutlet weak var resultadoISBN: UITextView!
   
    func sincrono(){
        let urls = "http://dia.ccm.itesm.mx"
        let url = NSURL(string: urls)
        let datos:NSData? = NSData(contentsOfURL: url!)
        let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
        print(texto!)
    }
    
     func asincrono(){
        
        if let text = ingresarISBN.text {
            let url = NSURL(string : "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(text)")
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                print (NSString(data: data!,
                    encoding: NSUTF8StringEncoding))
                let impresion = NSString(data: data!,
                    encoding: NSUTF8StringEncoding)
                dispatch_async(dispatch_get_main_queue()) {  // GCD
                    self.resultadoISBN.text = impresion as! String // might need a [weak self]
                }
            }
            task.resume()
        }
}
    
    
    @IBAction func btnLimpiar(sender: AnyObject) {
        ingresarISBN.text = ""
        resultadoISBN.text = ""
    }
    

    @IBAction func realizarActividad(sender: AnyObject) {
        
   
        if isConnectedToNetwork() == true {
            print("Internet connection OK")
                  asincrono()
        } else {
            print("Internet connection FAILED")

            let mensajeAlerta = UIAlertController(title: "No tienes conexion de internet",
                message: "Asegurate de que tu dispositivo esta conectado a internet" , preferredStyle: .Alert)
            
            let defaultAccion = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil)
            
            mensajeAlerta.addAction(defaultAccion)
            mensajeAlerta.addAction(cancelAction)
            
            presentViewController(mensajeAlerta, animated: true, completion: nil)
            
        }
        
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
     
        ingresarISBN.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

