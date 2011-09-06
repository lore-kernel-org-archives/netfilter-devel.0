From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/6] ipset patches
Date: Tue,  6 Sep 2011 21:59:01 +0200
Message-ID: <1315339147-9617-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:44373 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab1IFT7o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Sep 2011 15:59:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick and Pablo,

Here follows the patches which brings the kernel sync with ipset 6.9.1.
The first two are important bugfixes. Please consider applying them.

Best regards,
Jozsef

Jan Engelhardt (3):
  netfilter: ipset: avoid use of kernel-only types
  netfilter: ipset: expose userspace-relevant parts in ip_set.h
  netfilter: ipset: use NFPROTO_ constants

Joe Perches (1):
  netfilter: ipset: Remove unnecessary OOM logging messages

Jozsef Kadlecsik (2):
  netfilter: ipset: Autoload set type modules safely
  netfilter: ipset: Dumping error could lead to kernel BUG

 include/linux/netfilter/ipset/ip_set.h      |   31 ++++++++------
 include/linux/netfilter/xt_set.h            |    4 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c      |    4 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c   |    4 +-
 net/netfilter/ipset/ip_set_bitmap_port.c    |    4 +-
 net/netfilter/ipset/ip_set_core.c           |   57 +++++++++++++++++----------
 net/netfilter/ipset/ip_set_getport.c        |    4 +-
 net/netfilter/ipset/ip_set_hash_ip.c        |   18 ++++----
 net/netfilter/ipset/ip_set_hash_ipport.c    |   10 ++--
 net/netfilter/ipset/ip_set_hash_ipportip.c  |   10 ++--
 net/netfilter/ipset/ip_set_hash_ipportnet.c |   12 +++---
 net/netfilter/ipset/ip_set_hash_net.c       |   12 +++---
 net/netfilter/ipset/ip_set_hash_netiface.c  |   12 +++---
 net/netfilter/ipset/ip_set_hash_netport.c   |   12 +++---
 net/netfilter/ipset/ip_set_list_set.c       |    2 +-
 15 files changed, 108 insertions(+), 88 deletions(-)

