From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [ANNOUNCE] ipset 6.28 released
Date: Sun, 13 Mar 2016 12:35:18 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1603131230220.5571@nerf40.vanv.qr>
References: <alpine.DEB.2.10.1603122210440.15491@blackhole.kfki.hu> <alpine.LSU.2.20.1603122259210.6559@nerf40.vanv.qr> <alpine.DEB.2.10.1603131133010.18557@blackhole.kfki.hu> <alpine.LSU.2.20.1603131212410.8784@nerf40.vanv.qr>
 <alpine.DEB.2.10.1603131227140.18557@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:35592 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbcCMLfU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Mar 2016 07:35:20 -0400
In-Reply-To: <alpine.DEB.2.10.1603131227140.18557@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2016-03-13 12:29, Jozsef Kadlecsik wrote:
>On Sun, 13 Mar 2016, Jan Engelhardt wrote:
>
>> By the way, there is another issue. You are calling `modinfo` when make
>> install, but you are not passing  -b ${DESTDIR}, so it, too, fails
>> inside chroot buildroots. (because /lib/modules/V/kernel is empty;
>> ipset is in $DESTDIR/lib/modules/V/...)
>
>The variable DESTDIR is not defined by default, so some other trickery is 
>required to get the chroot prefix dir path at that level, when `modinfo` 
>is called. How do you call `configure` or `make`?

./configure --host=x86_64-suse-linux-gnu --build=x86_64-suse-linux-gnu
--program-prefix= --disable-dependency-tracking --prefix=/usr
--exec-prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin --sysconfdir=/etc
--datadir=/usr/share --includedir=/usr/include --libdir=/usr/lib64
--libexecdir=/usr/lib --localstatedir=/var --sharedstatedir=/usr/com
--mandir=/usr/share/man --infodir=/usr/share/info --disable-dependency-tracking
--disable-static --with-kbuild=/usr/src/linux-obj/x86_64/default
--with-ksource=/usr/src/linux --includedir=/usr/include/ipset

make -j6 all modules

make -j6 install modules_install
DESTDIR=/home/abuild/rpmbuild/BUILDROOT/ipset-6.28-0.x86_64
INSTALL_MOD_PATH=/home/abuild/rpmbuild/BUILDROOT/ipset-6.28-0.x86_64 V=1

