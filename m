From: Eddi Linder <eddi@guardicore.com>
Subject: Re: REOUTE target extenstion
Date: Fri, 29 May 2015 15:02:41 +0300
Message-ID: <CADgXnSMdWdbtBJ_0RxfUm0sFcXApBbEtUUSFdM+OKm8qrO7-sQ@mail.gmail.com>
References: <CADgXnSPNQM2xq_pAs72ddDCX-8DCx=J6mr--J_jPdMUcQS-PZw@mail.gmail.com>
	<20150527113746.GA23992@breakpoint.cc>
	<CADgXnSPkPdWdWcNJHrcv_9=oomWsE4ZfzoJZ3CTur=zW5LY9cQ@mail.gmail.com>
	<20150527121130.GC23992@breakpoint.cc>
	<20150527124037.GA19766@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	jengelh@inai.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:33308 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbbE2MCm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 May 2015 08:02:42 -0400
Received: by igbpi8 with SMTP id pi8so12735692igb.0
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2015 05:02:41 -0700 (PDT)
In-Reply-To: <20150527124037.GA19766@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The matching will be L3 based, but the copy can be of all the packet,
I'd like to simply change the dest device of it.
I can match by source device, I don't see why it's not logical to
target a device as an action.
And turning to "tc" is a nice alternative, and many things that can be
done in *tables can be done in "tc", but I'd like to stay focused on
netfilters as it is more flexible with the stage I insert my rules in
the packet's flow.

Pablo, in this case I need it to work not only on bridged devices, so
ebtables is not a solution for me.

On Wed, May 27, 2015 at 3:40 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, May 27, 2015 at 02:11:30PM +0200, Florian Westphal wrote:
>> Eddi Linder <eddi@guardicore.com> wrote:
>> > TEE is for gateway redirections, which means the redirected device has
>> > to have a configured ip, and to be reachable from the original device.
>>
>> That makes no sense to me.  The to-redirected device always needs to be
>> reachable.  And iptables is L3 and upwards, so I don't see how 1:1
>> copying would fit in here.
>>
>> > Florian, I didn't find the mirror target in the mainline documentation or code.
>>
>> I meant the tc action:
>>
>> tc filter add dev eth0 parent $parent protocol ip [..] action mirred egress redirect dev eth1
>>
>> > REROUTE redirection is more like the openvswitch output action, copy
>> > the packet from one device into another.
>>
>> Sorry, but my feeling is that this is out of scope for iptables.
>
> Agreed.
>
> There is an incomplete patch to add TEE support to nf_tables bridge
> family. You only have to specify the destination device as Eddi needs.
>
> Another alternative is to add this TEE support to ebtables, which is
> where this belongs.
