From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] netfilter: Checksum of an IPv6 UDP packet is mandatory
Date: Sat, 29 Jun 2013 00:15:19 +0800
Message-ID: <1372436119-61481-1-git-send-email-xiaosuo@gmail.com>
Cc: Changli Gao <xiaosuo@gmail.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53162 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab3F1QQS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:16:18 -0400
Received: by mail-pa0-f47.google.com with SMTP id kl14so2615068pab.6
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2013 09:16:17 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Checksum of an IPv6 UDP packet is mandatory.
---
 net/netfilter/nf_conntrack_proto_udp.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 9d7721c..31dc854 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -134,8 +134,15 @@ static int udp_error(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 	}
 
 	/* Packet with no checksum */
-	if (!hdr->check)
+	if (!hdr->check) {
+		if (pf == PF_INET6) {
+			if (LOG_INVALID(net, IPPROTO_UDP))
+				nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
+					       "nf_ct_udp: bad UDP checksum ");
+			return -NF_ACCEPT;
+		}
 		return NF_ACCEPT;
+	}
 
 	/* Checksum invalid? Ignore.
 	 * We skip checking packets on the outgoing path
-- 
1.7.9.5

