From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] netfilter: nf_conntrack_proto_gre: only create ct assured event once
Date: Fri, 30 Sep 2011 16:38:29 +0200
Message-ID: <1317393509-11078-1-git-send-email-fw@strlen.de>
Cc: denys@visp.net.lb, Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:55508 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019Ab1I3Ogj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Sep 2011 10:36:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

GRE connections cause ctnetlink event flood due to ASSURED event
being created for every packet received.

Reported-and-tested-by: Denys Fedoryshchenko <denys@visp.net.lb>
Signed-off-by: Florian Westphal <fw@strlen.de>
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
1.7.3.4

