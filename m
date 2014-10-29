From: Steven Rostedt <rostedt@goodmis.org>
Subject: [RFA][PATCH 2/8] netfilter: Remove return values for print_conntrack callbacks
Date: Wed, 29 Oct 2014 17:56:04 -0400
Message-ID: <20141029220107.465008329@goodmis.org>
References: <20141029215602.535533597@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: Ingo Molnar <mingo@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Joe Perches <joe@perches.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=0002-netfilter-Remove-return-values-for-print_conntrack-c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

[ REQUEST FOR ACKS ]

The seq_printf() and friends are having their return values removed.
The print_conntrack() returns the result of seq_printf(), which is
meaningless when seq_printf() returns void. Might as well remove the
return values of print_conntrack() as well.

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h          | 2 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c | 5 ++++-
 net/netfilter/nf_conntrack_proto_dccp.c               | 4 ++--
 net/netfilter/nf_conntrack_proto_gre.c                | 8 ++++----
 net/netfilter/nf_conntrack_proto_sctp.c               | 4 ++--
 net/netfilter/nf_conntrack_proto_tcp.c                | 4 ++--
 net/netfilter/nf_conntrack_standalone.c               | 4 ++--
 7 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 4c8d573830b7..82e4ec002a39 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -60,7 +60,7 @@ struct nf_conntrack_l4proto {
 			   const struct nf_conntrack_tuple *);
 
 	/* Print out the private part of the conntrack. */
-	int (*print_conntrack)(struct seq_file *s, struct nf_conn *);
+	void (*print_conntrack)(struct seq_file *s, struct nf_conn *);
 
 	/* Return the array of timeouts for this protocol. */
 	unsigned int *(*get_timeouts)(struct net *net);
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index 4c48e434bb1f..91f207c2cb69 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -147,7 +147,10 @@ static int ct_seq_show(struct seq_file *s, void *v)
 		      ? (long)(ct->timeout.expires - jiffies)/HZ : 0) != 0)
 		goto release;
 
-	if (l4proto->print_conntrack && l4proto->print_conntrack(s, ct))
+	if (l4proto->print_conntrack)
+		l4proto->print_conntrack(s, ct);
+
+	if (seq_has_overflowed(s))
 		goto release;
 
 	if (print_tuple(s, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index cb372f96f10d..15971177470a 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -626,9 +626,9 @@ static int dccp_print_tuple(struct seq_file *s,
 			  ntohs(tuple->dst.u.dccp.port));
 }
 
-static int dccp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
+static void dccp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
 {
-	return seq_printf(s, "%s ", dccp_state_names[ct->proto.dccp.state]);
+	seq_printf(s, "%s ", dccp_state_names[ct->proto.dccp.state]);
 }
 
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index d5665739e3b1..cba607ada069 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -235,11 +235,11 @@ static int gre_print_tuple(struct seq_file *s,
 }
 
 /* print private data for conntrack */
-static int gre_print_conntrack(struct seq_file *s, struct nf_conn *ct)
+static void gre_print_conntrack(struct seq_file *s, struct nf_conn *ct)
 {
-	return seq_printf(s, "timeout=%u, stream_timeout=%u ",
-			  (ct->proto.gre.timeout / HZ),
-			  (ct->proto.gre.stream_timeout / HZ));
+	seq_printf(s, "timeout=%u, stream_timeout=%u ",
+		   (ct->proto.gre.timeout / HZ),
+		   (ct->proto.gre.stream_timeout / HZ));
 }
 
 static unsigned int *gre_get_timeouts(struct net *net)
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 1314d33f6bcf..c61f4cd6407d 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -175,7 +175,7 @@ static int sctp_print_tuple(struct seq_file *s,
 }
 
 /* Print out the private part of the conntrack. */
-static int sctp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
+static void sctp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
 {
 	enum sctp_conntrack state;
 
@@ -183,7 +183,7 @@ static int sctp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
 	state = ct->proto.sctp.state;
 	spin_unlock_bh(&ct->lock);
 
-	return seq_printf(s, "%s ", sctp_conntrack_names[state]);
+	seq_printf(s, "%s ", sctp_conntrack_names[state]);
 }
 
 #define for_each_sctp_chunk(skb, sch, _sch, offset, dataoff, count)	\
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 44d1ea32570a..79668fd3db96 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -311,7 +311,7 @@ static int tcp_print_tuple(struct seq_file *s,
 }
 
 /* Print out the private part of the conntrack. */
-static int tcp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
+static void tcp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
 {
 	enum tcp_conntrack state;
 
@@ -319,7 +319,7 @@ static int tcp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
 	state = ct->proto.tcp.state;
 	spin_unlock_bh(&ct->lock);
 
-	return seq_printf(s, "%s ", tcp_conntrack_names[state]);
+	seq_printf(s, "%s ", tcp_conntrack_names[state]);
 }
 
 static unsigned int get_conntrack_index(const struct tcphdr *tcph)
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index cf65a1e040dd..348aa3602787 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -199,8 +199,8 @@ static int ct_seq_show(struct seq_file *s, void *v)
 		       ? (long)(ct->timeout.expires - jiffies)/HZ : 0) != 0)
 		goto release;
 
-	if (l4proto->print_conntrack && l4proto->print_conntrack(s, ct))
-		goto release;
+	if (l4proto->print_conntrack)
+		l4proto->print_conntrack(s, ct);
 
 	if (print_tuple(s, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 			l3proto, l4proto))
-- 
2.1.1
