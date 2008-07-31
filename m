From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 01/03: nf_conntrack_tcp: decrease timeouts while data in unacknowledged
Date: Thu, 31 Jul 2008 08:33:14 +0200 (MEST)
Message-ID: <20080731063313.18150.27237.sendpatchset@localhost.localdomain>
References: <20080731063312.18150.49494.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34601 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbYGaGdP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 02:33:15 -0400
In-Reply-To: <20080731063312.18150.49494.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: nf_conntrack_tcp: decrease timeouts while data in unacknowledged

In order to time out dead connections quicker, keep track of outstanding data
and cap the timeout.

Suggested by Herbert Xu.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 827768d3835412f6ba386c9fc2d6fdbde0c2c0ee
tree 03b536e5beeeb4585d4aec822125177c04353f2e
parent e93dc4891df93d7efa59d861fdcbb529a1819343
author Patrick McHardy <kaber@trash.net> Wed, 30 Jul 2008 12:06:26 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jul 2008 12:06:26 +0200

 include/linux/netfilter/nf_conntrack_tcp.h |    3 +++
 net/netfilter/nf_conntrack_proto_tcp.c     |   29 +++++++++++++++++++++++-----
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_tcp.h b/include/linux/netfilter/nf_conntrack_tcp.h
index 22ce299..a049df4 100644
--- a/include/linux/netfilter/nf_conntrack_tcp.h
+++ b/include/linux/netfilter/nf_conntrack_tcp.h
@@ -30,6 +30,9 @@ enum tcp_conntrack {
 /* Be liberal in window checking */
 #define IP_CT_TCP_FLAG_BE_LIBERAL		0x08
 
+/* Has unacknowledged data */
+#define IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED	0x10
+
 struct nf_ct_tcp_flags {
 	u_int8_t flags;
 	u_int8_t mask;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 420a10d..6f61261 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -67,7 +67,8 @@ static const char *const tcp_conntrack_names[] = {
 /* RFC1122 says the R2 limit should be at least 100 seconds.
    Linux uses 15 packets as limit, which corresponds
    to ~13-30min depending on RTO. */
-static unsigned int nf_ct_tcp_timeout_max_retrans __read_mostly =   5 MINS;
+static unsigned int nf_ct_tcp_timeout_max_retrans __read_mostly    =   5 MINS;
+static unsigned int nf_ct_tcp_timeout_unacknowledged __read_mostly =   5 MINS;
 
 static unsigned int tcp_timeouts[TCP_CONNTRACK_MAX] __read_mostly = {
 	[TCP_CONNTRACK_SYN_SENT]	= 2 MINS,
@@ -625,8 +626,10 @@ static bool tcp_in_window(const struct nf_conn *ct,
 		swin = win + (sack - ack);
 		if (sender->td_maxwin < swin)
 			sender->td_maxwin = swin;
-		if (after(end, sender->td_end))
+		if (after(end, sender->td_end)) {
 			sender->td_end = end;
+			sender->flags |= IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED;
+		}
 		/*
 		 * Update receiver data.
 		 */
@@ -637,6 +640,8 @@ static bool tcp_in_window(const struct nf_conn *ct,
 			if (win == 0)
 				receiver->td_maxend++;
 		}
+		if (ack == receiver->td_end)
+			receiver->flags &= ~IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED;
 
 		/*
 		 * Check retransmissions.
@@ -951,9 +956,16 @@ static int tcp_packet(struct nf_conn *ct,
 	if (old_state != new_state
 	    && new_state == TCP_CONNTRACK_FIN_WAIT)
 		ct->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_CLOSE_INIT;
-	timeout = ct->proto.tcp.retrans >= nf_ct_tcp_max_retrans
-		  && tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans
-		  ? nf_ct_tcp_timeout_max_retrans : tcp_timeouts[new_state];
+
+	if (ct->proto.tcp.retrans >= nf_ct_tcp_max_retrans &&
+	    tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans)
+		timeout = nf_ct_tcp_timeout_max_retrans;
+	else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
+		 IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&
+		 tcp_timeouts[new_state] > nf_ct_tcp_timeout_unacknowledged)
+		timeout = nf_ct_tcp_timeout_unacknowledged;
+	else
+		timeout = tcp_timeouts[new_state];
 	write_unlock_bh(&tcp_lock);
 
 	nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);
@@ -1236,6 +1248,13 @@ static struct ctl_table tcp_sysctl_table[] = {
 		.proc_handler	= &proc_dointvec_jiffies,
 	},
 	{
+		.procname	= "nf_conntrack_tcp_timeout_unacknowledged",
+		.data		= &nf_ct_tcp_timeout_unacknowledged,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_jiffies,
+	},
+	{
 		.ctl_name	= NET_NF_CONNTRACK_TCP_LOOSE,
 		.procname	= "nf_conntrack_tcp_loose",
 		.data		= &nf_ct_tcp_loose,
