From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6]: Prevent NAT from seeing fragments
Date: Fri, 18 Feb 2005 01:23:44 +0100
Message-ID: <42153590.8010704@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030003060900020608000804"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------030003060900020608000804
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch fixes another fragment handling problem, on loopback NAT might
get to see fragments because conntrack skips defragmentation for already
seen traffic. It just meant as a temporary solution for 2.6.11, in 2.6.12
we would prefer to skip refragmentation for loopback if it doesn't cause
problems.

Regards
Patrick


--------------030003060900020608000804
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/02/18 01:11:06+01:00 kaber@coreworks.de 
#   [NETFILTER]: Prevent NAT from seeing fragments
#   
#   The path for loopback is:
#   LOCAL_OUT: conntrack defrags
#   POST_ROUTING: conntrack refrags
#   PRE_ROUTING: skip conntrack defrag because skb->nfct != NULL
#   PRE_ROUTING: NAT gets hit by fragments
#   
#   Always defrag on loopback if NAT is compiled in.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
#   Acked-by: Rusty Russel <rusty@rustcorp.com.au>
# 
# net/ipv4/netfilter/ip_conntrack_standalone.c
#   2005/02/18 01:10:55+01:00 kaber@coreworks.de +2 -0
#   [NETFILTER]: Prevent NAT from seeing fragments
#   
#   The path for loopback is:
#   LOCAL_OUT: conntrack defrags
#   POST_ROUTING: conntrack refrags
#   PRE_ROUTING: skip conntrack defrag because skb->nfct != NULL
#   PRE_ROUTING: NAT gets hit by fragments
#   
#   Always defrag on loopback if NAT is compiled in.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
#   Acked-by: Rusty Russel <rusty@rustcorp.com.au>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-02-18 01:15:36 +01:00
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-02-18 01:15:36 +01:00
@@ -384,10 +384,12 @@
 				        const struct net_device *out,
 				        int (*okfn)(struct sk_buff *))
 {
+#if !defined(CONFIG_IP_NF_NAT) && !defined(CONFIG_IP_NF_NAT_MODULE)
 	/* Previously seen (loopback)?  Ignore.  Do this before
            fragment check. */
 	if ((*pskb)->nfct)
 		return NF_ACCEPT;
+#endif
 
 	/* Gather fragments. */
 	if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {

--------------030003060900020608000804--
