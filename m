From: Changli Gao <xiaosuo@gmail.com>
Subject: Add seperated timeout for the connections that only receive packets
 in one direction
Date: Fri, 27 Nov 2009 17:09:11 +0800
Message-ID: <4B0F9737.8050606@gmail.com>
Reply-To: xiaosuo@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, xiaosuo <xiaosuo@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:41646 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbZK0JJT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2009 04:09:19 -0500
Received: by pwi3 with SMTP id 3so889664pwi.21
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Nov 2009 01:09:26 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add seperated timeout for the connections that only receive packets in one direction.

If we use tcp_timeouts[TCP_CONNTRACK_ESTABLISHED] to timeout the connections that only receive packets in one direction, ACK flood attack with fake source address A will exhaust A's connection limit, and A is DoSed. After the attack is stopped, A can't recover quickly due to the large timeout value.

This patch adds a new timeout value: nf_ct_tcp_timeout_loose_unreply for this kind of connections. It can help A to recover quickly after the attack is over.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 nf_conntrack_proto_tcp.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 7eda8b8..471045a 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -70,6 +70,8 @@ static const char *const tcp_conntrack_names[] = {
 static unsigned int nf_ct_tcp_timeout_max_retrans __read_mostly    =   5 MINS;
 static unsigned int nf_ct_tcp_timeout_unacknowledged __read_mostly =   5 MINS;
 
+static unsigned int nf_ct_tcp_timeout_loose_unreply __read_mostly  =   30 SECS;
+
 static unsigned int tcp_timeouts[TCP_CONNTRACK_MAX] __read_mostly = {
 	[TCP_CONNTRACK_SYN_SENT]	= 2 MINS,
 	[TCP_CONNTRACK_SYN_RECV]	= 60 SECS,
@@ -1006,6 +1008,9 @@ static int tcp_packet(struct nf_conn *ct,
 			nf_ct_kill_acct(ct, ctinfo, skb);
 			return NF_ACCEPT;
 		}
+		if (new_state == TCP_CONNTRACK_ESTABLISHED &&
+		    timeout > nf_ct_tcp_timeout_loose_unreply)
+			timeout = nf_ct_tcp_timeout_loose_unreply;
 	} else if (!test_bit(IPS_ASSURED_BIT, &ct->status)
 		   && (old_state == TCP_CONNTRACK_SYN_RECV
 		       || old_state == TCP_CONNTRACK_ESTABLISHED)
@@ -1298,6 +1303,13 @@ static struct ctl_table tcp_sysctl_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
+		.procname	= "nf_conntrack_tcp_timeout_loose_unreply",
+		.data		= &nf_ct_tcp_timeout_loose_unreply,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	{
 		.procname       = "nf_conntrack_tcp_be_liberal",
 		.data           = &nf_ct_tcp_be_liberal,
 		.maxlen         = sizeof(unsigned int),
@@ -1394,6 +1406,13 @@ static struct ctl_table tcp_compat_sysctl_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
+		.procname	= "ip_conntrack_tcp_timeout_loose_unreply",
+		.data		= &nf_ct_tcp_timeout_loose_unreply,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	{
 		.procname	= "ip_conntrack_tcp_be_liberal",
 		.data		= &nf_ct_tcp_be_liberal,
 		.maxlen		= sizeof(unsigned int),

