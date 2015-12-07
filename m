From: Luuk Paulussen <Luuk.Paulussen@alliedtelesis.co.nz>
Subject: Re: [PATCH] Add tcindex to conntrack and add netfilter
 target/matches
Date: Mon, 7 Dec 2015 04:24:48 +0000
Message-ID: <56650A0F.3040206@alliedtelesis.co.nz>
References: <1449179951-26327-1-git-send-email-luuk.paulussen@alliedtelesis.co.nz>
 <1449179951-26327-2-git-send-email-luuk.paulussen@alliedtelesis.co.nz>
 <5664B698.8040904@alliedtelesis.co.nz>
 <20151206224522.GA27161@breakpoint.cc>
 <5664ECCC.1030104@alliedtelesis.co.nz> <20151207030550.GA29690@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	Kyeong Yoo <Kyeong.Yoo@alliedtelesis.co.nz>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:54850 "EHLO
	gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbbLGEYz convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Dec 2015 23:24:55 -0500
In-Reply-To: <20151207030550.GA29690@breakpoint.cc>
Content-Language: en-US
Content-ID: <7FFD3AB8D528BF4891E0ED69514324E2@atlnz.lc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On 12/07/2015 04:05 PM, Florian Westphal wrote:
> Luuk Paulussen <Luuk.Paulussen@alliedtelesis.co.nz> wrote:
>> On 12/07/2015 11:45 AM, Florian Westphal wrote:
>>> Why not extend cls_flow to allow matching ctmark directly via tc
>>> filters instead of requiring conntrack->foo copy to skb->foo?
>> The flow classifier doesn't have support for masks on the mark (or other
>> fields), so doesn't provide enough control to differentiate between
>> outgoing/incoming traffic.
> Hmm, add it?  Another alternative would be to extend em_meta with
> conntrack collectors.
>
> Could also add ability to match on conntrack direction.
I think that the flow classifier is mainly designed for leaf classes.  
It isn't really designed to work with more complex or hierarchical 
qdiscs as it just maps/hashes to a minor class number, so I don't think 
we can use it.
As per other comments further down, we'd prefer to be have already 
tagged the packet once we get to tc, which is already fully supported 
with fw/tcindex classifiers.
>> Also, do all packets have an associated
>> connection?
> No, but its pretty much the same as skb->mark == 0, no?
> (i.e. you could still fall back to some other clssification method?)
Our hope/plan is to make the classification decision using xtables (fast 
path falling back to slow path), which breaks if we have to reclassify 
at tc stage.
>
>>> We also have -j CLASSIFY to set skb->priority and at least cls_flow
>>> seems to be able to match on that (did not test it).
>> The functionality we are trying to achieve (for performance reasons) is
>> as follows:
> Thanks for explaining.
>
>> 1st packet in flow in each direction (slow path):
> "each direction?"  Does that mean that you might have two distinct
> results based on wheter skb is incoming or outgoing?
> Or does it mean "conntrack direction"?
>
> How is that handled in the fastpath? ctmark splitted in two halves + masking?
Both actually
  - mark is split into two halves with masking to differentiate based on 
conntrack direction, and then we also have to account for 
incoming/outgoing by installing two rules to match either conntrack 
direction at tc stage.  Generally traffic control is more relevant going 
out onto a WAN link than coming back in, so the rules are different in 
the two directions, but certain flows might originate from the WAN side.
>
> What about:
>
> -m connlabel ! --label classify_in -m conntrack --ctdir ORIGINAL -j IN_CLASSIFIERS
> -m connlabel ! --label classify_rep -m conntrack --ctdir REPLY -j REP_CLASSIFIERS
> (restore nfmark based on connmark here if needed)
>
> This means three tests & no repeat of "slowpath" after 1st packet even
> if ctmark remains at 0.
This could be a useful idea.  It does break in the (reasonably 
infrequent) case where the configuration is changed and the connection 
still exists.  Our plan in that case was to set all the connection marks 
back to 0 rather than deleting the connections.
>
> (Alternative is to disallow a 0 ctmark and just use -m connmark --mark 0
>   -j SLOWAPATH)
This alternative is what we are currently doing. (Non-matching packets 
are marked with a default mark)
>
>> - Go through list of classification rules and set something (packet
>> class) in a connection mark (with a mask) for traffic on this flow in
>> this direction.
> -A IN_CLASSIFIERS --label classify_in --set
> -A IN_CLASSIFIERS -m $magic -j CONNMARK ... 42/$mask
> /* more slowpath rules */
>
> To reduce rule traversal you can do this:
> -N CLASS_FOO
> -A CLASS_FOO -j CONNMARK ...
> -A IN_CLASSIFIERS $magic --goto CLASS_FOO
>
> Obviously that requires custom chain for each class, but it means
> slowpath chain returns early once a decision was made.
We are using techniques like this to reduce rule traversal.  We have a 
reasonably good grasp of what is needed in terms of rules, we just need 
more space...
>> Other packets in flow in this direction (fast path):
>> - Restore the part of the mark for this direction from connection and go
>> to egress where tc rules can do correct traffic control based on the
>> restored mark.
> If we could read ctmark from tc classifiers it seems this would not be
> needed since you could just classify based on the conntrack mark with
> fallback for skbs without conntrack entry (you'd also need to handle
> this case with the proposed "restore nfmark" scheme since the nfmark
> would be 0 (since nothing could be restored).
The idea is that if the fast path fails, the packet falls back to the 
slow path and is marked  (as well as the connection being updated if 
appropriate).  The goal is that no packet gets through the netfilter 
processing without some kind of mark being set. Otherwise you end up 
having to do the full classification in two places (xtables and tc) for 
packets with no connection.

The key point here is that the only reason that we are proposing this 
change is that the existing ct_mark doesn't have enough space left 
alongside other features, so using CONNMARK isn't an option (which is 
where CONNTCINDEX comes in).
