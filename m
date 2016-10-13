From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next,RFC 03/10] netfilter: bridge: kill
 NF_HOOK_THRESH() and state->tresh
Date: Thu, 13 Oct 2016 17:10:55 +0200
Message-ID: <20161013151055.GB20580@breakpoint.cc>
References: <1476360171-2991-1-git-send-email-pablo@netfilter.org>
 <1476360171-2991-4-git-send-email-pablo@netfilter.org>
 <20161013122545.GB14002@breakpoint.cc>
 <20161013150148.GA1301@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39412 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753016AbcJMPN1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Oct 2016 11:13:27 -0400
Content-Disposition: inline
In-Reply-To: <20161013150148.GA1301@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Oct 13, 2016 at 02:25:45PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Patch c5136b15ea36 ("netfilter: bridge: add and use br_nf_hook_thresh")
> > > introduced br_nf_hook_thresh().
> > > 
> > > Replace NF_HOOK_THRESH() by br_nf_hook_thresh from
> > > br_nf_forward_finish(), so we have no more callers for this macro.
> > > 
> > > As a result, state->thresh and explicit thresh parameter in the hook
> > > state structure is not required anymore.
> > > 
> > > And we can get rid of fast forward code in nf_iterate() in the core path
> > > that is only used by br_netfilter to search for the filter hook.
> > 
> > Note that you will need to move more parts of nf_hook_slow() into
> > br_nf_hook_thresh(); the bridge netfilter does need to thresh feature
> > that we have in nf_iterate().
> 
> br_nf_hook_thresh() is already skipping hooks before NF_BR_PRI_BRNF to
> emulate thresh. What else is missing?

AFAICS you are removing the NF_BR_PRI_BRNF skipping in this patch,
it relied on nf_hook_slow to do this (plus the state->thresh thing).
