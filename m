From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] MASQUERADE handling of device events
Date: Wed, 24 Nov 2004 14:37:34 +1100
Message-ID: <1101267454.6186.13.camel@localhost.localdomain>
References: <20041107181825.GA3522@linuxace.com>
	<1101005908.18919.11.camel@localhost.localdomain>
	<20041123211623.GA20289@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20041123211623.GA20289@linuxace.com>
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

On Tue, 2004-11-23 at 13:16 -0800, Phil Oester wrote:
> On Sun, Nov 21, 2004 at 01:58:28PM +1100, Rusty Russell wrote:
> > The MASQUERADE target use to destroy connections when an interface
> > went down.  We changed this to merely remove the ASSURED bit, and
> > destroy them if the same interface came up with a different IP
> > address.  Unfortunately, as Phil Oester pointed out, that code was
> > crap for PPP connections, since we (1) compared ifa_address instead of
> > ifa_local, (2) identified interfaces by ifindex, which increments as a
> > PPP device downs and ups, and (3) caused all connections to be flushed
> > when we added an IP address.
> > 
> > So that code was reverted after 2.6.10-rc2.
> > 
> > This code stores the interface name, rather than trying to use the
> > ifindex, and only deletes connections if *no* ifa_local on the
> > interface matches the connection, so simply adding a new IP address is
> > a NOOP.
> 
> But even using the interface name is unreliable.  Consider the user who
> uses multiple PPP connections.  Both go down at the same time, and
> come back with the 'old' ppp1 now named ppp0.

Sure, in which case the connections will be dropped, as they would be in
the naive case.  This entire idea is best-effort, like NAT itself 8)

I think it's worth trying, at least, but obviously the core team can
override me.

> Perhaps my original patch which special-cased ppp would be better?

Drawing a link between point-to-point and addresses being static is
wrong, IMHO.

Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
