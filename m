From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 00/12] ipset patches against nf-next-2.6, updated again
Date: Wed,  1 Jun 2011 23:35:39 +0200
Message-ID: <1306964151-4686-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:40458 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759912Ab1FAVfx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2011 17:35:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

I have updated the patches with the changes since last time I sent them.
The patches can be applied only if nf-next-2.6 is rebased onto current
net-next-2.6.

Please consider applying them.

Best regards,
Jozsef

Jozsef Kadlecsik (12):
  netfilter: ipset: Timeout can be modified for already added elements
  netfilter: ipset: Options and flags support added to the kernel API
  netfilter: ipset: Support listing setnames and headers too
  netfilter: ipset: Fix adding ranges to hash types
  netfilter: ipset: Set type support with multiple revisions added
  netfilter: ipset: Support range for IPv4 at adding/deleting elements
    for hash:*net* types
  netfilter: ipset: Take into account cidr value for the from address
    when creating the set
  netfilter: ipset: Add xt_action_param to the variant level kadt
    functions
  netfilter: ipset: Fix return code for destroy when sets are in use
  netfilter: ipset: Use the stored first cidr value instead of '1'
  netfilter: ipset: hash:net,iface type introduced
  netfilter: ipset: Whitespace and coding fixes, detected by
    checkpatch.pl

 include/linux/netfilter/ipset/ip_set.h         |   50 ++-
 include/linux/netfilter/ipset/ip_set_ahash.h   |   48 ++-
 include/linux/netfilter/ipset/ip_set_hash.h    |    4 +
 include/linux/netfilter/ipset/ip_set_timeout.h |    3 +
 include/linux/netfilter/ipset/pfxlen.h         |   11 +-
 include/linux/netfilter/xt_set.h               |   15 +-
 net/netfilter/ipset/Kconfig                    |   10 +
 net/netfilter/ipset/Makefile                   |    1 +
 net/netfilter/ipset/ip_set_bitmap_ip.c         |   35 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c      |   38 +-
 net/netfilter/ipset/ip_set_bitmap_port.c       |   31 +-
 net/netfilter/ipset/ip_set_core.c              |  165 +++---
 net/netfilter/ipset/ip_set_hash_ip.c           |   43 +-
 net/netfilter/ipset/ip_set_hash_ipport.c       |   63 ++-
 net/netfilter/ipset/ip_set_hash_ipportip.c     |   67 ++-
 net/netfilter/ipset/ip_set_hash_ipportnet.c    |  141 +++--
 net/netfilter/ipset/ip_set_hash_net.c          |   90 +++-
 net/netfilter/ipset/ip_set_hash_netiface.c     |  762 ++++++++++++++++++++++++
 net/netfilter/ipset/ip_set_hash_netport.c      |  119 +++--
 net/netfilter/ipset/ip_set_list_set.c          |  106 +++--
 net/netfilter/ipset/pfxlen.c                   |   23 +-
 net/netfilter/xt_set.c                         |  152 ++++--
 22 files changed, 1588 insertions(+), 389 deletions(-)
 create mode 100644 net/netfilter/ipset/ip_set_hash_netiface.c

