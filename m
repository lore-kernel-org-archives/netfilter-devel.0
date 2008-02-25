From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER -stable 01/03]: nfnetlink_queue: fix SKB_LINEAR_ASSERT when mangling packet data
Date: Mon, 25 Feb 2008 15:01:01 +0100 (MET)
Message-ID: <20080225140059.20602.57007.sendpatchset@localhost.localdomain>
References: <20080225140058.20602.52127.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50665 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbYBYOBF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Feb 2008 09:01:05 -0500
In-Reply-To: <20080225140058.20602.52127.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_queue: fix SKB_LINEAR_ASSERT when mangling packet data

Upstream commit e2b58a67:

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
commit 2e1a9528d31fda88923d6615eb4933df07f59762
tree 46cc8d288a33e945bec29f529a8f56d47c1b37bd
parent c78cb439103bf7deba5feb64921398d0ff93179a
author Patrick McHardy <kaber@trash.net> Mon, 25 Feb 2008 14:51:16 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 25 Feb 2008 14:51:16 +0100

 net/ipv4/netfilter/ip_queue.c   |   12 +++++++-----
 net/ipv6/netfilter/ip6_queue.c  |   10 ++++++----
 net/netfilter/nfnetlink_queue.c |   10 ++++++----
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index 14d64a3..16d0fb3 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -336,8 +336,8 @@ static int
 ipq_mangle_ipv4(ipq_verdict_msg_t *v, struct ipq_queue_entry *e)
 {
 	int diff;
-	int err;
 	struct iphdr *user_iph = (struct iphdr *)v->payload;
+	struct sk_buff *nskb;
 
 	if (v->data_len < sizeof(*user_iph))
 		return 0;
@@ -349,14 +349,16 @@ ipq_mangle_ipv4(ipq_verdict_msg_t *v, struct ipq_queue_entry *e)
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
index e273605..710a04f 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -333,8 +333,8 @@ static int
 ipq_mangle_ipv6(ipq_verdict_msg_t *v, struct ipq_queue_entry *e)
 {
 	int diff;
-	int err;
 	struct ipv6hdr *user_iph = (struct ipv6hdr *)v->payload;
+	struct sk_buff *nskb;
 
 	if (v->data_len < sizeof(*user_iph))
 		return 0;
@@ -346,14 +346,16 @@ ipq_mangle_ipv6(ipq_verdict_msg_t *v, struct ipq_queue_entry *e)
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
index 3ceeffc..561c974 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -616,8 +616,8 @@ err_out_put:
 static int
 nfqnl_mangle(void *data, int data_len, struct nfqnl_queue_entry *e)
 {
+	struct sk_buff *nskb;
 	int diff;
-	int err;
 
 	diff = data_len - e->skb->len;
 	if (diff < 0) {
@@ -627,14 +627,16 @@ nfqnl_mangle(void *data, int data_len, struct nfqnl_queue_entry *e)
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
