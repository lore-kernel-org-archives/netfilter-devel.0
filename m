Return-Path: <SRS0=aMTL=TF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F355C004C9
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 15:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B3F3208C0
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 15:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfEEP6D convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 May 2019 11:58:03 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56562 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726524AbfEEP6D (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 May 2019 11:58:03 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hNJWb-0006vL-Iz; Sun, 05 May 2019 17:58:01 +0200
Date:   Sun, 5 May 2019 17:58:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     =?iso-8859-15?Q?St=E9phane?= Veyret <sveyret@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_ct: add ct expectations support
Message-ID: <20190505155801.pzwtzc3ksjmplszt@breakpoint.cc>
References: <20190505154016.3505-1-sveyret@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190505154016.3505-1-sveyret@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Stéphane Veyret <sveyret@gmail.com> wrote:
> +static void nft_ct_expect_obj_eval(struct nft_object *obj,
> +				    struct nft_regs *regs,
> +				    const struct nft_pktinfo *pkt)
> +{
> +	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
> +	enum ip_conntrack_info ctinfo;
> +	struct nf_conn *ct = nf_ct_get(pkt->skb, ctinfo);
> +	int dir = CTINFO2DIR(ctinfo);
> +	struct nf_conntrack_expect *exp;
> +
> +	exp = nf_ct_expect_alloc(ct);
> +	if (exp == NULL) {
> +		nf_ct_helper_log(skb, ct, "cannot allocate expectation");
> +		regs->verdict.code = NF_DROP;
> +		return;
> +	}
> +
> +	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, priv->l3num,
> +		&ct->tuplehash[!dir].tuple.src.u3, &ct->tuplehash[!dir].tuple.dst.u3,
> +		priv->l4proto, NULL, &priv->dport);
> +	if (priv->timeout)
> +		exp->timeout.expires = jiffies + priv->timeout * HZ;
> +
> +	if (nf_ct_expect_related(exp) != 0) {
> +		nf_ct_helper_log(skb, ct, "cannot add expectation");

Please remove the nf_ct_helper_log() calls, it will crash in case there is no helper
attached to the conntrack.

Other than this I don't see any issues here, thanks for working on this!
