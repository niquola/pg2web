sudo apt-get update
sudo apt-get install libreadline-dev \
  curl \
  libncurses5-dev \
  libpcre3-dev \
  libssl-dev \
  perl \
  make

VERSION='1.7.2.1'
curl http://openresty.org/download/ngx_openresty-$VERSION.tar.gz > openresty.tar.gz
tar xzvf openresty.tar.gz
rm openresty.tar.gz

BLD=`pwd`

cd openresty

./configure --prefix=$BLD \
  --with-luajit \
  --with-pcre \
  --with-pcre-jit \
  --with-ipv6 \
  --with-http_postgres_module \
  -j4

make & make install

rm  nginx/conf/nginx.conf
ln -s `pwd`/nginx.conf nginx/conf/nginx.conf
ls -lah nginx/conf/nginx.conf
