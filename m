From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 7/9]: associate locally generated icmp errors with
 conntrack of original packet
Date: Mon, 15 Nov 2004 22:45:19 +0100
Message-ID: <4199236F.9010106@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070303010008030506000506"
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
--------------070303010008030506000506
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch changes icmp.c to associate locally generated icmp errors
with the conntrack of the original packet. This is necessary to fix
an information leak with these packets. A conntrack entry is put in the
hash tables when the packet passes POSTROUTING/LOCAL_IN, when an icmp
error is generated before this the conntrack of the inner packet can't
be found and it isn't NATed back to the original packet.



--------------070303010008030506000506
Content-Type: text/x-patch;
 name="07.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="07.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/11/13 14:41:16+01:00 kaber@coreworks.de 
#   [NETFILTER]: associate locally generated icmp errors with conntrack of original packet
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_REJECT.c
#   2004/11/13 14:41:07+01:00 kaber@coreworks.de +2 -16
#   [NETFILTER]: associate locally generated icmp errors with conntrack of original packet
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/icmp.c
#   2004/11/13 14:41:07+01:00 kaber@coreworks.de +2 -0
#   [NETFILTER]: associate locally generated icmp errors with conntrack of original packet
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/core/netfilter.c
#   2004/11/13 14:41:07+01:00 kaber@coreworks.de +14 -4
#   [NETFILTER]: associate locally generated icmp errors with conntrack of original packet
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter.h
#   2004/11/13 14:41:07+01:00 kaber@coreworks.de +2 -0
#   [NETFILTER]: associate locally generated icmp errors with conntrack of original packet
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter.h b/include/linux/netfilter.h
--- a/include/linux/netfilter.h	2004-11-15 22:07:35 +01:00
+++ b/include/linux/netfilter.h	2004-11-15 22:07:35 +01:00
@@ -173,6 +173,7 @@
 			unsigned int verdict);
 
 extern void (*ip_ct_attach)(struct sk_buff *, struct sk_buff *);
+extern void nf_ct_attach(struct sk_buff *, struct sk_buff *);
 
 #ifdef CONFIG_NETFILTER_DEBUG
 extern void nf_dump_skb(int pf, struct sk_buff *skb);
@@ -183,6 +184,7 @@
 
 #else /* !CONFIG_NETFILTER */
 #define NF_HOOK(pf, hook, skb, indev, outdev, okfn) (okfn)(skb)
+static inline void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb) {}
 #endif /*CONFIG_NETFILTER*/
 
 #endif /*__KERNEL__*/
diff -Nru a/net/core/netfilter.c b/net/core/netfilter.c
--- a/net/core/netfilter.c	2004-11-15 22:07:35 +01:00
+++ b/net/core/netfilter.c	2004-11-15 22:07:35 +01:00
@@ -802,12 +802,21 @@
 EXPORT_SYMBOL(nf_log_unregister);
 EXPORT_SYMBOL(nf_log_packet);
 
-/* This does not belong here, but ipt_REJECT needs it if connection
-   tracking in use: without this, connection may not be in hash table,
-   and hence manufactured ICMP or RST packets will not be associated
-   with it. */
+/* This does not belong here, but locally generated errors need it if connection
+   tracking in use: without this, connection may not be in hash table, and hence
+   manufactured ICMP or RST packets will not be associated with it. */
 void (*ip_ct_attach)(struct sk_buff *, struct sk_buff *);
 
+void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb)
+{
+	void (*attach)(struct sk_buff *, struct sk_buff *);
+
+	if (skb->nfct && (attach = ip_ct_attach) != NULL) {
+		mb(); /* Just to be sure: must be read before executing this */
+		attach(new, skb);
+	}
+}
+
 void __init netfilter_init(void)
 {
 	int i, h;
@@ -819,6 +828,7 @@
 }
 
 EXPORT_SYMBOL(ip_ct_attach);
+EXPORT_SYMBOL(nf_ct_attach);
 EXPORT_SYMBOL(nf_getsockopt);
 EXPORT_SYMBOL(nf_hook_slow);
 EXPORT_SYMBOL(nf_hooks);
diff -Nru a/net/ipv4/icmp.c b/net/ipv4/icmp.c
--- a/net/ipv4/icmp.c	2004-11-15 22:07:35 +01:00
+++ b/net/ipv4/icmp.c	2004-11-15 22:07:35 +01:00
@@ -338,6 +338,8 @@
 				      to, len, 0);
 
 	skb->csum = csum_block_add(skb->csum, csum, odd);
+	if (icmp_pointers[icmp_param->data.icmph.type].error)
+		nf_ct_attach(skb, icmp_param->skb);
 	return 0;
 }
 
diff -Nru a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
--- a/net/ipv4/netfilter/ipt_REJECT.c	2004-11-15 22:07:35 +01:00
+++ b/net/ipv4/netfilter/ipt_REJECT.c	2004-11-15 22:07:35 +01:00
@@ -38,20 +38,6 @@
 #define DEBUGP(format, args...)
 #endif
 
-/* If the original packet is part of a connection, but the connection
-   is not confirmed, our manufactured reply will not be associated
-   with it, so we need to do this manually. */
-static void connection_attach(struct sk_buff *new_skb, struct sk_buff *skb)
-{
-	void (*attach)(struct sk_buff *, struct sk_buff *);
-
-	/* Avoid module unload race with ip_ct_attach being NULLed out */
-	if (skb->nfct && (attach = ip_ct_attach) != NULL) {
-		mb(); /* Just to be sure: must be read before executing this */
-		attach(new_skb, skb);
-	}
-}
-
 static inline struct rtable *route_reverse(struct sk_buff *skb, int hook)
 {
 	struct iphdr *iph = skb->nh.iph;
@@ -209,7 +195,7 @@
 	if (nskb->len > dst_pmtu(nskb->dst))
 		goto free_nskb;
 
-	connection_attach(nskb, oldskb);
+	nf_ct_attach(nskb, oldskb);
 
 	NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, nskb, NULL, nskb->dst->dev,
 		ip_finish_output);
@@ -360,7 +346,7 @@
 	icmph->checksum = ip_compute_csum((unsigned char *)icmph,
 					  length - sizeof(struct iphdr));
 
-	connection_attach(nskb, skb_in);
+	nf_ct_attach(nskb, skb_in);
 
 	NF_HOOK(PF_INET, NF_IP_LOCAL_OUT, nskb, NULL, nskb->dst->dev,
 		ip_finish_output);

--------------070303010008030506000506--
