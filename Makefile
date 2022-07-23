addons/GDSerCommDock/bin/libGDSercomm.dylib:
	git clone --depth=1 git@github.com:Team-ROUS/GDSercomm.git
	cd GDSercomm && make
	cp GDSercomm/bin/libGDSercomm.dylib addons/GDSerCommDock/bin

clean:
	rm -rf GDSercomm
	rm -f addons/GDSerCommDock/bin/libGDSercomm.dylib
