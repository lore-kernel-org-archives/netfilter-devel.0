From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.21.1 released
Date: Fri, 7 Mar 2014 13:32:26 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1403071328240.32311@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:37087 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbaCGMcd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 07:32:33 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The library version was messed up in 6.21 which is fixed in 
this release. The bash utilities are updated as well.

Userspace changes:
  - The bash utilities are updated
  - Fix libipset library release versioning (reported by Mathieu Bridon)

Kernel part changes:
  - netfilter: ip_set: rename nfnl_dereference()/nfnl_set()
    (Patrick McHardy)

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
