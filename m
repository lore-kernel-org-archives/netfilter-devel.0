From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: [PATCH 2/3] accounting on ct kill (was: set SEEN_REPLY before
	destroying conntrack on TCP RST)
Date: Tue, 27 May 2008 23:55:20 +0100
Message-ID: <1211928920.14366.12.camel@pumper.lan.luxnet.ch>
References: <1211447601.6878.38.camel@pumper.lan.luxnet.ch>
	 <1211826305.19222.8.camel@pumper.lan.luxnet.ch>
	 <483B93C2.1000905@trash.net> <483C1B9D.5060705@gmx.ch>
	 <483C1F54.6040505@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56320 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760543AbYE0Wza (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 May 2008 18:55:30 -0400
In-Reply-To: <483C1F54.6040505@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Introduces nf_ct_kill_acct() which increments the accounting counters on
conntrack kill. The new function was necessary, because there are calls
to nf_ct_kill() which don't need accounting:

nf_conntrack_proto_tcp.c line ~847:
Kills ct and returns NF_REPEAT. We don't want to count twice.

nf_conntrack_proto_tcp.c line ~880:
Kills ct and returns NF_DROP. I think we don't want to count dropped
packets.

nf_conntrack_netlink.c line ~824:
As far as I can see ctnetlink_del_conntrack() is used to destroy a
conntrack on behalf of the user. There is an sk_buff, but I don't think
this is an actual packet. Incrementing counters here is therefore not
desired.

Signed-off-by: Fabian Hugelshofer <hugelshofer2006@gmx.ch>

--- linux-2.6.25.4.orig/include/net/netfilter/nf_conntrack.h	2008-05-27 21:47:46.000000000 +0100
+++ linux-2.6.25.4/include/net/netfilter/nf_conntrack.h	2008-05-27 22:14:38.000000000 +0100
@@ -230,7 +230,24 @@
 	__nf_ct_refresh_acct(ct, 0, skb, extra_jiffies, 0);
 }
 
-extern void nf_ct_kill(struct nf_conn *ct);
+extern void __nf_ct_kill_acct(struct nf_conn *ct,
+				enum ip_conntrack_info ctinfo,
+				const struct sk_buff *skb,
+				int do_acct);
+
+/* kill conntrack and do accounting */
+static inline void nf_ct_kill_acct(struct nf_conn *ct,
+				enum ip_conntrack_info ctinfo,
+				const struct sk_buff *skb)
+{
+	__nf_ct_kill_acct(ct, ctinfo, skb, 1);
+}
+
+/* kill conntrack without accounting */
+static inline void nf_ct_kill(struct nf_conn *ct)
+{
+	__nf_ct_kill_acct(ct, 0, NULL, 0);
+}
 
 /* These are for NAT.  Icky. */
 /* Update TCP window tracking data when NAT mangles the packet */
--- linux-2.6.25.4.orig/net/ipv4/netfilter/nf_conntrack_proto_icmp.c	2008-05-27 21:47:08.000000000 +0100
+++ linux-2.6.25.4/net/ipv4/netfilter/nf_conntrack_proto_icmp.c	2008-05-27 22:13:28.000000000 +0100
@@ -89,7 +89,7 @@
 	   (theoretically possible with SMP) */
 	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
 		if (atomic_dec_and_test(&ct->proto.icmp.count))
-			nf_ct_kill(ct);
+			nf_ct_kill_acct(ct, ctinfo, skb);
 	} else {
 		atomic_inc(&ct->proto.icmp.count);
 		nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);
--- linux-2.6.25.4.orig/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c	2008-05-27 21:47:13.000000000 +0100
+++ linux-2.6.25.4/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c	2008-05-27 22:15:38.000000000 +0100
@@ -90,7 +90,7 @@
 	   (theoretically possible with SMP) */
 	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
 		if (atomic_dec_and_test(&ct->proto.icmp.count))
-			nf_ct_kill(ct);
+			nf_ct_kill_acct(ct, ctinfo, skb);
 	} else {
 		atomic_inc(&ct->proto.icmp.count);
 		nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);
--- linux-2.6.25.4.orig/net/netfilter/nf_conntrack_core.c	2008-05-27 21:47:15.000000000 +0100
+++ linux-2.6.25.4/net/netfilter/nf_conntrack_core.c	2008-05-27 22:43:00.000000000 +0100
@@ -855,12 +855,24 @@
 }
 EXPORT_SYMBOL_GPL(__nf_ct_refresh_acct);
 
-void nf_ct_kill(struct nf_conn *ct)
-{
+void __nf_ct_kill_acct(struct nf_conn *ct,
+		enum ip_conntrack_info ctinfo,
+		const struct sk_buff *skb,
+		int do_acct)
+{
+#ifdef CONFIG_NF_CT_ACCT
+	if (do_acct) {
+		spin_lock_bh(&nf_conntrack_lock);
+		ct->counters[CTINFO2DIR(ctinfo)].packets++;
+		ct->counters[CTINFO2DIR(ctinfo)].bytes +=
+			skb->len - skb_network_offset(skb);
+		spin_unlock_bh(&nf_conntrack_lock);
+	}
+#endif
 	if (del_timer(&ct->timeout))
 		ct->timeout.function((unsigned long)ct);
 }
-EXPORT_SYMBOL_GPL(nf_ct_kill);
+EXPORT_SYMBOL_GPL(__nf_ct_kill_acct);
 
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 
--- linux-2.6.25.4.orig/net/netfilter/nf_conntrack_proto_dccp.c	2008-05-27 21:48:07.000000000 +0100
+++ linux-2.6.25.4/net/netfilter/nf_conntrack_proto_dccp.c	2008-05-27 22:16:12.000000000 +0100
@@ -475,7 +475,7 @@
 	if (type == DCCP_PKT_RESET &&
 	    !test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
 		/* Tear down connection immediately if only reply is a RESET */
-		nf_ct_kill(ct);
+		nf_ct_kill_acct(ct, ctinfo, skb);
 		return NF_ACCEPT;
 	}
 
--- linux-2.6.25.4.orig/net/netfilter/nf_conntrack_proto_tcp.c	2008-05-27 21:47:16.000000000 +0100
+++ linux-2.6.25.4/net/netfilter/nf_conntrack_proto_tcp.c	2008-05-27 22:17:05.000000000 +0100
@@ -960,7 +960,7 @@
 		   problem case, so we can delete the conntrack
 		   immediately.  --RR */
 		if (th->rst) {
-			nf_ct_kill(ct);
+			nf_ct_kill_acct(ct, ctinfo, skb);
 			return NF_ACCEPT;
 		}
 	} else if (!test_bit(IPS_ASSURED_BIT, &ct->status)






