Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE48C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Dec 2021 17:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242463AbhLIRMW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 12:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242456AbhLIRMV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 12:12:21 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE50C061746
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Dec 2021 09:08:46 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id l7so10031617lja.2
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Dec 2021 09:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ns1.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7B4jlP4VD881cFWC/4iDeVFecLMFrVcIDe/l0Ru2woI=;
        b=U+7tl7hJHCbSZn2mt1v9U6f+xgxJW1ahkH8CkfhWkJzO6jaWqpjY8CKcOXMugDb0Zt
         P6gKYmjF85EcN5iTjZiKm8RJzm1KSWkhJhN1StdRzDYssIQpIiiZtcSW4uKqohSA37JF
         +61g53+mMlg2tJ5R7yb1s3sDVANrWB6Ea+66OIzXMRzDUwgS1Hw38apwvLRAyVJeyYi7
         mi2t2ISUYzpz9qQoAjd68QAsUVaY9ikKHHgsCHXN2YWKt1NmIsxJWRqIo6YU3kXs7Asc
         Z3/nG9snCYcKe+6XanwhIUQNH1/WLRjoyKlhuuOy51wOtd3hpqRPCrg22my6jCfFby+u
         tAqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7B4jlP4VD881cFWC/4iDeVFecLMFrVcIDe/l0Ru2woI=;
        b=soHUg4tjmqRy8+9DaAFeJJw3g9IQcTmUllA04P9P6ryJA+UnXHNxmjLrYeW7Tl2p//
         roeoQNQcISg414pUY6pjcO9Z0smwOXAkvV2Hg4fk3bfjVeAZPBiLKEl1grjCwIotKapu
         8WGOGzC0Xzh7AgBgHp+LYDCfnuC22E0XGyR3ZHP+9Pt+mCMjq4RqUQAlpa7YMjAOaBMG
         6rP1gU0DUt37QG+O0/E33pzihnpa/is7PBLaZtTnvZnMT7X8goNEW8SibjxEh+RVC2rH
         oXjzZ9hfGJqfq7009fSDfLel2pXHsjTPDxggEi3ht1rUEDshg5KGunOFDun9RzzD7aib
         8utw==
X-Gm-Message-State: AOAM530w+YHfZeVlIxhpYAI+Jk29uBRfSa7f7zP/nQWSQ1c1mI+gJK5x
        LEoZpAwodYnZls/qnryGcT1vPfTStGAuxOCm5T9bj/fdCJC/4Ffi
X-Google-Smtp-Source: ABdhPJz8Nsz3JVO5dd5bOj3S0DxHdxqtpxWixV8SzVFa8a543CqHrg/AoONqqojfjRAKY4OApd3uyYrKCYtXca1XL3w=
X-Received: by 2002:a2e:5d7:: with SMTP id 206mr7605366ljf.133.1639069724749;
 Thu, 09 Dec 2021 09:08:44 -0800 (PST)
MIME-Version: 1.0
References: <20211209163926.25563-1-fw@strlen.de>
In-Reply-To: <20211209163926.25563-1-fw@strlen.de>
From:   Vitaly Zuevsky <vzuevsky@ns1.com>
Date:   Thu, 9 Dec 2021 17:08:34 +0000
Message-ID: <CA+PiBLw3aUEd7X3yt5p7D6=-+EdL3EtFxiqSV8FDb5GuuyyxaQ@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: ctnetlink: remove expired entries first
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 9, 2021 at 4:39 PM Florian Westphal <fw@strlen.de> wrote:
>
> When dumping conntrack table to userspace via ctnetlink, check if the ct has
> already expired before doing any of the 'skip' checks.
>
> This expires dead entries faster.
> /proc handler also removes outdated entries first.
>
> Reported-by: Vitaly Zuevsky <vzuevsky@ns1.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Vitaly, I suspect this might be related to the issue you reported,
>  I suspect we skip the NAT-clash entries instead of evicting them from
>  ctnetlink path too.
>
>  net/netfilter/nf_conntrack_netlink.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 81d03acf68d4..ec4164c32d27 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1195,8 +1195,6 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
>                 }
>                 hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[cb->args[0]],
>                                            hnnode) {
> -                       if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
> -                               continue;
>                         ct = nf_ct_tuplehash_to_ctrack(h);
>                         if (nf_ct_is_expired(ct)) {
>                                 if (i < ARRAY_SIZE(nf_ct_evict) &&
> @@ -1208,6 +1206,9 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
>                         if (!net_eq(net, nf_ct_net(ct)))
>                                 continue;
>
> +                       if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
> +                               continue;
> +
>                         if (cb->args[1]) {
>                                 if (ct != last)
>                                         continue;
> --
> 2.32.0
>

Florian, thanks for prompt turnaround on this. Seeing
conntrack -C
107530
mandates the check what flows consume this many entries. I cannot do
this if conntrack -L skips anything while kernel defaults to not
exposing conntrack table via /proc. This server is not supposed to NAT
anything by the way. We use some -j NOTRACK rules and I'd like to see
what flows evade those rules and consume so many slots. Could you
perhaps recommend a way to achieve this other than reconfiguring the
kernel?
