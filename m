From: Luuk Paulussen <Luuk.Paulussen@alliedtelesis.co.nz>
Subject: Re: [PATCH] Add tcindex to conntrack and add netfilter
 target/matches
Date: Mon, 7 Dec 2015 02:19:57 +0000
Message-ID: <5664ECCC.1030104@alliedtelesis.co.nz>
References: <1449179951-26327-1-git-send-email-luuk.paulussen@alliedtelesis.co.nz>
 <1449179951-26327-2-git-send-email-luuk.paulussen@alliedtelesis.co.nz>
 <5664B698.8040904@alliedtelesis.co.nz> <20151206224522.GA27161@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:54305 "EHLO
	gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbbLGCUI convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Dec 2015 21:20:08 -0500
In-Reply-To: <20151206224522.GA27161@breakpoint.cc>
Content-Language: en-US
Content-ID: <4E39E8A08547CC4081D5FC08FC543998@atlnz.lc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On 12/07/2015 11:45 AM, Florian Westphal wrote:
> Luuk Paulussen <Luuk.Paulussen@alliedtelesis.co.nz> wrote:
>> Hi All,
>>
>> I'm still hoping for some feedback on this.  I have some userspace
>> patches around this as well, (to set/show the tc_index in the
>> connection, and to add the marking/matching rules in iptables), but I am
>> holding off on sending them until I know what people think of this
>> idea/implementation first.
> I can't say for sure since I don't know enough about tc.
>
> However, AFAICS tc_index seems to be something that should be internal
> to tc and not exposed/changeable via iptables.
tc_index is a mark that can be set by certain configurable ingress 
schedulers (dsmark, GRED, ingress) for later classification via the 
tcindex classifer.  This just adds an alternative mechanism for setting 
this mark if those schedulers aren't being used.
* dsmark sets the tc_index value based on the incoming DSCP value
* ingress sets the tc_index value based on other rules (e.g. mark set 
via iptables)
* New code sets tc_index directly based on iptables classification or 
restoring saved value.
>
>> Basically it allows 16 bits of marking in skb and connmark for traffic
>> control purposes using an existing field in the skb.
> Why not extend cls_flow to allow matching ctmark directly via tc
> filters instead of requiring conntrack->foo copy to skb->foo?
The flow classifier doesn't have support for masks on the mark (or other 
fields), so doesn't provide enough control to differentiate between 
outgoing/incoming traffic.  Also, do all packets have an associated 
connection? if we restore the connection mark to the packet mark with a 
mask, then tc will only see the marking that we want it to see, and 
packets that don't have an associated connection will be matched to 
other rules.  Also, the tc_index and fw filters already exist for the 
skb fields.
>
> We also have -j CLASSIFY to set skb->priority and at least cls_flow
> seems to be able to match on that (did not test it).
The functionality we are trying to achieve (for performance reasons) is 
as follows:
1st packet in flow in each direction (slow path):
- Go through list of classification rules and set something (packet 
class) in a connection mark (with a mask) for traffic on this flow in 
this direction.
Other packets in flow in this direction (fast path):
- Restore the part of the mark for this direction from connection and go 
to egress where tc rules can do correct traffic control based on the 
restored mark.

I think that CLASSIFY can only really go through the slow path.

We also want to make use of hierarchical qdiscs, which requires that the 
packet steps through levels of qdiscs, being filtered/classified to the 
correct class at each level, which I think means that priority field 
isn't appropriate, as it might change at different steps.