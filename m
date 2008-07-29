From: Patrick McHardy <kaber@trash.net>
Subject: Re: TCP connection tracking timeout
Date: Tue, 29 Jul 2008 07:00:46 +0200
Message-ID: <488EA3FE.7050503@trash.net>
References: <20080729030104.GA15915@gondor.apana.org.au> <488EA0F1.2050906@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070407000509000109060007"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39542 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbYG2FBk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2008 01:01:40 -0400
In-Reply-To: <488EA0F1.2050906@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070407000509000109060007
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> [List address fixed - I assume netfilter-devel@lists.debian.org 
> doesn't exist :)]
>
> Herbert Xu wrote:
>> Hi:
>>
>> I've recently started keeping an eye on the number of connections
>> in my router's conntrack table.  It was sad to see so many TCP
>> connections that have died long ago still lingering in it.  We all
>> know that wandering ghosts are bad :)
>>
>> Here's my proposal to lay them to rest once and for all.  The
>> obvious solution is to reduce the timeout.  However, that runs
>> afoul of idle connections.  So the key is how do we tell an
>> idle connection apart from a dead one.
>>
>> Actually it isn't too hard.  The most common reason for a connection
>> to die without sending FIN/RST is a retransmission timeout.  For
>> example in Linux we can enter FIN_WAIT_1 without even transmitting
>> the actual FIN because of outstanding data before it.  So if we
>> tracked whether each connection has unacknowledged data then we
>> will be able to easily distinguish them.  In other words, we can
>> drastically lower the timeout on a connection with data outstanding.
>>
>> The only trouble now is to find a sucker^H^H^H^H^H^Hvolunteer
>> to implement this :)
>>   
>
>
> That sounds like a pretty neat idea. I'm testing a patch now, I'll
> send it over in a few minutes if it survives :)

This seems to work. I'm wondering however if this will really help.
We already track retransmissions and decrease the timeout on the
3rd retransmission, so this should only help if both the sender and
the receiver went down.



--------------070407000509000109060007
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

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

--------------070407000509000109060007--
