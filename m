From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/2] netfilter: Validate the sequence number of dataless ACK packets as well
Date: Fri, 31 Aug 2012 21:55:54 +0200
Message-ID: <1346442954-29047-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1346442954-29047-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Wrobel <wrr@mixedbit.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:33438 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815Ab2HaTz4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 Aug 2012 15:55:56 -0400
In-Reply-To: <1346442954-29047-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We spare nothing by not validating the sequence number of dataless
ACK packets and enabling it makes harder off-path attacks.

See: "Reflection scan: an Off-Path Attack on TCP" by Jan Wrobel,
http://arxiv.org/abs/1201.2074

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/nf_conntrack_proto_tcp.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index aba98f9..e046b37 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -630,15 +630,9 @@ static bool tcp_in_window(const struct nf_conn *ct,
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
1.7.0.4

