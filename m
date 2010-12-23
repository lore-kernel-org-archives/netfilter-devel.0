From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset-5.2 released
Date: Thu, 23 Dec 2010 15:57:12 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012231553460.6044@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm happy to announce ipset 5.2. The changelogs are short, one important 
fix is of listing/saving large sets:

userspace:
 - Handle internal printing errors
 - Use cast to void * instead of memcpy as Sparc workaround at 
   sockaddr_XXX (suggested by Jan Engelhardt)
 - Listing/saving of large sets could produce broken listing, fixed.
 - Support libtool < 2.2

kernel part:
 - Kernel version check at minimal supported version was mistyped, now 
   fixed.

You can download the source code from:
        http://ipset.netfilter.org
        ftp://ftp.netfilter.org/pub/ipset/
        git://git.netfilter.org/ipset.git, ipset-5 branch

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
