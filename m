From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/2] Wrong multiplication of TCPOLEN_TSTAMP_ALIGNED in tcp_sack skips fastpath
Date: Tue, 30 Aug 2011 15:35:41 +0200
Message-ID: <1314711341-28392-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1314711341-28392-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1314711341-28392-2-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:53042 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954Ab1H3Nfn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Aug 2011 09:35:43 -0400
In-Reply-To: <1314711341-28392-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The wrong multiplication of TCPOLEN_TSTAMP_ALIGNED by 4 skips the fast path
for the timestamp-only option. Bug reported by Michael M. Builov (netfilter
bugzilla #738).

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/nf_conntrack_proto_tcp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index afc4ab7..8235b86 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -447,7 +447,7 @@ static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
 	BUG_ON(ptr == NULL);
 
 	/* Fast path for timestamp-only option */
-	if (length == TCPOLEN_TSTAMP_ALIGNED*4
+	if (length == TCPOLEN_TSTAMP_ALIGNED
 	    && *(__be32 *)ptr == htonl((TCPOPT_NOP << 24)
 				       | (TCPOPT_NOP << 16)
 				       | (TCPOPT_TIMESTAMP << 8)
-- 
1.7.0.4

