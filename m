From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next,RFC 03/10] netfilter: bridge: kill
 NF_HOOK_THRESH() and state->tresh
Date: Thu, 13 Oct 2016 17:21:57 +0200
Message-ID: <20161013152157.GA3124@salvia>
References: <1476360171-2991-1-git-send-email-pablo@netfilter.org>
 <1476360171-2991-4-git-send-email-pablo@netfilter.org>
 <20161013122545.GB14002@breakpoint.cc>
 <20161013150148.GA1301@salvia>
 <20161013151055.GB20580@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57112 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752263AbcJMPah (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Oct 2016 11:30:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CB9D89B809
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 17:22:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E569BAC38
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 17:22:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 045C9DA91F
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 17:21:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20161013151055.GB20580@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 13, 2016 at 05:10:55PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Oct 13, 2016 at 02:25:45PM +0200, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > Patch c5136b15ea36 ("netfilter: bridge: add and use br_nf_hook_thresh")
> > > > introduced br_nf_hook_thresh().
> > > > 
> > > > Replace NF_HOOK_THRESH() by br_nf_hook_thresh from
> > > > br_nf_forward_finish(), so we have no more callers for this macro.
> > > > 
> > > > As a result, state->thresh and explicit thresh parameter in the hook
> > > > state structure is not required anymore.
> > > > 
> > > > And we can get rid of fast forward code in nf_iterate() in the core path
> > > > that is only used by br_netfilter to search for the filter hook.
> > > 
> > > Note that you will need to move more parts of nf_hook_slow() into
> > > br_nf_hook_thresh(); the bridge netfilter does need to thresh feature
> > > that we have in nf_iterate().
> > 
> > br_nf_hook_thresh() is already skipping hooks before NF_BR_PRI_BRNF to
> > emulate thresh. What else is missing?
> 
> AFAICS you are removing the NF_BR_PRI_BRNF skipping in this patch,
> it relied on nf_hook_slow to do this (plus the state->thresh thing).

int br_nf_hook_thresh(unsigned int hook, struct net *net,
                      struct sock *sk, struct sk_buff *skb,
                      struct net_device *indev,
                      struct net_device *outdev,
                      int (*okfn)(struct net *, struct sock *,
                                  struct sk_buff *))
{
        struct nf_hook_entry *elem;
        struct nf_hook_state state;
        int ret;

        elem = rcu_dereference(net->nf.hooks[NFPROTO_BRIDGE][hook]);

        while (elem && (elem->ops.priority <= NF_BR_PRI_BRNF))
                elem = rcu_dereference(elem->next);

        ...

        nf_hook_state_init(&state, elem, hook, NFPROTO_BRIDGE, indev, ...

Hm, but this code (before actually calling nf_hook_slow) is skipping
the hook until we get to NF_BR_PRI_BRNF + 1.

Then hook state sets hook_entry to elem.

Am I missing anything?
