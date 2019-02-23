# Simple Amiga VASM template: compile m68k on Linux, run on FS-UAE or real device

git clone https://github.com/devpack/amiga-vasm-template.git  
cd amiga-vasm-template  
make  
make run  
make clean  

Assume fs-uae is in the $PATH


Note: building vasm and vlink

wget http://server.owl.de/~frank/tags/vasm1_8e.tar.gz  
tar xfz vasm1_8e.tar.gz  
cd vasm  
make CPU=m68k SYNTAX=mot  

wget http://server.owl.de/~frank/tags/vlink0_16b.tar.gz  
tar xfz vlink0_16b.tar.gz  
cd vlink  
make CPU=m68k SYNTAX=mot  




