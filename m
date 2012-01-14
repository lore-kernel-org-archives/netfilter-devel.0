From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/8] ipset patches
Date: Sat, 14 Jan 2012 17:38:53 +0100
Message-ID: <1326559141-26783-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:60279 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755526Ab2ANQjV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Jan 2012 11:39:21 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Here follow the patches which bring the kernel in sync with the current
ipset release. I included the patches which was sent in September but was
forgotten due to the kernel.org issues. Please consider applying them.

Best regards,
Jozsef

Jan Engelhardt (3):
  netfilter: ipset: use NFPROTO_ constants
  netfilter: ipset: avoid use of kernel-only types
  netfilter: ipset: expose userspace-relevant parts in ip_set.h

Jozsef Kadlecsik (5):
  netfilter: ipset: Autoload set type modules safely
  netfilter: ipset: Dumping error triggered removing references twice
  netfilter: ipset: Log warning when a hash type of set gets full
  netfilter: ipset: Exceptions support added to hash:*net* types
  netfilter: ipset: hash:net,iface timeout bug fixed

 include/linux/netfilter/ipset/ip_set.h       |   35 ++++---
 include/linux/netfilter/ipset/ip_set_ahash.h |  119 ++++++++++++++++-----
 include/linux/netfilter/xt_set.h             |    4 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c       |    4 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c    |    4 +-
 net/netfilter/ipset/ip_set_bitmap_port.c     |    4 +-
 net/netfilter/ipset/ip_set_core.c            |   53 ++++++---
 net/netfilter/ipset/ip_set_getport.c         |    4 +-
 net/netfilter/ipset/ip_set_hash_ip.c         |   18 ++--
 net/netfilter/ipset/ip_set_hash_ipport.c     |   10 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c   |   10 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |  147 ++++++++++++++++++-------
 net/netfilter/ipset/ip_set_hash_net.c        |   89 +++++++++++++---
 net/netfilter/ipset/ip_set_hash_netiface.c   |   84 +++++++++++----
 net/netfilter/ipset/ip_set_hash_netport.c    |  150 +++++++++++++++++++-------
 net/netfilter/ipset/ip_set_list_set.c        |    2 +-
 16 files changed, 532 insertions(+), 205 deletions(-)

