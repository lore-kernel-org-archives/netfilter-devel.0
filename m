From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 1/2] netfilter: fix nf_log_packet message in icmpv6 conntrack.
Date: Thu, 29 Jan 2009 21:36:21 +0100
Message-ID: <1233261382-17030-2-git-send-email-eric@inl.fr>
References: <1233261382-17030-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:52084 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753946AbZA2UgZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:36:25 -0500
In-Reply-To: <1233261382-17030-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes a trivial typo that was adding a new line at end of
the nf_log_packet() prefix. It also make the logging conditionnal by
adding a LOG_INVALID test.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index c323643..72dbb6d 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -201,8 +201,9 @@ icmpv6_error(struct net *net, struct sk_buff *skb, unsigned int dataoff,
 
 	if (net->ct.sysctl_checksum && hooknum == NF_INET_PRE_ROUTING &&
 	    nf_ip6_checksum(skb, hooknum, dataoff, IPPROTO_ICMPV6)) {
-		nf_log_packet(PF_INET6, 0, skb, NULL, NULL, NULL,
-			      "nf_ct_icmpv6: ICMPv6 checksum failed\n");
+		if (LOG_INVALID(net, IPPROTO_ICMPV6))
+			nf_log_packet(PF_INET6, 0, skb, NULL, NULL, NULL,
+				      "nf_ct_icmpv6: ICMPv6 checksum failed ");
 		return -NF_ACCEPT;
 	}
 
-- 
1.5.6.3

