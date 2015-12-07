From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] Add tcindex to conntrack and add netfilter target/matches
Date: Mon, 7 Dec 2015 04:05:50 +0100
Message-ID: <20151207030550.GA29690@breakpoint.cc>
References: <1449179951-26327-1-git-send-email-luuk.paulussen@alliedtelesis.co.nz>
 <1449179951-26327-2-git-send-email-luuk.paulussen@alliedtelesis.co.nz>
 <5664B698.8040904@alliedtelesis.co.nz>
 <20151206224522.GA27161@breakpoint.cc>
 <5664ECCC.1030104@alliedtelesis.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Luuk Paulussen <Luuk.Paulussen@alliedtelesis.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36364 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755067AbbLGDFy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Dec 2015 22:05:54 -0500
Content-Disposition: inline
In-Reply-To: <5664ECCC.1030104@alliedtelesis.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Luuk Paulussen <Luuk.Paulussen@alliedtelesis.co.nz> wrote:
> On 12/07/2015 11:45 AM, Florian Westphal wrote:
> > Why not extend cls_flow to allow matching ctmark directly via tc
> > filters instead of requiring conntrack->foo copy to skb->foo?

> The flow classifier doesn't have support for masks on the mark (or other 
> fields), so doesn't provide enough control to differentiate between 
> outgoing/incoming traffic.

Hmm, add it?  Another alternative would be to extend em_meta with
conntrack collectors.

Could also add ability to match on conntrack direction.

> Also, do all packets have an associated
> connection?

No, but its pretty much the same as skb->mark == 0, no?
(i.e. you could still fall back to some other clssification method?)

> > We also have -j CLASSIFY to set skb->priority and at least cls_flow
> > seems to be able to match on that (did not test it).
> The functionality we are trying to achieve (for performance reasons) is 
> as follows:

Thanks for explaining.

> 1st packet in flow in each direction (slow path):

"each direction?"  Does that mean that you might have two distinct
results based on wheter skb is incoming or outgoing?
Or does it mean "conntrack direction"?

How is that handled in the fastpath? ctmark splitted in two halves + masking?

What about:

-m connlabel ! --label classify_in -m conntrack --ctdir ORIGINAL -j IN_CLASSIFIERS
-m connlabel ! --label classify_rep -m conntrack --ctdir REPLY -j REP_CLASSIFIERS
(restore nfmark based on connmark here if needed)

This means three tests & no repeat of "slowpath" after 1st packet even
if ctmark remains at 0.

(Alternative is to disallow a 0 ctmark and just use -m connmark --mark 0
 -j SLOWAPATH)

> - Go through list of classification rules and set something (packet 
> class) in a connection mark (with a mask) for traffic on this flow in 
> this direction.

-A IN_CLASSIFIERS --label classify_in --set
-A IN_CLASSIFIERS -m $magic -j CONNMARK ... 42/$mask
/* more slowpath rules */

To reduce rule traversal you can do this:
-N CLASS_FOO
-A CLASS_FOO -j CONNMARK ...
-A IN_CLASSIFIERS $magic --goto CLASS_FOO

Obviously that requires custom chain for each class, but it means
slowpath chain returns early once a decision was made.

> Other packets in flow in this direction (fast path):
> - Restore the part of the mark for this direction from connection and go 
> to egress where tc rules can do correct traffic control based on the 
> restored mark.

If we could read ctmark from tc classifiers it seems this would not be
needed since you could just classify based on the conntrack mark with
fallback for skbs without conntrack entry (you'd also need to handle
this case with the proposed "restore nfmark" scheme since the nfmark
would be 0 (since nothing could be restored).

> I think that CLASSIFY can only really go through the slow path.

Right, xtables architecture limitation :-(
