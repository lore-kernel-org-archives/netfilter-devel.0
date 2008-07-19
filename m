From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset-2.3.3
Date: Sat, 19 Jul 2008 23:16:37 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807192259320.24664@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

This is a compatibility fix release of ipset which supports kernel 
versions >= 2.6.16 and 2.4.36.x. All internal changes which affect ipset 
above 2.6.16 and between 2.4.36.x and the 2.6 kernel trees were checked 
and revised. Now a single source tree supports both the 2.6 and the 2.4 
kernel versions. 

If you run ipset on a 2.4 kernel, please upgrade as you'll get all the 
bugfixes (which had been forgotten to backport) and iptreemap support.

You can download ipset from the home page or from the svn repository

        http://ipset.netfilter.org/
        https://svn.netfilter.org/netfilter/trunk/ipset

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
