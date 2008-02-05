From: Jeff Chua <jeff.chua.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cups slow on linux-2.6.24
Date: Tue, 5 Feb 2008 09:17:57 +0800 (SGT)
Message-ID: <Pine.LNX.4.64.0802050913560.6704@boston.corp.fedex.com>
Reply-To: "Mirror of cups.bugs Newsgroup" <cups-bugs-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Krzysztof Piotr Oledzki <ole-gcSpNFQc7Gg@public.gmane.org>,
	Patrick McHardy <kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org>,
	Netfilter Development Mailinglist <netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, cups-bugs <cups-bugs-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
To: Jozsef Kadlecsik <kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org>
Return-path: <cups-bugs-bounces-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.easysw.com/mailman/listinfo/cups-bugs>,
	<mailto:cups-bugs-request-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org?subject=unsubscribe>
List-Post: <mailto:cups-bugs-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
List-Help: <mailto:cups-bugs-request-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org?subject=help>
List-Subscribe: <http://lists.easysw.com/mailman/listinfo/cups-bugs>,
	<mailto:cups-bugs-request-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org?subject=subscribe>
Sender: cups-bugs-bounces-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org
Errors-To: cups-bugs-bounces-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org



On Feb 5, 2008 4:17 AM, Jozsef Kadlecsik <kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org> wrote:

> Actively closed connections are not handled properly, i.e. the initiator 
> of the active close should not be taken into account. So could you give 
> a try to the patch below? Does it just suppress the 'invalid packed 
> ignored' and all other kernel messages or both suppresses them and 
> produces normal printing speed?

Jozsef,

Amazing! You fixed it. No more 'invalid packed ignored', and speed back to 
normal (continues after approx. 20 seconds of pausing after 503 prints).

I used the latest git, and have to modify your patch slightly to make it 
work (changing "conntrack" to "ct").


Thank you for fixing this.

Jeff


Here's your patch modified so it'll apply to the latest git.

--- a/net/netfilter/nf_conntrack_proto_tcp.c.org	2008-02-05 08:29:39 +0800
+++ a/net/netfilter/nf_conntrack_proto_tcp.c	2008-02-05 08:28:05 +0800
@@ -125,7 +125,7 @@
   * CLOSE_WAIT:	ACK seen (after FIN)
   * LAST_ACK:	FIN seen (after FIN)
   * TIME_WAIT:	last ACK seen
- * CLOSE:	closed connection
+ * CLOSE:	closed connection (RST)
   *
   * LISTEN state is not used.
   *
@@ -824,9 +824,23 @@
  	case TCP_CONNTRACK_SYN_SENT:
  		if (old_state < TCP_CONNTRACK_TIME_WAIT)
  			break;
-		if ((ct->proto.tcp.seen[!dir].flags & IP_CT_TCP_FLAG_CLOSE_INIT)
-		    || (ct->proto.tcp.last_dir == dir
-		        && ct->proto.tcp.last_index == TCP_RST_SET)) {
+		/* RFC 1122: "When a connection is closed actively,
+		 * it MUST linger in TIME-WAIT state for a time 2xMSL
+		 * (Maximum Segment Lifetime). However, it MAY accept
+		 * a new SYN from the remote TCP to reopen the connection
+		 * directly from TIME-WAIT state, if..."
+		 * We ignore the conditions because we are in the
+		 * TIME-WAIT state anyway.
+		 *
+		 * Handle aborted connections: we and the server
+		 * think there is an existing connection but the client
+		 * aborts it and starts a new one.
+		 */
+		if (((ct->proto.tcp.seen[dir].flags
+		      | ct->proto.tcp.seen[!dir].flags)
+		     & IP_CT_TCP_FLAG_CLOSE_INIT)
+ 		    || (ct->proto.tcp.last_dir == dir
+ 		        && ct->proto.tcp.last_index == TCP_RST_SET)) {
  			/* Attempt to reopen a closed/aborted connection.
  			 * Delete this connection and look up again. */
  			write_unlock_bh(&tcp_lock);
@@ -838,15 +852,23 @@
  	case TCP_CONNTRACK_IGNORE:
  		/* Ignored packets:
  		 *
+		 * Our connection entry may be out of sync, so ignore
+		 * packets which may signal the real connection between
+		 * the client and the server.
+		 *
  		 * a) SYN in ORIGINAL
  		 * b) SYN/ACK in REPLY
  		 * c) ACK in reply direction after initial SYN in original.
+		 *
+		 * If the ignored packet is invalid, the receiver will send 
+		 * a RST we'll catch below.
  		 */
  		if (index == TCP_SYNACK_SET
  		    && ct->proto.tcp.last_index == TCP_SYN_SET
  		    && ct->proto.tcp.last_dir != dir
  		    && ntohl(th->ack_seq) == ct->proto.tcp.last_end) {
  			/* This SYN/ACK acknowledges a SYN that we earlier
+			/* b) This SYN/ACK acknowledges a SYN that we earlier
  			 * ignored as invalid. This means that the client and
  			 * the server are both in sync, while the firewall is
  			 * not. We kill this session and block the SYN/ACK so
@@ -924,8 +946,7 @@

  	ct->proto.tcp.state = new_state;
  	if (old_state != new_state
-	    && (new_state == TCP_CONNTRACK_FIN_WAIT
-		|| new_state == TCP_CONNTRACK_CLOSE))
+	    && new_state == TCP_CONNTRACK_FIN_WAIT)
  		ct->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_CLOSE_INIT;
  	timeout = ct->proto.tcp.retrans >= nf_ct_tcp_max_retrans
  		  && tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans
