From: Andreas Schultz <aschultz@tpip.net>
Subject: Re: nftables queue target aborts rules processing unconditionally
Date: Fri, 3 Mar 2017 17:24:40 +0100 (CET)
Message-ID: <337978493.287220.1488558280660.JavaMail.zimbra@tpip.net>
References: <1942735443.286636.1488553299817.JavaMail.zimbra@tpip.net> <20170303154124.GH29213@breakpoint.cc> <323159116.287095.1488556655720.JavaMail.zimbra@tpip.net> <20170303160149.GI29213@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpip.net ([92.43.49.48]:34432 "EHLO mail.tpip.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751584AbdCCQYp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2017 11:24:45 -0500
In-Reply-To: <20170303160149.GI29213@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

----- On Mar 3, 2017, at 5:01 PM, Florian Westphal fw@strlen.de wrote:

> Andreas Schultz <aschultz@tpip.net> wrote:
>> ok, somewhat unexpected (or rather undocumented), but I can live
>> with that.
>> 
>> I've now experimented with NF_REPEAT to achieve something similar.
>> Can I assume that NF_REPEAT should restart the current "netfilter hook*?
> 
> Yes.
> 
>> e.g. when we are somewhere in FILTER FORWARD, it will restart with the
>> first rule of that hook?
> 
> It restarts the hook, yes.
> 
>> My experiments show that this works with nft when I don't modify the
>> ruleset. However, when I modify the ruleset before returning NF_REPEAT,
>> the packet will skip the current hook completely.
> 
> Hmm, that shouldn't happen.
> REPEAT should always just re-start the current hook.
> If that hook gets deleted (and possibly re-created) while packet was
> queued the kernel is supposed to drop the packet.

I intentionally created an endless loop with NF_REPEAT. Without the nft
modification it goes into the expected loop, but with the nft modification
it does not (see below for log).
 
>> I don't modify the chain the packet is currently traversing. I only add
>> new chains and modify the vmap.
> 
> The netfilter infrastructure is a layer below nftables/iptables so it
> is not even aware of rule set modifications.
> 
>> >> It also appears as if the nft trace infrastructure does not now how to
>> >> deal with queues. The above rules lead to this annotated trace output:
>> >> 
>> >> > trace id 10d53daf ip filter client_to_any packet: iif "upstream" oif "ens256"
>> >> > ether saddr 00:50:56:96:9b:1c ether daddr 00:0c:29:46:1f:53 ether type ip6
>> >> 
>> >> That's rule #11... Where is the hit on the queue rule and the return??
>> > 
>> > No idea, I will have a closer look next week.
>> > Glancing at the code it should work just fine.
>> 
>> There might a event buffering issue. I have now sometimes seen the queueing
>> trace. At other times the event is lost. So maybe the netlink buffer is not
>> large enough?
> 
> How many events are there...?
> If there aren't hundreds of events going on that really should not be an
> issue.

The trace is really just the 10 or so events. Whether the queue event
is in there or not seems to be purely random:

trace id ed0492b0 ip filter client_to_any packet: iif "upstream" oif "ens256" ether saddr 00:50:56:96:9b:1c ether daddr 00:0c:29:46:1f:53 ether type ip6 
trace id ed0492b0 ip filter client_to_any rule nftrace set 1 (verdict continue)
trace id ed0492b0 ip filter client_to_any rule counter packets 0 bytes 0 queue num 0 (verdict queue)
add chain ip filter CIn_1
add rule ip filter CIn_1 counter name "CIn_1_Session"
add rule ip filter CIn_1 ip daddr 172.20.16.0/24 counter packets 0 bytes 0 accept
add rule ip filter CIn_1 ip daddr 8.0.0.0/8 counter packets 0 bytes 0 accept
add chain ip filter COut_1
add rule ip filter COut_1 counter name "COut_1_Session"
add rule ip filter COut_1 ip saddr 172.20.16.0/24 counter packets 0 bytes 0 accept
add rule ip filter COut_1 ip saddr 8.0.0.0/8 counter packets 0 bytes 0 accept
trace id ed0492b0 ip mangle POSTROUTING verdict continue 
trace id ed0492b0 ip mangle POSTROUTING 

Regards
Andreas
