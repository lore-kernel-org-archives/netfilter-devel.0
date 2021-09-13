Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0533C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 16:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC56F604D1
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 16:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235528AbhIMQEn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 12:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345425AbhIMQDr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 12:03:47 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1039C0613DF
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Sep 2021 09:02:25 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mPoPV-0001K4-0F; Mon, 13 Sep 2021 18:02:21 +0200
Date:   Mon, 13 Sep 2021 18:02:20 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jan Engelhardt <jengelh@inai.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptabes-nft] iptables-nft: allow removal of empty builtin
 chains
Message-ID: <20210913160220.GQ23554@breakpoint.cc>
References: <20210815143637.GK607@breakpoint.cc>
 <20210815142734.GA31050@salvia>
 <20210913154611.GB22465@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913154611.GB22465@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> > Ok, so I will just send a simplified version of this patch that
> > will remove all empty basechains for -X too.
> 
> I believe there was a misunderstanding: How I read Pablo's comments, he
> was walking about '-X' with base-chain name explicitly given. If a user
> calls e.g. 'iptables-nft -X FORWARD', it is clear that the new behaviour
> is intended and dropping any non-standard policy is not a surprise. The
> code right now though behaves unexpectedly:
> 
> | # nft flush ruleset
> | # ./install/sbin/iptables-nft -P FORWARD DROP
> | # ./install/sbin/iptables-nft -X
> | # nft list ruleset
> | table ip filter {
> | }
> 
> So forward DROP policy is lost even though the user just wanted to make
> sure any user-defined chains are gone. But things are worse in practice:
> 
> | # iptables -A FORWARD -d 10.0.0.1 -j ACCEPT
> | # iptables -P FORWARD DROP
> | # iptables -X
> 
> With iptables-nft, the last command above fails (EBUSY). I expect users
> to be pedantic when it comes to unexpected firewall openings or bogus
> errors in iptables-wrapping scripts.
> 
> IMHO we're fine if chains with non-standard policy stay in place. Yet
> this might be racey because IIRC we don't have a "delete chain only if
> policy is accept" command flavour in kernel. This would be interesting,
> because we could drop a base chain also when it's flushed - just
> ignoring a rejected delete if it happens to be non-standard policy.
> 
> The safe option should be to delete base chains only if given
> explicitly, as suggested by Pablo already I suppose.

No idea, I won't change anything. V1 kept '-X' behaviour as-is:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210814174643.130760-1-fw@strlen.de/

see the "don't delete built-in chain" comment, the reject-check was kept
in place for the case where iptables-nft is iterating over all the
chains; explict '-X $NAME' was required.

So I don't know what I should change now.  Feel free to update
as you see fit, including a revert.
