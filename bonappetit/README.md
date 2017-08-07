this one took a bit; i kept using the directory traversal in the `page` query
parameter to look for a flag file on disk

then i realized you could load `.htaccess` with it even though the `.htaccess`
forbids serving itself (apache cares about `.htaccess`, php doesn't)

```
<FilesMatch "suP3r_S3kr1t_Fl4G">
  Order Allow,Deny
  Deny from all
</FilesMatch>
```

from there you can see a `suP3r_S3kr1t_Fl4G` file that `.htaccess` specifically
forbids serving, but php on the other hand...

[http://bonappetit.stillhackinganyway.nl/?page=suP3r_S3kr1t_Fl4G](http://bonappetit.stillhackinganyway.nl/?page=suP3r_S3kr1t_Fl4G)
