From: Florian Westphal <fw@strlen.de>
Subject: Re: NFQUEUE "fail-open" only open to queue limit and not receive
 buffer limit
Date: Fri, 11 Mar 2016 01:14:21 +0100
Message-ID: <20160311001421.GA6620@breakpoint.cc>
References: <7966959fae8e4dd5b13ba4d607ac2db4@XCH-RTP-014.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Yigal Reiss (yreiss)" <yreiss@cisco.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45279 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932844AbcCKAOY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2016 19:14:24 -0500
Content-Disposition: inline
In-Reply-To: <7966959fae8e4dd5b13ba4d607ac2db4@XCH-RTP-014.cisco.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yigal Reiss (yreiss) <yreiss@cisco.com> wrote:
> Currently the "fail-open" feature in NFQUEUE passes packets only in the case where the limit comes from the queue size (queue->queue_total >= queue->queue_maxlen).

Right.

> In case where the qlen is high and the load is high, packets will be dropped as result of crossing the socket's receive buffer size. This will eventually be reported through the proc file as 'user dropped' (don't know why).

It should also be reported to the application via -ENOBUFS (see
netlink_overrun() in net/netlink.c .

> From user perspective IMO the user doesn't care if the packet cannot be passed as a result of a queue size or socket receive buffer size.
> This is quite arbitrary and depends on average packet size.

Yes, it depends on packet size and time until verdict is sent.

> Actually the result may be opposite to what the user desired if he raises the qlen wishing to increase availability but in fact causing more packets be dropped
> due to receive buffer limitations.

If userspace bumps qlen it should also increase its sk buffer size
accordingly.  (see for instance nfnl_rcvbufsiz() in libnfnetlink).

> I suggest implementing the same behavior (fail open) also for the case where nfnetlink_unicast() fails (which usually would be due to receive buffer limit).
> 
> Does this make sense?

Even when qlen is near-full sk rmem could be low, and vice versa.

I agree that it would be nice to also implement failopen reinject.

> If so, what would be the recommended way of achieving that?
> The problem is that skb is being freed at netlink level (netlink_attachskb).
> So it's either copying the skb each time before calling nfnetlink_unicast()
> (wasteful) or passing a flag all the way to indicate that freeing is not desired (lots of changes and involves also core netlink). Any other suggestions?

I think it would be good to consider auditing the kernel and see if its
feasible to switch to a 'skb must be free'd by caller on error' model.

This doesn't necessarily mean changing netlink_unicast(), it could for
instance be resolved by adding netlink_unicast_try (you might want
to figure out a better name...) that doesn't free on error and then
make netlink_unicast a short-hand wrapper for the latter to keep
the current fire-and-forget sematics around.

(Alternatively, use your 'flag' method, I'm not sure what will
 be 'nicer' or less intrusive).
