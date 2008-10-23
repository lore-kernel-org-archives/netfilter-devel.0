From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset-2.4.2 released
Date: Thu, 23 Oct 2008 19:40:30 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0810231931420.28950@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:54440 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbYJWRkc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2008 13:40:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Krzysztof Oledzki discovered a serious bug in the 2.4.x versions of ipset: 
when flushing a nethash/ipportnethash type of set, it can lead to a kernel 
crash due to a wrong type declaration in the flush functions. Also, for a 
successful compilation with kernel versions above 2.6.26.6, an include 
file was missing from ip_set_iptree.c and ip_set_iptreemap.c.

Please upgrade to ipset 2.4.2.

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
