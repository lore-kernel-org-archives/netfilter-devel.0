Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11559C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 15:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0B9060FBF
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 15:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245594AbhIMPxI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 11:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244551AbhIMPxE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 11:53:04 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C028C0698DE
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Sep 2021 08:46:15 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mPo9r-0006GB-1a; Mon, 13 Sep 2021 17:46:11 +0200
Date:   Mon, 13 Sep 2021 17:46:11 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptabes-nft] iptables-nft: allow removal of empty builtin
 chains
Message-ID: <20210913154611.GB22465@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Jan Engelhardt <jengelh@inai.de>,
        netfilter-devel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210815143637.GK607@breakpoint.cc>
 <20210815142734.GA31050@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

Sorry to jump late onto this discussion, I missed it entirely and just
noticed the new commit. /o\

On Sun, Aug 15, 2021 at 04:27:34PM +0200, Pablo Neira Ayuso wrote:
> On Sun, Aug 15, 2021 at 04:14:14PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > But we really do not need NLM_F_NONREC for this new feature, right? I
> > > mean, a quick shortcut to remove the basechain and its content should
> > > be fine.
> > 
> > Would deviate a lot from iptables behaviour.
> 
> It's a new feature: you could still keep NLM_F_NONREC in place, and
> only allow to remove one chain (with no rules) at a time if you
> prefer, ie.
> 
> iptables-nft -K INPUT -t filter
> 
> or -X if you prefer to overload the existing command.
> 
> > > > No, I don't think so.  I would prefer if
> > > > iptables-nft -F -t filter
> > > > iptables-nft -X -t filter
> > > > 
> > > > ... would result in an empty "filter" table.
> > > 
> > > Your concern is that this would change the default behaviour?
> > 
> > Yes, maybe ok to change it though.  After all, a "iptables-nft -A INPUT
> > ..." will continue to work just fine (its auto-created again).
> > 
> > We could check if policy is still set to accept before implicit
> > removal in the "iptables-nft -X" case.
> 
> That's possible yes, but why force the user to change the policy from
> DROP to ACCEPT to delete an empty basechain right thereafter?

On Sun, Aug 15, 2021 at 04:36:37PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > We could check if policy is still set to accept before implicit
> > > removal in the "iptables-nft -X" case.
> > 
> > That's possible yes, but why force the user to change the policy from
> > DROP to ACCEPT to delete an empty basechain right thereafter?
> 
> Ok, so I will just send a simplified version of this patch that
> will remove all empty basechains for -X too.

I believe there was a misunderstanding: How I read Pablo's comments, he
was walking about '-X' with base-chain name explicitly given. If a user
calls e.g. 'iptables-nft -X FORWARD', it is clear that the new behaviour
is intended and dropping any non-standard policy is not a surprise. The
code right now though behaves unexpectedly:

| # nft flush ruleset
| # ./install/sbin/iptables-nft -P FORWARD DROP
| # ./install/sbin/iptables-nft -X
| # nft list ruleset
| table ip filter {
| }

So forward DROP policy is lost even though the user just wanted to make
sure any user-defined chains are gone. But things are worse in practice:

| # iptables -A FORWARD -d 10.0.0.1 -j ACCEPT
| # iptables -P FORWARD DROP
| # iptables -X

With iptables-nft, the last command above fails (EBUSY). I expect users
to be pedantic when it comes to unexpected firewall openings or bogus
errors in iptables-wrapping scripts.

IMHO we're fine if chains with non-standard policy stay in place. Yet
this might be racey because IIRC we don't have a "delete chain only if
policy is accept" command flavour in kernel. This would be interesting,
because we could drop a base chain also when it's flushed - just
ignoring a rejected delete if it happens to be non-standard policy.

The safe option should be to delete base chains only if given
explicitly, as suggested by Pablo already I suppose.

Cheers, Phil
