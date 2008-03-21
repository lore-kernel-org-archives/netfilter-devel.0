From: Chris Wright <chrisw@sous-sol.org>
Subject: [patch 38/76] NETFILTER: nfnetlink_queue: fix SKB_LINEAR_ASSERT when mangling packet data
Date: Fri, 21 Mar 2008 15:43:28 -0700
Message-ID: <20080321224408.967850935@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59312 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763739AbYCUWuw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:50:52 -0400
Content-Disposition: inline; filename=netfilter-nfnetlink_queue-fix-skb_linear_assert-when-mangling-packet-data.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Patrick McHardy <kaber@trash.net>

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
Patrick, which part of commit log did you want to drop?

 net/ipv4/netfilter/ip_queue.c   |   12 +++++++-----
 net/ipv6/netfilter/ip6_queue.c  |   10 ++++++----
 net/netfilter/nfnetlink_queue.c |   10 ++++++----
 3 files changed, 19 insertions(+), 13 deletions(-)

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
@@ -349,14 +349,16 @@ ipq_mangle_ipv4(ipq_verdict_msg_t *v, st
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
@@ -346,14 +346,16 @@ ipq_mangle_ipv6(ipq_verdict_msg_t *v, st
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
@@ -627,14 +627,16 @@ nfqnl_mangle(void *data, int data_len, s
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

-- 
