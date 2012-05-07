From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/2] ipset related bugfixes
Date: Mon,  7 May 2012 14:35:43 +0200
Message-ID: <1336394145-10078-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:36078 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756342Ab2EGMfq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 May 2012 08:35:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please apply the next two bugfixes and push forward for kernel inclusion.
The patches can be pulled from git://blackhole.kfki.hu/git/net. Thanks!

Best regards,
Jozsef

Jozsef Kadlecsik (2):
  netfilter: ipset: Fix timeout value overflow bug
  netfilter: ipset: Fix hash size checking in kernel

 include/linux/netfilter/ipset/ip_set_ahash.h   |   16 ++++++++++++++++
 include/linux/netfilter/ipset/ip_set_timeout.h |    4 ++++
 net/netfilter/ipset/ip_set_hash_ip.c           |   10 +++++++---
 net/netfilter/ipset/ip_set_hash_ipport.c       |   10 +++++++---
 net/netfilter/ipset/ip_set_hash_ipportip.c     |   10 +++++++---
 net/netfilter/ipset/ip_set_hash_ipportnet.c    |   10 +++++++---
 net/netfilter/ipset/ip_set_hash_net.c          |   10 +++++++---
 net/netfilter/ipset/ip_set_hash_netiface.c     |   10 +++++++---
 net/netfilter/ipset/ip_set_hash_netport.c      |   10 +++++++---
 net/netfilter/xt_set.c                         |   15 +++++++++++++--
 10 files changed, 82 insertions(+), 23 deletions(-)

