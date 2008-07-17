From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Conntrack Events Performance - Multipart Messages?
Date: Thu, 17 Jul 2008 12:03:06 +0200
Message-ID: <487F18DA.7030208@netfilter.org>
References: <487E24FC.60700@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52765 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754725AbYGQKDN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jul 2008 06:03:13 -0400
In-Reply-To: <487E24FC.60700@gmx.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
> I am writing a network application for a genuine wireless router (266Mhz
> IXP4XX). I am capturing packets with ULOG and need connection tracking.
> For performance reasons I planned to use connection tracking events
> (NEW/DESTROY) to avoid doing the same work twice.

Did you write your own application to handle ctevents and ULOG messages?
Are you using any library? What does your application do?

We now have the berkeley socket filtering facilities for netlink, you
may use it to filter only the events that you need. I have a patch here
for libnetfilter_conntrack that introduces a high-level API to
autogenerate simple BSF code for filtering. As soon as I finish testing
it, I'll commit it.

Also, you may periodically dump the connection tracking table (polling),
but, of course, this depends on the nature of your application. Assuming
that your application is a logger, this is not a choice as you'll lose
information.

> In a high load test case I stress the router with UDP packets with
> random source ports (1000B payload, 1800pps). CPU usage is 100%, 10% of
> packets and 80% ctevents are dropped. If I disable ctevents, the CPU
> usage is just 24% and no packet drops occur.

I have a similar testbed here. You did not mention the threshold that
you're using in ULOG. If you provide more information on your
application I'll try to reproduce those numbers.

> My application is not very heavy and I expect most of the ctevent
> overhead to be caused by passing events from kernel to user space. I
> expect that performance could be increased by using multipart messages
> for ctevents like it is done in ULOG/NFLOG.
> 
> Do you share my opinion, that multipart messages would lead to
> significant performance improvements? (Actually, I doubt that I will be
> more efficient than performing connection tracking in user space)

Yes, I think that batching could help here.

> Do you think introducing multipart messages for connection tracking
> events is feasible without breaking existing applications? Maybe with a
> default setting of 1 bundled events, which can be increased by a
> function call?

AFAIK, libnfnetlink and other netlink-based libraries should handle the
multipart messages appropriately so that should not be a problem.

> Is someone intending to implement multipart messages for ctevents? ;-)

The problem here is that batching should be a per-socket parameter. We
will not accept a patch that changes the behaviour for all the ctevent
users. And I don't see an obvious way to do this now.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
