mkdir qdarch
cd qdarch
wget https://raw.githubusercontent.com/l3f7s1d3/qdarch/master/qdarch/conky.conf
wget https://raw.githubusercontent.com/l3f7s1d3/qdarch/master/qdarch/doinchroot.sh
wget https://raw.githubusercontent.com/l3f7s1d3/qdarch/master/qdarch/i3
wget https://raw.githubusercontent.com/l3f7s1d3/qdarch/master/qdarch/quick.sh
wget https://raw.githubusercontent.com/l3f7s1d3/qdarch/master/qdarch/syslinux.cfg
chmod +x quick.sh
chmod +x doinchroot.sh
sleep 1
./quick.sh
