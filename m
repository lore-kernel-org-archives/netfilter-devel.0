From: Florian Westphal <fw@strlen.de>
Subject: [Q RFC nft] how to add bridge vlan header match support?
Date: Thu, 2 Jul 2015 17:24:33 +0200
Message-ID: <20150702152433.GC16529@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53951 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753090AbbGBPYf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jul 2015 11:24:35 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.80)
	(envelope-from <fw@strlen.de>)
	id 1ZAgLp-0005J9-Tx
	for netfilter-devel@vger.kernel.org; Thu, 02 Jul 2015 17:24:33 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi.

Matching VLAN id from bridge netfilter doesn't seem to work:

nft add rule bridge filter input vlan type ip
<cmdline>:1:30-38: Error: conflicting protocols specified: ether vs. vlan

This happens in expr_evaluate_payload(),
ctx->pctx.protocol[base].desc != payload->payload.desc is true.

So, how to fix this?
This seems to work, but I'm not sure this approach is sane
(also lacks reverse translation):

+static bool resolve_protocol_conflict(struct eval_ctx *ctx,
+                                     struct expr *payload)
+{
+       const struct hook_proto_desc *h = &hook_proto_desc[ctx->pctx.family];
+       enum proto_bases base = payload->payload.base;
+       const struct proto_desc *desc;
+       struct stmt *nstmt;
+       int link;
+
+       desc = ctx->pctx.protocol[base].desc;
+       if (desc == payload->payload.desc)
+               return true;
+
+       if (payload->payload.base != h->base)
+               return false;
+
+       link = proto_find_num(desc, payload->payload.desc);
+       if (link < 0 || payload_gen_dependency(ctx, payload, &nstmt) < 0)
+               return false;
+
+       payload->payload.offset += 8*14; /* XXX: add size to proto_desc? */
+       list_add_tail(&nstmt->list, &ctx->stmt->list);
+
+       return true;
+}
@@ -286,7 +312,7 @@ static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **expr)
                if (payload_gen_dependency(ctx, payload, &nstmt) < 0)
                        return -1;
                list_add_tail(&nstmt->list, &ctx->stmt->list);
-       } else if (ctx->pctx.protocol[base].desc != payload->payload.desc)
+       } else if (!resolve_protocol_conflict(ctx, payload))

It creates following code with above rule:
  [ payload load 2b @ link header + 12 => reg 1 ]
  [ cmp eq reg 1 0x00000081 ] -> implict dependency, eth->type == vlan?
  [ payload load 2b @ link header + 16 => reg 1 ], vlan id
  [ cmp eq reg 1 0x00000008 ]

Is this a sane approach?
If yes, where would you store the underlying ll header size needed for offset correction?

Do you think we should already consider arbitary stacking (e.g. qinq)?
If yes, any hints on how to add this on nft side?

Thanks,
Florian
