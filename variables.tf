variable "resource_prefix" {
  type        = string
  description = "Prefix for resource names"
  default     = "terraform-hw"
}

variable "ssh_public_key" {
  type        = string
  description = "Public SSH key for virtual machine access"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKjx//F3vf4h33szji0E/eXp3m4eEeaP8F5hCj+i7JjZ6uElxRwWqimqHGGD2hAd6wt+sw53ro8ErGNqOlNDBTfS01e+gonNiOSISAYg5kFfci27tsOsxJr7vj6wQIN4NV4aorl0erXS863+d7u6LVyYY/pcL5N+OkoeXAUn51TvVr0rFRYToRrx4ZPtTz44JReCWGNUHXaHD8jH/sE/4DKo3MKt4usVPelqEzsSSLXe+UxmPaGkCH2o3k5TXL3bC+11gcLma7WSPYMNn1mrnY9ZNSysdz5rQu3CYze1+TD9GPHUYmLGnmkaoIzj0P6VKEe/CMq6VdPgI7borLaMy1 dev\\didyk.dmitriy@didyk-d-pc"
}
