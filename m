From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] pptp conntrack broken when non-modular
Date: Sun, 18 Dec 2005 11:48:48 -0800
Message-ID: <20051218194848.GA1038@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The GRE protocol helper of PPTP does not get properly registered
when it is built in, because ip_nat_proto_gre_init runs prior to
ip_nat_init, so ip_nat_protos is unitialized when ip_nat_proto_gre_init
tries to register protocol 47.

Changing ip_nat_protocol_register to unconditionally register solves
half the problem.  But then when ip_nat_init does run, it overwrites
the registration with ip_nat_unknown_protocol.  So the second
part of the fix is to change ip_nat_init not to overwrite previously
registered protos.

This fixes netfilter bugzilla #397, and IMHO should go to mainline
ASAP to hopefully make 2.6.15.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-pptp

diff -ru linux-orig/include/linux/netfilter_ipv4/ip_nat_protocol.h linux-po/include/linux/netfilter_ipv4/ip_nat_protocol.h
--- linux-orig/include/linux/netfilter_ipv4/ip_nat_protocol.h	2005-10-27 20:02:08.000000000 -0400
+++ linux-po/include/linux/netfilter_ipv4/ip_nat_protocol.h	2005-12-18 14:06:48.000000000 -0500
@@ -57,7 +57,7 @@
 };
 
 /* Protocol registration. */
-extern int ip_nat_protocol_register(struct ip_nat_protocol *proto);
+extern void ip_nat_protocol_register(struct ip_nat_protocol *proto);
 extern void ip_nat_protocol_unregister(struct ip_nat_protocol *proto);
 
 extern struct ip_nat_protocol *ip_nat_proto_find_get(u_int8_t protocol);
diff -ru linux-orig/net/ipv4/netfilter/ip_nat_core.c linux-po/net/ipv4/netfilter/ip_nat_core.c
--- linux-orig/net/ipv4/netfilter/ip_nat_core.c	2005-12-18 14:15:42.000000000 -0500
+++ linux-po/net/ipv4/netfilter/ip_nat_core.c	2005-12-18 14:44:31.000000000 -0500
@@ -516,19 +516,11 @@
 EXPORT_SYMBOL_GPL(ip_nat_icmp_reply_translation);
 
 /* Protocol registration. */
-int ip_nat_protocol_register(struct ip_nat_protocol *proto)
+void ip_nat_protocol_register(struct ip_nat_protocol *proto)
 {
-	int ret = 0;
-
 	write_lock_bh(&ip_nat_lock);
-	if (ip_nat_protos[proto->protonum] != &ip_nat_unknown_protocol) {
-		ret = -EBUSY;
-		goto out;
-	}
 	ip_nat_protos[proto->protonum] = proto;
- out:
 	write_unlock_bh(&ip_nat_lock);
-	return ret;
 }
 EXPORT_SYMBOL(ip_nat_protocol_register);
 
@@ -604,7 +596,9 @@
 	/* Sew in builtin protocols. */
 	write_lock_bh(&ip_nat_lock);
 	for (i = 0; i < MAX_IP_NAT_PROTO; i++)
-		ip_nat_protos[i] = &ip_nat_unknown_protocol;
+		/* Don't overwrite protos already registered */
+		if (!ip_nat_protos[i])
+			ip_nat_protos[i] = &ip_nat_unknown_protocol;
 	ip_nat_protos[IPPROTO_TCP] = &ip_nat_protocol_tcp;
 	ip_nat_protos[IPPROTO_UDP] = &ip_nat_protocol_udp;
 	ip_nat_protos[IPPROTO_ICMP] = &ip_nat_protocol_icmp;
diff -ru linux-orig/net/ipv4/netfilter/ip_nat_helper_pptp.c linux-po/net/ipv4/netfilter/ip_nat_helper_pptp.c
--- linux-orig/net/ipv4/netfilter/ip_nat_helper_pptp.c	2005-12-18 14:15:42.000000000 -0500
+++ linux-po/net/ipv4/netfilter/ip_nat_helper_pptp.c	2005-12-18 14:19:52.000000000 -0500
@@ -378,18 +378,14 @@
 }
 
 
-extern int __init ip_nat_proto_gre_init(void);
+extern void __init ip_nat_proto_gre_init(void);
 extern void __exit ip_nat_proto_gre_fini(void);
 
 static int __init init(void)
 {
-	int ret;
-
 	DEBUGP("%s: registering NAT helper\n", __FILE__);
 
-	ret = ip_nat_proto_gre_init();
-	if (ret < 0)
-		return ret;
+	ip_nat_proto_gre_init();
 
 	BUG_ON(ip_nat_pptp_hook_outbound);
 	ip_nat_pptp_hook_outbound = &pptp_outbound_pkt;
diff -ru linux-orig/net/ipv4/netfilter/ip_nat_proto_gre.c linux-po/net/ipv4/netfilter/ip_nat_proto_gre.c
--- linux-orig/net/ipv4/netfilter/ip_nat_proto_gre.c	2005-12-18 14:15:42.000000000 -0500
+++ linux-po/net/ipv4/netfilter/ip_nat_proto_gre.c	2005-12-18 14:21:18.000000000 -0500
@@ -203,9 +203,9 @@
 #endif
 };
 				  
-int __init ip_nat_proto_gre_init(void)
+void __init ip_nat_proto_gre_init(void)
 {
-	return ip_nat_protocol_register(&gre);
+	ip_nat_protocol_register(&gre);
 }
 
 void __exit ip_nat_proto_gre_fini(void)

--ikeVEW9yuYc//A+q--
