From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER -stable 02/03]: Fix incorrect use of skb_make_writable
Date: Mon, 25 Feb 2008 15:01:02 +0100 (MET)
Message-ID: <20080225140100.20602.23690.sendpatchset@localhost.localdomain>
References: <20080225140058.20602.52127.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50671 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbYBYOBE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Feb 2008 09:01:04 -0500
In-Reply-To: <20080225140058.20602.52127.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Fix incorrect use of skb_make_writable

Upstream commit eb1197bc0:

http://bugzilla.kernel.org/show_bug.cgi?id=9920
The function skb_make_writable returns true or false.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3040fdefd830230ef6c2515715755f312a24f814
tree 05308bc27435162f4b2060158ee87abf786e8d0e
parent 2e1a9528d31fda88923d6615eb4933df07f59762
author Patrick McHardy <kaber@trash.net> Mon, 25 Feb 2008 14:51:17 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 25 Feb 2008 14:51:17 +0100

 net/bridge/netfilter/ebt_dnat.c     |    2 +-
 net/bridge/netfilter/ebt_redirect.c |    2 +-
 net/bridge/netfilter/ebt_snat.c     |    2 +-
 net/ipv4/netfilter/arpt_mangle.c    |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index 74262e9..4fa9ecf 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -20,7 +20,7 @@ static int ebt_target_dnat(struct sk_buff *skb, unsigned int hooknr,
 {
 	struct ebt_nat_info *info = (struct ebt_nat_info *)data;
 
-	if (skb_make_writable(skb, 0))
+	if (!skb_make_writable(skb, 0))
 		return NF_DROP;
 
 	memcpy(eth_hdr(skb)->h_dest, info->mac, ETH_ALEN);
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index 422cb83..e322f10 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -21,7 +21,7 @@ static int ebt_target_redirect(struct sk_buff *skb, unsigned int hooknr,
 {
 	struct ebt_redirect_info *info = (struct ebt_redirect_info *)data;
 
-	if (skb_make_writable(skb, 0))
+	if (!skb_make_writable(skb, 0))
 		return NF_DROP;
 
 	if (hooknr != NF_BR_BROUTING)
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 425ac92..146e889 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -22,7 +22,7 @@ static int ebt_target_snat(struct sk_buff *skb, unsigned int hooknr,
 {
 	struct ebt_nat_info *info = (struct ebt_nat_info *) data;
 
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
