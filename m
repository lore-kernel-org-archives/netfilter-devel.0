From: Patrick Schaaf <bof@bof.de>
Subject: Re: ip_conntrack performance issues - also semantic issues
Date: Sun, 19 Jan 2003 10:16:57 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030119091656.GG12401@oknodo.bof.de>
References: <20030118232752.26497.32589.Mailman@kashyyyk> <15914.20503.476455.344137@isis.cs3-inc.com> <20030119075102.GF12401@oknodo.bof.de> <15914.25470.189261.168220@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-netf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15914.25470.189261.168220@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, Jan 19, 2003 at 12:36:14AM -0800, Don Cohen wrote:
>  > I'll do so. Your point about the post-dequeueing hook warrants
>  > thinking about by the masses :)
> The reason I didn't is that I already suggested this to the list.

I'm of the opinion that good points warrant occasional repeating,
until they permeated enough skulls to be resolved once and for all.
Without the repetition, I wouldn't have thought about some of
the things I write now.

I'll again put this reply onto the list, see new point 3), below.

As you indicate you are not fully familiar with it, here's the story
about the "allocate early, hash late" approach which is in the current
code. It's really pretty simple. See net/ipv4/netfilter/ip_conntrack_core.c:

	- init_conntrack() allocates a new conntrack, triggered
	  by resolve_normal_ct(), which in turn is called by
	  ip_conntrack_in() - the PREROUTING hook function,
	  sitting there before all other functions (mangle/nat/filter).
	  There are no other call chains.
	  The new conntrack is NOT put into the hashes, but only
	  referenced by the skbuff (the packet under inspection).
	  The state match, NAT, etc. all use this skbuff reference!
	- __ip_conntrack_confirm() puts the conntrack of an skbuff
	  that passed through to POSTROUTING, into the hashes.
	  This function is wrapped in a 'static inline' in
	  include/linux/netfilter_ipv4/ip_conntrack_core.h,
	  called ip_conntrack_confirm(). For normal iptables
	  operation, this in turn is called from exactly
	  one place, ip_confirm() in net/ipv4/ip_conntrack_standalone.c.
	  That ip_confirm(), in turn, is the last LOCAL_IN hook
	  function, and (indirectly through ip_refrag()) the last
	  POSTROUTING hook function.

Point 2), i.e. your "put it after egress dequeue" proposal, would
mean delaying the confirm operation now done in ip_refrag(). A new
hook in the core network stack, called after egress dequeueing,
would again call ip_confirm(), as in the LOCAL_IN case.

Hmm, here's a point 3): in the LOCAL_IN case, the incoming packet may
be an UDP packet to a nonexisting local port.  This packet will be
dropped by the UDP bind hash lookup, but that comes AFTER the
LOCAL_IN hook, so there will be a conntrack remaining (with
30 seconds timeout, IIRC.)  So, the proposed after-egress-dequeue hook,
should also be called from the local delivery code, after real user level
interest has been checked.

>  > 1) that a NEW conntrack need not be allocated in full.
> I guess you're saying that the allocation takes a significant amount
> of time, entering into hash is another chunk, and the first part is
> done at prerouting.

I'm pretty sure that the allocation is the main cost, putting into
the hashes is not performance critical per se (if the lists are short). 

> In which case I agree allocation should be delayed.  But of course
> this means that various code has to be changed to expect new
> connections to be unallocated.

This may come at a cost for the normal case. In the normal case,
the allocation cost _has_ to be payed (or we wouldn't load
ip_conntrack), and the constant per-packet checking would
be pure overhead.

For filtered DoS packets not belonging to any connection, it would
certainly be a significant saving.

[BIG SNIP]

> I don't know of any, but for such protocols I guess the right thing
> would be to allocate enough at arrival of the first packet to
> recognize the second packet on its arrival, etc.

This is already done, in a sense. The really large NAT pieces are
kept outside the main ip_conntrack structure, allocated on demand.
As far as I know the prococol helpers operate (or could operate)
the same way.

Keep the "equal for all" conntracking structure simple. BTW, there's
still 10-15% cruft there which could be removed.

> A borderline case - even tcp does allow, e.g., a syn followed by a
> repeat of the syn if not answered promptly.  But in that case both
> can be classified as new.  Only in the second phase it's important
> to recognize that the second one is a repeat of the first.

In the current ip_conntrack_confirm() implementation, when that
happens, the second packet is DROPped, and its conntrack freed
shortly thereafter. This happens whenever ip_conntrack_confirm()
finds one or the other direction of the connection in the hashes.

I think that's about the sanest thing one can do, realizing that
before that point, we potentially set up conflicting NAT information
for one and the same end-user TCP connection. Letting both progress,
is a sure way to desaster. With the given approach, there's a chance
for everything to just work.

best regards
  Patrick
