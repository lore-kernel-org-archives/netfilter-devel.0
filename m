From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.28 released
Date: Sun, 13 Mar 2016 12:49:16 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1603131239390.18557@blackhole.kfki.hu>
References: <alpine.DEB.2.10.1603122210440.15491@blackhole.kfki.hu> <alpine.LSU.2.20.1603122259210.6559@nerf40.vanv.qr> <alpine.DEB.2.10.1603131133010.18557@blackhole.kfki.hu> <alpine.LSU.2.20.1603131212410.8784@nerf40.vanv.qr> <alpine.DEB.2.10.1603131227140.18557@blackhole.kfki.hu>
 <alpine.LSU.2.20.1603131230220.5571@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:48631 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbcCMLsd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Mar 2016 07:48:33 -0400
In-Reply-To: <alpine.LSU.2.20.1603131230220.5571@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 13 Mar 2016, Jan Engelhardt wrote:

> >> By the way, there is another issue. You are calling `modinfo` when make
> >> install, but you are not passing  -b ${DESTDIR}, so it, too, fails
> >> inside chroot buildroots. (because /lib/modules/V/kernel is empty;
> >> ipset is in $DESTDIR/lib/modules/V/...)
> >
> >The variable DESTDIR is not defined by default, so some other trickery is 
> >required to get the chroot prefix dir path at that level, when `modinfo` 
> >is called. How do you call `configure` or `make`?
> 
> ./configure --host=x86_64-suse-linux-gnu --build=x86_64-suse-linux-gnu
> --program-prefix= --disable-dependency-tracking --prefix=/usr
> --exec-prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin --sysconfdir=/etc
> --datadir=/usr/share --includedir=/usr/include --libdir=/usr/lib64
> --libexecdir=/usr/lib --localstatedir=/var --sharedstatedir=/usr/com
> --mandir=/usr/share/man --infodir=/usr/share/info --disable-dependency-tracking
> --disable-static --with-kbuild=/usr/src/linux-obj/x86_64/default
> --with-ksource=/usr/src/linux --includedir=/usr/include/ipset
> 
> make -j6 all modules
> 
> make -j6 install modules_install
> DESTDIR=/home/abuild/rpmbuild/BUILDROOT/ipset-6.28-0.x86_64
> INSTALL_MOD_PATH=/home/abuild/rpmbuild/BUILDROOT/ipset-6.28-0.x86_64 V=1

So we'd need INSTALL_MOD_PATH then. I'm going to commit the next patch to 
address chroot buildroots:

diff --git a/Makefile.am b/Makefile.am
index 684ebee..e3404fa 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -16,6 +16,7 @@ IP_SET_MAX=$(MAXSETS)
 endif
 
 SUBDIRS                = include/libipset lib src utils
+INSTALL_MOD_PATH = /
 
 sparse:
        $(MAKE) -C lib sparse-check
@@ -71,7 +72,7 @@ modules_install:
 if WITH_KMOD
        ${MAKE} -C $(KBUILD_OUTPUT) M=$$PWD/kernel/net \
                        KDIR=$$PWD/kernel modules_install
-       @modinfo ip_set_hash_ip | ${GREP} /extra/ >/dev/null || echo "$$DEPMOD_WARNING"
+       @modinfo -b ${INSTALL_MOD_PATH} ip_set_hash_ip | ${GREP} /extra/ >/dev/null || echo "$$DEPMOD_WARNING
        @lsmod | ${GREP} '^ip_set' >/dev/null && echo "$$MODULE_WARNING"
 else
        @echo Skipping kernel modules due to --with-kmod=no

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
