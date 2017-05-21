From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 2/3] netfilter: nf_ct_helper: use
 nf_ct_iterate_cleanup to unlink helper objs
Date: Sun, 21 May 2017 12:31:53 +0200
Message-ID: <20170521103153.GE1004@breakpoint.cc>
References: <1495345149-57674-1-git-send-email-zlpnobody@163.com>
 <1495345149-57674-3-git-send-email-zlpnobody@163.com>
 <20170521081521.GD1004@breakpoint.cc>
 <CAML_gOc1OHEc_evYoXj2f0O1CMGLVc0MMNYgVE0xNtzXPXNJtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Liping Zhang <zlpnobody@163.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37048 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750994AbdEUKcn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 May 2017 06:32:43 -0400
Content-Disposition: inline
In-Reply-To: <CAML_gOc1OHEc_evYoXj2f0O1CMGLVc0MMNYgVE0xNtzXPXNJtQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@gmail.com> wrote:
> Hi Florian,
> 
> 2017-05-21 16:15 GMT+08:00 Florian Westphal <fw@strlen.de>:
> [...]
> > this is broken for unconfirmed conntracks, as
> > other cpu can reallocate the extension area.
> 
> Right, I missed this point, thanks for your reminder.
> 
> > For the module removal case, we have no choice but to toss the
> > unconfirmed conntracks.
> >
> > Same for patch #3.
> >
> > I plan to submit my patches soon, perhaps its best if I only
> > submit the first couple of patches so you can rebase on top of that?
> 
> I read your nfct_iterate_cleanup_15 patch series just now.
> Your patch set did more jobs, also including all the jobs which
> my patch set did. :)
> 
> I think it's better to do these things together, so I'm fine if you
> can mark my patch set as Superseded. :)

What about this: I will submit first half of my patches, then you can
rebase your two patches on top and send them, then I can rebase again
the rest.  What do you think?

BTW, I found another bug just now, but I don't have time to address it
right now:

nf_nat_proto_clean() does:

ct->status &= ~IPS_NAT_DONE_MASK;

Thats also broken(racy).  We have to audit all the non-atomic writes of
ct->status and change them to set/clear_bit()...

