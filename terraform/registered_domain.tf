resource "aws_route53domains_registered_domain" "main_domain" {
  domain_name   = var.domain
  transfer_lock = false
  admin_contact {
    address_line_1 = var.address_line_1
    city           = var.city
    contact_type   = var.contact_type
    country_code   = var.country_code
    email          = var.email
    first_name     = var.first_name
    last_name      = var.last_name
    phone_number   = var.phone_number
    zip_code       = var.zip_code
  }
  billing_contact {
    address_line_1 = var.address_line_1
    city           = var.city
    contact_type   = var.contact_type
    country_code   = var.country_code
    email          = var.email
    first_name     = var.first_name
    last_name      = var.last_name
    phone_number   = var.phone_number
    zip_code       = var.zip_code
  }
  name_server {
    glue_ips = []
    name     = "ns-1632.awsdns-12.co.uk"
  }
  name_server {
    glue_ips = []
    name     = "ns-957.awsdns-55.net"
  }
  name_server {
    glue_ips = []
    name     = "ns-347.awsdns-43.com"
  }
  name_server {
    glue_ips = []
    name     = "ns-1391.awsdns-45.org"
  }
  registrant_contact {
    address_line_1 = var.address_line_1
    city           = var.city
    contact_type   = var.contact_type
    country_code   = var.country_code
    email          = var.email
    first_name     = var.first_name
    last_name      = var.last_name
    phone_number   = var.phone_number
    zip_code       = var.zip_code
  }
  tech_contact {
    address_line_1 = var.address_line_1
    city           = var.city
    contact_type   = var.contact_type
    country_code   = var.country_code
    email          = var.email
    first_name     = var.first_name
    last_name      = var.last_name
    phone_number   = var.phone_number
    zip_code       = var.zip_code
  }
}