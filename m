From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset 6.19 released
Date: Thu, 9 May 2013 22:28:26 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1305092214320.25002@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:52344 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab3EIU2a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 May 2013 16:28:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm happy to announce ipset 6.19. The main new feature in this release is 
the per element byte and packet counters for every set type, which is 
based on the new internal extension infrastructure. Please read the 
updated manpage on how to use counters, initialize or change them.

The management and matching of counters is added to the "set" match of 
iptables/ip6tables, which is available in the "next" branch of the 
iptables git tree.

Userspace changes:
  - Check at modules_install whether depmod ignores the extra subdir
    (reported by Husnu Demir and tian fang)
  - The utils are updated from their sources
  - Manpage typing error correction (reported by Husnu Demir)
  - Update testsuite as the trailing space was eliminated at listings
  - Add sparse checking support to userspace
  - Improve XML output: add element tag and root element (suggested by 
    Lucas Hamie)
  - Manpage updates
  - Add new testsuite entries to verify counters and the new type
    implementation
  - Introduce the new set type revisions with counter support
  - Support counters in the ipset library
  - The uapi include split in the package itself

Kernel part changes:
  - Compatibility fixes to keep the support of kernels back to 2.6.32
  - Backport nla_put_net64
  - Support package fragments for IPv4 protos without ports
    (Anders K. Pedersen)
  - Use fix sized type for timeout in the extension part
  - Make sure kernel configured properly for sparse checkings
  - Fix "may be used uninitialized" warnings (reported by Pablo Neira
    Ayuso)
  - Rename simple macro names to avoid namespace issues (reported by
    David Laight)
  - Fix sparse warnings due to missing rcu annotations (reported by
    Pablo Neira Ayuso)
  - Sparse warning about shadowed variable fixed
  - Don't call ip_nest_end needlessly in the error path (suggested by
    Pablo Neira Ayuso)
  - set match: add support to match the counters
  - The list:set type with counter support
  - The hash types with counter support
  - The bitmap types with counter support
  - Introduce the counter extension in the core
  - list:set type using the extension interface
  - Hash types using the unified code base
  - Unified hash type generation
  - Bitmap types using the unified code base
  - Unified bitmap type generation
  - Introduce extensions to elements in the core
  - Move often used IPv6 address masking function to header file
  - Make possible to test elements marked with nomatch, from userspace
  - netfilter ipset: Use ipv6_addr_equal() where appropriate.
    (YOSHIFUJI Hideaki)
  - Add a compatibility header file for easier maintenance
  - The uapi include split in the package itself
  - Reorder modules a little bit in Kbuild

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
