From: anand@eis.iisc.ernet.in (SVR Anand)
Subject: Re: netfilter hook in packet capture
Date: Sat, 3 Jan 2004 18:31:26 +0530 (GMT+05:30)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401031301.SAA06299@eis.iisc.ernet.in>
References: <20040102121218.GK3530@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org (Harald Welte)
In-Reply-To: <20040102121218.GK3530@obroa-skai.de.gnumonks.org> from "Harald Welte" at Jan 02, 2004 01:12:18 PM
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte,

Thanks for your response. 

I am sending the patch to the file 
/usr/src/linux-2.6.0/net/packet/af_packet.c

which will give access to the netfilter hook before giving the captured
packets to the application. I have used the feature to perform the initial
packet filtering, as well as DoS protection at the kernel itself so that 
the "accepted" packets are processed by my IDS like application which 
examines these packets at lot more depth. 

Thus I have a complete firewall system running partly at the kernel, and 
partly at the user land. Apart from off-loading part of the job, the 
flexibility of being able to use iptables externally to control the 
interesting packets that can be given to the application is something that 
is appealing.

Here is the simple patch. I guess it can be applied any kernel with NF_HOOK 
support. I hope others find it useful too. 

Anand

---------------------------------------------------------------------

--- af_packet.c.org	2003-12-26 14:32:51.000000000 +0530
+++ af_packet.c	2004-01-03 17:51:29.000000000 +0530
@@ -72,8 +72,15 @@
 #include <net/inet_common.h>
 #endif
 
+#define PACKET_IP_TABLES
+
+#ifdef PACKET_IP_TABLES
+#include <linux/netfilter_ipv4.h>
+#endif
+
 #define CONFIG_SOCK_PACKET	1
 
+
 /*
    Proposed replacement for SIOC{ADD,DEL}MULTI and
    IFF_PROMISC, IFF_ALLMULTI flags.
@@ -272,6 +279,11 @@
 	return 0;
 }
 
+static inline int tpacket_local_deliver_finish(struct sk_buff *skb)
+{
+
+	return 0;
+}
 
 /*
  *	Output a raw packet to a device layer. This bypasses all the other
@@ -418,6 +430,7 @@
 	u8 * skb_head = skb->data;
 	int skb_len = skb->len;
 	unsigned snaplen;
+	int err;
 
 	if (skb->pkt_type == PACKET_LOOPBACK)
 		goto drop;
@@ -427,6 +440,17 @@
 
 	skb->dev = dev;
 
+
+#ifdef PACKET_IP_TABLES
+
+    if (skb->protocol == __constant_htons(ETH_P_IP)) {
+    err = NF_HOOK(PF_INET, NF_IP_LOCAL_IN, skb, skb->dev, NULL,
+			                       tpacket_local_deliver_finish);
+	if (err < 0) return 0;
+     }
+#endif
+
+
 	if (dev->hard_header) {
 		/* The device has an explicit notion of ll header,
 		   exported to higher levels.
@@ -521,10 +545,21 @@
 	unsigned long status = TP_STATUS_LOSING|TP_STATUS_USER;
 	unsigned short macoff, netoff;
 	struct sk_buff *copy_skb = NULL;
+	int err;
 
 	if (skb->pkt_type == PACKET_LOOPBACK)
 		goto drop;
 
+#ifdef PACKET_IP_TABLES
+
+    if (skb->protocol == __constant_htons(ETH_P_IP)) {
+    err = NF_HOOK(PF_INET, NF_IP_LOCAL_IN, skb, skb->dev, NULL,
+			                       tpacket_local_deliver_finish);
+	if (err < 0) return 0;
+     }
+#endif
+
+
 	sk = pt->af_packet_priv;
 	po = pkt_sk(sk);
 

---------------------------------------------------------------------
> 
> 
> 
> We would definitely be interested in such a patch.  Please first submit
> it to the netfilter development team, and we will then push it for
> kernel inclusion (after any changes/suggestions that we might have).
> 
> Please send the patch to netfilter-devel@lists.netfilter.org
> 
> Thanks a lot!
> 
> 
> --=20
> - Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
