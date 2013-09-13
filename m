From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] netfilter: ipv6: icmpv6_manip_pkt comparing codes to types
Date: Thu, 12 Sep 2013 18:04:16 -0700
Message-ID: <20130913010416.GA8656@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="DocE+STaALJfprDB"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:40299 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3IMBEC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Sep 2013 21:04:02 -0400
Received: by mail-pd0-f173.google.com with SMTP id p10so541283pdj.4
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2013 18:04:01 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In commit 58a317f1 (netfilter: ipv6: add IPv6 NAT support), icmpv6_manip_pkt
was added with an incorrect comparison of ICMP codes to types.  This causes
problems when using NAT rules with the --random option.  Correct the
comparison.

This closes netfilter bugzilla #851, reported by Alexander Neumann.

Signed-off-by: Phil Oester <kernel@linuxace.com>


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-icmpv6_manip_pkt

diff --git a/net/ipv6/netfilter/nf_nat_proto_icmpv6.c b/net/ipv6/netfilter/nf_nat_proto_icmpv6.c
index 61aaf70..2205e8e 100644
--- a/net/ipv6/netfilter/nf_nat_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_nat_proto_icmpv6.c
@@ -69,8 +69,8 @@ icmpv6_manip_pkt(struct sk_buff *skb,
 	hdr = (struct icmp6hdr *)(skb->data + hdroff);
 	l3proto->csum_update(skb, iphdroff, &hdr->icmp6_cksum,
 			     tuple, maniptype);
-	if (hdr->icmp6_code == ICMPV6_ECHO_REQUEST ||
-	    hdr->icmp6_code == ICMPV6_ECHO_REPLY) {
+	if (hdr->icmp6_type == ICMPV6_ECHO_REQUEST ||
+	    hdr->icmp6_type == ICMPV6_ECHO_REPLY) {
 		inet_proto_csum_replace2(&hdr->icmp6_cksum, skb,
 					 hdr->icmp6_identifier,
 					 tuple->src.u.icmp.id, 0);

--DocE+STaALJfprDB--
