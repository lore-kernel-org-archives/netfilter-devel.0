From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 6/18]: Release dst_entry in PRE_ROUTING after NAT
Date: Mon, 20 Dec 2004 08:14:32 +0100
Message-ID: <41C67BD8.2010801@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010507080609090506050500"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------010507080609090506050500
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Release dst_entry in PRE_ROUTING after NAT, fixes
DNAT on loopback.


--------------010507080609090506050500
Content-Type: text/x-patch;
 name="06.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="06.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/12/05 22:44:07+01:00 kaber@coreworks.de 
#   [NETFILTER]: Release dst_entry in PRE_ROUTING after NAT
#   
#   Fixes NAT on loopback.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_standalone.c
#   2004/12/05 22:44:05+01:00 kaber@coreworks.de +24 -1
#   [NETFILTER]: Release dst_entry in PRE_ROUTING after NAT
#   
#   Fixes NAT on loopback.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_nat_standalone.c b/net/ipv4/netfilter/ip_nat_standalone.c
--- a/net/ipv4/netfilter/ip_nat_standalone.c	2004-12-20 06:59:30 +01:00
+++ b/net/ipv4/netfilter/ip_nat_standalone.c	2004-12-20 06:59:30 +01:00
@@ -156,6 +156,29 @@
 }
 
 static unsigned int
+ip_nat_in(unsigned int hooknum,
+          struct sk_buff **pskb,
+          const struct net_device *in,
+          const struct net_device *out,
+          int (*okfn)(struct sk_buff *))
+{
+	u_int32_t saddr, daddr;
+	unsigned int ret;
+
+	saddr = (*pskb)->nh.iph->saddr;
+	daddr = (*pskb)->nh.iph->daddr;
+
+	ret = ip_nat_fn(hooknum, pskb, in, out, okfn);
+	if (ret != NF_DROP && ret != NF_STOLEN
+	    && ((*pskb)->nh.iph->saddr != saddr
+	        || (*pskb)->nh.iph->daddr != daddr)) {
+		dst_release((*pskb)->dst);
+		(*pskb)->dst = NULL;
+	}
+	return ret;
+}
+
+static unsigned int
 ip_nat_out(unsigned int hooknum,
 	   struct sk_buff **pskb,
 	   const struct net_device *in,
@@ -217,7 +240,7 @@
 
 /* Before packet filtering, change destination */
 static struct nf_hook_ops ip_nat_in_ops
-= { { NULL, NULL }, ip_nat_fn, PF_INET, NF_IP_PRE_ROUTING, NF_IP_PRI_NAT_DST };
+= { { NULL, NULL }, ip_nat_in, PF_INET, NF_IP_PRE_ROUTING, NF_IP_PRI_NAT_DST };
 /* After packet filtering, change source */
 static struct nf_hook_ops ip_nat_out_ops
 = { { NULL, NULL }, ip_nat_out, PF_INET, NF_IP_POST_ROUTING, NF_IP_PRI_NAT_SRC};

--------------010507080609090506050500--
