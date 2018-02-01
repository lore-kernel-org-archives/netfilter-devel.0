From: Florian Westphal <fw@strlen.de>
Subject: Re: [Patch net] xt_RATEEST: acquire xt_rateest_mutex for hash insert
Date: Thu, 1 Feb 2018 23:36:35 +0100
Message-ID: <20180201223635.GC11048@breakpoint.cc>
References: <20180201002631.17638-1-xiyou.wangcong@gmail.com>
 <1517449486.3715.112.camel@gmail.com>
 <CAM_iQpVkek-RJ35+YfnV73asi6zjM0Sf=nroxxcN=mWubPtHfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50624 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751567AbeBAWja (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Feb 2018 17:39:30 -0500
Content-Disposition: inline
In-Reply-To: <CAM_iQpVkek-RJ35+YfnV73asi6zjM0Sf=nroxxcN=mWubPtHfA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Wed, Jan 31, 2018 at 5:44 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > On Wed, 2018-01-31 at 16:26 -0800, Cong Wang wrote:
> >> rateest_hash is supposed to be protected by xt_rateest_mutex.
> >>
> >> Reported-by: <syzbot+5cb189720978275e4c75@syzkaller.appspotmail.com>
> >> Fixes: 5859034d7eb8 ("[NETFILTER]: x_tables: add RATEEST target")
> >> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> >> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> >> ---
> >>  net/netfilter/xt_RATEEST.c | 2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
> >> index 498b54fd04d7..83ec3a282755 100644
> >> --- a/net/netfilter/xt_RATEEST.c
> >> +++ b/net/netfilter/xt_RATEEST.c
> >> @@ -36,7 +36,9 @@ static void xt_rateest_hash_insert(struct xt_rateest *est)
> >>       unsigned int h;
> >>
> >>       h = xt_rateest_hash(est->name);
> >> +     mutex_lock(&xt_rateest_mutex);
> >>       hlist_add_head(&est->list, &rateest_hash[h]);
> >> +     mutex_unlock(&xt_rateest_mutex);
> >>  }
> >
> > We probably should make this module netns aware, otherwise bad things
> > will happen.
> 
> Right, both the lock and the hashtable. I can do it for net-next,
> if you don't.

Note that the xtables af mutexes are not per-netns, the race is iptables
vs. ip6tables.
