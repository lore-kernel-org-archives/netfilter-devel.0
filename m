From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 07/08: nf_nat_sip: add TCP support
Date: Thu, 11 Feb 2010 08:39:45 +0100 (MET)
Message-ID: <20100211073941.7894.51583.sendpatchset@x2.localnet>
References: <20100211073932.7894.23544.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35452 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab0BKHjq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 02:39:46 -0500
In-Reply-To: <20100211073932.7894.23544.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit ed23b7593761f4d57be5906ada862d1b74137af8
Author: Patrick McHardy <kaber@trash.net>
Date:   Thu Feb 11 07:40:34 2010 +0100

    netfilter: nf_nat_sip: add TCP support
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index fa9bb89..cd84d6f 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -104,6 +104,7 @@ extern unsigned int (*nf_nat_sip_hook)(struct sk_buff *skb,
 				       unsigned int dataoff,
 				       const char **dptr,
 				       unsigned int *datalen);
+extern void (*nf_nat_sip_seq_adjust_hook)(struct sk_buff *skb, s16 off);
 extern unsigned int (*nf_nat_sip_expect_hook)(struct sk_buff *skb,
 					      unsigned int dataoff,
 					      const char **dptr,
diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index b232e40..39b1ac0 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -1,4 +1,4 @@
-/* SIP extension for UDP NAT alteration.
+/* SIP extension for NAT alteration.
  *
  * (C) 2005 by Christian Hentschel <chentschel@arnet.com.ar>
  * based on RR's ip_nat_ftp.c and other modules.
@@ -15,6 +15,7 @@
 #include <linux/ip.h>
 #include <net/ip.h>
 #include <linux/udp.h>
+#include <linux/tcp.h>
 
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_helper.h>
@@ -36,10 +37,27 @@ static unsigned int mangle_packet(struct sk_buff *skb, unsigned int dataoff,
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
-
-	if (!nf_nat_mangle_udp_packet(skb, ct, ctinfo, matchoff, matchlen,
-				      buffer, buflen))
-		return 0;
+	struct tcphdr *th;
+	unsigned int baseoff;
+
+	if (nf_ct_protonum(ct) == IPPROTO_TCP) {
+		th = (struct tcphdr *)(skb->data + ip_hdrlen(skb));
+		baseoff = ip_hdrlen(skb) + th->doff * 4;
+		matchoff += dataoff - baseoff;
+
+		if (!__nf_nat_mangle_tcp_packet(skb, ct, ctinfo,
+						matchoff, matchlen,
+						buffer, buflen, false))
+			return 0;
+	} else {
+		baseoff = ip_hdrlen(skb) + sizeof(struct udphdr);
+		matchoff += dataoff - baseoff;
+
+		if (!nf_nat_mangle_udp_packet(skb, ct, ctinfo,
+					      matchoff, matchlen,
+					      buffer, buflen))
+			return 0;
+	}
 
 	/* Reload data pointer and adjust datalen value */
 	*dptr = skb->data + dataoff;
@@ -104,6 +122,7 @@ static unsigned int ip_nat_sip(struct sk_buff *skb, unsigned int dataoff,
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	unsigned int coff, matchoff, matchlen;
+	enum sip_header_types hdr;
 	union nf_inet_addr addr;
 	__be16 port;
 	int request, in_header;
@@ -120,9 +139,14 @@ static unsigned int ip_nat_sip(struct sk_buff *skb, unsigned int dataoff,
 	} else
 		request = 0;
 
+	if (nf_ct_protonum(ct) == IPPROTO_TCP)
+		hdr = SIP_HDR_VIA_TCP;
+	else
+		hdr = SIP_HDR_VIA_UDP;
+
 	/* Translate topmost Via header and parameters */
 	if (ct_sip_parse_header_uri(ct, *dptr, NULL, *datalen,
-				    SIP_HDR_VIA_UDP, NULL, &matchoff, &matchlen,
+				    hdr, NULL, &matchoff, &matchlen,
 				    &addr, &port) > 0) {
 		unsigned int matchend, poff, plen, buflen, n;
 		char buffer[sizeof("nnn.nnn.nnn.nnn:nnnnn")];
@@ -204,9 +228,23 @@ next:
 	if (!map_sip_addr(skb, dataoff, dptr, datalen, SIP_HDR_FROM) ||
 	    !map_sip_addr(skb, dataoff, dptr, datalen, SIP_HDR_TO))
 		return NF_DROP;
+
 	return NF_ACCEPT;
 }
 
+static void ip_nat_sip_seq_adjust(struct sk_buff *skb, s16 off)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+	const struct tcphdr *th;
+
+	if (nf_ct_protonum(ct) != IPPROTO_TCP || off == 0)
+		return;
+
+	th = (struct tcphdr *)(skb->data + ip_hdrlen(skb));
+	nf_nat_set_seq_adjust(ct, ctinfo, th->seq, off);
+}
+
 /* Handles expected signalling connections and media streams */
 static void ip_nat_sip_expected(struct nf_conn *ct,
 				struct nf_conntrack_expect *exp)
@@ -277,8 +315,8 @@ static unsigned int ip_nat_sip_expect(struct sk_buff *skb, unsigned int dataoff,
 	if (port == 0)
 		return NF_DROP;
 
-	if (exp->tuple.dst.u3.ip != exp->saved_ip ||
-	    exp->tuple.dst.u.udp.port != exp->saved_proto.udp.port) {
+	if (0 && (exp->tuple.dst.u3.ip != exp->saved_ip ||
+	    exp->tuple.dst.u.udp.port != exp->saved_proto.udp.port)) {
 		buflen = sprintf(buffer, "%pI4:%u", &newip, port);
 		if (!mangle_packet(skb, dataoff, dptr, datalen,
 				   matchoff, matchlen, buffer, buflen))
@@ -472,6 +510,7 @@ err1:
 static void __exit nf_nat_sip_fini(void)
 {
 	rcu_assign_pointer(nf_nat_sip_hook, NULL);
+	rcu_assign_pointer(nf_nat_sip_seq_adjust_hook, NULL);
 	rcu_assign_pointer(nf_nat_sip_expect_hook, NULL);
 	rcu_assign_pointer(nf_nat_sdp_addr_hook, NULL);
 	rcu_assign_pointer(nf_nat_sdp_port_hook, NULL);
@@ -483,12 +522,14 @@ static void __exit nf_nat_sip_fini(void)
 static int __init nf_nat_sip_init(void)
 {
 	BUG_ON(nf_nat_sip_hook != NULL);
+	BUG_ON(nf_nat_sip_seq_adjust_hook != NULL);
 	BUG_ON(nf_nat_sip_expect_hook != NULL);
 	BUG_ON(nf_nat_sdp_addr_hook != NULL);
 	BUG_ON(nf_nat_sdp_port_hook != NULL);
 	BUG_ON(nf_nat_sdp_session_hook != NULL);
 	BUG_ON(nf_nat_sdp_media_hook != NULL);
 	rcu_assign_pointer(nf_nat_sip_hook, ip_nat_sip);
+	rcu_assign_pointer(nf_nat_sip_seq_adjust_hook, ip_nat_sip_seq_adjust);
 	rcu_assign_pointer(nf_nat_sip_expect_hook, ip_nat_sip_expect);
 	rcu_assign_pointer(nf_nat_sdp_addr_hook, ip_nat_sdp_addr);
 	rcu_assign_pointer(nf_nat_sdp_port_hook, ip_nat_sdp_port);
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 1cc75c5..3bb3aaf 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -56,6 +56,9 @@ unsigned int (*nf_nat_sip_hook)(struct sk_buff *skb, unsigned int dataoff,
 				unsigned int *datalen) __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_sip_hook);
 
+void (*nf_nat_sip_seq_adjust_hook)(struct sk_buff *skb, s16 off) __read_mostly;
+EXPORT_SYMBOL_GPL(nf_nat_sip_seq_adjust_hook);
+
 unsigned int (*nf_nat_sip_expect_hook)(struct sk_buff *skb,
 				       unsigned int dataoff,
 				       const char **dptr,
@@ -1360,6 +1363,7 @@ static int sip_help_tcp(struct sk_buff *skb, unsigned int protoff,
 	const char *dptr, *end;
 	s16 diff, tdiff = 0;
 	int ret;
+	typeof(nf_nat_sip_seq_adjust_hook) nf_nat_sip_seq_adjust;
 
 	if (ctinfo != IP_CT_ESTABLISHED &&
 	    ctinfo != IP_CT_ESTABLISHED + IP_CT_IS_REPLY)
@@ -1415,6 +1419,12 @@ static int sip_help_tcp(struct sk_buff *skb, unsigned int protoff,
 		datalen  = datalen + diff - msglen;
 	}
 
+	if (ret == NF_ACCEPT && ct->status & IPS_NAT_MASK) {
+		nf_nat_sip_seq_adjust = rcu_dereference(nf_nat_sip_seq_adjust_hook);
+		if (nf_nat_sip_seq_adjust)
+			nf_nat_sip_seq_adjust(skb, tdiff);
+	}
+
 	return ret;
 }
 
