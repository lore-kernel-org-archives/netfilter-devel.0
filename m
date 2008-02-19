From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/07]: Fix incorrect use of skb_make_writable
Date: Tue, 19 Feb 2008 17:25:48 +0100 (MET)
Message-ID: <20080219162536.13631.48348.sendpatchset@localhost.localdomain>
References: <20080219162532.13631.71318.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50468 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbYBSQZt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:25:49 -0500
In-Reply-To: <20080219162532.13631.71318.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Fix incorrect use of skb_make_writable

http://bugzilla.kernel.org/show_bug.cgi?id=9920
The function skb_make_writable returns true or false.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 02413e566cd9a49bcf1f15f69cdc749780181412
tree 9ec6b55a428fbfdd24da2bc619ebf4c5dabb0354
parent 30c709c51fa0f400859890d534cfa02eb8d06cc7
author Joonwoo Park <joonwpark81@gmail.com> Tue, 19 Feb 2008 17:15:27 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 19 Feb 2008 17:15:27 +0100

 net/bridge/netfilter/ebt_dnat.c     |    2 +-
 net/bridge/netfilter/ebt_redirect.c |    2 +-
 net/bridge/netfilter/ebt_snat.c     |    2 +-
 net/ipv4/netfilter/arpt_mangle.c    |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index e700cbf..1ec671d 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -20,7 +20,7 @@ static int ebt_target_dnat(struct sk_buff *skb, unsigned int hooknr,
 {
 	const struct ebt_nat_info *info = data;
 
-	if (skb_make_writable(skb, 0))
+	if (!skb_make_writable(skb, 0))
 		return NF_DROP;
 
 	memcpy(eth_hdr(skb)->h_dest, info->mac, ETH_ALEN);
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index bfdf2fb..bfb9f74 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -21,7 +21,7 @@ static int ebt_target_redirect(struct sk_buff *skb, unsigned int hooknr,
 {
 	const struct ebt_redirect_info *info = data;
 
-	if (skb_make_writable(skb, 0))
+	if (!skb_make_writable(skb, 0))
 		return NF_DROP;
 
 	if (hooknr != NF_BR_BROUTING)
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index e252dab..204f996 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -22,7 +22,7 @@ static int ebt_target_snat(struct sk_buff *skb, unsigned int hooknr,
 {
 	const struct ebt_nat_info *info = data;
 
-	if (skb_make_writable(skb, 0))
+	if (!skb_make_writable(skb, 0))
 		return NF_DROP;
 
 	memcpy(eth_hdr(skb)->h_source, info->mac, ETH_ALEN);
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index 45fa4e2..3f4222b 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -19,7 +19,7 @@ target(struct sk_buff *skb,
 	unsigned char *arpptr;
 	int pln, hln;
 
-	if (skb_make_writable(skb, skb->len))
+	if (!skb_make_writable(skb, skb->len))
 		return NF_DROP;
 
 	arp = arp_hdr(skb);
