provider "google" {
  credentials = file("mygcp-creds.json")
  project     = "newproj-372417"
  region      = "us-west1"
  zone        = "us-west1-a"
}

resource "google_compute_instance" "lamp_server" {
  name         = "my-lamp-server"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "projects/click-to-deploy-images/global/images/wordpress-v20220821"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}

resource "google_sql_database_instance" "dbase" {  
  name = "lamp-database"
  database_version = "MYSQL_8_0"
  region = "us-west1"
  settings {
    tier = "db-f1-micro"
  }
  deletion_protection = "false"
}

resource "google_sql_database" "lamp_database" { 
  name = "lamp-database1"
  instance = google_sql_database_instance.dbase.name
  charset = "utf8"
  collation = "utf8_general_ci"
}

resource "google_sql_user" "user" {
  name = "root"
  instance = "${google_sql_database_instance.dbase.name}"
  host = "%"
  password = "mypassw0rd"
}
