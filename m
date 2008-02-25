From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER -stable 03/03]: fix ebtable targets return
Date: Mon, 25 Feb 2008 15:01:04 +0100 (MET)
Message-ID: <20080225140102.20602.42947.sendpatchset@localhost.localdomain>
References: <20080225140058.20602.52127.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50675 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbYBYOBF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Feb 2008 09:01:05 -0500
In-Reply-To: <20080225140058.20602.52127.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: fix ebtable targets return

Upstream commit 1b04ab459:

The function ebt_do_table doesn't take NF_DROP as a verdict from the targets.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a07e4d33874c30069459f82917b2d334e5c58125
tree 91dda0811ebb02f60ba50c447834bb2bdb781cf6
parent 3040fdefd830230ef6c2515715755f312a24f814
author Patrick McHardy <kaber@trash.net> Mon, 25 Feb 2008 14:51:17 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 25 Feb 2008 14:51:17 +0100

 net/bridge/netfilter/ebt_dnat.c     |    2 +-
 net/bridge/netfilter/ebt_redirect.c |    2 +-
 net/bridge/netfilter/ebt_snat.c     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index 4fa9ecf..1024511 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -21,7 +21,7 @@ static int ebt_target_dnat(struct sk_buff *skb, unsigned int hooknr,
 	struct ebt_nat_info *info = (struct ebt_nat_info *)data;
 
 	if (!skb_make_writable(skb, 0))
-		return NF_DROP;
+		return EBT_DROP;
 
 	memcpy(eth_hdr(skb)->h_dest, info->mac, ETH_ALEN);
 	return info->target;
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index e322f10..88afc34 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -22,7 +22,7 @@ static int ebt_target_redirect(struct sk_buff *skb, unsigned int hooknr,
 	struct ebt_redirect_info *info = (struct ebt_redirect_info *)data;
 
 	if (!skb_make_writable(skb, 0))
-		return NF_DROP;
+		return EBT_DROP;
 
 	if (hooknr != NF_BR_BROUTING)
 		memcpy(eth_hdr(skb)->h_dest,
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 146e889..4c5a5a9 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -23,7 +23,7 @@ static int ebt_target_snat(struct sk_buff *skb, unsigned int hooknr,
 	struct ebt_nat_info *info = (struct ebt_nat_info *) data;
 
 	if (!skb_make_writable(skb, 0))
-		return NF_DROP;
+		return EBT_DROP;
 
 	memcpy(eth_hdr(skb)->h_source, info->mac, ETH_ALEN);
 	if (!(info->target & NAT_ARP_BIT) &&
