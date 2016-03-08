From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/1] ipset patch for nf
Date: Tue,  8 Mar 2016 20:44:19 +0100
Message-ID: <1457466260-20373-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:32919 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbcCHTni (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 14:43:38 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please apply the next patch against the nf tree:

- Julia Lawall pointed out that IPSET_ATTR_ETHER netlink attribute
  length was not checked explicitly. The patch adds the missing
  checkings.

The patch should be applied to the older stable kernel branches too.

Best regards,
Jozsef

The following changes since commit 45040978c8994d1401baf5cc5ac71c1495d4e120:

  netfilter: ipset: Fix set:list type crash when flush/dump set in parallel (2016-02-24 20:32:21 +0100)

are available in the git repository at:

  git://blackhole.kfki.hu/nf master

for you to fetch changes up to d8aacd87180141ff6b812b53de77a4336e87c91a:

  netfilter: ipset: Check IPSET_ATTR_ETHER netlink attribute length (2016-03-08 20:36:17 +0100)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      netfilter: ipset: Check IPSET_ATTR_ETHER netlink attribute length

 net/netfilter/ipset/ip_set_bitmap_ipmac.c | 2 ++
 net/netfilter/ipset/ip_set_hash_mac.c     | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)
