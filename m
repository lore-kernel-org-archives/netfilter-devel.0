From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: netfilter question
Date: Wed, 16 Nov 2016 07:23:09 -0800
Message-ID: <1479309789.8455.194.camel@edumazet-glaptop3.roam.corp.google.com>
References: <cad49557-7c7a-83c9-d2b6-71d9624f0d52@miromedia.ca>
         <CANn89iLr-Zf2W5MW47QtKo17915UoryZentihKt1SMv7NP_dOw@mail.gmail.com>
         <20161116150200.GH30581@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <edumazet@google.com>,
        Eric Desrochers <ericd@miromedia.ca>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33714 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753151AbcKPPXM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Nov 2016 10:23:12 -0500
Received: by mail-pg0-f65.google.com with SMTP id 3so14965294pgd.0
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Nov 2016 07:23:11 -0800 (PST)
In-Reply-To: <20161116150200.GH30581@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2016-11-16 at 16:02 +0100, Florian Westphal wrote:
> Eric Dumazet <edumazet@google.com> wrote:
> > On Wed, Nov 16, 2016 at 2:22 AM, Eric Desrochers <ericd@miromedia.ca> wrote:
> > > Hi Eric,
> > >
> > > My name is Eric and I'm reaching you today as I found your name in multiple netfilter kernel commits, and was hoping we can discuss about a potential regression.
> > >
> > > I identified (git bisect) this commit [https://github.com/torvalds/linux/commit/71ae0dff02d756e4d2ca710b79f2ff5390029a5f] as the one introducing a serious performance slowdown when using the binary ip/ip6tables with a large number of policies.
> > >
> > > I also tried with the latest and greatest v4.9-rc4 mainline kernel, and the slowdown is still present.
> > >
> > > So even commit [https://github.com/torvalds/linux/commit/a1a56aaa0735c7821e85c37268a7c12e132415cb] which introduce a 16 bytes alignment on xt_counter percpu allocations so that bytes and packets sit in same cache line, doesn't have impact too.
> > >
> > >
> > > Everything I found is detailed in the following bug : https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1640786
> > >
> > > Of course, I'm totally aware that "iptables-restore" should be the favorite choice as it is way more efficient (note that using iptables-restore doesn't exhibit the problem) but some folks still rely on ip/ip6tables and might face this performance slowdown.
> > >
> > > I found the problem today, I will continue to investigate on my side, but I was wondering if we could have a discussion about this subject.
> > >
> > > Thanks in advance.
> 
> [..]
> 
> > Key point is that we really care about fast path : packet processing.
> > And cited commit helps this a lot by lowering the memory foot print on
> > hosts with many cores.
> > This is a step into right direction.
> > 
> > Now we probably should batch the percpu allocations one page at a
> > time, or ask Tejun if percpu allocations could be really really fast
> > (probably much harder)
> > 
> > But really you should not use iptables one rule at a time...
> > This will never compete with iptables-restore. ;)
> > 
> > Florian, would you have time to work on a patch trying to group the
> > percpu allocations one page at a time ?
> 
> You mean something like this ? :
>         xt_entry_foreach(iter, entry0, newinfo->size) {
> -               ret = find_check_entry(iter, net, repl->name, repl->size);
> -               if (ret != 0)
> +               if (pcpu_alloc == 0) {
> +                       pcnt = __alloc_percpu(PAGE_SIZE, sizeof(struct xt_counters));

alignment should be a page.

> +                       if (IS_ERR_VALUE(pcnt))
> +                               BUG();

well. no BUG() for sure ;)

> +               }
> +
> +               iter->counters.pcnt = pcnt + pcpu_alloc;
> +               iter->counters.bcnt = !!pcpu_alloc;
> +               pcpu_alloc += sizeof(struct xt_counters);
> +
> +               if (pcpu_alloc > PAGE_SIZE - sizeof(struct xt_counters))
> +                       pcpu_alloc = 0;
> +
> +               ret = find_check_entry(iter, net, repl->name, repl->size)
>  ...
> 
> This is going to be ugly since we'll have to deal with SMP vs. NONSMP (i.e. no perpcu allocations)
> in ip/ip6/arptables.

Time for a common helper then ...

> 
> Error unwind will also be a mess (we can abuse .bcnt to tell if pcpu offset should be free'd or not).

Free if the address is aligned to a page boundary ?

Otherwise skip it, it already has been freed earlier.

> 
> But maybe I don't understand what you are suggesting :)
> Can you elaborate?

Note that this grouping will also help data locality.

I definitely have servers with a huge number of percpu allocations and I
fear we might have many TLB misses because of possible spread of
xt_counters.

Note that percpu pages must not be shared by multiple users
(ip/ip6/arptable), each table should get its own cache.



