# Highest Value Transactions on Buda.com (Last 24 hours)

_An application developed with Ruby to determine the highest value transactions in the last 24 hours in the regional cryptocurrency industry._

The application has a custom architecture organized within the app folder as follows:

- **app/**
- **-----database/**: Contains the responses of the cached API.
- **-----helpers/**: Contains date and date files. templates with ERB.
- **-----mocks/**: Contains json files with the mocked responses of the services.
- **-----public/**: Contains the img, icons and html files generated from the server's public folder
- **-----services/**: Contains calls to APIs of external services.
- **-----views/**: Contains the views of the application.

 It should be noted that the code is made based on the **functional paradigm**.

 Error handling is also included in the API services, for this I include three levels:
 - **First level**: If there was a previous response from the API, this will be saved within the database/cache/ folder to be later used in a subsequent query.
 - **Second level**: If there has never been a response API success is read directly from mocked files simulating a correct response to the front.
 - **Third level**: If there was a successful API response within the last 5 minutes, it will be saved within database/cache/. The system verifies that it has been created within this period of time, if so it will not call the API again, causing the response to be quickly obtained and rendered on the front, reducing loading problems and also avoiding falling into rules. of rate limit and bot score that the service could have. 
 
 I preferred not to include a relational or non-relational database such as mysql or redis respectively so as not to increase the level of difficulty of the test so much.

You can enter from these links:

[https://highest-trades-buda-com-809bb4cac0c4.herokuapp.com/](https://highest-trades-buda-com-809bb4cac0c4.herokuapp.com/)
or
[https://ruby.flemingtechnologies.us/](https://ruby.flemingtechnologies.us/)

![](https://firebasestorage.googleapis.com/v0/b/fleming-technologies.appspot.com/o/2023-09-30_15-06.jpeg?alt=media&token=062cd623-1557-462a-8549-42c124a872a3&_gl=1*pdmmrs*_ga*MTE1NjMzNTkxOS4xNjkzOTU0NjQz*_ga_CW55HF8NVT*MTY5NjA5NzgxOS4yNC4xLjE2OTYwOTc4NDAuMzkuMC4w)

The data is public and is accessed through:[https://api.buda.com/](https://api.buda.com/)

## Starting 🚀

These instructions will allow you to get a copy of the project up and running on your local machine for development and testing purposes.

_See **Deployment** to learn how to deploy the project._

### Pre requirements 📋

Before installing the project you must have **Ruby** installed on your local machine and also a text editor for development.

**Text editor** _(I recommend Visual Studio Code)_
[https://code.visualstudio.com/](https://code.visualstudio.com)

**Ruby** _(I recommend version 3+)_
[https://www.ruby-lang.org](https://www.ruby-lang.org)

**Bundle**
You must have bundle installed to be able to load the project's dependencies.
```
gem install bundler
```

### Install 🔧

Before installing, verify that you have Ruby, gem and bundle installed correctly, as follows:

```
$ruby --version
@ruby 3.0.2p107 (2021-07-07 revision 0db68f0233) [x86_64-linux-gnu] (This should be seen as a result)
```

```
$gem --version
3.3.5 (This should be seen as a result)
```

```
$bundle --version
Bundler version 2.4.20 (This should be seen as a result)
```

To install the project you must download it as a zip or clone it from this address:
<!-- ``` -->
[https://github.com/gonzafg2/Grupo_MOK_Tech_Lead.git](hhttps://github.com/gonzafg2/Grupo_MOK_Tech_Lead.git)
<!-- ``` -->

After having the files on your computer you must install, make sure you have all the dependencies installed on your local machine.

#### Dependencies 📋
* gem 'puma'
* gem 'money'
* gem 'httpx'
* gem 'erb'
* gem 'json'
* gem 'sinatra'

Run this command in a terminal:

```
sudo gem install puma money httpx erb json sinatra
```

Then you must install the project dependencies, for this you must execute the following command in a terminal:

```
bundle install
```
This will install all the dependencies necessary to run the application on your computer, which will be installed inside a folder called ***vendor***.

If everything went correctly you can see the app by executing the following command:

```
ruby app.rb
```

This will create a local server to view the project which you can access by entering one of these addresses: ***(Could be different on your computer)***

```
File 'index.html' successfully generated.
Initializing app...
== Sinatra (v3.1.0) has taken the stage on 4567 for development with backup from Puma
Puma starting in single mode...
* Puma version: 6.4.0 (ruby 3.0.2-p107) ("The Eagle of Durango")
*  Min threads: 0
*  Max threads: 5
*  Environment: development
*          PID: 253172
* Listening on http://127.0.0.1:4567
* Listening on http://[::1]:4567
Use Ctrl-C to stop
```

## Deployment 📦

You can deploy by pushing to Heroku, for this you must have a Heroku account and have the Heroku CLI installed on your computer:

```
git push heroku master
```

## Built with 🛠️

The following technologies have been used in this project:

* [HTML5 y CSS3](https://www.w3.org/) - Like tag languages and styles.
* [Bootstrap](https://getbootstrap.com/) - CSS framework.
* [Ruby](https://www.ruby-lang.org) - High-level, multi-purpose, multi-paradigm, general-purpose programming language.
* [HTTPX](https://www.rubydoc.info/gems/httpx) - Ruby library used to make calls to an API in a simple way, based on HTTP2 requests.
* [Heroku](https://www.heroku.com) - Used to deploy and host the application.

## Author ✒️

For now there is only one author:

* **Gonzalo Fleming** - _Initial Development_ - [gonzafg2](https://github.com/gonzafg2)

## License 📄

This project is under the MIT License - see the file [LICENSE](https://github.com/gonzafg2/Grupo_MOK_Tech_Lead/blob/master/LICENSE) for details.

## Expressions of Gratitude 🎁

* You can tell others about this project. 📢
* Or buy me a beer 🍺 or a coffee ☕.
* Or also give thanks publicly 🤓.
* Etc.

---
⌨️ with ❤️ by [GFleming](https://github.com/gonzafg2) 😊
