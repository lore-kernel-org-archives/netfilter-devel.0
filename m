From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/2] Incorrect handling of invalid TCP option in TCP connection tracking
Date: Tue, 30 Aug 2011 15:35:40 +0200
Message-ID: <1314711341-28392-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1314711341-28392-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:60134 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622Ab1H3Nfn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Aug 2011 09:35:43 -0400
In-Reply-To: <1314711341-28392-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Michael M. Builov reported that in the tcp_options and tcp_sack functions
of netfilter TCP conntrack the incorrect handling of invalid TCP option
with too big opsize may lead to read access beyond tcp-packet or buffer
allocated on stack (netfilter bugzilla #738). The fix is to stop parsing
the options at detecting the broken option.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/nf_conntrack_proto_tcp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 37bf943..afc4ab7 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -409,7 +409,7 @@ static void tcp_options(const struct sk_buff *skb,
 			if (opsize < 2) /* "silly options" */
 				return;
 			if (opsize > length)
-				break;	/* don't parse partial options */
+				return;	/* don't parse partial options */
 
 			if (opcode == TCPOPT_SACK_PERM
 			    && opsize == TCPOLEN_SACK_PERM)
@@ -469,7 +469,7 @@ static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
 			if (opsize < 2) /* "silly options" */
 				return;
 			if (opsize > length)
-				break;	/* don't parse partial options */
+				return;	/* don't parse partial options */
 
 			if (opcode == TCPOPT_SACK
 			    && opsize >= (TCPOLEN_SACK_BASE
-- 
1.7.0.4

