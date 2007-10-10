From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Wed, 10 Oct 2007 21:26:33 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710102054120.13087@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:44903 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049AbXJJT0g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Oct 2007 15:26:36 -0400
In-Reply-To: <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Wed, 3 Oct 2007, Krzysztof Oledzki wrote:

> I also wondering if the code from nf_conntrack_proto_tcp.c is correct:
> 
> --- cut here ---
> new_state = tcp_conntracks[dir][index][old_state];
> 
> switch (new_state)
> (...)
> case TCP_CONNTRACK_SYN_SENT:
> if (old_state < TCP_CONNTRACK_TIME_WAIT)
>         break;
> if ((conntrack->proto.tcp.seen[dir].flags &
>         IP_CT_TCP_FLAG_CLOSE_INIT)
>     || after(ntohl(th->seq),
>              conntrack->proto.tcp.seen[dir].td_end)) {
>         /* Attempt to reopen a closed connection.
>         * Delete this connection and look up again. */
>         write_unlock_bh(&tcp_lock);
>         if (del_timer(&conntrack->timeout))
>                 conntrack->timeout.function((unsigned long)
>                                             conntrack);
>         return -NF_REPEAT;

With your description I could reproduce the bug and actually you were 
completely right: the code above is incorrect. Somehow I was able to 
misread RFC1122 and mixed the roles :-(:

   When a connection is >>closed actively<<, it MUST linger in
   TIME-WAIT state for a time 2xMSL (Maximum Segment Lifetime).
   However, it MAY >>accept<< a new SYN from the remote TCP to
   reopen the connection directly from TIME-WAIT state, if it:
   [...]

The fix is as follows: if the receiver initiated an active close, then the 
sender may reopen the connection - otherwise try to figure out if we hold 
a dead connection.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index eb3fe74..1b836d0 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -831,6 +831,20 @@ static int tcp_packet(struct nf_conn *conntrack,
 	tuple = &conntrack->tuplehash[dir].tuple;
 
 	switch (new_state) {
+	case TCP_CONNTRACK_SYN_SENT:
+		if (old_state < TCP_CONNTRACK_TIME_WAIT)
+			break;
+		if (conntrack->proto.tcp.seen[!dir].flags &
+			IP_CT_TCP_FLAG_CLOSE_INIT) {
+			/* Attempt to reopen a closed connection.
+			* Delete this connection and look up again. */
+			write_unlock_bh(&tcp_lock);
+			if (del_timer(&conntrack->timeout))
+				conntrack->timeout.function((unsigned long)
+							    conntrack);
+			return -NF_REPEAT;
+		}
+		/* Fall through */
 	case TCP_CONNTRACK_IGNORE:
 		/* Ignored packets:
 		 *
@@ -879,27 +893,6 @@ static int tcp_packet(struct nf_conn *conntrack,
 			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
 				  "nf_ct_tcp: invalid state ");
 		return -NF_ACCEPT;
-	case TCP_CONNTRACK_SYN_SENT:
-		if (old_state < TCP_CONNTRACK_TIME_WAIT)
-			break;
-		if ((conntrack->proto.tcp.seen[dir].flags &
-			IP_CT_TCP_FLAG_CLOSE_INIT)
-		    || after(ntohl(th->seq),
-			     conntrack->proto.tcp.seen[dir].td_end)) {
-			/* Attempt to reopen a closed connection.
-			* Delete this connection and look up again. */
-			write_unlock_bh(&tcp_lock);
-			if (del_timer(&conntrack->timeout))
-				conntrack->timeout.function((unsigned long)
-							    conntrack);
-			return -NF_REPEAT;
-		} else {
-			write_unlock_bh(&tcp_lock);
-			if (LOG_INVALID(IPPROTO_TCP))
-				nf_log_packet(pf, 0, skb, NULL, NULL,
-					      NULL, "nf_ct_tcp: invalid SYN");
-			return -NF_ACCEPT;
-		}
 	case TCP_CONNTRACK_CLOSE:
 		if (index == TCP_RST_SET
 		    && ((test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
