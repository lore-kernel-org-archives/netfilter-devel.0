From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] netfilter: fix tuple inversion for Node information request.
Date: Mon, 19 Jan 2009 23:20:12 +0100
Message-ID: <1232403612-32301-1-git-send-email-eric@inl.fr>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: kaber@trash.net, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39931 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754045AbZASWU1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2009 17:20:27 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The patch fixes a typo in the inverse mapping of Node Information
request. Following draft-ietf-ipngwg-icmp-name-lookups-09, "Querier"
sends a type 139 (ICMPV6_NI_QUERY) packet to "Responder" which answer
with a type 140 (ICMPV6_NI_REPLY) packet.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index bd52151..7a98857 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -49,8 +49,8 @@ static bool icmpv6_pkt_to_tuple(const struct sk_buff *skb,
 static const u_int8_t invmap[] = {
 	[ICMPV6_ECHO_REQUEST - 128]	= ICMPV6_ECHO_REPLY + 1,
 	[ICMPV6_ECHO_REPLY - 128]	= ICMPV6_ECHO_REQUEST + 1,
-	[ICMPV6_NI_QUERY - 128]		= ICMPV6_NI_QUERY + 1,
-	[ICMPV6_NI_REPLY - 128]		= ICMPV6_NI_REPLY +1
+	[ICMPV6_NI_QUERY - 128]		= ICMPV6_NI_REPLY + 1,
+	[ICMPV6_NI_REPLY - 128]		= ICMPV6_NI_QUERY +1
 };
 
 static bool icmpv6_invert_tuple(struct nf_conntrack_tuple *tuple,
-- 
1.5.6.3

