From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/07]: nfnetlink_queue: fix SKB_LINEAR_ASSERT when mangling packet data
Date: Tue, 19 Feb 2008 17:25:46 +0100 (MET)
Message-ID: <20080219162533.13631.56839.sendpatchset@localhost.localdomain>
References: <20080219162532.13631.71318.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50462 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbYBSQZr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:25:47 -0500
In-Reply-To: <20080219162532.13631.71318.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: {ip,ip6,nfnetlink}_queue: fix SKB_LINEAR_ASSERT when mangling packet data

As reported by Tomas Simonaitis <tomas.simonaitis@gmail.com>, inserting new
data in skbs queued over {ip,ip6,nfnetlink}_queue triggers a SKB_LINEAR_ASSERT
in skb_put().

Going back through the git history, it seems this bug is present since at
least 2.6.12-rc2, probably even since the removal of skb_linearize() for
netfilter.

Linearize non-linear skbs through skb_copy_expand() when enlarging them.
Tested by Thomas, fixes bugzilla #9933.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2292fd9623ce0391217dfe8cec57f70fd90da538
tree ba852b5da64fac4aaec85ecf9622cca31e3ffb0d
parent 73b9987a76c8e0b5326afcc3632f79be425676bc
author Patrick McHardy <kaber@trash.net> Tue, 19 Feb 2008 17:15:26 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 19 Feb 2008 17:15:26 +0100

 net/ipv4/netfilter/ip_queue.c   |   12 +++++++-----
 net/ipv6/netfilter/ip6_queue.c  |   10 ++++++----
 net/netfilter/nfnetlink_queue.c |   10 ++++++----
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index 6bda110..fe05da4 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -283,8 +283,8 @@ static int
 ipq_mangle_ipv4(ipq_verdict_msg_t *v, struct nf_queue_entry *e)
 {
 	int diff;
-	int err;
 	struct iphdr *user_iph = (struct iphdr *)v->payload;
+	struct sk_buff *nskb;
 
 	if (v->data_len < sizeof(*user_iph))
 		return 0;
@@ -296,14 +296,16 @@ ipq_mangle_ipv4(ipq_verdict_msg_t *v, struct nf_queue_entry *e)
 		if (v->data_len > 0xFFFF)
 			return -EINVAL;
 		if (diff > skb_tailroom(e->skb)) {
-			err = pskb_expand_head(e->skb, 0,
+			nskb = skb_copy_expand(e->skb, 0,
 					       diff - skb_tailroom(e->skb),
 					       GFP_ATOMIC);
-			if (err) {
+			if (!nskb) {
 				printk(KERN_WARNING "ip_queue: error "
-				      "in mangle, dropping packet: %d\n", -err);
-				return err;
+				      "in mangle, dropping packet\n");
+				return -ENOMEM;
 			}
+			kfree_skb(e->skb);
+			e->skb = nskb;
 		}
 		skb_put(e->skb, diff);
 	}
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
index e869916..cc2f9af 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -285,8 +285,8 @@ static int
 ipq_mangle_ipv6(ipq_verdict_msg_t *v, struct nf_queue_entry *e)
 {
 	int diff;
-	int err;
 	struct ipv6hdr *user_iph = (struct ipv6hdr *)v->payload;
+	struct sk_buff *nskb;
 
 	if (v->data_len < sizeof(*user_iph))
 		return 0;
@@ -298,14 +298,16 @@ ipq_mangle_ipv6(ipq_verdict_msg_t *v, struct nf_queue_entry *e)
 		if (v->data_len > 0xFFFF)
 			return -EINVAL;
 		if (diff > skb_tailroom(e->skb)) {
-			err = pskb_expand_head(e->skb, 0,
+			nskb = skb_copy_expand(e->skb, 0,
 					       diff - skb_tailroom(e->skb),
 					       GFP_ATOMIC);
-			if (err) {
+			if (!nskb) {
 				printk(KERN_WARNING "ip6_queue: OOM "
 				      "in mangle, dropping packet\n");
-				return err;
+				return -ENOMEM;
 			}
+			kfree_skb(e->skb);
+			e->skb = nskb;
 		}
 		skb_put(e->skb, diff);
 	}
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a48b20f..0043d3a 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -443,8 +443,8 @@ err_out:
 static int
 nfqnl_mangle(void *data, int data_len, struct nf_queue_entry *e)
 {
+	struct sk_buff *nskb;
 	int diff;
-	int err;
 
 	diff = data_len - e->skb->len;
 	if (diff < 0) {
@@ -454,14 +454,16 @@ nfqnl_mangle(void *data, int data_len, struct nf_queue_entry *e)
 		if (data_len > 0xFFFF)
 			return -EINVAL;
 		if (diff > skb_tailroom(e->skb)) {
-			err = pskb_expand_head(e->skb, 0,
+			nskb = skb_copy_expand(e->skb, 0,
 					       diff - skb_tailroom(e->skb),
 					       GFP_ATOMIC);
-			if (err) {
+			if (!nskb) {
 				printk(KERN_WARNING "nf_queue: OOM "
 				      "in mangle, dropping packet\n");
-				return err;
+				return -ENOMEM;
 			}
+			kfree_skb(e->skb);
+			e->skb = nskb;
 		}
 		skb_put(e->skb, diff);
 	}
