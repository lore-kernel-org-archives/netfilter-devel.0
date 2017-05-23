From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: ctnetlink: fix incorrect nf_ct_put during
 hash resize
Date: Wed, 24 May 2017 00:28:55 +0200
Message-ID: <20170523222855.GA11547@breakpoint.cc>
References: <1495322569-63361-1-git-send-email-zlpnobody@163.com>
 <20170521000047.GA1004@breakpoint.cc>
 <CAML_gOdnZkbCp8JnVpd8bbeTQuhK7hMtQio4iuLQe137HxE_+g@mail.gmail.com>
 <20170523213427.GA9071@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:41250 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967833AbdEWW3E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 May 2017 18:29:04 -0400
Content-Disposition: inline
In-Reply-To: <20170523213427.GA9071@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, May 21, 2017 at 08:59:45AM +0800, Liping Zhang wrote:
> > Hi Florian,
> > 
> > 2017-05-21 8:00 GMT+08:00 Florian Westphal <fw@strlen.de>:
> > [...]
> > > Yes, you're right, seems this was added in
> > > 93bb0ceb75be2fdfa9fc0dd1fb522d9ada515d9c (it adds the 'goto out').
> > 
> > I added some trace logs, and when the hash size reduced, for example,
> > from 60000 to 500, then the issue would happen.
> > 
> > Actually, hitting 'goto out' is not easy, so the issue exists for a very long
> > time. Maybe commit 89f2e21883b5("[NETFILTER]: ctnetlink: change
> > table dumping not to require an unique ID") is to blame for it.
> > 
> > > Your patch looks correct.
> > >
> > > However, why do we bump refcnt of 'last' in the first place?
> > >
> > > Its only the continuation marker, i.e. its expected to reside
> > > in the hash slot at cb->args[0], but after rehash this might not
> > > be true either.
> > >
> > > I think we should simplify this, just take the verbatim address,
> > > and clear it right at start of ctnetlink_dump_table, i.e.
> > >
> > > unsigned long last = cb->args[1];
> > > cb->args[1] = 0;
> > >
> > > for (; cb->args[0] < nf_conntrack_htable_size; cb->args[0]++) {
> > >          ...
> > >     hlist_nulls_for_each_entry ... {
> > >        ...
> > >        if (last) {
> > >             if (last != (unsigned long)ct))
> > >                cont;
> > >             last = 0;
> > >        }
> > >        ...
> > >        dump();
> > >     }
> > >     last = 0; /* reset it, as it wasn't in args[0] slot */
> > >  }
> > >
> > > Do you see any problem with that?
> > 
> > I think this will be better, this will make code more clean.
> > Also we can clean up the ctnetlink_exp_ct_dump_table too.
> 
> @Florian, no objection then if I place this into nf.git?

No objection, thanks!

> I will append the Fixes: tag:
> 
> Fixes: 89f2e21883b5 ("[NETFILTER]: ctnetlink: change table dumping not to require an unique ID")

That commit looks fine to me, it seems to make sure to put
"last" only once in all cases.

93bb0ceb75be2fdfa9fc0dd1 however adds a check on cb->args[0], and if
that is hit it will do a put() on last, and then, the "done" netlink
callback will do another put operation on cb->args[1] (i.e., last).

