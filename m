From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: ctnetlink: fix incorrect nf_ct_put during
 hash resize
Date: Wed, 24 May 2017 08:22:00 +0200
Message-ID: <20170524062200.GB11547@breakpoint.cc>
References: <1495322569-63361-1-git-send-email-zlpnobody@163.com>
 <20170521000047.GA1004@breakpoint.cc>
 <CAML_gOdnZkbCp8JnVpd8bbeTQuhK7hMtQio4iuLQe137HxE_+g@mail.gmail.com>
 <20170523213427.GA9071@salvia>
 <20170523222855.GA11547@breakpoint.cc>
 <CAML_gOcOaq_jMkWpjBLxo9Hr=sUu6hSWrRv=y89D--iCutEX7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:42140 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934596AbdEXGWT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 02:22:19 -0400
Content-Disposition: inline
In-Reply-To: <CAML_gOcOaq_jMkWpjBLxo9Hr=sUu6hSWrRv=y89D--iCutEX7g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@gmail.com> wrote:
> 2017-05-24 6:28 GMT+08:00 Florian Westphal <fw@strlen.de>:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> [...]
> >> I will append the Fixes: tag:
> >>
> >> Fixes: 89f2e21883b5 ("[NETFILTER]: ctnetlink: change table dumping not to require an unique ID")
> >
> > That commit looks fine to me, it seems to make sure to put
> > "last" only once in all cases.
> >
> > 93bb0ceb75be2fdfa9fc0dd1 however adds a check on cb->args[0], and if
> > that is hit it will do a put() on last, and then, the "done" netlink
> > callback will do another put operation on cb->args[1] (i.e., last).
> 
> After I have a closer look, I think this patch should add:
> 
> Fixes: d205dc40798d ("[NETFILTER]: ctnetlink: fix deadlock in table dumping")
> 
> After this commit, when the hash size was reduced, for example,
> from 60000 to 600, then we may put the "last" ct twice, as we may
> fail to go into the iteration and clear the cb->args[1], so:
> 
> 1. nf_ct_put(last) by ctnetlink_dump_table, but cb->args[1] still
> point to the "last"
> 2. nf_ct_put((struct nf_conn *)cb->args[1]) by ctnetlink_done

You are right.
