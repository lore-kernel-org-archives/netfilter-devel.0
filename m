From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 24/38]: nf_conntrack_tcp: remove timeout indirection
Date: Tue, 15 Jan 2008 07:19:44 +0100 (MET)
Message-ID: <20080115061939.3184.31189.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62230 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbYAOGTq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:46 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_tcp: remove timeout indirection

Instead of keeping pointers to the timeout values in a table, simply
put the timeout values in the table directly.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e11744f0b9408e74f920463e52d59460e9c2b2b2
tree 7a75dea3fedc59c8ae32106fb1aae3a95bf3dfe9
parent 310e65023fa9efc6b18c32f3146cc6c24e6b2c33
author Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:25 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:25 +0100

 net/netfilter/nf_conntrack_proto_tcp.c |   67 +++++++++++++-------------------
 1 files changed, 28 insertions(+), 39 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index dbd8f84..64c9b91 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -64,32 +64,21 @@ static const char *tcp_conntrack_names[] = {
 #define HOURS * 60 MINS
 #define DAYS * 24 HOURS
 
-static unsigned int nf_ct_tcp_timeout_syn_sent __read_mostly =      2 MINS;
-static unsigned int nf_ct_tcp_timeout_syn_recv __read_mostly =     60 SECS;
-static unsigned int nf_ct_tcp_timeout_established __read_mostly =   5 DAYS;
-static unsigned int nf_ct_tcp_timeout_fin_wait __read_mostly =      2 MINS;
-static unsigned int nf_ct_tcp_timeout_close_wait __read_mostly =   60 SECS;
-static unsigned int nf_ct_tcp_timeout_last_ack __read_mostly =     30 SECS;
-static unsigned int nf_ct_tcp_timeout_time_wait __read_mostly =     2 MINS;
-static unsigned int nf_ct_tcp_timeout_close __read_mostly =        10 SECS;
-
 /* RFC1122 says the R2 limit should be at least 100 seconds.
    Linux uses 15 packets as limit, which corresponds
    to ~13-30min depending on RTO. */
 static unsigned int nf_ct_tcp_timeout_max_retrans __read_mostly =   5 MINS;
 
-static unsigned int * tcp_timeouts[] = {
-    NULL,                              /* TCP_CONNTRACK_NONE */
-    &nf_ct_tcp_timeout_syn_sent,       /* TCP_CONNTRACK_SYN_SENT, */
-    &nf_ct_tcp_timeout_syn_recv,       /* TCP_CONNTRACK_SYN_RECV, */
-    &nf_ct_tcp_timeout_established,    /* TCP_CONNTRACK_ESTABLISHED, */
-    &nf_ct_tcp_timeout_fin_wait,       /* TCP_CONNTRACK_FIN_WAIT, */
-    &nf_ct_tcp_timeout_close_wait,     /* TCP_CONNTRACK_CLOSE_WAIT, */
-    &nf_ct_tcp_timeout_last_ack,       /* TCP_CONNTRACK_LAST_ACK, */
-    &nf_ct_tcp_timeout_time_wait,      /* TCP_CONNTRACK_TIME_WAIT, */
-    &nf_ct_tcp_timeout_close,          /* TCP_CONNTRACK_CLOSE, */
-    NULL,                              /* TCP_CONNTRACK_LISTEN */
- };
+static unsigned int tcp_timeouts[TCP_CONNTRACK_MAX] __read_mostly = {
+	[TCP_CONNTRACK_SYN_SENT]	= 2 MINS,
+	[TCP_CONNTRACK_SYN_RECV]	= 60 SECS,
+	[TCP_CONNTRACK_ESTABLISHED]	= 5 DAYS,
+	[TCP_CONNTRACK_FIN_WAIT]	= 2 MINS,
+	[TCP_CONNTRACK_CLOSE_WAIT]	= 60 SECS,
+	[TCP_CONNTRACK_LAST_ACK]	= 30 SECS,
+	[TCP_CONNTRACK_TIME_WAIT]	= 2 MINS,
+	[TCP_CONNTRACK_CLOSE]		= 10 SECS,
+};
 
 #define sNO TCP_CONNTRACK_NONE
 #define sSS TCP_CONNTRACK_SYN_SENT
@@ -941,8 +930,8 @@ static int tcp_packet(struct nf_conn *conntrack,
 		|| new_state == TCP_CONNTRACK_CLOSE))
 		conntrack->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_CLOSE_INIT;
 	timeout = conntrack->proto.tcp.retrans >= nf_ct_tcp_max_retrans
-		  && *tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans
-		  ? nf_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];
+		  && tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans
+		  ? nf_ct_tcp_timeout_max_retrans : tcp_timeouts[new_state];
 	write_unlock_bh(&tcp_lock);
 
 	nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);
@@ -1163,56 +1152,56 @@ static struct ctl_table_header *tcp_sysctl_header;
 static struct ctl_table tcp_sysctl_table[] = {
 	{
 		.procname	= "nf_conntrack_tcp_timeout_syn_sent",
-		.data		= &nf_ct_tcp_timeout_syn_sent,
+		.data		= &tcp_timeouts[TCP_CONNTRACK_SYN_SENT],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_tcp_timeout_syn_recv",
-		.data		= &nf_ct_tcp_timeout_syn_recv,
+		.data		= &tcp_timeouts[TCP_CONNTRACK_SYN_RECV],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_tcp_timeout_established",
-		.data		= &nf_ct_tcp_timeout_established,
+		.data		= &tcp_timeouts[TCP_CONNTRACK_ESTABLISHED],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_tcp_timeout_fin_wait",
-		.data		= &nf_ct_tcp_timeout_fin_wait,
+		.data		= &tcp_timeouts[TCP_CONNTRACK_FIN_WAIT],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_tcp_timeout_close_wait",
-		.data		= &nf_ct_tcp_timeout_close_wait,
+		.data		= &tcp_timeouts[TCP_CONNTRACK_CLOSE_WAIT],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_tcp_timeout_last_ack",
-		.data		= &nf_ct_tcp_timeout_last_ack,
+		.data		= &tcp_timeouts[TCP_CONNTRACK_LAST_ACK],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_tcp_timeout_time_wait",
-		.data		= &nf_ct_tcp_timeout_time_wait,
+		.data		= &tcp_timeouts[TCP_CONNTRACK_TIME_WAIT],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_tcp_timeout_close",
-		.data		= &nf_ct_tcp_timeout_close,
+		.data		= &tcp_timeouts[TCP_CONNTRACK_CLOSE],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
@@ -1257,56 +1246,56 @@ static struct ctl_table tcp_sysctl_table[] = {
 static struct ctl_table tcp_compat_sysctl_table[] = {
 	{
 		.procname	= "ip_conntrack_tcp_timeout_syn_sent",
-		.data		= &nf_ct_tcp_timeout_syn_sent,
+		.data		= &tcp_timeouts[TCP_CONNTRACK_SYN_SENT],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ip_conntrack_tcp_timeout_syn_recv",
-		.data		= &nf_ct_tcp_timeout_syn_recv,
+		.data		= &tcp_timeouts[TCP_CONNTRACK_SYN_RECV],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ip_conntrack_tcp_timeout_established",
-		.data		= &nf_ct_tcp_timeout_established,
+		.data		= &tcp_timeouts[TCP_CONNTRACK_ESTABLISHED],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ip_conntrack_tcp_timeout_fin_wait",
-		.data		= &nf_ct_tcp_timeout_fin_wait,
+		.data		= &tcp_timeouts[TCP_CONNTRACK_FIN_WAIT],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ip_conntrack_tcp_timeout_close_wait",
-		.data		= &nf_ct_tcp_timeout_close_wait,
+		.data		= &tcp_timeouts[TCP_CONNTRACK_CLOSE_WAIT],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ip_conntrack_tcp_timeout_last_ack",
-		.data		= &nf_ct_tcp_timeout_last_ack,
+		.data		= &tcp_timeouts[TCP_CONNTRACK_LAST_ACK],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ip_conntrack_tcp_timeout_time_wait",
-		.data		= &nf_ct_tcp_timeout_time_wait,
+		.data		= &tcp_timeouts[TCP_CONNTRACK_TIME_WAIT],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ip_conntrack_tcp_timeout_close",
-		.data		= &nf_ct_tcp_timeout_close,
+		.data		= &tcp_timeouts[TCP_CONNTRACK_CLOSE],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
