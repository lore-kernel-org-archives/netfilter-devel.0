From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 2/2] Revert nf_reset change
Date: Thu, 04 Aug 2005 17:45:06 +0900 (JST)
Message-ID: <200508040845.j748j75I001485@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Aug__4_17_45_06_2005_897)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
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

----Next_Part(Thu_Aug__4_17_45_06_2005_897)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


nf_conntrack doesn't support NAT in the current and have similer problems.
But should follow this for future work.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Thu_Aug__4_17_45_06_2005_897)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="02-revert_reset.patch"

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -164,6 +164,13 @@ static unsigned int ipv4_conntrack_defra
 					  const struct net_device *out,
 					  int (*okfn)(struct sk_buff *))
 {
+#if !defined(CONFIG_IP_NF_NAT) && !defined(CONFIG_IP_NF_NAT_MODULE)
+	/* Previously seen (loopback)?  Ignore.  Do this before
+	   fragment check. */
+	if ((*pskb)->nfct)
+		return NF_ACCEPT;
+#endif
+
 	/* Gather fragments. */
 	if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {
 		*pskb = nf_ct_ipv4_gather_frags(*pskb,
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -76,8 +76,6 @@ static inline int ip6_output_finish(stru
 	struct dst_entry *dst = skb->dst;
 	struct hh_cache *hh = dst->hh;
 
-	nf_reset(skb);
-
 	if (hh) {
 		int hh_alen;
 
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -223,6 +223,10 @@ static unsigned int ipv6_defrag(unsigned
 {
 	struct sk_buff *reasm;
 
+	/* Previously seen (loopback)?  */
+	if ((*pskb)->nfct)
+		return NF_ACCEPT;
+
 	reasm = nf_ct_frag6_gather(*pskb);
 
 	/* queued */

----Next_Part(Thu_Aug__4_17_45_06_2005_897)----
