From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset-6.8 released
Date: Mon, 11 Jul 2011 11:28:36 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1107111120380.32664@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm happy to announce ipset-6.8. The new release contains an important fix
of the hash:net,iface type, so if you use that hash type *and* store
overlapping networks with different interfaces in the same set, then 
please upgrade.

Kernel part changes
 - Fix compiler warnings "'hash_ip4_data_next' declared inline after
   being called" (Chris Friesen)
 - hash:net,iface fixed to handle overlapping nets behind different
   interfaces
 - Make possible to hash some part of the data element only.

Userspace changes
 - Update the manpage and document the limits in hash:net,iface.
 - README file corrections from Richard Lucassen

You can download the source code of ipset from:
        http://ipset.netfilter.org
        ftp://ftp.netfilter.org/pub/ipset/
        git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
