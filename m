From: Luuk Paulussen <Luuk.Paulussen@alliedtelesis.co.nz>
Subject: Re: [PATCH] Add tcindex to conntrack and add netfilter
 target/matches
Date: Sun, 13 Dec 2015 23:00:15 +0000
Message-ID: <566DF87E.40608@alliedtelesis.co.nz>
References: <1449179951-26327-1-git-send-email-luuk.paulussen@alliedtelesis.co.nz>
 <1449179951-26327-2-git-send-email-luuk.paulussen@alliedtelesis.co.nz>
 <5664B698.8040904@alliedtelesis.co.nz>
 <20151206224522.GA27161@breakpoint.cc>
 <5664ECCC.1030104@alliedtelesis.co.nz> <5667EF49.8060707@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>,
	Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:48490 "EHLO
	gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbbLMXAa convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Dec 2015 18:00:30 -0500
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client did not present a certificate)
	by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 0D3D0806F6
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 12:00:24 +1300 (NZDT)
In-Reply-To: <5667EF49.8060707@iogearbox.net>
Content-Language: en-US
Content-ID: <56F1166445DE6D41B8E4A1FA32287A80@atlnz.lc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On 12/09/2015 10:07 PM, Daniel Borkmann wrote:
> On 12/07/2015 03:19 AM, Luuk Paulussen wrote:
>> On 12/07/2015 11:45 AM, Florian Westphal wrote:
>>> Luuk Paulussen <Luuk.Paulussen@alliedtelesis.co.nz> wrote:
>>>> Hi All,
>>>>
>>>> I'm still hoping for some feedback on this.  I have some userspace
>>>> patches around this as well, (to set/show the tc_index in the
>>>> connection, and to add the marking/matching rules in iptables), but 
>>>> I am
>>>> holding off on sending them until I know what people think of this
>>>> idea/implementation first.
>>> I can't say for sure since I don't know enough about tc.
>>>
>>> However, AFAICS tc_index seems to be something that should be internal
>>> to tc and not exposed/changeable via iptables.
>> tc_index is a mark that can be set by certain configurable ingress
>> schedulers (dsmark, GRED, ingress) for later classification via the
>> tcindex classifer.  This just adds an alternative mechanism for setting
>> this mark if those schedulers aren't being used.
>
> Fwiw, tc_index can be read/written by cls_bpf (and you can also apply 
> masks
> on that field if needed).
I've just been looking into this and it does seem like it might cover a 
small part of what we are trying to do, although misses the key part, 
which is to use connection tracking information to limit full processing 
to the first packet of a flow in each direction. I'm guessing that there 
isn't any bpf support for connection information?

One thing that isn't quite clear to me. Is it possible to use xt_bfp.c 
to set the tc_index field from netfilter?  If this is the case, then it 
does set a precedent
for being able to set this value outside of tc code (but sill misses the 
save/restore possibility).

Given that tc_index is simple metadata I'm guessing that filter 
performance over the tcindex classifier wouldn't be significantly better?

>> * dsmark sets the tc_index value based on the incoming DSCP value
>> * ingress sets the tc_index value based on other rules (e.g. mark set
>> via iptables)
>> * New code sets tc_index directly based on iptables classification or
>> restoring saved value.

I'm still looking for an overall idea around whether this patch has a 
chance of being accepted for the kernel.  It feels like none of the 
comments or proposed ideas have addressed the issues that the patch is 
addressing:
1. Save/restore functionality of mark/connmark can significantly 
increase performance for larger rule sets, so is desirable for 
performance reasons.
2. Insufficient space in skb nf mark and connection mark for all 
applications that might want to use it.
3. tc being one of the users of nf mark (via fw filter) has a logical 
alternative in the 16 bit tc_index field, which could be used without 
increasing SKB size.  This doesn't currently have a match/tag target in 
netfilter or an analogue in the connection for save/restore.  It does 
however have a pre-existing classifier in tc code.

So this patch adds tc_index field to the connection and 
match/tag/save/restore targets to netfilter, allowing marking packets 
for tc into this field and save/restore from the connection.