From: Simon Kirby <sim@netnation.com>
Subject: Re: iptables STILL incorrectly using TCP packet contents without
	checking header!
Date: Thu, 31 Mar 2005 16:03:40 -0800
Message-ID: <20050401000340.GA2275@netnation.com>
References: <20050331185732.GA20249@netnation.com>
	<424C57EB.7020308@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
Content-Disposition: inline
In-Reply-To: <424C57EB.7020308@outerspace.dyndns.org>
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

On Thu, Mar 31, 2005 at 11:04:59PM +0300, Jonas Berlin wrote:

> What does it do if it mismatches? Match state "INVALID" ? Or not match any
> state at all?

Yes, state INVALID.

> If (and only if) the "state" match doesn't let us match the packet with
> f.ex. the INVALID state, how would we allow the user to match these packets?
> Maybe a --verify-checksum could be added to -p tcp and -p udp, which would
> maybe mostly be used inverted?
>...
> But what will be done in case REJECT notices it's not valid? Return
> IPT_CONTINUE? If that, then at least the packet & byte counters will
> possibly be misleading - aren't they incremented regardless of the return
> value of the target?

Ahh, right, the details... always in the way!

I was thinking that REJECT should DROP in any case where it is unable to
respond due to bad checksums, etc., but where the match side of the rule
did match.  It would be very bad to skip the rule in this case and
incorrect, I would suspsect, to do anything else.

Others have mentioned that a "is corrupted?" match option would be useful
for this and other reasons.  It is not sufficient to depend on the state
module for this feature because there are situations where using stateful
tracking is not possible (eg: BGP routers, as in my case).  Maybe
something like this:

	iptables -A FORWARD -m checksum ! --checksum ip -J DROP
	iptables -A FORWARD -p tcp -m checksum ! --checksum tcp -J DROP

(Grr, the "-m module --module-foo" syntax is annoyingly redundant.)

As for the matching side of things, let's see... Is it ever bad to
skip a rule that with otherwise block a corrupted packet?  For instance:

	iptables -A FORWARD -d 1.2.3.4 --dport 22 -j REJECT
	iptables -P FORWARD ACCEPT

If checksumming were implemented in this case and the rule no longer
matched a corrupted packet, the packet would still be forwarded. 
However, the end point should just discard it.  I don't think this
will introduce any new problems except possibly for the ability to
fling loads of corrupted packets (DoS) past firewalls if TCP is
blocked with something like:

	iptables -A FORWARD -p tcp --dport 0:65535 -j REJECT

This is probably a rare case, but probably worth noting.

Is there anything else?

Simon-
