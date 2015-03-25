From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/4] netfilter: nf_tables: set transactions
Date: Wed, 25 Mar 2015 14:08:46 +0000
Message-ID: <1427292530-28529-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48909 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbbCYOIy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 10:08:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These patches add transaction support to set elements. It pretty much
resembles the existing transaction support, the changelogs explain it
in more detail.

As a by-product the patches get rid of the RCU grace period for every
nft_hash element that is destroyed, we now have only the single global
transaction grace perdiod independantly of what we destroy.

Please apply, thanks!


Patrick McHardy (4):
  netfilter: nf_tables: consolide set element destruction
  netfilter: nf_tables: return set extensions from ->lookup()
  netfilter: nf_tables: add transaction helper functions
  netfilter: nf_tables: implement set transaction support

 include/net/netfilter/nf_tables.h | 67 +++++++++++++++++++++++++++----
 net/netfilter/nf_tables_api.c     | 84 +++++++++++++++++++++------------------
 net/netfilter/nf_tables_core.c    |  6 +--
 net/netfilter/nft_hash.c          | 62 ++++++++++++++++-------------
 net/netfilter/nft_lookup.c        |  6 ++-
 net/netfilter/nft_rbtree.c        | 69 +++++++++++++++++++-------------
 6 files changed, 188 insertions(+), 106 deletions(-)

-- 
2.1.0

