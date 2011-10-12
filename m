From: pablo@netfilter.org
Subject: [PATCH 1/2] netfilter: nf_conntrack: fix event flooding in GRE protocol tracker
Date: Wed, 12 Oct 2011 19:32:51 +0200
Message-ID: <1318440772-21058-2-git-send-email-pablo@netfilter.org>
References: <1318440772-21058-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59762 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab1JLRjy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Oct 2011 13:39:54 -0400
In-Reply-To: <1318440772-21058-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

GRE connections cause ctnetlink event flood because the ASSURED event
is set for every packet received.

Reported-by: Denys Fedoryshchenko <denys@visp.net.lb>
Tested-by: Denys Fedoryshchenko <denys@visp.net.lb>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_gre.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index cf616e5..d69facd 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -241,8 +241,8 @@ static int gre_packet(struct nf_conn *ct,
 		nf_ct_refresh_acct(ct, ctinfo, skb,
 				   ct->proto.gre.stream_timeout);
 		/* Also, more likely to be important, and not a probe. */
-		set_bit(IPS_ASSURED_BIT, &ct->status);
-		nf_conntrack_event_cache(IPCT_ASSURED, ct);
+		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
+			nf_conntrack_event_cache(IPCT_ASSURED, ct);
 	} else
 		nf_ct_refresh_acct(ct, ctinfo, skb,
 				   ct->proto.gre.timeout);
-- 
1.7.2.5

