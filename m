From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -stable-3.9 14/15] netfilter: nf_nat_sip: fix mangling
Date: Tue,  2 Jul 2013 16:51:04 +0200
Message-ID: <1372776665-6795-14-git-send-email-pablo@netfilter.org>
References: <1372776665-6795-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, stable@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44200 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096Ab3GBOx1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jul 2013 10:53:27 -0400
In-Reply-To: <1372776665-6795-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Balazs Peter Odor <balazs@obiserver.hu>

In (b20ab9c netfilter: nf_ct_helper: better logging for dropped packets)
there were some missing brackets around the logging information, thus
always returning drop.

Closes https://bugzilla.kernel.org/show_bug.cgi?id=60061

Signed-off-by: Balazs Peter Odor <balazs@obiserver.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Cherry-pick: 5aed93875cd88502f04a0d4517b8a2d89a849773

 net/netfilter/nf_nat_sip.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index 96ccdf7..dac11f7 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -230,9 +230,10 @@ static unsigned int nf_nat_sip(struct sk_buff *skb, unsigned int protoff,
 					&ct->tuplehash[!dir].tuple.src.u3,
 					false);
 			if (!mangle_packet(skb, protoff, dataoff, dptr, datalen,
-					   poff, plen, buffer, buflen))
+					   poff, plen, buffer, buflen)) {
 				nf_ct_helper_log(skb, ct, "cannot mangle received");
 				return NF_DROP;
+			}
 		}
 
 		/* The rport= parameter (RFC 3581) contains the port number
-- 
1.7.10.4

