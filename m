From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RESEND v3] netfilter: xtables: add quota support to nfacct
Date: Sun, 2 Feb 2014 21:40:12 +0100
Message-ID: <20140202204012.GJ776@breakpoint.cc>
References: <1391292671-26466-1-git-send-email-mathieu.poirier@linaro.org>
 <20140201225726.GF776@breakpoint.cc>
 <CANLsYkzCb=UqUoG5p4pVr-8YNfJcb25uesUZTMrwT7KuEh2LYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	kadlec <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58065 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417AbaBBUkS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Feb 2014 15:40:18 -0500
Content-Disposition: inline
In-Reply-To: <CANLsYkzCb=UqUoG5p4pVr-8YNfJcb25uesUZTMrwT7KuEh2LYg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Mathieu Poirier <mathieu.poirier@linaro.org> wrote:
[ removed netfilter@ from cc ]

> On 1 February 2014 15:57, Florian Westphal <fw@strlen.de> wrote:
> > mathieu.poirier@linaro.org <mathieu.poirier@linaro.org> wrote:
> >> +struct xt_nfacct_match_info_v1 {
> >> +     char            name[NFACCT_NAME_MAX];
> >> +     struct nf_acct  *nfacct;
> >> +
> >> +     __u32 flags;
> >> +     __aligned_u64 quota;
> >> +     /* used internally by kernel */
> >> +     struct nf_acct_quota    *priv __attribute__((aligned(8)));
> >> +};
> >
> > I think *nfacct pointer is also kernel internal, so it should also get
> > aligned (might also be possible to stash it in *private struct).
> 
> I suspect Pablo didn't change it already for a good reason and as such
> reluctant to do the modification myself.

Looks like an oversight to me.  I haven't checked but my guess would
be that -m nfacct won't work with 32bit userspace on 64 bit machines.

Would be better to avoid such problems with match revision 2.

> >> +             if (val <= info->quota) {
> >> +                     ret = !ret;
> >> +                     info->priv->quota_reached = false;
> >
> > Why quota_reached = false
> > assignment?
> 
> An object that has reached it's quota can always be reset from the
> userspace with:
> 
> $ nfacct get object_name reset

I see.  Makes sense,  thanks.
 
> As such we need to reset the flag so that a broadcast isn't sent.
> > [ How is this toggled (other than transition to 'true' below)? ]
> >
> >> +             if (val >= info->quota && !info->priv->quota_reached) {
> >> +                     info->priv->quota_reached = true;
> >> +                     nfnl_quota_event(info->nfacct);
> >> +             }
> >> +
> >> +             spin_unlock_bh(&info->priv->lock);
> >> +     }
> >
> > Hm.  Not sure why the lock has to be hold during all tests.  What about:
> 
> Here "info" is an object seen and shared by all processors.  If a
> process looses the CPU between the two atomic64_read, other CPUs in
> the system can grab "info" and go through the same code, leading to an
> erroneous count of byte and packets.
> To me the real problem is with the incrementation of "pkts" and
> "bytes" in function "nfnl_acct_update" - there is simply no way to
> prevent a process from loosing the CPU between the two incrementation.

Not following.  Write side is done via atomic ops, so we don't lose any
information.  Also, note that netfilter hooks run with rcu_read_lock().

Its possible that concurrent reader sees pkts already incremented but
the "old" byte count.  Is that what you're referring to? Is it a concern?

When you read either the packet or byte count you only know that this
_was_ the statistic count at some point in the (very recent) past anyway.

To me it only looks like you need to make sure that you try to send out
a broadcast notification message once when one of the counters has
recently exceeded the given threshold.

Or is there more to this functionality?
