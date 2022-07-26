Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE75AC00140
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Jul 2022 17:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239843AbiGZRwP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Jul 2022 13:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239846AbiGZRvY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Jul 2022 13:51:24 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30ED532DAA
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Jul 2022 10:50:59 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oGOhu-0007ef-1C; Tue, 26 Jul 2022 19:50:58 +0200
Date:   Tue, 26 Jul 2022 19:50:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_queue: only allow supported families
Message-ID: <20220726175058.GC7785@breakpoint.cc>
References: <20220726104348.2125-1-fw@strlen.de>
 <Yt/sKPSv8K1gD1oX@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yt/sKPSv8K1gD1oX@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > +	case NFPROTO_INET:
> 
> there is a special inet/ingress, maybe it requires a sanity check here?

Right, this patch allows 'inet+ingress', whoch doesn't work either.

> >  static int nft_queue_init(const struct nft_ctx *ctx,
> >  			  const struct nft_expr *expr,
> >  			  const struct nlattr * const tb[])
> > @@ -82,6 +100,9 @@ static int nft_queue_init(const struct nft_ctx *ctx,
> 
> Maybe .validate is a better place for this?

Yep, I sent a v2.
