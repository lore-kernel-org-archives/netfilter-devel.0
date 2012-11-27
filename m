From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.16.1 released
Date: Tue, 27 Nov 2012 15:16:42 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211271510180.15929@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:42984 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629Ab2K0OQo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:16:44 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm happy to announce ipset 6.16.1. The most important part is the patch 
from Florian Westphal, which fixes netiface set name overflow in the 
kernel. The RCU handling of the automating increase of the maximal sets 
feature introduced in 6.15 is also fixed.

Userspace changes:
  - Remove all modules before testing resize 
  - build: support for Linux 3.7 UAPI (Jan Engelhardt) 

Kernel part changes:
  - Add ipset package version to external module description 
  - Backport RCU handling up to 2.6.32.x 
  - Netlink pid is renamed to portid in kernel 3.7.0 
  - Fix RCU handling when the number of maximal sets are increased
  - netfilter: ipset: fix netiface set name overflow (Florian Westphal) 

You can download the source code of ipset from:
        http://ipset.netfilter.org
        ftp://ftp.netfilter.org/pub/ipset/
        git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
