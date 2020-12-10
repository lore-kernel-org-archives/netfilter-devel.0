Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D920C4167B
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Dec 2020 13:32:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EED923A1D
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Dec 2020 13:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389333AbgLJNcq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Dec 2020 08:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389320AbgLJNcm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Dec 2020 08:32:42 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579F8C0613CF
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2020 05:32:02 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1knM36-0001bI-VH; Thu, 10 Dec 2020 14:32:00 +0100
Date:   Thu, 10 Dec 2020 14:32:00 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: ctnetlink: always include remaining
 timeout
Message-ID: <20201210133200.GE31101@breakpoint.cc>
References: <20201210112022.7793-1-fw@strlen.de>
 <20201210131906.GA18962@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210131906.GA18962@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Dec 10, 2020 at 12:20:22PM +0100, Florian Westphal wrote:
> > DESTROY events do not include the remaining timeout.
> > 
> > Unconditionally including the timeout allows to see if the entry timed
> > timed out or was removed explicitly.
> > 
> > The latter case can happen when a conntrack gets deleted prematurely,
> > e.g. due to a tcp reset, module removal, netdev notifier (nat/masquerade
> > device went down), ctnetlink and so on.
> >
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  Might make sense to further extend nf_ct_delete and also pass a
> >  reason code in the future.
> 
> IIRC, TCP state is not included in the event, right?

No, protoinfo is only dumped for non-destroy case.

> This has been requested many times in the past, to debug connectivity
> issues too.
> 
> Probably extending .to_nlattr to take a bool parameter to specify if
> this is the destroy event path, then _only_ include the TCP state
> information there (other TCP information is not relevant and netlink
> bandwidth is limited from the event path).

Sounds reasonable, will send a v2.
