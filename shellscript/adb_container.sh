#!/bin/bash

create_container() {
image_name="rafly28/adb"
default_direktori="/home/ubuntu/shellscript/on-premise" # Changes This

printf "===================================="
printf "Defaultnya ada di $default_direktori"
printf "====================================\n\n"
printf "ini Listnya\n\n"
ls -l $default_direktori
echo -n "Shellscriptnya ada dimana bre: "
read tambahan_direktori

direktori="${default_direktori}${tambahan_direktori}"

echo -n "Mau bikin berapa neh containernya: "
read jumlah_container

if ! docker images | grep -q $image_name; then
    echo "Image $image_name tidak ditemukan. Melakukan pull image..."
    docker pull $image_name:2
else
    echo "Image $image_name sudah tersedia."
fi

for ((i=1; i<=$jumlah_container; i++))
do
    docker run -d -it --name install_engine$i -v $direktori:/shellscript rafly28/adb:2 bash
done
}

enter_container() {
nama_container=install_engine

echo -n "Mau masuk ke Container berapa cuyy: "
read nomor_container

docker exec -it $nama_container$nomor_container bash
}

remove_container(){
echo -n "Process removing container..."

nama_container=install_engine

jumlah_container=$(docker ps -a --format '{{.Names}}' | grep -c "$nama_container")

if [ $jumlah_container -gt 1 ]; then
    for nama in $(docker ps -a --format '{{.Names}}' | grep "$nama_container")
    do
        docker kill $nama && docker rm $nama

        echo "Container $nama telah dihentikan dan dihapus."
    done
elif [ $jumlah_container -eq 1 ]; then
    nama=$(docker ps -a --format '{{.Names}}' | grep "$nama_container")

    docker kill $nama && docker rm $nama

    echo "Container has been slain"
else
    echo "Tidak ditemukan container dengan nama yang sesuai."
fi
}
printf "==============================================\n"
printf "                ADB CONTAINER                 \n"
printf "==============================================\n"
#printf "Create by: Rafly\n\n"
echo "Pilih Action Shell Container:"
echo "1) Create Container"
echo "2) Enter Container"
echo "3) Remove Container"
read -p "Masukkan pilihan (1, 2, atau 3): " choice

case $choice in
    1)
        create_container
        ;;
    2)
        enter_container
        ;;
    3)
	remove_container
	;;
    *)
        echo "Pilihan tidak valid. Silakan jalankan script lagi dan pilih antara 1, 2, atau 3."
        ;;
esac
