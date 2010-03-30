From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH:RFC 5/5] bridge-netfilter: use the vlan id as part of the
 connection tracking tuple for bridged traffic
Date: Tue, 30 Mar 2010 16:16:21 +0200
Message-ID: <4BB207B5.2020001@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:53197 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab0C3OQX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Mar 2010 10:16:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

bridge-netfilter: use the vlan id as part of the connection tracking tuple for bridged traffic

Currently connection tracking isn't aware of the vlan id that bridged
encapsulated IP packets belong to. Since it's possible to enable
filtering of bridged IP traffic encapsulated in a vlan header, we
have a security risk if an overlapping IP network range is used on
different vlan networks. By making the connection tracking code use
the vlan id as part of the tuple, we eliminate this security risk.
Something similar could be done for IP traffic encapsulated in PPPoE,
but I'm not sure it's worth the effort.

Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>

--- linux-2.6.33/net/netfilter/nf_conntrack_core.c	2010-02-24 19:52:17.000000000 +0100
+++ linux-2.6.33-uml/net/netfilter/nf_conntrack_core.c	2010-03-30 12:33:00.000000000 +0200
@@ -32,6 +32,7 @@
 #include <linux/mm.h>
 #include <linux/nsproxy.h>
 #include <linux/rculist_nulls.h>
+#include <linux/netfilter_bridge.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
@@ -110,6 +111,11 @@ nf_ct_get_tuple(const struct sk_buff *sk
 
 	tuple->dst.protonum = protonum;
 	tuple->dst.dir = IP_CT_DIR_ORIGINAL;
+#ifdef CONFIG_BRIDGE_NETFILTER
+	/* +1 because 0 identifies no vlan encapsulation */
+	if (skb->nf_bridge && (skb->nf_bridge->mask & BRNF_8021Q))
+		tuple->dst.vlan_id = (ntohs(*(u_int16_t *)(skb->data - VLAN_HLEN)) & VLAN_VID_MASK) + 1;
+#endif
 
 	return l4proto->pkt_to_tuple(skb, dataoff, tuple);
 }
@@ -158,6 +164,9 @@ nf_ct_invert_tuple(struct nf_conntrack_t
 	inverse->dst.dir = !orig->dst.dir;
 
 	inverse->dst.protonum = orig->dst.protonum;
+#ifdef CONFIG_BRIDGE_NETFILTER
+	inverse->dst.vlan_id = orig->dst.vlan_id;
+#endif
 	return l4proto->invert_tuple(inverse, orig);
 }
 EXPORT_SYMBOL_GPL(nf_ct_invert_tuple);
--- linux-2.6.33/include/net/netfilter/nf_conntrack_tuple.h	2010-02-24 19:52:17.000000000 +0100
+++ linux-2.6.33-uml/include/net/netfilter/nf_conntrack_tuple.h	2010-03-30 12:34:13.000000000 +0200
@@ -94,6 +94,9 @@ struct nf_conntrack_tuple {
 
 		/* The direction (for tuplehash) */
 		u_int8_t dir;
+#ifdef CONFIG_BRIDGE_NETFILTER
+		u_int16_t vlan_id;
+#endif
 	} dst;
 };
 
@@ -163,7 +166,11 @@ static inline bool __nf_ct_tuple_dst_equ
 {
 	return (nf_inet_addr_cmp(&t1->dst.u3, &t2->dst.u3) &&
 		t1->dst.u.all == t2->dst.u.all &&
-		t1->dst.protonum == t2->dst.protonum);
+		t1->dst.protonum == t2->dst.protonum
+#ifdef CONFIG_BRIDGE_NETFILTER
+		&& likely(t1->dst.vlan_id == t2->dst.vlan_id)
+#endif
+		);
 }
 
 static inline bool nf_ct_tuple_equal(const struct nf_conntrack_tuple *t1,

-- 
Bart De Schuymer
www.artinalgorithms.be
