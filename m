From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/1] ipset patch for nf
Date: Wed, 24 Feb 2016 21:19:25 +0100
Message-ID: <1456345166-23605-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:34010 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbcBXU2Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Feb 2016 15:28:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please apply the next patch against the nf tree:

- Deniz Eren reported that parallel flush/dump of list:set type of sets
  can lead to kernel crash. The bug was due to non-RCU compatible flushing,
  listing in the set type, fixed by me.

The following changes since commit 5cc6ce9ff27565949a1001a2889a8dd9fd09e772:

  netfilter: nft_counter: fix erroneous return values (2016-02-08 13:05:02 +0100)

are available in the git repository at:

  git://blackhole.kfki.hu/nf master

for you to fetch changes up to 45040978c8994d1401baf5cc5ac71c1495d4e120:

  netfilter: ipset: Fix set:list type crash when flush/dump set in parallel (2016-02-24 20:32:21 +0100)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      netfilter: ipset: Fix set:list type crash when flush/dump set in parallel

 net/netfilter/ipset/ip_set_core.c     |  3 +++
 net/netfilter/ipset/ip_set_list_set.c | 55 ++++++++++++++++++++++--------------------------
 2 files changed, 28 insertions(+), 30 deletions(-)
