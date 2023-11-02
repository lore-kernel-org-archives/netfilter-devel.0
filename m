Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B59A8C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 11:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjKBLLj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 07:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjKBLLj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 07:11:39 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E062E111
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 04:11:36 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qyVbr-00075o-J9; Thu, 02 Nov 2023 12:11:35 +0100
Date:   Thu, 2 Nov 2023 12:11:35 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH RFC] netfilter: nf_tables: add flowtable map for xdp
 offload
Message-ID: <20231102111135.GI6174@breakpoint.cc>
References: <20231019202507.16439-1-fw@strlen.de>
 <87il6k1lbz.fsf@toke.dk>
 <20231102105434.GF6174@breakpoint.cc>
 <87fs1o1ki4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87fs1o1ki4.fsf@toke.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Toke Høiland-Jørgensen <toke@kernel.org> wrote:
> > From nft based flowtable offload we already had a feature request to
> > bounce flows back to normal path periodially, this was because people
> > wanted to make sure that long-living flows get revalidated vs. current
> > netfilter ruleset and not the one that was active at flow offload time.
> >
> > There was a patch for it, using a new sysctl, and author never came
> > back with an updated patch to handle this via the ruleset instead.
> 
> Right, if there's an existing policy knob for this it makes sense to
> support it in the XDP case as well, of course.
> 
> Does HW flow offload deal with that reordering case at all, BTW? I
> assume it could happen for that as well?

We do not have such a feature, only a request.  The patch was never
applied because we belive a sysctl based approach is not very flexible.

HW can bounce offloaded packets at any time.
SW fallback bounces packets that it cannot handle, currently those
are ip options or ip fragments.

FIN or RST moves flow back to slowpath permanently.
