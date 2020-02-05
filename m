Return-Path: <SRS0=2+fO=3Z=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NORMAL_HTTP_TO_IP,NUMERIC_HTTP_ADDR,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88EF0C35247
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Feb 2020 15:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66FC220730
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Feb 2020 15:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgBEPmB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Feb 2020 10:42:01 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:40600 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727029AbgBEPmA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Feb 2020 10:42:00 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1izMoQ-0003EZ-RF; Wed, 05 Feb 2020 16:41:58 +0100
Date:   Wed, 5 Feb 2020 16:41:58 +0100
From:   Florian Westphal <fw@strlen.de>
To:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: masquerade
Message-ID: <20200205154158.GJ26952@breakpoint.cc>
References: <E019C7FD-C763-465B-A32B-BE35A27C0B7A@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E019C7FD-C763-465B-A32B-BE35A27C0B7A@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com> wrote:
> Hello,
> 
> I was addressing kubernetes hairpin case when a container connects to itself via exposed service.
> 
> Example pod with ip 1.1.1.1 listening on port tcp 8080 and exposed via   service 2.2.2.2:8080, if curl is run from inside the pod, like curl http://2.2.2.2:8080 then the packet would be first dnat to 1.1.1.1:8080 and then its source needs to be masqueraded. In iptables implementation it seems it is automatically masqueraded to host's IP whereas in nftables (all rules are equivalent) source gets masqueraded into POD's interface.
> 
> I would appreciate if somebody could confirm this behavior and different in masquerading between iptables and nftables for containers.

They have same behaviour.  MASQUERADE target (xtables) and nft
masquerade are frontends for the same code.
The address masqueraded to is the primary address of the outgoing interface.

nftables masquerade code:

static void nft_masq_ipv4_eval(const struct nft_expr *expr,
                               struct nft_regs *regs,
                               const struct nft_pktinfo *pkt)
{
        struct nft_masq *priv = nft_expr_priv(expr);
        struct nf_nat_range2 range;

        memset(&range, 0, sizeof(range));
        range.flags = priv->flags;
        if (priv->sreg_proto_min) {
                range.min_proto.all = (__force __be16)nft_reg_load16(
                        &regs->data[priv->sreg_proto_min]);
                range.max_proto.all = (__force __be16)nft_reg_load16(
                        &regs->data[priv->sreg_proto_max]);
        }
        regs->verdict.code = nf_nat_masquerade_ipv4(pkt->skb, nft_hook(pkt),
                                                    &range, nft_out(pkt));
}

... and xtables one:
static unsigned int
masquerade_tg(struct sk_buff *skb, const struct xt_action_param *par)
{
        struct nf_nat_range2 range;
        const struct nf_nat_ipv4_multi_range_compat *mr;

        mr = par->targinfo;
        range.flags = mr->range[0].flags;
        range.min_proto = mr->range[0].min;
        range.max_proto = mr->range[0].max;

        return nf_nat_masquerade_ipv4(skb, xt_hooknum(par), &range,
                                      xt_out(par));
}

As you can see, both use same function, except nft feeds the arguments
from nftables registers and x_tables uses the targets arguments from
iptables command line.
