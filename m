From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.14 released
Date: Fri, 21 Sep 2012 23:11:48 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1209212301110.16781@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:54449 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab2IUVLu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Sep 2012 17:11:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm happy to announce ipset 6.14, which includes two important bugfixes
and a few new features. 

If you use hash:*net* types, then consider upgrading: when the number of 
different sized networks are greater than the smallest CIDR value of the 
networks in such sets, the broken internal cidr book-keeping could lead 
invalid matching.

If you want to use the new feature of matching elements marked with 
"nomatch" in hash:*net* sets, then you need the corresponding new
revision of the "set" match in iptables 1.4.16 - which is unreleased yet - 
or use the iptables git tree :-).

Userspace changes:
 - Support to match elements marked with "nomatch" in hash:*net* sets
 - Coding style fixes
 - The set type revision number is added to the header part of listing
 - Help prints list type revision and terse description
 - Add /0 network support to hash:net,iface type
 - Fix errors when compiling in debug mode (Krunal Patel)
 - Make sure IPPROTO_UDPLITE is defined
 - build: restore -version-info (Jan Engelhardt)

Kernel part changes:
 - Support to match elements marked with "nomatch" in hash:*net* sets
 - Coding style fixes
 - Include supported revisions in module description
 - Add /0 network support to hash:net,iface type
 - Fix cidr book keeping for hash:*net* types
 - Check and reject crazy /0 input parameters
 - Backport ether_addr_equal
 - Coding style fix, backport from kernel
 - net: cleanup unsigned to unsigned int (Eric Dumazet)

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
