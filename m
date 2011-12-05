From: Pete Holland <pholland27@gmail.com>
Subject: [PATCH 1/1] netfilter: conntrack: make call to nf_log_packet due to
 helper rejection conditional on LOG_INVALID (resubmit #2)
Date: Mon, 5 Dec 2011 15:42:07 -0800
Message-ID: <CANtneH+fB4YU73inZaq1Ho_=uPmrY1oymiYVdZ8bibtKbZa5nA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57296 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481Ab1LEXmI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Dec 2011 18:42:08 -0500
Received: by eeaq14 with SMTP id q14so2407929eea.19
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Dec 2011 15:42:07 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Peter Holland <pholland27@gmail.com>

Make the logging of dropped packets due to ct helper rejection
conditional on LOG_INVALID.
This is consistent with the other uses of nf_log_packet.
Use protocol from conntrack.
Without this check, there is a possible DoS based on traffic induced
log generation.
(specifically this was noted in the wild by an attacker against the SIP helper)

Signed-off-by: Peter Holland <pholland27@gmail.com>
---
--- net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c.orig	2011-11-29
11:34:36.683717278 -0800
+++ net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2011-12-05
15:29:32.363651787 -0800
@@ -98,6 +98,7 @@ static unsigned int ipv4_confirm(unsigne
 	const struct nf_conn_help *help;
 	const struct nf_conntrack_helper *helper;
 	unsigned int ret;
+	struct net *net;

 	/* This is where we call the helper: as the packet goes out. */
 	ct = nf_ct_get(skb, &ctinfo);
@@ -113,11 +114,14 @@ static unsigned int ipv4_confirm(unsigne
 	if (!helper)
 		goto out;

+	net = nf_ct_net(ct);
+
 	ret = helper->help(skb, skb_network_offset(skb) + ip_hdrlen(skb),
 			   ct, ctinfo);
 	if (ret != NF_ACCEPT) {
-		nf_log_packet(NFPROTO_IPV4, hooknum, skb, in, out, NULL,
-			      "nf_ct_%s: dropping packet", helper->name);
+		if (LOG_INVALID(net, nf_ct_protonum(ct)))
+			nf_log_packet(NFPROTO_IPV4, hooknum, skb, in, out, NULL,
+				      "nf_ct_%s: dropping packet", helper->name);
 		return ret;
 	}

@@ -128,7 +132,7 @@ static unsigned int ipv4_confirm(unsigne

 		seq_adjust = rcu_dereference(nf_nat_seq_adjust_hook);
 		if (!seq_adjust || !seq_adjust(skb, ct, ctinfo)) {
-			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
+			NF_CT_STAT_INC_ATOMIC(net, drop);
 			return NF_DROP;
 		}
 	}
--- net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c.orig	2011-11-29
11:35:00.221028814 -0800
+++ net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2011-12-05
15:34:10.743771621 -0800
@@ -156,7 +156,7 @@ static unsigned int ipv6_confirm(unsigne
 	unsigned int ret, protoff;
 	unsigned int extoff = (u8 *)(ipv6_hdr(skb) + 1) - skb->data;
 	unsigned char pnum = ipv6_hdr(skb)->nexthdr;
-
+	struct net *net;

 	/* This is where we call the helper: as the packet goes out. */
 	ct = nf_ct_get(skb, &ctinfo);
@@ -171,6 +171,8 @@ static unsigned int ipv6_confirm(unsigne
 	if (!helper)
 		goto out;

+	net = nf_ct_net(ct);
+
 	protoff = nf_ct_ipv6_skip_exthdr(skb, extoff, &pnum,
 					 skb->len - extoff);
 	if (protoff > skb->len || pnum == NEXTHDR_FRAGMENT) {
@@ -180,8 +182,9 @@ static unsigned int ipv6_confirm(unsigne

 	ret = helper->help(skb, protoff, ct, ctinfo);
 	if (ret != NF_ACCEPT) {
-		nf_log_packet(NFPROTO_IPV6, hooknum, skb, in, out, NULL,
-			      "nf_ct_%s: dropping packet", helper->name);
+		if (LOG_INVALID(net, nf_ct_protonum(ct)))
+			nf_log_packet(NFPROTO_IPV6, hooknum, skb, in, out, NULL,
+				      "nf_ct_%s: dropping packet", helper->name);
 		return ret;
 	}
 out:
