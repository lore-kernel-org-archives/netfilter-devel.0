From: Pete Holland <pholland27@gmail.com>
Subject: [PATCH 1/1] netfilter: conntrack: make call to nf_log_packet due to
 helper rejection conditional on LOG_INVALID (resubmit)
Date: Fri, 2 Dec 2011 09:37:04 -0800
Message-ID: <CANtneHLYOANXQ432me_htXrMcQkv-WVpNYTrwmxAjc2gV68iPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65272 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170Ab1LBRhF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Dec 2011 12:37:05 -0500
Received: by bkas6 with SMTP id s6so4113734bka.19
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Dec 2011 09:37:04 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Peter Holland <pholland27@gmail.com>

Make the logging of dropped packets due to ct helper rejection
conditional on LOG_INVALID.
This is consistent with the other uses of nf_log_packet.
Use protocol from conntrack tuple (original direction).
Without this check, there is a possible DoS based on traffic induced
log generation.
(specifically this was noted in the wild by an attacker against the SIP helper)

Signed-off-by: Peter Holland <pholland27@gmail.com>
---
--- net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c.orig	2011-11-29
11:34:36.683717278 -0800
+++ net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2011-12-02
09:32:00.727064563 -0800
@@ -116,8 +116,10 @@ static unsigned int ipv4_confirm(unsigne
 	ret = helper->help(skb, skb_network_offset(skb) + ip_hdrlen(skb),
 			   ct, ctinfo);
 	if (ret != NF_ACCEPT) {
-		nf_log_packet(NFPROTO_IPV4, hooknum, skb, in, out, NULL,
-			      "nf_ct_%s: dropping packet", helper->name);
+		if (LOG_INVALID(nf_ct_net(ct),
+				ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum))			
+			nf_log_packet(NFPROTO_IPV4, hooknum, skb, in, out, NULL,
+				      "nf_ct_%s: dropping packet", helper->name);
 		return ret;
 	}

--- net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c.orig	2011-11-29
11:35:00.221028814 -0800
+++ net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2011-12-02
09:32:45.457026870 -0800
@@ -180,8 +180,10 @@ static unsigned int ipv6_confirm(unsigne

 	ret = helper->help(skb, protoff, ct, ctinfo);
 	if (ret != NF_ACCEPT) {
-		nf_log_packet(NFPROTO_IPV6, hooknum, skb, in, out, NULL,
-			      "nf_ct_%s: dropping packet", helper->name);
+		if (LOG_INVALID(nf_ct_net(ct),
+				ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum))	
+			nf_log_packet(NFPROTO_IPV6, hooknum, skb, in, out, NULL,
+				      "nf_ct_%s: dropping packet", helper->name);
 		return ret;
 	}
 out:
