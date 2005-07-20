From: "David S. Miller" <davem@davemloft.net>
Subject: Re: SACK out of window segments?
Date: Wed, 20 Jul 2005 12:26:52 -0700 (PDT)
Message-ID: <20050720.122652.28782810.davem@davemloft.net>
References: <Pine.LNX.4.58.0507201213110.25054@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kadlec@blackhole.kfki.hu
In-Reply-To: <Pine.LNX.4.58.0507201213110.25054@blackhole.kfki.hu>
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

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date: Wed, 20 Jul 2005 12:34:02 +0200 (CEST)

> https://lists.netfilter.org/pipermail/netfilter-devel/2005-July/020292.html
 ...
> It seems that at least Linux 2.4.25 accepts and (S)ACKs segments which
> otherwise looks to be out of window ones. In order to cope with that I had
> to add code to the TCP connection tracking part of netfilter.
> 
> The question is wether that was a SACK bug in 2.4.25? Or there's something
> in the RFCs we overlook and what looks like a violation is actually an RFC
> conformant feature?

What is running on the sender in that trace in the quoted URL above?

That last packet is definitely out of window, from the trace's point
of view, but I'm very suspicious that any stack would do that,
especially Linux.

I'm even more suspicious that a zero window scale is being used in
both directions, indicating that perhaps something in the middle might
be zeroing out the window scale and re-adjusting the advertised
windows on us.  I hope you can verify that, to the best of your
knowledge, this is not occuring.

As a receiver, we never even get to the SACK code if the packet is
truly out of window.  It is protected by this test in
tcp_input.c:tcp_data_queue().

	/* Out of window. F.e. zero window probe. */
	if (!before(TCP_SKB_CB(skb)->seq, tp->rcv_nxt + tcp_receive_window(tp)))
		goto out_of_window;

tcp_receive_window() expands to:

static __inline__ u32 tcp_receive_window(const struct tcp_sock *tp)
{
	s32 win = tp->rcv_wup + tp->rcv_wnd - tp->rcv_nxt;

	if (win < 0)
		win = 0;
	return (u32) win;
}

So that last packet in the trace should have been caught by the
tests above and thus ignored, and the receiver should have emitted
an immediate ACK (in hopes to get the sender's idea of the window
correct again).

I keep coming back to the idea that something is mucking with the
packet contents, and thus the end system is seeing something
different from the trace.

The only reliable way to analyze these kinds of things is to get
a trace on both sides of the connection, which I realize is often
entirely infeasible.

There are so many ugly black boxes out there messing with sequence
numbers and window scaling options, such that a one-sided trace
is truly meaningless for debugging these days.

In fact, something changing the sequence numbers is also the only
logical explanation for the connection "hanging" after dropping that
packet.  The sender should retransmit and the connection should get
going again perfectly fine after dropping that supposedly
out-of-window frame.
