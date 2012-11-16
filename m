From: pablo@netfilter.org
Subject: [PATCH 2/3] [-stable] netfilter: Validate the sequence number of dataless ACK packets as well
Date: Fri, 16 Nov 2012 15:00:13 +0100
Message-ID: <1353074415-21379-3-git-send-email-pablo@netfilter.org>
References: <1353074415-21379-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, stable@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36213 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab2KPOAc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:00:32 -0500
In-Reply-To: <1353074415-21379-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

We spare nothing by not validating the sequence number of dataless
ACK packets and enabling it makes harder off-path attacks.

See: "Reflection scan: an Off-Path Attack on TCP" by Jan Wrobel,
http://arxiv.org/abs/1201.2074

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 1eb458c..a9d5f50 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -625,15 +625,9 @@ static bool tcp_in_window(const struct nf_conn *ct,
 		ack = sack = receiver->td_end;
 	}
 
-	if (seq == end
-	    && (!tcph->rst
-		|| (seq == 0 && state->state == TCP_CONNTRACK_SYN_SENT)))
+	if (tcph->rst && seq == 0 && state->state == TCP_CONNTRACK_SYN_SENT)
 		/*
-		 * Packets contains no data: we assume it is valid
-		 * and check the ack value only.
-		 * However RST segments are always validated by their
-		 * SEQ number, except when seq == 0 (reset sent answering
-		 * SYN.
+		 * RST sent answering SYN.
 		 */
 		seq = end = sender->td_end;
 
-- 
1.7.10.4

