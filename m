From: Robert Edmonds <edmonds@debian.org>
Subject: [PATCH]: ROUTE: convert hh_lock to seqlock
Date: Wed, 23 May 2007 21:57:58 -0400
Message-ID: <20070524015758.GA6544@mycre.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

hh_cache's lock has been converted to a seqlock in recent kernels.

Signed-off-by: Robert S. Edmonds <edmonds@debian.org>
---
 ipv4/netfilter/ipt_ROUTE.c  |   19 +++++++++++--------
 ipv6/netfilter/ip6t_ROUTE.c |    8 +++++---
 2 files changed, 16 insertions(+), 11 deletions(-)

diff -urNad netfilter-extensions-20070520+debian~/net/ipv4/netfilter/ipt_ROUTE.c netfilter-extensions-20070520+debian/net/ipv4/netfilter/ipt_ROUTE.c
--- netfilter-extensions-20070520+debian~/net/ipv4/netfilter/ipt_ROUTE.c	2007-05-23 19:47:12.000000000 -0400
+++ netfilter-extensions-20070520+debian/net/ipv4/netfilter/ipt_ROUTE.c	2007-05-23 20:54:22.000000000 -0400
@@ -118,6 +118,7 @@
 	struct hh_cache *hh = dst->hh;
 	struct net_device *dev = dst->dev;
 	int hh_len = LL_RESERVED_SPACE(dev);
+	unsigned seq;
 
 	/* Be paranoid, rather than too clever. */
 	if (unlikely(skb_headroom(skb) < hh_len && dev->hard_header)) {
@@ -135,12 +136,13 @@
 	}
 
 	if (hh) {
-		int hh_alen;
+		do {
+			int hh_alen;
 
-		read_lock_bh(&hh->hh_lock);
-		hh_alen = HH_DATA_ALIGN(hh->hh_len);
-  		memcpy(skb->data - hh_alen, hh->hh_data, hh_alen);
-		read_unlock_bh(&hh->hh_lock);
+			seq = read_seqbegin(&hh->hh_lock);
+			hh_alen = HH_DATA_ALIGN(hh->hh_len);
+			memcpy(skb->data - hh_alen, hh->hh_data, hh_alen);
+		} while (read_seqretry(&hh->hh_lock, seq));
 		skb_push(skb, hh->hh_len);
 		hh->hh_output(skb);
 	} else if (dst->neighbour)
diff -urNad netfilter-extensions-20070520+debian~/net/ipv6/netfilter/ip6t_ROUTE.c netfilter-extensions-20070520+debian/net/ipv6/netfilter/ip6t_ROUTE.c
--- netfilter-extensions-20070520+debian~/net/ipv6/netfilter/ip6t_ROUTE.c	2007-05-23 20:54:13.000000000 -0400
+++ netfilter-extensions-20070520+debian/net/ipv6/netfilter/ip6t_ROUTE.c	2007-05-23 21:00:47.000000000 -0400
@@ -120,11 +120,13 @@
 {
 	struct dst_entry *dst = skb->dst;
 	struct hh_cache *hh = dst->hh;
+	unsigned seq;
 
 	if (hh) {
-		read_lock_bh(&hh->hh_lock);
-		memcpy(skb->data - 16, hh->hh_data, 16);
-		read_unlock_bh(&hh->hh_lock);
+		do {
+			seq = read_seqbegin(&hh->hh_lock);
+			memcpy(skb->data - 16, hh->hh_data, 16);
+		} while (read_seqretry(&hh->hh_lock, seq));
 		skb_push(skb, hh->hh_len);
 		hh->hh_output(skb);
 	} else if (dst->neighbour)
