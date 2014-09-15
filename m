From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/8] ipset patches for nf-next
Date: Mon, 15 Sep 2014 23:02:46 +0200
Message-ID: <1410814974-9918-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:50010 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757614AbaIOVCh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:02:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please consider to apply the next series of patches:

- the new hash:mac type by which it's easy to store
  just the MAC addresses in a set
- an optimization to the skbinfo expression, which
  suppresses sending zero valued extensions
- the skbinfo extension support to the SET
  target from Anton Danilov
- the skbinfo extension support for the list,
  hash and bitmap types separatedly
  from Anton Danilov
- the skbinfo extension support in the ipset
  core from Anton Danilov
- a fix for a static checker warning in
  ip_set_core.c, reported by Dan Carpenter

The skbinfo extension makes possible to store
fw mark, tc class and/or hardware queue parameters
together with the set elements and then attach
them to the matchig packets by the SET target.

You can pull the changes from

        git://blackhole.kfki.hu/nf-next master

The iptables part of the new SET target functionality
can be found in the iptables git tree, in the ipset
branch.

Thanks,
Jozsef

============================================================================
The following changes since commit 0bbe80e571c7b866afd92a98edd32a969467a7a9:

  netfilter: masquerading needs to be independent of x_tables in Kconfig (2014-09-12 09:40:18 +0200)

are available in the git repository at:

  git://blackhole.kfki.hu/nf-next master

for you to fetch changes up to 07034aeae152de52c29f032ca995bf9dafbe24e2:

  netfilter: ipset: hash:mac type added to ipset (2014-09-15 22:20:21 +0200)

----------------------------------------------------------------
Anton Danilov (5):
      netfilter: ipset: Add skbinfo extension kernel support in the ipset core.
      netfilter: ipset: Add skbinfo extension kernel support for the bitmap set types.
      netfilter: ipset: Add skbinfo extension kernel support for the hash set types.
      netfilter: ipset: Add skbinfo extension kernel support for the list set type.
      netfilter: ipset: Add skbinfo extension support to SET target.

Jozsef Kadlecsik (3):
      netfilter: ipset: Fix static checker warning in ip_set_core.c
      netfilter: ipset: send nonzero skbinfo extensions only
      netfilter: ipset: hash:mac type added to ipset

 include/linux/netfilter/ipset/ip_set.h       |  60 +++++++++-
 include/uapi/linux/netfilter/ipset/ip_set.h  |  12 ++
 include/uapi/linux/netfilter/xt_set.h        |  10 ++
 net/netfilter/ipset/Kconfig                  |   9 ++
 net/netfilter/ipset/Makefile                 |   1 +
 net/netfilter/ipset/ip_set_bitmap_gen.h      |   4 +
 net/netfilter/ipset/ip_set_bitmap_ip.c       |  11 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c    |  11 +-
 net/netfilter/ipset/ip_set_bitmap_port.c     |  11 +-
 net/netfilter/ipset/ip_set_core.c            |  30 ++++-
 net/netfilter/ipset/ip_set_hash_gen.h        |  16 ++-
 net/netfilter/ipset/ip_set_hash_ip.c         |  14 ++-
 net/netfilter/ipset/ip_set_hash_ipmark.c     |  14 ++-
 net/netfilter/ipset/ip_set_hash_ipport.c     |  14 ++-
 net/netfilter/ipset/ip_set_hash_ipportip.c   |  14 ++-
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |  14 ++-
 net/netfilter/ipset/ip_set_hash_mac.c        | 173 +++++++++++++++++++++++++++
 net/netfilter/ipset/ip_set_hash_net.c        |  16 ++-
 net/netfilter/ipset/ip_set_hash_netiface.c   |  16 ++-
 net/netfilter/ipset/ip_set_hash_netnet.c     |  16 ++-
 net/netfilter/ipset/ip_set_hash_netport.c    |  16 ++-
 net/netfilter/ipset/ip_set_hash_netportnet.c |  16 ++-
 net/netfilter/ipset/ip_set_list_set.c        |  19 ++-
 net/netfilter/xt_set.c                       | 155 ++++++++++++++++++++++++
 24 files changed, 635 insertions(+), 37 deletions(-)
 create mode 100644 net/netfilter/ipset/ip_set_hash_mac.c
