Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3984C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Oct 2021 10:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 948EE61372
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Oct 2021 10:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbhJDKnE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Oct 2021 06:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhJDKnD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Oct 2021 06:43:03 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1738CC061745
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Oct 2021 03:41:15 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mXLPE-0004Tb-0W; Mon, 04 Oct 2021 12:41:12 +0200
Date:   Mon, 4 Oct 2021 12:41:12 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        eric@garver.life, phil@nwl.cc, kadlec@netfilter.org
Subject: Re: [PATCH RFC 2/2] netfilter: nf_nat: don't allow source ports that
 shadow local port
Message-ID: <20211004104112.GK2935@breakpoint.cc>
References: <20210923131243.24071-1-fw@strlen.de>
 <20210923131243.24071-3-fw@strlen.de>
 <20211001132128.GG2935@breakpoint.cc>
 <YVrUjttDagSNWnWT@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVrUjttDagSNWnWT@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Oct 01, 2021 at 03:21:28PM +0200, Florian Westphal wrote:
> > Alternate fix idea:
> > 
> > 1. store skb->skb_iif in nf_conn.
> > 
> > This means locally vs. remote-generated nf_conn can be identified
> > via ct->skb_iff != 0.
> > 
> > 2. For "remote" case, force following behaviour:
> >    check that sport > dport and sport > 1024.
> > 
> > OTOH, this isn't transparent to users and might cause issues
> > with very very old "credential passing" applications that insist
> > on using privileged port range (< 1024) :-/
> 
> Can't this be just expressed through ruleset? I mean, conditionally
> masquerade depending on whether the packet is locally generated or
> not, for remove for sport > 1024 range.

Yes, see patch #1, it demos a couple of ruleset based fixes/mitigations
for this problem.
