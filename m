Return-Path: <SRS0=+Cxx=DA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C288C2D0A8
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Sep 2020 13:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2413C206A5
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Sep 2020 13:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgIWNaW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Sep 2020 09:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWNaW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Sep 2020 09:30:22 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FAE5C0613CE
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2020 06:30:22 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kL4qg-0008Bk-5K; Wed, 23 Sep 2020 15:30:18 +0200
Date:   Wed, 23 Sep 2020 15:30:18 +0200
From:   Florian Westphal <fw@strlen.de>
To:     "Jose M. Guisado Gomez" <guigom@riseup.net>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3 nf-next] netfilter: nf_tables: add userdata attributes
 to nft_chain
Message-ID: <20200923133018.GA31471@breakpoint.cc>
References: <20200923112042.GB3218@salvia>
 <20200923131629.761-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923131629.761-1-guigom@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jose M. Guisado Gomez <guigom@riseup.net> wrote:
> Enables storing userdata for nft_chain. Field udata points to user data
> and udlen stores its length.
> 
> Adds new attribute flag NFTA_CHAIN_USERDATA.
> 
> Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
> ---
> +	if (nla[NFTA_CHAIN_USERDATA]) {
> +		udlen = nla_len(nla[NFTA_CHAIN_USERDATA]);
> +		chain->udata = kzalloc(udlen, GFP_KERNEL);
> +		if (chain->udata == NULL) {
> +			err = -ENOMEM;
> +			goto err_destroy_chain;
> +		}
> +
> +		nla_memcpy(chain->udata, nla[NFTA_CHAIN_USERDATA], udlen);
> +		chain->udlen = udlen;

nit: You could use nla_memdup() instead of alloc+memcpy.

> -err2:
> +err_unregister_hook:
>  	nf_tables_unregister_hook(net, table, chain);
> -err1:
> +err_free_udata:
> +	kfree(chain->udata);
> +err_destroy_chain:
>  	nf_tables_chain_destroy(ctx);

This frees ->udata on error.  But what if the chain is added
successfully and then deleted at a later time?

Wouldn't it make more sense to only patch nf_tables_chain_destroy()
to handle both error and chain delete case?
