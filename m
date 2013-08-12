From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables RFC v3 PATCH 11/16] nft: Refactor firewall
 printing so it reuses already parsed cs struct
Date: Mon, 12 Aug 2013 11:30:47 +0200
Message-ID: <20130812093047.GA4516@localhost>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1376055090-26551-12-git-send-email-tomasz.bursztyka@linux.intel.com>
 <20130809215145.GB7102@localhost>
 <520894B3.50209@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58168 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274Ab3HLJbA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Aug 2013 05:31:00 -0400
Content-Disposition: inline
In-Reply-To: <520894B3.50209@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Tomasz,

On Mon, Aug 12, 2013 at 10:54:27AM +0300, Tomasz Bursztyka wrote:
> Hi Pablo,
> 
> >I like patches from 11 to 13, that refactorization save us quite some
> >code and the result in one single parsing and we also work with the
> >command structure.
> >
> >Please, can you send me these three patches in first place?
> 
> Not impossible but means a big rebase of this patchset.
> (it currently needs translation stuff, or then it would require some
> work to handle target/matches properly as original code does not in
> nft_rule_to_iptables_command_state, without solving pure-nft
> expressed extensions of course)
> 
> Could you recheck in detail patches 3/16 and 4/16?
> If there is no flaws in the translation engine, we might just go for
> it at it is.

I'm not convinced that this approach is the way to go. In the payload
case, the number of instruction tuples will explode, and you will have
to iterate many times to find the corresponding parser.

I started a quick patch this weekend based on this, the initial idea
is the following:

1) Assuming we use a common path to translate rules from nft to xt in
nft_rule_to_iptables_command_state, that function invokes a parser
depending on the instruction:

+void nft_parse_nat(struct nft_parse_ctx *ctx, struct nft_rule_expr
*e,
+                  struct nft_rule_expr_iter *iter, int family,
+                  struct iptables_command_state *cs)
+{
+       int nat_type;
+       struct nf_nat_range range;
+       uint32_t reg;
+
+       nat_type = nft_rule_expr_get_u32(e, NFT_EXPR_NAT_TYPE);
+
+       reg = nft_rule_expr_get_u32(e, NFT_EXPR_NAT_REG_ADDR_MIN);
+       if (reg)
+               range.min_addr.ip = ctx->registers[reg];
+
+       reg = nft_rule_expr_get_u32(e, NFT_EXPR_NAT_REG_ADDR_MAX);
+       if (reg) {
+               range.flags |= NF_NAT_RANGE_MAP_IPS;
+               range.max_addr.ip = ctx->registers[reg];
+       }
+
+       reg = nft_rule_expr_get_u32(e, NFT_EXPR_NAT_REG_PROTO_MIN);
+       if (reg)
+               range.min_proto.all = ctx->registers[reg];
+
+       reg = nft_rule_expr_get_u32(e, NFT_EXPR_NAT_REG_PROTO_MAX);
+       if (reg) {
+               range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
+               range.max_proto.all = ctx->registers[reg];
+       }
+
+       nft_nat_dispatcher(nat_type, family, &range);
+}

2) Then, this parser generates a structure that contains what most NAT
extension need. The immediate parser stores the values in the
ctx->registers, so the NAT will find what it needs there.

The dispatcher is specific per instruction, so we can look up for the
corresponding xt extension base on some specific tuple, in this case,
the family and the nat type:

+static void nft_nat_dispatcher(enum nft_nat_types nat_type, int fa
+                              struct nf_nat_range *range)
+{
+       struct nft_xt_nat *xt_nat;
+
+       list_for_each_entry(xt_nat, &nft_xt_nat_list, head) {
+               if (xt_nat->family == family &&
+                   xt_nat->nat_type == nat_type) {
+                       xt_nat->parse(range);
+                       return;
+               }
+       }
+}

This is currently a list, but we could implement it using a hashtable
in the payload case. The xt_nat->parse function is defined in the
corresponding xt extension.

Anyway, I really think we have to start by converting nft to ipt
command state in one single patch, as your patches 11-13 do, we need
it for whatever approach we decide to follow. If you don't have time
to make that rebase, I'll try to find some spare time to work on it.
Let me know.

Regards.
