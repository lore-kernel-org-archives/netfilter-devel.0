From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf-next v2 2/2] netfilter: nft_hash: support of symmetric hash
Date: Wed, 1 Mar 2017 12:11:54 +0800
Message-ID: <CAML_gOc8AAQ6ijDS65c1Qb6cYhBWFbEs814yDH5_27m1t6hsQw@mail.gmail.com>
References: <20170228173826.e2lx4f2yrbn7aegn@nevthink>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:35269 "EHLO
        mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750778AbdCAH2R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Mar 2017 02:28:17 -0500
Received: by mail-vk0-f52.google.com with SMTP id x75so4764136vke.2
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 23:28:08 -0800 (PST)
In-Reply-To: <20170228173826.e2lx4f2yrbn7aegn@nevthink>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

2017-03-01 1:38 GMT+08:00 Laura Garcia Liebana <nevola@gmail.com>:
[...]
> +static const struct nft_expr_ops *
> +nft_hash_select_ops(const struct nft_ctx *ctx,
> +                   const struct nlattr * const tb[])
> +{
> +       u32 type;
> +
> +       if (!tb[NFTA_HASH_TYPE])
> +               return ERR_PTR(-EINVAL);

For compatibility reason, if tb[NFTA_HASH_TYPE] is NULL, maybe it's better
to return &nft_jhash_ops instead of reporting error.
