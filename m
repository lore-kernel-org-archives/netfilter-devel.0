From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 1/5]: Release dst_entry in PRE_ROUTING after NAT
Date: Mon, 29 Nov 2004 00:28:31 +0100
Message-ID: <41AA5F1F.2060806@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020103030707090707000100"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------020103030707090707000100
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Release dst_entry in PRE_ROUTING after NAT. The loopback driver doesn't
release the dst_entry itself and ip_rcv_finish only routes the packet if
it doesn't already have a dst_entry. Fixes DNAT on loopback.



--------------020103030707090707000100
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/11/27 12:14:54+01:00 kaber@coreworks.de 
#   [NETFILTER]: Release dst_entry in PRE_ROUTING after NAT
#   
#   Fixes NAT on loopback.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_standalone.c
#   2004/11/27 12:14:47+01:00 kaber@coreworks.de +24 -1
#   [NETFILTER]: Release dst_entry in PRE_ROUTING after NAT
#   
#   Fixes NAT on loopback.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_nat_standalone.c b/net/ipv4/netfilter/ip_nat_standalone.c
--- a/net/ipv4/netfilter/ip_nat_standalone.c	2004-11-28 21:36:33 +01:00
+++ b/net/ipv4/netfilter/ip_nat_standalone.c	2004-11-28 21:36:33 +01:00
@@ -180,6 +180,29 @@
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
@@ -243,7 +266,7 @@
 
 /* Before packet filtering, change destination */
 static struct nf_hook_ops ip_nat_in_ops = {
-	.hook		= ip_nat_fn,
+	.hook		= ip_nat_in,
 	.owner		= THIS_MODULE,
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_PRE_ROUTING,

--------------020103030707090707000100--
