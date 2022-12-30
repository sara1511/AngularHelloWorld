import { Component, Injectable, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})

@Injectable()
export class AppComponent implements OnInit {
  title = 'hello-world';
  constructor(private http: HttpClient){ }

  requestOptions = { withCredentials: true };

  ngOnInit() {
    this.fetchAll();
  }

  fetchAll(){
    this.http.get('https://angularlinuxdemoapp-node-express-multer.azurewebsites.net/', this.requestOptions)
    .subscribe(response=>{console.log(response)}, err=>{console.log("Service Not Found"+ JSON.stringify(err))})
  }
}
