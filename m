From: philipc@snapgear.com
Subject: [PATCH 2/4] TCPMSS: clamp to input interface MTU too
Date: Wed, 24 May 2006 14:04:43 +1000
Message-ID: <20060524040950.965615000@snapgear.com>
References: <20060524040441.111049000@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline; filename=tcpmssin.patch
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

Ideally we would clamp the MSS based on the PMTU from src to dst.
Currently we use the PMTU from the packet filter to the dst.
This patch better approximates the full PTMU by using the input
interface MTU too.

Signed-off-by: Philip Craig <philipc@snapgear.com>

Index: linux-2.6.17-rc4.orig/net/ipv4/netfilter/ipt_TCPMSS.c
===================================================================
--- linux-2.6.17-rc4.orig.orig/net/ipv4/netfilter/ipt_TCPMSS.c	2006-05-24 11:57:22.000000000 +1000
+++ linux-2.6.17-rc4.orig/net/ipv4/netfilter/ipt_TCPMSS.c	2006-05-24 11:57:23.000000000 +1000
@@ -27,6 +27,8 @@ MODULE_DESCRIPTION("iptables TCP MSS mod
 #define DEBUGP(format, args...)
 #endif
 
+#define HDRSIZE (sizeof(struct iphdr) + sizeof(struct tcphdr))
+
 static u_int16_t
 cheat_check(u_int32_t oldvalinv, u_int32_t newval, u_int16_t oldcheck)
 {
@@ -55,7 +57,7 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 	const struct ipt_tcpmss_info *tcpmssinfo = targinfo;
 	struct tcphdr *tcph;
 	struct iphdr *iph;
-	u_int16_t tcplen, newtotlen, oldval, newmss;
+	u_int16_t tcplen, newtotlen, oldval, newmss, mtu;
 	unsigned int i;
 	u_int8_t *opt;
 
@@ -92,14 +94,27 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 			return IPT_CONTINUE;
 		}
 
-		if(dst_mtu((*pskb)->dst) <= (sizeof(struct iphdr) + sizeof(struct tcphdr))) {
+		mtu = dst_mtu((*pskb)->dst);
+		if (mtu <= HDRSIZE) {
 			if (net_ratelimit())
 				printk(KERN_ERR
-		       			"ipt_tcpmss_target: unknown or invalid path-MTU (%d)\n", dst_mtu((*pskb)->dst));
+		       			"ipt_tcpmss_target: unknown or "
+					"invalid path-MTU (%d)\n", mtu);
 			return IPT_CONTINUE;
 		}
 
-		newmss = dst_mtu((*pskb)->dst) - sizeof(struct iphdr) - sizeof(struct tcphdr);
+		if (in && in->mtu < mtu) {
+			mtu = in->mtu;
+			if (mtu <= HDRSIZE) {
+				if (net_ratelimit())
+					printk(KERN_ERR
+						"ipt_tcpmss_target: invalid "
+						"interface MTU (%d)\n", mtu);
+				return IPT_CONTINUE;
+			}
+		}
+
+		newmss = mtu - HDRSIZE;
 	} else
 		newmss = tcpmssinfo->mss;
 

--
