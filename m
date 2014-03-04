From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] parser: support reject unreach|reset
Date: Tue, 4 Mar 2014 09:08:08 +0000
Message-ID: <20140304090807.GE5094@macbook.localnet>
References: <1393881146-12967-1-git-send-email-fw@strlen.de>
 <1393882892.19488.14.camel@ice-age2.regit.org>
 <20140303220351.GI9965@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38216 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480AbaCDJIL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:08:11 -0500
Content-Disposition: inline
In-Reply-To: <20140303220351.GI9965@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 03, 2014 at 11:03:51PM +0100, Florian Westphal wrote:
> Eric Leblond <eric@regit.org> wrote:
> > > 
> > >  In iptables this is avoided by making checkentry fail if -p tcp is not
> > >  specified when tcp-reset is requested.
> > >
> > >  How should this be handled in nft?
> > 
> > Good point. It looks a bit like what Patrick did mention in "Re:
> > [nftables RFC PATCH 0/1] implementing icmp code filterin"
> > 
> > "We do something similar in ct_expr_update_type() for ct expressions."
> > 
> > Idea is to update the entry and in this case to output an error if we
> > don't have tcp. But I'm not sure we can access to the other expressions
> > (and henve to the TCP or not info) in that point.
> 
> Thanks for the pointer, this seems to work:
> 
> static int stmt_evaluate_reject(struct eval_ctx *ctx, struct stmt *stmt)
> {
>         if (stmt->reject.type == NFT_REJECT_TCP_RST) {
>                 const struct proto_desc *desc;
>                 desc = ctx->pctx.protocol[PROTO_BASE_TRANSPORT_HDR].desc;
>                 if (desc != &proto_tcp)
>                         return stmt_error(ctx, stmt, "reset option can only be used with tcp");
>         }
> 
>         stmt->flags |= STMT_F_TERMINAL;
>         return 0;
> }

Yes, this is what we should do in userspace. As an add-on, we could (as we
do for payload matches) add implicit matches if no TCP match is present,
IOW, just as

"filter output tcp dport ssh"

really generates

"filter output ip protocol tcp tcp dport ssh",

"filter output reset"

would generate

"filter output ip protocol 6 reset"

and only return an error if a conflicting protocol expression is specified.
I'm not entirely sure whether we want to do this for statements or just for
match expressions though, for now I guess just the check is fine.

In the kernel we still should silently ignore packets that are not TCP,
rules might be installed by other means than nft.
