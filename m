Return-Path: <SRS0=LKiS=YY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D25CA9ECB
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 15:01:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 513A320650
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 15:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbfJaPB4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Oct 2019 11:01:56 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:47392 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbfJaPBz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Oct 2019 11:01:55 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iQBxR-0005xc-GP; Thu, 31 Oct 2019 16:01:53 +0100
Date:   Thu, 31 Oct 2019 16:01:53 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v3 00/12] Implement among match support
Message-ID: <20191031150153.GE8531@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191030172701.5892-1-phil@nwl.cc>
 <20191031141314.u5fvw4djza25er44@salvia>
 <20191031141452.h3hknkc3qze3xm3r@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031141452.h3hknkc3qze3xm3r@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Oct 31, 2019 at 03:14:52PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Oct 31, 2019 at 03:13:14PM +0100, Pablo Neira Ayuso wrote:
> > On Wed, Oct 30, 2019 at 06:26:49PM +0100, Phil Sutter wrote:
> > [...]
> > > Patches 1 to 5 implement required changes and are rather boring by
> > > themselves: When converting an nftnl rule to iptables command state,
> > > cache access is required (to lookup set references).
> > 
> > nft_handle is passed now all over the place, this allows anyone to
> > access all of its content. This layering design was done on purpose,
> > to avoid giving access to all information to the callers, instead
> > force the developer to give a reason to show why it needs something
> > else from wherever he is. I'm not entirely convinced exposing the
> > handle everywhere just because you need to access the set cache is the
> > way to go.
> 
> In other words: You only need the cache, right? Why don't you just
> expose cache to these functions which what you need?

When creating a new rule with among match, code needs to call
batch_add() to add the NFT_COMPAT_SET_ADD job. So in that direction I
don't see an alternative to passing nft_handle around.

When parsing a lookup expression, we may get by without having to call
__nft_build_cache() as cache might be present already (not sure if I
miss something). If not, nft_handle is mandatory - cache update
functions access many fields in nft_handle.

So when passing cache and builtin_table pointers to rule_to_cs, pure set
lookups should be possible without nft_handle access. We need
builtin_table pointer to identify the right table array item in cache.
With only table name, we need to call nft_table_builtin_find() and that
takes nft_handle as well.

I could give it a try if you still think it's feasible to keep
nft_handle away from nft_xt_ctx.

Thanks, Phil
