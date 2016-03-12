From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.28 released
Date: Sat, 12 Mar 2016 22:15:10 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1603122210440.15491@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:38760 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbcCLVO3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Mar 2016 16:14:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm happy to announce ipset 6.28 with a couple of important fixes, some 
compatibility improvements and corrections.

Userspace changes:
  - Support older pkg-config packages
  - Add bash completion to the install routine (Mart Frauenlob)
  - Fix misleading error message with comment extension
  - Test added to check 0.0.0.0/0,iface to be matched in
    hash:net,iface type
  - Fix link with libtool >= 2.4.4 (Olivier Blin)
Kernel part changes:
  - Check IPSET_ATTR_ETHER netlink attribute length
  - Fix __aligned_u64 compatibility support for older kernel releases
  - Add compatibility to support EXPORT_SYMBOL_GPL in module.h
  - Fix set:list type crash when flush/dump set in parallel
  - Pass down netns pointer to call() and call_rcu() (backport)
  - Allow a 0 netmask with hash_netiface type (Florian Westphal)

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
