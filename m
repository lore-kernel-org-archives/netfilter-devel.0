From: Roel Kluin <12o3l@tiscali.nl>
Subject: [PATCH 5/6] NETFILTER: signed tcphoff for ipv6_skip_exthdr() retval
Date: Wed, 16 Apr 2008 18:00:02 +0200
Message-ID: <48062282.4070204@tiscali.nl>
References: <480558CA.7090800@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, coreteam@netfilter.org,
	lkml <linux-kernel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:51765 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbYDPQAE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2008 12:00:04 -0400
In-Reply-To: <480558CA.7090800@tiscali.nl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

if tcphoff remains unsigned, a negative ipv6_skip_exthdr() return value will
go unnoticed,
    
Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
index 3b2aa56..9685b6f 100644
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -90,7 +90,7 @@ tcpoptstrip_tg6(struct sk_buff *skb, const struct net_device *in,
 		const struct xt_target *target, const void *targinfo)
 {
 	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
-	unsigned int tcphoff;
+	int tcphoff;
 	u_int8_t nexthdr;
 
 	nexthdr = ipv6h->nexthdr;

