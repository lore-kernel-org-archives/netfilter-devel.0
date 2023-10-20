Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5696CDB474
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Oct 2023 11:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376988AbjJTLbW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Oct 2023 07:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376883AbjJTLbW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2023 07:31:22 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE261AE
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2023 04:31:20 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qtnip-0006l6-Cs; Fri, 20 Oct 2023 13:31:19 +0200
Date:   Fri, 20 Oct 2023 13:31:19 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,RFC 3/8] netfilter: nf_tables: expose opaque set
 element as struct nft_elem_priv
Message-ID: <20231020113119.GE9493@breakpoint.cc>
References: <20231019141958.653727-1-pablo@netfilter.org>
 <20231019141958.653727-4-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019141958.653727-4-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> +static inline void *nft_elem_priv_cast(const struct nft_elem_priv *priv)
> +{
> +	return (void *)priv;
> +}

I'm fine with this, alternative would be to make this per-set backend:

#define nft_elem_priv_to_bitmap_elem(ptr)	container_of_const(ptr, struct nft_bitmap_elem, priv)

I'll leave it up to you.  The only advantage of the latter is that priv
doesn't have to be the first member.
