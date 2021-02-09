Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5C0C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Feb 2021 14:12:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 258C364E37
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Feb 2021 14:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhBIOMd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 09:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbhBIOMd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 09:12:33 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6F1C061788
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Feb 2021 06:11:52 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1l9Tk7-0005mK-Hu; Tue, 09 Feb 2021 15:11:51 +0100
Date:   Tue, 9 Feb 2021 15:11:51 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] erec: Sanitize erec location indesc
Message-ID: <20210209141151.GO3158@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20210126175502.9171-1-phil@nwl.cc>
 <20210203003832.GA30866@salvia>
 <20210203104507.GO3158@orbyte.nwl.cc>
 <20210209131511.GA27807@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209131511.GA27807@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, Feb 09, 2021 at 02:15:11PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Feb 03, 2021 at 11:45:07AM +0100, Phil Sutter wrote:
> > On Wed, Feb 03, 2021 at 01:38:32AM +0100, Pablo Neira Ayuso wrote:
> > > On Tue, Jan 26, 2021 at 06:55:02PM +0100, Phil Sutter wrote:
> > > > erec_print() unconditionally dereferences erec->locations->indesc, so
> > > > make sure it is valid when either creating an erec or adding a location.
> > > 
> > > I guess your're trigger a bug where erec is indesc is NULL, thing is
> > > that indesc should be always set on. Is there a reproducer for this bug?
> > 
> > Yes, exactly. I hit it when trying to clean up the netdev family reject
> > support, while just "hacking around". You can trigger it with the
> > following change:
> > 
> > | --- a/src/evaluate.c
> > | +++ b/src/evaluate.c
> > | @@ -2718,7 +2718,7 @@ static int stmt_evaluate_reject_bridge(struct eval_ctx *ctx, struct stmt *stmt,
> > |         const struct proto_desc *desc;
> > |  
> > |         desc = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
> > | -       if (desc != &proto_eth && desc != &proto_vlan && desc != &proto_netdev)
> > | +       if (desc != &proto_eth && desc != &proto_vlan)
> > |                 return stmt_binary_error(ctx,
> > |                                          &ctx->pctx.protocol[PROTO_BASE_LL_HDR],
> > |                                          stmt, "unsupported link layer protocol");
> 
> I'm attaching fix.
> 
> Looks like call to stmt_binary_error() parameters are not in the right
> order, &ctx->pctx.protocol[PROTO_BASE_LL_HDR] has indesc.

Thanks for addressing the root problem!

> Probably add a bugtrap to erec to check that indesc is always set on
> accordingly instead?

Is it better than just sanitizing input to error functions? After all we
just want to make sure users see the error message, right? Catching
the programming mistake (wrong args passed to __stmt_binary_error())
IMHO is useful only if we can compile-time assert it. Otherwise we risk
hiding error info from user.

Cheers, Phil
