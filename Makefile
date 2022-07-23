addons/GDSerCommDock/bin/libGDSercomm.dylib:
	curl -Lo GDSercomm.zip https://github.com/Team-ROUS/GDSercomm/archive/refs/heads/master.zip
	unzip GDSercomm.zip
	mv GDSercomm-master GDSercomm
	cd GDSercomm && make
	cp GDSercomm/bin/libGDSercomm.dylib addons/GDSerCommDock/bin

clean:
	rm -rf GDSercomm
	rm -f GDSercomm.zip
	rm -f addons/GDSerCommDock/bin/libGDSercomm.dylib
