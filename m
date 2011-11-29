From: Pete Holland <pholland27@gmail.com>
Subject: [PATCH 1/1] netfilter: conntrack: make call to nf_log_packet due to
 helper rejection conditional on LOG_INVALID
Date: Tue, 29 Nov 2011 12:08:14 -0800
Message-ID: <CANtneH+UUgXdk1UmHKR8JfN=jqsFZ+LFYGQZ_tHF_aZ_zCn3Dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49978 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab1K2UIP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Nov 2011 15:08:15 -0500
Received: by ywa9 with SMTP id 9so4487858ywa.19
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2011 12:08:15 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Peter Holland <pholland27@gmail.com>

Make the logging of dropped packets due to ct helper rejection
conditional on LOG_INVALID.
This is consistent with the other uses of nf_log_packet.
Use the IPPROTO_RAW filter since it is unclear based on the caller
what protocol it actually is.
Without this check, there is a possible DoS based on traffic induced
log generation.
(specifically this was noted in the wild by an attacker against the SIP helper)

Signed-off-by: Peter Holland <pholland27@gmail.com>

---

--- net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c.orig	2011-11-29
11:34:36.683717278 -0800
+++ net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2011-11-29
11:41:55.031121908 -0800
@@ -116,8 +116,9 @@ static unsigned int ipv4_confirm(unsigne
 	ret = helper->help(skb, skb_network_offset(skb) + ip_hdrlen(skb),
 			   ct, ctinfo);
 	if (ret != NF_ACCEPT) {
-		nf_log_packet(NFPROTO_IPV4, hooknum, skb, in, out, NULL,
-			      "nf_ct_%s: dropping packet", helper->name);
+		if (LOG_INVALID(nf_ct_net(ct, IPPROTO_RAW))			
+			nf_log_packet(NFPROTO_IPV4, hooknum, skb, in, out, NULL,
+				      "nf_ct_%s: dropping packet", helper->name);
 		return ret;
 	}

--- net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c.orig	2011-11-29
11:35:00.221028814 -0800
+++ net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2011-11-29
11:38:49.541033773 -0800
@@ -180,8 +180,9 @@ static unsigned int ipv6_confirm(unsigne

 	ret = helper->help(skb, protoff, ct, ctinfo);
 	if (ret != NF_ACCEPT) {
-		nf_log_packet(NFPROTO_IPV6, hooknum, skb, in, out, NULL,
-			      "nf_ct_%s: dropping packet", helper->name);
+		if (LOG_INVALID(nf_ct_net(ct), IPPROTO_RAW))	
+			nf_log_packet(NFPROTO_IPV6, hooknum, skb, in, out, NULL,
+				      "nf_ct_%s: dropping packet", helper->name);
 		return ret;
 	}
 out:
