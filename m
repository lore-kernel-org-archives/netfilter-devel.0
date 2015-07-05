From: Florian Westphal <fw@strlen.de>
Subject: Re: [Q RFC nft] how to add bridge vlan header match support?
Date: Mon, 6 Jul 2015 00:03:22 +0200
Message-ID: <20150705220322.GB16864@breakpoint.cc>
References: <20150702152433.GC16529@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57642 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918AbbGEWDY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jul 2015 18:03:24 -0400
Content-Disposition: inline
In-Reply-To: <20150702152433.GC16529@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Hi.
> 
> Matching VLAN id from bridge netfilter doesn't seem to work:
> 
> nft add rule bridge filter input vlan type ip
> <cmdline>:1:30-38: Error: conflicting protocols specified: ether vs. vlan
> 
> This happens in expr_evaluate_payload(),
> ctx->pctx.protocol[base].desc != payload->payload.desc is true.
> 
> So, how to fix this?
> This seems to work, but I'm not sure this approach is sane
> (also lacks reverse translation):
> 
> +static bool resolve_protocol_conflict(struct eval_ctx *ctx,
> +                                     struct expr *payload)
> +{
> +       const struct hook_proto_desc *h = &hook_proto_desc[ctx->pctx.family];
> +       enum proto_bases base = payload->payload.base;
> +       const struct proto_desc *desc;
> +       struct stmt *nstmt;
> +       int link;
> +
> +       desc = ctx->pctx.protocol[base].desc;
> +       if (desc == payload->payload.desc)
> +               return true;
> +
> +       if (payload->payload.base != h->base)
> +               return false;
> +
> +       link = proto_find_num(desc, payload->payload.desc);
> +       if (link < 0 || payload_gen_dependency(ctx, payload, &nstmt) < 0)
> +               return false;
> +
> +       payload->payload.offset += 8*14; /* XXX: add size to proto_desc? */
> +       list_add_tail(&nstmt->list, &ctx->stmt->list);
> +
> +       return true;
> +}
> @@ -286,7 +312,7 @@ static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **expr)
>                 if (payload_gen_dependency(ctx, payload, &nstmt) < 0)
>                         return -1;
>                 list_add_tail(&nstmt->list, &ctx->stmt->list);
> -       } else if (ctx->pctx.protocol[base].desc != payload->payload.desc)
> +       } else if (!resolve_protocol_conflict(ctx, payload))
> 
> It creates following code with above rule:
>   [ payload load 2b @ link header + 12 => reg 1 ]
>   [ cmp eq reg 1 0x00000081 ] -> implict dependency, eth->type == vlan?
>   [ payload load 2b @ link header + 16 => reg 1 ], vlan id
>   [ cmp eq reg 1 0x00000008 ]
> 
> Is this a sane approach?

"No".  Its not sufficient.

This makes

nft add rule bridge filter input vlan type ip

work, but thats not enough.  F.e.

nft add rule bridge filter input vlan id 42 ip saddr 10.2.3.4

Must inject *two* dependency tests.

'vlan' should add 'ether type vlan'.
'ip' should add 'vlan type ip'.

And both must be done respecting the correct nexthdr protocol offsets.

Which for the intermediate (vlan) header must be done respecting the
ether hdr size.

Any idea how to allow such stacking on nft side?

Thanks,
Florian
