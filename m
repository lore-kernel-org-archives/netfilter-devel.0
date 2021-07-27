Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC9BC4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 18:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87BED60F9E
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 18:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhG0Sgd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 14:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhG0Sgd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 14:36:33 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5502EC061757
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jul 2021 11:36:31 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id u3so23345614lff.9
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jul 2021 11:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=al4wzAJPVQCguHEu1jhSq1/gMp7DeO9ySyLPCGHhK8I=;
        b=HKodYM2zPvQzUWEQkhv+E+fV3FRH30nwSv1TB2yiJNZXZ+lWLtg2xvsNUkMWSS2B0l
         j61pM4+O8Dk+c7dHHPkzUrV6NATSmGlpuFSzSnNWa/pFKMpbiZHLsQ4jp1CwIkKD0Ftv
         H3A6ub0nnNOOxXtTAJYWzv9mF7VbxSBzJKf4CZsY/XQVI5Vn9M2u8NMCTuiEWZa1y+nD
         vhtC7roHXwmmGyMtPjmO1FMdWVhLcKvPN3TpAHlMLqk5dn36P5ptZ3y4BUnCLHQpEjcb
         HyVvgAIi+9lFHJfnEJB5s2tMJc20NRNJSCBrYHurSyu+MV5tvesP3S2yOgKbzGWz0V6t
         O+kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=al4wzAJPVQCguHEu1jhSq1/gMp7DeO9ySyLPCGHhK8I=;
        b=ADPx+dzYlEHOTGGvGmNnAof9PJPYruiG1r1tKg5QZ2E3Cy7jpKyakids3ZJWBoMJZi
         ildpCag1La9W9K9W0aAmwu2ArcQWBHvaa8wlViF2LGzzk1c/qI8qIv12bQ61ANWKIMKN
         LfOJ1lgFpfKaso4bjDlN4klPSVLCpjgafcayXyKwWjaUZqE/Q/26+d94pvJlPkQjzQxG
         0gGl/xJoiVp900z3kHDR3GwOYILqxyC4toY0pnsLnr25zw5RkNmYFPSV2UDKfubr2WWP
         DzTqFuoBD8pq8Iz2yebTyvMRd2uLmNJYvSL7Oz5gQ/vOhjFzLP6cNGwI3p/0F2tOYvi6
         QPQw==
X-Gm-Message-State: AOAM5314VBrBrUQqnFOZWhu/BdriOieRacMyHao5PQSA2pQewD2SjAKg
        4iVL643AwuNGGSUBMT8fCBkbXo93wy3xTy5n56Q=
X-Google-Smtp-Source: ABdhPJzEzgkDIXO/lR94BDze5NzW1kPNNM6TZl5YEA84INnzJ7qlolSSw/SvgAm4izJ13T2vtWQ6w62NbJMCKaBAUFI=
X-Received: by 2002:a19:431a:: with SMTP id q26mr16911546lfa.531.1627410989696;
 Tue, 27 Jul 2021 11:36:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210727153741.14406-1-pablo@netfilter.org> <20210727153741.14406-2-pablo@netfilter.org>
In-Reply-To: <20210727153741.14406-2-pablo@netfilter.org>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Wed, 28 Jul 2021 02:36:18 +0800
Message-ID: <CAGnHSE=e-iYaz3KOMBq1JSVRd0HTL=TKQ_HHMadfyd2Nr8__yg@mail.gmail.com>
Subject: Re: [PATCH nft 2/3] netlink_linearize: incorrect netlink bytecode
 with binary operation and flags
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hmm, that means `tcp flags & (fin | syn | rst | ack) syn` is now
equivalent to 'tcp flags & (fin | syn | rst | ack) == syn'. Does that
mean `tcp flags syn` (was supposed to be and) is now equivalent to
`tcp flags == syn` instead of `tcp flags & syn == syn` / `tcp flags &
syn != 0`?

Suppose `tcp flags & syn != 0` should then be translated to `tcp flags
syn / syn` instead, please note that while nft translates `tcp flags &
syn == syn` to `tcp flags syn / syn`, it does not accept the
translation as input (when the mask is not a comma-separated list):

# nft --debug=netlink add rule meh tcp_flags 'tcp flags syn / syn'
Error: syntax error, unexpected newline, expecting comma
add rule meh tcp_flags tcp flags syn / syn
                                          ^

Also, does that mean `tcp flags & (fin | syn | rst | ack) fin,syn,ack`
will now be equivalent to `tcp flags & (fin | syn | rst | ack) = (fin
| syn | ack)` instead of (ultimately) `tcp flags & (fin | syn | ack)
!= 0`? Which means `tcp flags & (fin | syn | ack) != 0` should not be
translated to `tcp flags fin,syn,ack`?


On Tue, 27 Jul 2021 at 23:37, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> nft generates incorrect bytecode when combining flag datatype and binary
> operations:
>
>   # nft --debug=netlink add rule meh tcp_flags 'tcp flags & (fin | syn | rst | ack) syn'
> ip
>   [ meta load l4proto => reg 1 ]
>   [ cmp eq reg 1 0x00000006 ]
>   [ payload load 1b @ transport header + 13 => reg 1 ]
>   [ bitwise reg 1 = ( reg 1 & 0x00000017 ) ^ 0x00000000 ]
>   [ bitwise reg 1 = ( reg 1 & 0x00000002 ) ^ 0x00000000 ]
>   [ cmp neq reg 1 0x00000000 ]
>
> Note the double bitwise expression. The last two expressions are not
> correct either since it should match on the syn flag, ie. 0x2.
>
> After this patch, netlink bytecode generation looks correct:
>
>  # nft --debug=netlink add rule meh tcp_flags 'tcp flags & (fin | syn | rst | ack) syn'
> ip
>   [ meta load l4proto => reg 1 ]
>   [ cmp eq reg 1 0x00000006 ]
>   [ payload load 1b @ transport header + 13 => reg 1 ]
>   [ bitwise reg 1 = ( reg 1 & 0x00000017 ) ^ 0x00000000 ]
>   [ cmp eq reg 1 0x00000002 ]
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/netlink_linearize.c     | 38 ++++++++++++++++-----------
>  tests/py/inet/tcp.t         |  2 ++
>  tests/py/inet/tcp.t.json    | 52 +++++++++++++++++++++++++++++++++++++
>  tests/py/inet/tcp.t.payload | 16 ++++++++++++
>  4 files changed, 93 insertions(+), 15 deletions(-)
>
> diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
> index 9ab3ec3ef2ff..eb53ccec1154 100644
> --- a/src/netlink_linearize.c
> +++ b/src/netlink_linearize.c
> @@ -481,23 +481,31 @@ static void netlink_gen_flagcmp(struct netlink_linearize_ctx *ctx,
>         netlink_gen_raw_data(zero, expr->right->byteorder, len, &nld);
>         netlink_gen_data(expr->right, &nld2);
>
> -       nle = alloc_nft_expr("bitwise");
> -       netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG, sreg);
> -       netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, sreg);
> -       nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, len);
> -       nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_MASK, &nld2.value, nld2.len);
> -       nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_XOR, &nld.value, nld.len);
> -       nft_rule_add_expr(ctx, nle, &expr->location);
> -
> -       nle = alloc_nft_expr("cmp");
> -       netlink_put_register(nle, NFTNL_EXPR_CMP_SREG, sreg);
> -       if (expr->op == OP_NEG)
> +       if (expr->left->etype == EXPR_BINOP) {
> +               nle = alloc_nft_expr("cmp");
> +               netlink_put_register(nle, NFTNL_EXPR_CMP_SREG, sreg);
>                 nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP, NFT_CMP_EQ);
> -       else
> -               nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP, NFT_CMP_NEQ);
> +               nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld2.value, nld2.len);
> +               nft_rule_add_expr(ctx, nle, &expr->location);
> +       } else {
> +               nle = alloc_nft_expr("bitwise");
> +               netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG, sreg);
> +               netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, sreg);
> +               nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, len);
> +               nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_MASK, &nld2.value, nld2.len);
> +               nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_XOR, &nld.value, nld.len);
> +               nft_rule_add_expr(ctx, nle, &expr->location);
>
> -       nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, nld.len);
> -       nft_rule_add_expr(ctx, nle, &expr->location);
> +               nle = alloc_nft_expr("cmp");
> +               netlink_put_register(nle, NFTNL_EXPR_CMP_SREG, sreg);
> +               if (expr->op == OP_NEG)
> +                       nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP, NFT_CMP_EQ);
> +               else
> +                       nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP, NFT_CMP_NEQ);
> +
> +               nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, nld.len);
> +               nft_rule_add_expr(ctx, nle, &expr->location);
> +       }
>
>         mpz_clear(zero);
>         release_register(ctx, expr->left);
> diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
> index 16e15b9f76c1..983564ec5b75 100644
> --- a/tests/py/inet/tcp.t
> +++ b/tests/py/inet/tcp.t
> @@ -69,6 +69,8 @@ tcp flags != cwr;ok
>  tcp flags == syn;ok
>  tcp flags fin,syn / fin,syn;ok
>  tcp flags != syn / fin,syn;ok
> +tcp flags & (fin | syn | rst | ack) syn;ok;tcp flags syn / fin,syn,rst,ack
> +tcp flags & (fin | syn | rst | ack) != syn;ok;tcp flags != syn / fin,syn,rst,ack
>  tcp flags & (fin | syn | rst | psh | ack | urg | ecn | cwr) == fin | syn | rst | psh | ack | urg | ecn | cwr;ok;tcp flags == 0xff
>  tcp flags { syn, syn | ack };ok
>  tcp flags & (fin | syn | rst | psh | ack | urg) == { fin, ack, psh | ack, fin | psh | ack };ok
> diff --git a/tests/py/inet/tcp.t.json b/tests/py/inet/tcp.t.json
> index 590a3dee5d3f..033a4f22e0fd 100644
> --- a/tests/py/inet/tcp.t.json
> +++ b/tests/py/inet/tcp.t.json
> @@ -1521,3 +1521,55 @@
>      }
>  ]
>
> +# tcp flags & (fin | syn | rst | ack) syn
> +[
> +    {
> +        "match": {
> +            "left": {
> +                "&": [
> +                    {
> +                        "payload": {
> +                            "field": "flags",
> +                            "protocol": "tcp"
> +                        }
> +                    },
> +                    [
> +                        "fin",
> +                        "syn",
> +                        "rst",
> +                        "ack"
> +                    ]
> +                ]
> +            },
> +            "op": "==",
> +            "right": "syn"
> +        }
> +    }
> +]
> +
> +# tcp flags & (fin | syn | rst | ack) != syn
> +[
> +    {
> +        "match": {
> +            "left": {
> +                "&": [
> +                    {
> +                        "payload": {
> +                            "field": "flags",
> +                            "protocol": "tcp"
> +                        }
> +                    },
> +                    [
> +                        "fin",
> +                        "syn",
> +                        "rst",
> +                        "ack"
> +                    ]
> +                ]
> +            },
> +            "op": "!=",
> +            "right": "syn"
> +        }
> +    }
> +]
> +
> diff --git a/tests/py/inet/tcp.t.payload b/tests/py/inet/tcp.t.payload
> index 7f302080f02a..eaa7cd099bd6 100644
> --- a/tests/py/inet/tcp.t.payload
> +++ b/tests/py/inet/tcp.t.payload
> @@ -370,6 +370,22 @@ inet test-inet input
>    [ bitwise reg 1 = ( reg 1 & 0x00000003 ) ^ 0x00000000 ]
>    [ cmp neq reg 1 0x00000002 ]
>
> +# tcp flags & (fin | syn | rst | ack) syn
> +inet test-inet input
> +  [ meta load l4proto => reg 1 ]
> +  [ cmp eq reg 1 0x00000006 ]
> +  [ payload load 1b @ transport header + 13 => reg 1 ]
> +  [ bitwise reg 1 = ( reg 1 & 0x00000017 ) ^ 0x00000000 ]
> +  [ cmp eq reg 1 0x00000002 ]
> +
> +# tcp flags & (fin | syn | rst | ack) != syn
> +inet test-inet input
> +  [ meta load l4proto => reg 1 ]
> +  [ cmp eq reg 1 0x00000006 ]
> +  [ payload load 1b @ transport header + 13 => reg 1 ]
> +  [ bitwise reg 1 = ( reg 1 & 0x00000017 ) ^ 0x00000000 ]
> +  [ cmp neq reg 1 0x00000002 ]
> +
>  # tcp flags & (fin | syn | rst | psh | ack | urg | ecn | cwr) == fin | syn | rst | psh | ack | urg | ecn | cwr
>  inet test-inet input
>    [ meta load l4proto => reg 1 ]
> --
> 2.20.1
>
