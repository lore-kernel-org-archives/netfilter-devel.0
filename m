Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BAD0C43460
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Apr 2021 15:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11D7C6115A
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Apr 2021 15:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhDBP5g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 11:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235535AbhDBP5f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 11:57:35 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209E7C061788
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Apr 2021 08:57:33 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id l4so7970081ejc.10
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Apr 2021 08:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NjT54jtHRWKb63cV3/hvdT10b8Uf7zTQ4kkn5xjn2aM=;
        b=FUjZ/sKKfq/dlrPz8u+SJ62Ga8K959fAd5BunVNKzOn/gAZ6fJYs27mZwf6RJOZTQn
         dpHYSItXJjJC4A0ekocKCMtK5C4EvS/dAZAWewVW3h/TYBK4GFz24XBY2b0WxPuQJWAX
         CP3RKFN8yGf5jO9TEtGkevkavP9D9upUCvyneOr9XN57RMLIw437TuLJ3utLEF0eTxrl
         mzioT1k8en4NqqkZohpKdOUz6qkg660nxewtJxaG9eECxpsZ3Uqg3VWmhM9Up8n2AOl5
         nYUs2vu42noqZnTT7DjlPNFU5348frOLqWe9eU+jtoNw/ah8JDTH2qBkkWj9Qk3jOwEr
         uBbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NjT54jtHRWKb63cV3/hvdT10b8Uf7zTQ4kkn5xjn2aM=;
        b=RAl410QqACPx1br1iofAeXVvkHD9Ft41AM79t4m2onKEz3W1yYXGGi+h4LmabEAQOK
         7s5MfGhVLRr+ujv2XLN9/b05ALGaU0lhPJ4UEJT3pSneEkqsQ9BK6gPOwEmbGddA7HmG
         yPk085pCZR420LymqR8/cNMqAdFzvvLZJcdNXWS2xA99rFh3aHc7yGlqYpX76ZkSadbs
         nAYv8ahINj4Xfa8qScKDGvrg61Rzd3BbDpZNyOgY/73T/MpYXnFiGtWBhlyOn6x2NX2/
         /BsQauTHQutHUnfRqW7VQe2wrZfoZ9aI490nAvTIISgh8G/VUvoiGtiiyruZehUoftiP
         Limg==
X-Gm-Message-State: AOAM533UtJaiJr/eYWQTu/Ka5u3+BT8Aqs8/9RVV4IPXcLmAFgF1Wd6L
        dYlzQL7YAbe367R09e4TEw0t8l6UpMb/cxJ1sobw
X-Google-Smtp-Source: ABdhPJzHGKOWAt5592FR69/C4RRWwtwIrfzvGzE/+gvH00fewfB4eOPn+6tpjVTvpOEP4zkXW11lI7AjMOKwnvxyvso=
X-Received: by 2002:a17:906:3d62:: with SMTP id r2mr14487188ejf.488.1617379051355;
 Fri, 02 Apr 2021 08:57:31 -0700 (PDT)
MIME-Version: 1.0
References: <YGcD6HO8tiX7G4OJ@mwanda>
In-Reply-To: <YGcD6HO8tiX7G4OJ@mwanda>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 2 Apr 2021 11:57:20 -0400
Message-ID: <CAHC9VhQ4D25kvzjXyvk8eJFXCOAaxuzUkSyNTePSrBHONxXZwQ@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nftables: fix a warning message in nf_tables_commit_audit_collect()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Richard Guy Briggs <rgb@redhat.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 2, 2021 at 7:46 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
> The first argument of a WARN_ONCE() is a condition.  This WARN_ONCE()
> will only print the table name, and is potentially problematic if the
> table name has a %s in it.
>
> Fixes: bb4052e57b5b ("audit: log nftables configuration change events once per table")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  net/netfilter/nf_tables_api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks Dan.

Reviewed-by: Paul Moore <paul@paul-moore.com>

> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 42bf3e15065a..2fb2ccf87011 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -8022,7 +8022,7 @@ static void nf_tables_commit_audit_collect(struct list_head *adl,
>                 if (adp->table == table)
>                         goto found;
>         }
> -       WARN_ONCE("table=%s not expected in commit list", table->name);
> +       WARN_ONCE(1, "table=%s not expected in commit list", table->name);
>         return;
>  found:
>         adp->entries++;
> --
> 2.30.2

-- 
paul moore
www.paul-moore.com
