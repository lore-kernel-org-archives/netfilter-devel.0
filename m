From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCEMENT] ipset-3.2
Date: Fri, 21 Aug 2009 16:12:27 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0908211609150.6879@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

Some small issues needed fixing, so here comes the new ipset release with 
the tiny changelog:

- Mixed up formats in ip_set_iptree.c fixed (Rob Sterenborg)
- Don't use 'bool' for backward compatibility reasons (Rob Sterenborg)

[It seems holidays are over :-).]

As usual, you can download it from http://ipset.netfilter.org or from 
git://git.netfilter.org/ipset.git.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
