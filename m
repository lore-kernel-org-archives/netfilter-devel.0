From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/6] netfilter: set extensions
Date: Wed, 25 Mar 2015 13:07:44 +0000
Message-ID: <1427288870-26336-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48257 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbbCYNHy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 09:07:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches add so called "set extensions" to maintain optional
per element data for nft sets and converts nf_tables to use them.

Following patches will use these set extensions to add some features from
ipset which we are currently missing, namely timeouts and comments, as
well as set transactions, variable sized data for concatenations and
per-flow expressions. I'll send the next batch as soon as these have been
merged.

Please apply, thanks!


Patrick McHardy (6):
  rhashtable: provide len to obj_hashfn
  netfilter: nft_hash: restore struct nft_hash
  netfilter: nft_hash: indent rhashtable parameters
  netfilter: nft_hash: convert to use rhashtable callbacks
  netfilter: nf_tables: add set extensions
  netfilter: nf_tables: convert hash and rbtree to set extensions

 include/linux/rhashtable.h        |   6 +-
 include/net/netfilter/nf_tables.h | 119 ++++++++++++++++++++++++++++++--
 lib/rhashtable.c                  |   2 +-
 net/netfilter/nf_tables_api.c     | 135 ++++++++++++++++++++++++++++--------
 net/netfilter/nft_hash.c          | 141 +++++++++++++++++++++-----------------
 net/netfilter/nft_rbtree.c        |  64 ++++++-----------
 net/netlink/af_netlink.c          |   2 +-
 7 files changed, 326 insertions(+), 143 deletions(-)

-- 
2.1.0

