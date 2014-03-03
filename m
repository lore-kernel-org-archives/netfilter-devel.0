From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] parser: support reject unreach|reset
Date: Mon, 3 Mar 2014 23:03:51 +0100
Message-ID: <20140303220351.GI9965@breakpoint.cc>
References: <1393881146-12967-1-git-send-email-fw@strlen.de>
 <1393882892.19488.14.camel@ice-age2.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53413 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754798AbaCCWDx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:03:53 -0500
Content-Disposition: inline
In-Reply-To: <1393882892.19488.14.camel@ice-age2.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond <eric@regit.org> wrote:
> On Mon, 2014-03-03 at 22:12 +0100, Florian Westphal wrote:
> > reject did not allow to use tcp reset instead of icmp unreach.
> 
> I'm currently working on a patchset to support this and also setting the
> ICMP code. But I'm fighting on the ICMP code filtering.

Good to hear this, very nice!

In that case its probably best if this patch is tossed to not
interfere with your work.

> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  After this patch its possibe to do something like
> > 
> >  rule filter output reject reset
> 
> I found syntax a bit short ;) If we add ICMP code support
> and follow the logic:
> 
> rule filter output reject administratively-prohibited
> 
> My plan was to do something like:
> 
> rule filter output reject with tcp reset
> rule filter output reject with icmp|code administratively-prohibited
> 
> > 
> >  Which makes kernel generate bogus tcp resets in repsonse
> >  to non-tcp packets.
> > 
> >  In iptables this is avoided by making checkentry fail if -p tcp is not
> >  specified when tcp-reset is requested.
> >
> >  How should this be handled in nft?
> 
> Good point. It looks a bit like what Patrick did mention in "Re:
> [nftables RFC PATCH 0/1] implementing icmp code filterin"
> 
> "We do something similar in ct_expr_update_type() for ct expressions."
> 
> Idea is to update the entry and in this case to output an error if we
> don't have tcp. But I'm not sure we can access to the other expressions
> (and henve to the TCP or not info) in that point.

Thanks for the pointer, this seems to work:

static int stmt_evaluate_reject(struct eval_ctx *ctx, struct stmt *stmt)
{
        if (stmt->reject.type == NFT_REJECT_TCP_RST) {
                const struct proto_desc *desc;
                desc = ctx->pctx.protocol[PROTO_BASE_TRANSPORT_HDR].desc;
                if (desc != &proto_tcp)
                        return stmt_error(ctx, stmt, "reset option can only be used with tcp");
        }

        stmt->flags |= STMT_F_TERMINAL;
        return 0;
}

