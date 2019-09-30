Return-Path: <SRS0=Tpyl=XZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF6E9C32792
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Sep 2019 12:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EA0120842
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Sep 2019 12:37:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BOEV3HJc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfI3Mhy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Sep 2019 08:37:54 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:40918 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfI3Mhx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Sep 2019 08:37:53 -0400
Received: by mail-ot1-f65.google.com with SMTP id y39so8121670ota.7
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2019 05:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5arOKosm4SQAkgJSi8nTflluTvYW6Ujv606ja1vGMUo=;
        b=BOEV3HJcDnwpxrDEBc4p4DTN0U1Fs7TQMw38M9ncAMLUZCvRShRAvXchtn9c0fZ8pE
         /tQUVO2Dnx4m1Xu0LbjTVu2VgEDqgEcDwvBdc8GFH96nDwgXuqfr3V8hZPWasyWCWjgu
         cFcbqiuoeQ0/qL1Rd91KzxLABjhsi0PK94o47P1IpffEH8tRlshqgVJcazuT1VaFSYxY
         5bwD60j4+YAhlXfmLGK4HB5ev1kGwA12OBfj3MJWlVAfCGVP3qpZFIgNMG7xcOREIdWA
         +hiI3kRMwG85N4RhjqADP/5y3yY/Ei5f/DLWcx/ZG3s6bbeDhl2aEgVvMLSFlHh7zHUN
         ckEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5arOKosm4SQAkgJSi8nTflluTvYW6Ujv606ja1vGMUo=;
        b=hKKzxYdRQGp5UUaFKqyyOM5lHTMefkv36dTk6brqWFwirxNa9pMYi3JnsijS9KSBvr
         VEKCq7L9dQjxPkOi4Jr17M/F4Q7xyKXV+fsHgY8Efi3XRcZP5VIt1xvq8bfQ+i7bNoX7
         8MiH3hTMXLC+YcXlwdL15BCv/V37lizNwKorCR63eqJt4knQwJk6JoZYS2dtvrqBE+JC
         MVUmEMzwtp2YJKsF5UWVJJJ6UdmtfiEnasX/wDBUS4oZcMtX+Z0cvp5m3JUGOFeXlTNX
         P2cuw4Vt+2z0piVsdK+iev3SOm7RW6bJBSNb/pJmWolpzxgCGLi4xFTI16HXfkD72dL9
         KbyQ==
X-Gm-Message-State: APjAAAVnrM19N8gZyQII7dcD8sWokV1KUgJab9pl5KzGt/Gekwd8fl5a
        cs8+cl1sd9jFVaq+jcjLNGP8k1wPRakAo/kppuMdww==
X-Google-Smtp-Source: APXvYqx4ASt5zGrPAjUMe05Ppjyk9xbwTxV6yuejqQemTJffQ9v7d36V+L98MpKP4RNJLWabihL94Ffrb3L/H1XA1Hw=
X-Received: by 2002:a9d:7207:: with SMTP id u7mr13486720otj.59.1569847072797;
 Mon, 30 Sep 2019 05:37:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190930090549.24317-1-pablo@netfilter.org>
In-Reply-To: <20190930090549.24317-1-pablo@netfilter.org>
From:   Laura Garcia <nevola@gmail.com>
Date:   Mon, 30 Sep 2019 14:37:41 +0200
Message-ID: <CAF90-WhCqwbzqXszcpJVT1YfwQriJNs_1sLk57pVK-cgGYrJqw@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nft_connlimit: disable bh on garbage collection
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 30, 2019 at 11:08 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> BH must be disabled when invoking nf_conncount_gc_list() to perform
> garbage collection, otherwise deadlock might happen.
>

It is working great, thank you. Also, probably this is also desirable for 4.19.

>   nf_conncount_add+0x1f/0x50 [nf_conncount]
>   nft_connlimit_eval+0x4c/0xe0 [nft_connlimit]
>   nft_dynset_eval+0xb5/0x100 [nf_tables]
>   nft_do_chain+0xea/0x420 [nf_tables]
>   ? sch_direct_xmit+0x111/0x360
>   ? noqueue_init+0x10/0x10
>   ? __qdisc_run+0x84/0x510
>   ? tcp_packet+0x655/0x1610 [nf_conntrack]
>   ? ip_finish_output2+0x1a7/0x430
>   ? tcp_error+0x130/0x150 [nf_conntrack]
>   ? nf_conntrack_in+0x1fc/0x4c0 [nf_conntrack]
>   nft_do_chain_ipv4+0x66/0x80 [nf_tables]
>   nf_hook_slow+0x44/0xc0
>   ip_rcv+0xb5/0xd0
>   ? ip_rcv_finish_core.isra.19+0x360/0x360
>   __netif_receive_skb_one_core+0x52/0x70
>   netif_receive_skb_internal+0x34/0xe0
>   napi_gro_receive+0xba/0xe0
>   e1000_clean_rx_irq+0x1e9/0x420 [e1000e]
>   e1000e_poll+0xbe/0x290 [e1000e]
>   net_rx_action+0x149/0x3b0
>   __do_softirq+0xde/0x2d8
>   irq_exit+0xba/0xc0
>   do_IRQ+0x85/0xd0
>   common_interrupt+0xf/0xf
>   </IRQ>
>   RIP: 0010:nf_conncount_gc_list+0x3b/0x130 [nf_conncount]
>
> Fixes: 2f971a8f4255 ("netfilter: nf_conncount: move all list iterations under spinlock")
> Reported-by: Laura Garcia Liebana <nevola@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nft_connlimit.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
> index af1497ab9464..69d6173f91e2 100644
> --- a/net/netfilter/nft_connlimit.c
> +++ b/net/netfilter/nft_connlimit.c
> @@ -218,8 +218,13 @@ static void nft_connlimit_destroy_clone(const struct nft_ctx *ctx,
>  static bool nft_connlimit_gc(struct net *net, const struct nft_expr *expr)
>  {
>         struct nft_connlimit *priv = nft_expr_priv(expr);
> +       bool ret;
>
> -       return nf_conncount_gc_list(net, &priv->list);
> +       local_bh_disable();
> +       ret = nf_conncount_gc_list(net, &priv->list);
> +       local_bh_enable();
> +
> +       return ret;
>  }
>
>  static struct nft_expr_type nft_connlimit_type;
> --
> 2.11.0
>
