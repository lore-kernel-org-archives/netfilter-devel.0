From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Resend: TCP window tracking fixes
Date: Wed, 02 Feb 2005 00:45:19 +0100
Message-ID: <4200148F.70004@trash.net>
References: <20050201232504.GA27476@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050201232504.GA27476@linuxace.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Phil Oester wrote:

>Resending two patches which have not yet made it to mainline, and
>which (IMO) are fairly important and should go in before 2.6.11.
>
>1) retransmission handling -- window tracking needs to look at both
>   seq numbers in determining whether a retransmission has occurred
>
>   http://lists.netfilter.org/pipermail/netfilter-devel/2005-January/018241.html
>
>2) over-window handling -- window tracking should not adjust down
>   the maximum seq number which it thinks a client has received --
>   the client may disagree with this number
>
>   http://lists.netfilter.org/pipermail/netfilter-devel/2005-January/018278.html
>
>Patches attached below, comments welcomed.
>
I already have the retransmission handling patch queued, I'm just
a little behind with pushing it to Dave. I would like to hear
Jozsef's opinion before applying your second patch, he knows the
code much better than me. Jozsef, does the second patch look ok
to you ?

Regards
Patrick


>Phil
>
>
>  
>
>------------------------------------------------------------------------
>
>diff -ru linux-orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c linux-testdellfw/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
>--- linux-orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-01-28 17:48:10.620973992 -0500
>+++ linux-testdellfw/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-01-28 17:54:02.799434728 -0500
>@@ -622,7 +622,6 @@
> 	/* Ignore data over the right edge of the receiver's window. */
> 	if (after(end, sender->td_maxend) &&
> 	    before(seq, sender->td_maxend)) {
>-		end = sender->td_maxend;
> 		if (*index == TCP_FIN_SET)
> 			*index = TCP_ACK_SET;
> 	}
>@@ -691,9 +690,9 @@
> 			after(seq, sender->td_end - receiver->td_maxwin - 1) ?
> 			before(sack, receiver->td_end + 1) ?
> 			after(ack, receiver->td_end - MAXACKWINDOW(sender)) ? "BUG"
>-			: "ACK is under the lower bound (possibly overly delayed ACK)"
>-			: "ACK is over the upper bound (ACKed data has never seen yet)"
>-			: "SEQ is under the lower bound (retransmitted already ACKed data)"
>+			: "ACK is under the lower bound (possible overly delayed ACK)"
>+			: "ACK is over the upper bound (ACKed data not seen yet)"
>+			: "SEQ is under the lower bound (already ACKed data retransmitted)"
> 			: "SEQ is over the upper bound (over the window of the receiver)");
> 
> 		res = ip_ct_tcp_be_liberal && !tcph->rst;
>  
>
