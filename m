From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset-2.4.5 released
Date: Sat, 15 Nov 2008 21:23:45 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0811152120400.13100@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

The new ipset release contains a fix in the new set type setlist
and a kernel compatibility correction:

  - setlist type does not work properly together with swapping
    sets, bug reported by Thomas Jacob.
  - Include linux/capability.h explicitly in ip_set.c
    (Jan Engelhardt)

You can download the source of ipset from the webpage or svn:

        http://ipset.netfilter.org/
        svn co https://svn.netfilter.org/netfilter/trunk/ipset

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
