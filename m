From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: ctnetlink: fix incorrect nf_ct_put during
 hash resize
Date: Sun, 21 May 2017 02:00:47 +0200
Message-ID: <20170521000047.GA1004@breakpoint.cc>
References: <1495322569-63361-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36434 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751403AbdEUABg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 May 2017 20:01:36 -0400
Content-Disposition: inline
In-Reply-To: <1495322569-63361-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> If nf_conntrack_htable_size was adjusted by the user during the ct
> dump operation, we may invoke nf_ct_put twice for the same ct, i.e.
> the "last" ct. This will cause the ct will be freed but still linked
> in hash buckets.
> 
> It's very easy to reproduce the problem by the following commands:
>   # while : ; do
>   echo $RANDOM > /proc/sys/net/netfilter/nf_conntrack_buckets
>   done
>   # while : ; do
>   conntrack -L
>   done
>   # iperf -s 127.0.0.1 &
>   # iperf -c 127.0.0.1 -P 60 -t 36000
> 
> After a while, the system will hang like this:
>   NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [bash:20184]
>   NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [iperf:20382]
>   ...
> 
> So at last if we find cb->args[1] is equal to "last", this means hash
> resize happened, then we can set cb->args[1] to 0 to fix the above
> issue.

Yes, you're right, seems this was added in
93bb0ceb75be2fdfa9fc0dd1fb522d9ada515d9c (it adds the 'goto out').

Your patch looks correct.

However, why do we bump refcnt of 'last' in the first place?

Its only the continuation marker, i.e. its expected to reside
in the hash slot at cb->args[0], but after rehash this might not
be true either.

I think we should simplify this, just take the verbatim address,
and clear it right at start of ctnetlink_dump_table, i.e.

unsigned long last = cb->args[1];
cb->args[1] = 0;

for (; cb->args[0] < nf_conntrack_htable_size; cb->args[0]++) {
	 ...
    hlist_nulls_for_each_entry ... {
       ...
       if (last) {
            if (last != (unsigned long)ct))
	       cont;
            last = 0;
       }
       ...
       dump();
    }
    last = 0; /* reset it, as it wasn't in args[0] slot */
 }

Do you see any problem with that?

[ It might be better to take your patch for nf- though and do
  this no-refcnt thing in nf-next ... ]
