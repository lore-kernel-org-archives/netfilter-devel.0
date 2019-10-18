Return-Path: <SRS0=5/AD=YL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F0ECA9EA0
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 10:24:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F6982064B
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 10:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbfJRKYF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Oct 2019 06:24:05 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:34254 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727791AbfJRKYF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 06:24:05 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iLPQQ-0002ZF-6W; Fri, 18 Oct 2019 12:24:02 +0200
Date:   Fri, 18 Oct 2019 12:24:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     wenxu@ucloud.cn
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add vlan support
Message-ID: <20191018102402.GY25052@breakpoint.cc>
References: <1571392968-1263-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571392968-1263-1-git-send-email-wenxu@ucloud.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This patch implements the vlan expr type that can be used to
> configure vlan tci and vlan proto

Looks like a very small module with no external dependencies,
I think you could make this a nft-builtin feature and just add
nft_vlan.o to 'nf_tables-objs' in net/netfilter/Makefile, similar to
nft_rt.

What do you think?

If you plan to extend this in the future then I'm fine with keeping it
as a module.

> +static int nft_vlan_set_init(const struct nft_ctx *ctx,
> +			     const struct nft_expr *expr,
> +			     const struct nlattr * const tb[])
> +{
> +	struct nft_vlan *priv = nft_expr_priv(expr);
> +	int err;

I think you need to add

	if (!tb[NFTA_VLAN_ACTION] ||
	    !tb[NFTA_VLAN_SREG] ||
	    !tb[NFTA_VLAN_SREG2])
		return -EINVAL;

Other than that this looks good to me.
