From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 1/2] follows skb timestamp changes in
 nf_conntrack
Date: Thu, 01 Sep 2005 13:00:38 +0900 (JST)
Message-ID: <200509010400.j8140c2G000134@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Sep__1_13_00_38_2005_839)--"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Thu_Sep__1_13_00_38_2005_839)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch follows the skb timestamp change for skb diet.
Please apply nf_conntrack tree.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

Regards,
-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Sep__1_13_00_38_2005_839)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="02-timestamp.patch"

[NETFILTER] follows skb timestamp changes in nf_conntrack

This patch follows the skb timestamp change for skb diet.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 88b8f555d0553ad2d4a3ab16fe2da38c555eb8c3
tree 72590bc85e6ca379a1b0dbcbc020979f91bf0b9b
parent fb12078da0631bcadfb36766bdac675adb127e8e
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 03:15:34 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 03:15:34 +0900

 net/ipv6/netfilter/nf_conntrack_reasm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -549,7 +549,7 @@ static int nf_ct_frag6_queue(struct nf_c
 		fq->fragments = skb;
 
 	skb->dev = NULL;
-	fq->stamp = skb->stamp;
+	skb_get_timestamp(skb, &fq->stamp);
 	fq->meat += skb->len;
 	atomic_add(skb->truesize, &nf_ct_frag6_mem);
 
@@ -655,7 +655,7 @@ nf_ct_frag6_reasm(struct nf_ct_frag6_que
 
 	head->next = NULL;
 	head->dev = dev;
-	head->stamp = fq->stamp;
+	skb_set_timestamp(head, &fq->stamp);
 	head->nh.ipv6h->payload_len = htons(payload_len);
 
 	/* Yes, and fold redundant checksum back. 8) */

----Next_Part(Thu_Sep__1_13_00_38_2005_839)----
