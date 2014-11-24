From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.24 released
Date: Mon, 24 Nov 2014 22:05:47 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1411242200400.31300@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:54507 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbaKXVEy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:04:54 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm happy to announce ipset 6.24, which includes a couple of fixes,
backports from the kernel tree and a nice performance improvement by
the introduction of RCUs at the set level instead of the rwlocks.

Userspace changes:
  - The "extra" subdirectory for kernel modules may have a full subtree
    (reported by Jesper Dangaard Brouer)
  - Add more compatibility checkings to support older kernel releases
  - Make_global.am: Don't include host headers (Baruch Siach)
  - Alignment problem between 64bit kernel 32bit userspace fixed
    (reported by Sven-Haegar Koch)
  - Add script to check libipset.map for missing symbols
  - Update libipset.map with ipset_parse_tcp_udp_port (Thomas Backlund)
  - libipset: Bump lib version and update map file (Neutron Soutmun)
  - Bash utilities updated
  - ipset: Fix hyphen used as minus sign in manpage (Neutron Soutmun)
Kernel part changes:
  - netfilter: ipset: small potential read beyond the end of buffer
    (Dan Carpenter)
  - Fix parallel resizing and listing of the same set
  - styles warned by checkpatch.pl fixed
  - Introduce RCU in all set types instead of rwlock per set
    (performance tested by Jesper Dangaard Brouer)
  - Remove rbtree from hash:net,iface in order to run under RCU
  - Explicitly add padding elements to hash:net,net and hash:net,port,net
  - Allocate the proper size of memory when /0 networks are supported
  - Simplify cidr handling for hash:*net* types
  - Indicate when /0 networks are supported
  - Kernel API changes in em_ipset.c, support both old and new ones
  - netfilter: Convert uses of __constant_<foo> to <foo> (Joe Perches)
  - net: use the new API kvfree() (WANG Cong)
  - treewide: fix errors in print (Masanari Iida)
  - netfilter: use IS_ENABLED(CONFIG_BRIDGE_NETFILTER) (Pablo Neira Ayuso)
  - Use IS_ENABLED macro and define it if required
  - Alignment problem between 64bit kernel 32bit userspace fixed
    (reported by Sven-Haegar Koch)
  - netfilter: ipset: off by one in ip_set_nfnl_get_byindex()
    (Dan Carpenter)

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
