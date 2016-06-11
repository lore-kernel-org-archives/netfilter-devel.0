From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 0/3] netfilter: fix a endless jump loop bug
Date: Sat, 11 Jun 2016 12:20:25 +0800
Message-ID: <1465618828-22162-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:49443 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbcFKEVS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Jun 2016 00:21:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

This patch set mainly fix a endless jump loop bug, for example, user
can add the following nft rules successfully:
  # nft add table filter
  # nft add chain filter test
  # nft add rule filter test tcp dport vmap {1: jump test}

This is because we skip the inactive elements in set, and miss the validate
check. Fix it in patch #2.

And after apply patch#2, I also find that there is a redundant 
nf_tables_set_destroy call when set bind fails, which cause my
mechain enter into deadlock. Fix it in patch #3.

Also fix a typo in patch #1.

Liping Zhang (3):
  netfilter: nf_tables: fix wrong check of NFT_SET_MAP in
    nf_tables_bind_set
  netfilter: nf_tables: fix a endless jump loop when use vmap
  netfilter: nf_tables: fix wrong destroy anonymous sets if binding
    fails

 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 40 +++++++++++++++++++--------------------
 net/netfilter/nft_hash.c          |  3 ++-
 net/netfilter/nft_rbtree.c        |  3 ++-
 4 files changed, 24 insertions(+), 23 deletions(-)

-- 
2.5.5


