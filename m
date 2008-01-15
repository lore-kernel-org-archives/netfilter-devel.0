From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 34/38]: nf_conntrack_sctp: remove timeout indirection
Date: Tue, 15 Jan 2008 07:19:58 +0100 (MET)
Message-ID: <20080115061953.3184.11875.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62264 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbYAOGT7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:59 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sctp: remove timeout indirection

Instead of keeping pointers to the timeout values in a table, simply
put the timeout values in the table directly.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 918cc347b331a901245021bd85c1cb3c7ff54482
tree a7aa2f2d554107ce90f7c4e4da77711ce954e235
parent 07f97b30ff30a5ce17377199ae32176b5dab5b08
author Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:30 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:30 +0100

 net/netfilter/nf_conntrack_proto_sctp.c |   57 +++++++++++++------------------
 1 files changed, 24 insertions(+), 33 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 14b1c02..21d29e7 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -49,24 +49,15 @@ static const char *sctp_conntrack_names[] = {
 #define HOURS * 60 MINS
 #define DAYS  * 24 HOURS
 
-static unsigned int nf_ct_sctp_timeout_closed __read_mostly          =  10 SECS;
-static unsigned int nf_ct_sctp_timeout_cookie_wait __read_mostly     =   3 SECS;
-static unsigned int nf_ct_sctp_timeout_cookie_echoed __read_mostly   =   3 SECS;
-static unsigned int nf_ct_sctp_timeout_established __read_mostly     =   5 DAYS;
-static unsigned int nf_ct_sctp_timeout_shutdown_sent __read_mostly   = 300 SECS / 1000;
-static unsigned int nf_ct_sctp_timeout_shutdown_recd __read_mostly   = 300 SECS / 1000;
-static unsigned int nf_ct_sctp_timeout_shutdown_ack_sent __read_mostly = 3 SECS;
-
-static unsigned int * sctp_timeouts[]
-= { NULL,                                  /* SCTP_CONNTRACK_NONE  */
-    &nf_ct_sctp_timeout_closed,	           /* SCTP_CONNTRACK_CLOSED */
-    &nf_ct_sctp_timeout_cookie_wait,       /* SCTP_CONNTRACK_COOKIE_WAIT */
-    &nf_ct_sctp_timeout_cookie_echoed,     /* SCTP_CONNTRACK_COOKIE_ECHOED */
-    &nf_ct_sctp_timeout_established,       /* SCTP_CONNTRACK_ESTABLISHED */
-    &nf_ct_sctp_timeout_shutdown_sent,     /* SCTP_CONNTRACK_SHUTDOWN_SENT */
-    &nf_ct_sctp_timeout_shutdown_recd,     /* SCTP_CONNTRACK_SHUTDOWN_RECD */
-    &nf_ct_sctp_timeout_shutdown_ack_sent  /* SCTP_CONNTRACK_SHUTDOWN_ACK_SENT */
- };
+static unsigned int sctp_timeouts[SCTP_CONNTRACK_MAX] __read_mostly = {
+	[SCTP_CONNTRACK_CLOSED]			= 10 SECS,
+	[SCTP_CONNTRACK_COOKIE_WAIT]		= 3 SECS,
+	[SCTP_CONNTRACK_COOKIE_ECHOED]		= 3 SECS,
+	[SCTP_CONNTRACK_ESTABLISHED]		= 5 DAYS,
+	[SCTP_CONNTRACK_SHUTDOWN_SENT]		= 300 SECS / 1000,
+	[SCTP_CONNTRACK_SHUTDOWN_RECD]		= 300 SECS / 1000,
+	[SCTP_CONNTRACK_SHUTDOWN_ACK_SENT]	= 3 SECS,
+};
 
 #define sNO SCTP_CONNTRACK_NONE
 #define	sCL SCTP_CONNTRACK_CLOSED
@@ -380,7 +371,7 @@ static int sctp_packet(struct nf_conn *ct,
 	}
 	write_unlock_bh(&sctp_lock);
 
-	nf_ct_refresh_acct(ct, ctinfo, skb, *sctp_timeouts[new_state]);
+	nf_ct_refresh_acct(ct, ctinfo, skb, sctp_timeouts[new_state]);
 
 	if (old_state == SCTP_CONNTRACK_COOKIE_ECHOED &&
 	    dir == IP_CT_DIR_REPLY &&
@@ -474,49 +465,49 @@ static struct ctl_table_header *sctp_sysctl_header;
 static struct ctl_table sctp_sysctl_table[] = {
 	{
 		.procname	= "nf_conntrack_sctp_timeout_closed",
-		.data		= &nf_ct_sctp_timeout_closed,
+		.data		= &sctp_timeouts[SCTP_CONNTRACK_CLOSED],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_sctp_timeout_cookie_wait",
-		.data		= &nf_ct_sctp_timeout_cookie_wait,
+		.data		= &sctp_timeouts[SCTP_CONNTRACK_COOKIE_WAIT],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_sctp_timeout_cookie_echoed",
-		.data		= &nf_ct_sctp_timeout_cookie_echoed,
+		.data		= &sctp_timeouts[SCTP_CONNTRACK_COOKIE_ECHOED],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_sctp_timeout_established",
-		.data		= &nf_ct_sctp_timeout_established,
+		.data		= &sctp_timeouts[SCTP_CONNTRACK_ESTABLISHED],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_sctp_timeout_shutdown_sent",
-		.data		= &nf_ct_sctp_timeout_shutdown_sent,
+		.data		= &sctp_timeouts[SCTP_CONNTRACK_SHUTDOWN_SENT],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_sctp_timeout_shutdown_recd",
-		.data		= &nf_ct_sctp_timeout_shutdown_recd,
+		.data		= &sctp_timeouts[SCTP_CONNTRACK_SHUTDOWN_RECD],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_sctp_timeout_shutdown_ack_sent",
-		.data		= &nf_ct_sctp_timeout_shutdown_ack_sent,
+		.data		= &sctp_timeouts[SCTP_CONNTRACK_SHUTDOWN_ACK_SENT],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
@@ -530,49 +521,49 @@ static struct ctl_table sctp_sysctl_table[] = {
 static struct ctl_table sctp_compat_sysctl_table[] = {
 	{
 		.procname	= "ip_conntrack_sctp_timeout_closed",
-		.data		= &nf_ct_sctp_timeout_closed,
+		.data		= &sctp_timeouts[SCTP_CONNTRACK_CLOSED],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ip_conntrack_sctp_timeout_cookie_wait",
-		.data		= &nf_ct_sctp_timeout_cookie_wait,
+		.data		= &sctp_timeouts[SCTP_CONNTRACK_COOKIE_WAIT],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ip_conntrack_sctp_timeout_cookie_echoed",
-		.data		= &nf_ct_sctp_timeout_cookie_echoed,
+		.data		= &sctp_timeouts[SCTP_CONNTRACK_COOKIE_ECHOED],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ip_conntrack_sctp_timeout_established",
-		.data		= &nf_ct_sctp_timeout_established,
+		.data		= &sctp_timeouts[SCTP_CONNTRACK_ESTABLISHED],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ip_conntrack_sctp_timeout_shutdown_sent",
-		.data		= &nf_ct_sctp_timeout_shutdown_sent,
+		.data		= &sctp_timeouts[SCTP_CONNTRACK_SHUTDOWN_SENT],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ip_conntrack_sctp_timeout_shutdown_recd",
-		.data		= &nf_ct_sctp_timeout_shutdown_recd,
+		.data		= &sctp_timeouts[SCTP_CONNTRACK_SHUTDOWN_RECD],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ip_conntrack_sctp_timeout_shutdown_ack_sent",
-		.data		= &nf_ct_sctp_timeout_shutdown_ack_sent,
+		.data		= &sctp_timeouts[SCTP_CONNTRACK_SHUTDOWN_ACK_SENT],
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
