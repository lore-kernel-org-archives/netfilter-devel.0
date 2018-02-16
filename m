From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH RFC 0/4] net: add bpfilter
Date: Fri, 16 Feb 2018 21:44:01 +0100
Message-ID: <9182f7b2-da9c-765e-028f-8b9e5c5d4716@iogearbox.net>
References: <20180216134023.15536-1-daniel@iogearbox.net>
 <20180216145727.GC32618@breakpoint.cc> <20180216161408.GA3776@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, alexei.starovoitov@gmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:44361 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750851AbeBPUoF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Feb 2018 15:44:05 -0500
In-Reply-To: <20180216161408.GA3776@breakpoint.cc>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On 02/16/2018 05:14 PM, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
>> Daniel Borkmann <daniel@iogearbox.net> wrote:
>> Several questions spinning at the moment, I will probably come up with
>> more:
> 
> ... and here there are some more ...
> 
> One of the many pain points of xtables design is the assumption of 'used
> only by sysadmin'.
> 
> This has not been true for a very long time, so by now iptables has
> this userspace lock (yes, its fugly workaround) to serialize concurrent
> iptables invocations in userspace.
> 
> AFAIU the translate-in-userspace design now brings back the old problem
> of different tools overwriting each others iptables rules.

Right, so the behavior would need to be adapted to be exactly the same,
given all the requests go into kernel space first via the usual uapis,
I don't think there would be anything in the way of keeping that as is.

> Another question -- am i correct in that each rule manipulation would
> incur a 'recompilation'?  Or are there different mini programs chained
> together?

Right now in the PoC yes, basically it regenerates the program on the fly
in gen.c when walking the struct bpfilter_ipt_ip's and appends the entries
to the program, but it doesn't have to be that way. There are multiple
options to allow for a partial code generation, e.g. via chaining tail
call arrays or directly via BPF to BPF calls eventually, there would be
few changes on BPF side needed, but it can be done; there could additionally
be various optimizations passes during code generation phase performed
while keeping given constraints in order to speed up getting to a verdict.

> One of the nftables advantages is that (since rule representation in
> kernel is black-box from userspace point of view) is that the kernel
> can announce add/delete of rules or elements from nftables sets.
> 
> Any particular reason why translating iptables rather than nftables
> (it should be possible to monitor the nftables changes that are
>  announced by kernel and act on those)?

Yeah, correct, this should be possible as well. We started out with the
iptables part in the demo as the majority of bigger infrastructure projects
all still rely heavily on it (e.g. docker, k8s to just name two big ones).
Usually they have their requests to iptables baked into their code directly
which probably won't change any time soon, so thought was that they could
benefit initially from it once there would be sufficient coverage.

Thanks,
Daniel
