From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/2] netfilter: ipset: new features
Date: Thu,  7 Apr 2011 12:10:58 +0200
Message-ID: <1302171060-20872-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:43574 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab1DGKLE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2011 06:11:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

Here come the feature improvements from ipset 6.2. Please apply them.

Best regards,
Jozsef

Jozsef Kadlecsik (2):
  netfilter: ipset: SCTP, UDPLITE support added
  netfilter: ipset: Timeout can be modified for already added elements

 include/linux/netfilter/ipset/ip_set.h         |    3 +-
 include/linux/netfilter/ipset/ip_set_ahash.h   |   15 ++--
 include/linux/netfilter/ipset/ip_set_getport.h |    2 +
 net/netfilter/ipset/ip_set_bitmap_ip.c         |   20 +++---
 net/netfilter/ipset/ip_set_bitmap_ipmac.c      |   21 +++---
 net/netfilter/ipset/ip_set_bitmap_port.c       |   20 +++---
 net/netfilter/ipset/ip_set_getport.c           |   16 ++++-
 net/netfilter/ipset/ip_set_hash_ip.c           |   10 ++--
 net/netfilter/ipset/ip_set_hash_ipport.c       |   14 ++--
 net/netfilter/ipset/ip_set_hash_ipportip.c     |   14 ++--
 net/netfilter/ipset/ip_set_hash_ipportnet.c    |   14 ++--
 net/netfilter/ipset/ip_set_hash_net.c          |    8 +-
 net/netfilter/ipset/ip_set_hash_netport.c      |   14 ++--
 net/netfilter/ipset/ip_set_list_set.c          |   92 ++++++++++++++++--------
 14 files changed, 157 insertions(+), 106 deletions(-)

