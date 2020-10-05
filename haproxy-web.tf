resource "digitalocean_droplet" "haproxy-web" {
  image              = "ubuntu-16-04-x64"
  name               = "haproxy-web"
  region             = "nyc1"
  size               = "512mb"
  private_networking = true
  ssh_keys = [
    data.digitalocean_ssh_key.homebase_ssh.id
  ]
  connection {
    host        = digitalocean_droplet.haproxy-web.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.pvt_key)
    timeout     = "2m"
  }
  provisioner "remote-exec" {
    inline = [
      "sleep 25",
      "sudo apt-get update",
      "sudo apt-get -y install haproxy"
    ]
  }
  provisioner "file" {
    content     = data.template_file.haproxyconf.rendered
    destination = "/etc/haproxy/haproxy.cfg"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo service haproxy restart"
    ]
  }
}
