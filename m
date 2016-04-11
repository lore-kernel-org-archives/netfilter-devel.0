From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: conntrack: don't acquire lock during seq_printf
Date: Mon, 11 Apr 2016 21:14:29 +0200
Message-ID: <1460402069-22101-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35501 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752329AbcDKTOO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Apr 2016 15:14:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

read access doesn't need any lock here.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_sctp.c | 8 +-------
 net/netfilter/nf_conntrack_proto_tcp.c  | 8 +-------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 9578a7c..1d7ab96 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -191,13 +191,7 @@ static void sctp_print_tuple(struct seq_file *s,
 /* Print out the private part of the conntrack. */
 static void sctp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
 {
-	enum sctp_conntrack state;
-
-	spin_lock_bh(&ct->lock);
-	state = ct->proto.sctp.state;
-	spin_unlock_bh(&ct->lock);
-
-	seq_printf(s, "%s ", sctp_conntrack_names[state]);
+	seq_printf(s, "%s ", sctp_conntrack_names[ct->proto.sctp.state]);
 }
 
 #define for_each_sctp_chunk(skb, sch, _sch, offset, dataoff, count)	\
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 278f3b9..e0cb0ce 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -313,13 +313,7 @@ static void tcp_print_tuple(struct seq_file *s,
 /* Print out the private part of the conntrack. */
 static void tcp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
 {
-	enum tcp_conntrack state;
-
-	spin_lock_bh(&ct->lock);
-	state = ct->proto.tcp.state;
-	spin_unlock_bh(&ct->lock);
-
-	seq_printf(s, "%s ", tcp_conntrack_names[state]);
+	seq_printf(s, "%s ", tcp_conntrack_names[ct->proto.tcp.state]);
 }
 
 static unsigned int get_conntrack_index(const struct tcphdr *tcph)
-- 
2.7.3

