From: Philip Craig <philipc@snapgear.com>
Subject: [PATCH] TCPMSS --clamp-mss-to-pmtu should use MTU of incoming interface
Date: Wed, 29 Oct 2003 14:11:21 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200310290411.h9T4BLm4020882@philipc1.sw.moreton.com.au>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Ideally, the TCPMSS --clamp-mss-to-pmtu option would clamp the MSS to
the PMTU from the dst to the src.  Currently, it uses the PMTU from the
packet filter to the dst, which will just be the MTU of the outgoing
interface if PMTU discovery hasn't occurred yet.  This patch better
approximates the full PMTU by including the MTU of the incoming
interface.

Regards,
Phil

--- linux-2.4.x/net/ipv4/netfilter/ipt_TCPMSS.c	7 Jan 2002 23:16:13 -0000	1.1.1.2
+++ linux-2.4.x/net/ipv4/netfilter/ipt_TCPMSS.c	28 Oct 2003 06:47:26 -0000
@@ -45,7 +45,7 @@
 	const struct ipt_tcpmss_info *tcpmssinfo = targinfo;
 	struct tcphdr *tcph;
 	struct iphdr *iph;
-	u_int16_t tcplen, newtotlen, oldval, newmss;
+	u_int16_t tcplen, newtotlen, oldval, newmss, mtu;
 	unsigned int i;
 	u_int8_t *opt;
 
@@ -91,8 +91,20 @@
 		       			"ipt_tcpmss_target: unknown or invalid path-MTU (%d)\n", (*pskb)->dst->pmtu);
 			return NF_DROP; /* or IPT_CONTINUE ?? */
 		}
+		mtu = (*pskb)->dst->pmtu;
 
-		newmss = (*pskb)->dst->pmtu - sizeof(struct iphdr) - sizeof(struct tcphdr);
+		if (in) {
+			if (in->mtu <= (sizeof(struct iphdr) + sizeof(struct tcphdr))) {
+				if (net_ratelimit())
+					printk(KERN_ERR
+		       				"ipt_tcpmss_target: invalid interface MTU (%d)\n", in->mtu);
+				return NF_DROP; /* or IPT_CONTINUE ?? */
+			}
+			if (in->mtu < mtu)
+				mtu = in->mtu;
+		}
+
+		newmss = mtu - sizeof(struct iphdr) - sizeof(struct tcphdr);
 	} else
 		newmss = tcpmssinfo->mss;
 
