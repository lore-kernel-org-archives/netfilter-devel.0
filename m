Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2DBEB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jul 2023 14:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbjGEOdg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 10:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbjGEOde (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 10:33:34 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8994A1725;
        Wed,  5 Jul 2023 07:33:31 -0700 (PDT)
Date:   Wed, 5 Jul 2023 16:33:28 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, sashal@kernel.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: [PATCH -stable,5.10 02/10] netfilter: nf_tables: add
 rescheduling points during loop detection walks
Message-ID: <ZKV/OBWpvkSPNQ3x@calendula>
References: <20230705142213.53418-1-pablo@netfilter.org>
 <20230705142213.53418-3-pablo@netfilter.org>
 <20230705143107.GE3751@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230705143107.GE3751@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 05, 2023 at 04:31:07PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > From: Florian Westphal <fw@strlen.de>
> > 
> > [ 81ea010667417ef3f218dfd99b69769fe66c2b67 ]
> > 
> > Add explicit rescheduling points during ruleset walk.
> > 
> > Switching to a faster algorithm is possible but this is a much
> > smaller change, suitable for nf tree.
> > 
> > Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1460
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  net/netfilter/nf_tables_api.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index e3865f29ae83..3c9292d3f826 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -3164,6 +3164,8 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
> >  			if (err < 0)
> >  				return err;
> >  		}
> > +
> > +		cond_resched();
> >  	}
> >  
> >  	return 0;
> > @@ -8506,9 +8508,13 @@ static int nf_tables_check_loops(const struct nft_ctx *ctx,
> >  				break;
> >  			}
> >  		}
> > +
> > +		cond_resched();
> >  	}
> >  
> >  	list_for_each_entry(set, &ctx->table->sets, list) {
> > +		cond_resched();
> > +
> >  		if (!nft_is_active_next(ctx->net, set))
> 
> Nack, this is wrong.  Either drop this patch or also pick up
> 2024439bd5ceb145eeeb428b2a59e9b905153ac3
> ("netfilter: nf_tables: fix scheduling-while-atomic splat")
> I suspect it will cherry-pick without problems.

OK, I'll respin and send v2.
