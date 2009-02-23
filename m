From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: conntrack: account packets drop by tcp_packet()
Date: Mon, 23 Feb 2009 11:15:51 +0100
Message-ID: <20090223101551.7309.61740.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34885 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751697AbZBWKP4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Feb 2009 05:15:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since tcp_packet() may return -NF_DROP in two situations, the
packet-drop stats must be increased.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nf_conntrack_core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 8b9dbb7..4503727 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -733,6 +733,8 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 		nf_conntrack_put(skb->nfct);
 		skb->nfct = NULL;
 		NF_CT_STAT_INC_ATOMIC(net, invalid);
+		if (-ret == NF_DROP)
+			NF_CT_STAT_INC_ATOMIC(net, drop);
 		return -ret;
 	}
 

