From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 10/19]: Select source address for gateway in MASQUERADE
Date: Mon, 25 Oct 2004 02:49:35 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <417C4D9F.50401@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000506070602050305050502"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000506070602050305050502
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Select source address for gateway in MASQUERADE, based
on Herbert's suggestion.



--------------000506070602050305050502
Content-Type: text/x-patch;
 name="10.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="10.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/20 20:27:59+02:00 kaber@coreworks.de 
#   [NETFILTER]: Select source address for gateway in MASQUERADE
#   
#   Suggested by Herbert Xu <herbert@gondor.apana.org.au>
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_MASQUERADE.c
#   2004/10/20 20:26:59+02:00 kaber@coreworks.de +3 -1
#   [NETFILTER]: Select source address for gateway in MASQUERADE
#   
#   Suggested by Herbert Xu <herbert@gondor.apana.org.au>
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-10-22 03:39:37 +02:00
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-10-22 03:39:37 +02:00
@@ -81,6 +81,7 @@
 	enum ip_conntrack_info ctinfo;
 	const struct ip_nat_multi_range *mr;
 	struct ip_nat_multi_range newrange;
+	struct rtable *rt;
 	u_int32_t newsrc;
 
 	IP_NF_ASSERT(hooknum == NF_IP_POST_ROUTING);
@@ -95,7 +96,8 @@
 	                    || ctinfo == IP_CT_RELATED + IP_CT_IS_REPLY));
 
 	mr = targinfo;
-	newsrc = inet_select_addr(out, 0, RT_SCOPE_UNIVERSE);
+	rt = (struct rtable *)(*pskb)->dst;
+	newsrc = inet_select_addr(out, rt->rt_gateway, RT_SCOPE_UNIVERSE);
 	if (!newsrc) {
 		printk("MASQUERADE: %s ate my IP address\n", out->name);
 		return NF_DROP;

--------------000506070602050305050502--
