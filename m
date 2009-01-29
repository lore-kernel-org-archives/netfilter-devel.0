From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] netfilter: log invalid new icmpv6 packet with nf_log_packet().
Date: Thu, 29 Jan 2009 21:59:02 +0100
Message-ID: <1233262742-4891-1-git-send-email-eric@inl.fr>
References: <49821831.6000609@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:38931 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752653AbZA2U7H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:59:07 -0500
In-Reply-To: <49821831.6000609@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a logging message for invalid new icmpv6 packet.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 72dbb6d..41b8a95 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -126,6 +126,10 @@ static bool icmpv6_new(struct nf_conn *ct, const struct sk_buff *skb,
 		pr_debug("icmpv6: can't create new conn with type %u\n",
 			 type + 128);
 		nf_ct_dump_tuple_ipv6(&ct->tuplehash[0].tuple);
+		if (LOG_INVALID(nf_ct_net(ct), IPPROTO_ICMPV6))
+			nf_log_packet(PF_INET6, 0, skb, NULL, NULL, NULL,
+				      "nf_ct_icmpv6: invalid new with type %d ",
+				      type + 128);
 		return false;
 	}
 	atomic_set(&ct->proto.icmp.count, 0);
-- 
1.5.6.3

