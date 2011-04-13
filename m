From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/5] netfilter: ipset patches
Date: Wed, 13 Apr 2011 21:52:31 +0200
Message-ID: <1302724356-19590-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:44662 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758201Ab1DMTwh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:52:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

Here follows the ipset patches for nf-next-2.6. This batch contains
the missing fixes compared to nf-2.6 and one new feature, the ability
to modify the timeout value of already existing elements.

Best regards,
Jozsef

Jozsef Kadlecsik (5):
  netfilter: ipset: list:set timeout variant fixes
  netfilter: ipset: references are protected by rwlock instead of mutex
  netfilter: ipset: Timeout can be modified for already added elements
  netfilter: ipset: bitmap:ip,mac type requires "src" for MAC
  netfilter: ipset: set match and SET target fixes

 include/linux/netfilter/ipset/ip_set.h       |    5 +-
 include/linux/netfilter/ipset/ip_set_ahash.h |   18 ++--
 net/netfilter/ipset/ip_set_bitmap_ip.c       |   23 ++--
 net/netfilter/ipset/ip_set_bitmap_ipmac.c    |   28 +++--
 net/netfilter/ipset/ip_set_bitmap_port.c     |   23 ++--
 net/netfilter/ipset/ip_set_core.c            |  109 ++++++++++++--------
 net/netfilter/ipset/ip_set_hash_ip.c         |   10 +-
 net/netfilter/ipset/ip_set_hash_ipport.c     |   12 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c   |   12 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |   12 +-
 net/netfilter/ipset/ip_set_hash_net.c        |    8 +-
 net/netfilter/ipset/ip_set_hash_netport.c    |   12 +-
 net/netfilter/ipset/ip_set_list_set.c        |  139 +++++++++++++++----------
 net/netfilter/xt_set.c                       |   18 +++-
 14 files changed, 248 insertions(+), 181 deletions(-)

