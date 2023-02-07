Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FB2C636CC
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Feb 2023 10:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjBGK5A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Feb 2023 05:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjBGK47 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Feb 2023 05:56:59 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3222B5B99
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Feb 2023 02:56:56 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pPLef-0006Tq-BK; Tue, 07 Feb 2023 11:56:53 +0100
Date:   Tue, 7 Feb 2023 11:56:53 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v2] netfilter: nf_tables: Introduce
 NFTA_RULE_ACTUAL_EXPR
Message-ID: <Y+Iudd7MODhgjrgz@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <Y8fe9+XHbxYyD4LY@salvia>
 <Y8f4pNIcb2zH9QqZ@orbyte.nwl.cc>
 <Y9wrzkablavNnUXl@salvia>
 <Y90QrjOONoZmcCZL@orbyte.nwl.cc>
 <Y90o8eq3egHbtC3Z@salvia>
 <Y900iRzf2q8xnXyv@orbyte.nwl.cc>
 <Y94oUYqArYqhkmOX@salvia>
 <Y97HaXaEtIlFUQSJ@orbyte.nwl.cc>
 <Y+DN2miPlSlBAIaj@salvia>
 <Y+IrUPyJi/GE6Cbk@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+IrUPyJi/GE6Cbk@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 07, 2023 at 11:43:28AM +0100, Pablo Neira Ayuso wrote:
> On Mon, Feb 06, 2023 at 10:52:29AM +0100, Pablo Neira Ayuso wrote:
> > On Sat, Feb 04, 2023 at 10:00:25PM +0100, Phil Sutter wrote:
> > > On Sat, Feb 04, 2023 at 10:41:37AM +0100, Pablo Neira Ayuso wrote:
> > > > On Fri, Feb 03, 2023 at 05:21:29PM +0100, Phil Sutter wrote:
> > > > [...]
> > > > > On Fri, Feb 03, 2023 at 04:32:01PM +0100, Pablo Neira Ayuso wrote:
> > > > [...]
> > > > > > I also wonder if this might cause problems with nftables and implicit
> > > > > > sets, they are bound to one single lookup expression that, when gone,
> > > > > > the set is released. Now you will have two expressions pointing to an
> > > > > > implicit set. Same thing with implicit chains. This might get tricky
> > > > > > with the transaction interface.
> > > > > 
> > > > > While indeed two lookup expressions will refer to the same anonymous
> > > > > set, only one of those expressions will ever be in use. There's no way
> > > > > the kernel would switch between rule variants (or use both at the same
> > > > > time).
> > > > 
> > > > OK, but control plane will reject two lookup expressions that refer to
> > > > the same anonymous set.
> > > 
> > > Only if it sees the second expression: If NFTA_RULE_ACTUAL_EXPR is
> > > present, the kernel will copy the content of NFTA_RULE_EXPRESSIONS into
> > > a buffer pointed to by nft_rule::dump_expr. It does not inspect the
> > > content apart from nla_policy checking which merely ensures it's a
> > > nested array of elements conforming to nft_expr_policy (i.e., have a
> > > NAME and DATA attribute).
> > > 
> > > The copied data is touched only by nf_tables_fill_rule_info() which
> > > copies it as-is into the skb. Later, nf_tables_rule_destroy() just frees
> > > the whole blob.
> > > 
> > > So effectively the kernel doesn't know or care what expressions are
> > > contained in NFTA_RULE_EXPRESSIONS.
> > 
> > Copy should work, sorry I thought you were parsing the expression again.
> 
> If you are happy with this, then let's place it in nf-next?

Yes, please! I'll finish user space this week. :)

Thanks, Phil
