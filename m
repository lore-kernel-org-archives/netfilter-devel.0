From: pablo@netfilter.org
Subject: [PATCH] netfilter: nf_ct_tcp: extend log message for invalid ignored packets
Date: Mon, 14 May 2012 14:52:39 +0200
Message-ID: <1336999959-20480-1-git-send-email-pablo@netfilter.org>
Cc: kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54139 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755830Ab2ENMxI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 May 2012 08:53:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Extend log message if packets are ignored to include the TCP state, ie.
replace:

[ 3968.070196] nf_ct_tcp: invalid packet ignored IN= OUT= SRC=...

by:

[ 3968.070196] nf_ct_tcp: invalid packet ignored in state ESTABLISHED IN= OUT= SRC=...

This information is useful to know in what state we were while ignoring the
packet.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 4dfbfa8..21ff1a9 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -952,7 +952,8 @@ static int tcp_packet(struct nf_conn *ct,
 		spin_unlock_bh(&ct->lock);
 		if (LOG_INVALID(net, IPPROTO_TCP))
 			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
-				  "nf_ct_tcp: invalid packet ignored ");
+				  "nf_ct_tcp: invalid packet ignored in "
+				  "state %s ", tcp_conntrack_names[old_state]);
 		return NF_ACCEPT;
 	case TCP_CONNTRACK_MAX:
 		/* Invalid packet */
-- 
1.7.10

