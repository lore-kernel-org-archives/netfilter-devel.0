From: "David S. Miller" <davem@davemloft.net>
Subject: Re: TCP window tracking has bad side effects
Date: Fri, 10 Dec 2004 12:32:52 -0800
Message-ID: <20041210123252.6b2b82ed.davem@davemloft.net>
References: <20041201110253.GA9536@suse.de>
	<Pine.LNX.4.58.0412011308520.27175@blackhole.kfki.hu>
	<20041201153903.GA16807@suse.de>
	<Pine.LNX.4.58.0412030942320.30157@blackhole.kfki.hu>
	<Pine.LNX.4.58.0412060934050.5880@blackhole.kfki.hu>
	<20041209162656.GA9569@suse.de>
	<Pine.LNX.4.58.0412101052450.14449@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, ludwig.nussel@suse.de
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0412101052450.14449@blackhole.kfki.hu>
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

On Fri, 10 Dec 2004 11:03:29 +0100 (CET)
Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:

> Hi Ludwing,
> 
> On Thu, 9 Dec 2004, Ludwig Nussel wrote:
> 
> > Seems to work. The client machine no longer drops the packet and
> > properly sends RST.
> 
> Thank you for the bug and test reports. Attached is the patch for kernel
> inclusion by Dave: Patrick rewived the previous one and noted that a
> condition was errorneously dropped - it's back now and a typo in logging
> is fixed as well. If you run the previous code on a production machine,
> please replace it with the new one.

Jozsef, btw, can I ask you to stop using whatever patch generating
tool you use that removes trailing spaces?  It makes it so that I have
to apply your patches by hand.

For example:

> @@ -552,8 +552,8 @@
>  			 * Both sides must send the Window Scale option
>  			 * to enable window scaling in either direction.
>  			 */
> -			if (!(sender->flags & IP_CT_TCP_STATE_FLAG_WINDOW_SCALE
> -			      && receiver->flags & IP_CT_TCP_STATE_FLAG_WINDOW_SCALE))
> +			if (!(sender->flags & IP_CT_TCP_FLAG_WINDOW_SCALE
> +			      && receiver->flags & IP_CT_TCP_FLAG_WINDOW_SCALE))
>  				sender->td_scale =
>  				receiver->td_scale = 0;
>  		} else {

In the sources, there is a space at the end of the line
with the "sender->td_scale =" assignment statement.  Yet
in your patch, it is not there.

Same thing here:

> @@ -876,7 +880,7 @@
>  		WRITE_UNLOCK(&tcp_lock);
>  		if (LOG_INVALID(IPPROTO_TCP))
>  			nf_log_packet(PF_INET, 0, skb, NULL, NULL,
> -				  "ip_ct_tcp: invalid SYN (ignored) ");
> +				  "ip_ct_tcp: invalid packet ignored ");
>  		return NF_ACCEPT;
>  	case TCP_CONNTRACK_MAX:
>  		/* Invalid packet */

The "nf_log_packet(..." line should have a trailing space,
yet you are patching against a line that does not have it.

And finally it occurs a third time in this hunk.

> @@ -901,11 +905,12 @@
>  		break;
>  	case TCP_CONNTRACK_CLOSE:
>  		if (index == TCP_RST_SET
> -		    && test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
> -		    && conntrack->proto.tcp.last_index <= TCP_SYNACK_SET
> +		    && ((test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
> +		         && conntrack->proto.tcp.last_index <= TCP_SYNACK_SET)
> +		        || conntrack->proto.tcp.last_index == TCP_ACK_SET)
>  		    && after(ntohl(th->ack_seq),
>  		    	     conntrack->proto.tcp.last_seq)) {
> -			/* Ignore RST closing down invalid SYN
> +			/* Ignore RST closing down invalid SYN or ACK
>  			   we had let trough. */
>  		    	WRITE_UNLOCK(&tcp_lock);
>  			if (LOG_INVALID(IPPROTO_TCP))

The line with the "/* Ignore ..." comment should have a trailing
space, yet it does not in what your patch is against.

I've read recently that one of the commonly used patch
generating tools removes the training spaces.  But whatever
it is, please stop doing this :-)
