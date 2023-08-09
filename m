Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6571C04A94
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Aug 2023 00:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbjHIAEn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 20:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbjHIAEm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 20:04:42 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8DE1986
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Aug 2023 17:04:41 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 41be03b00d2f7-56334abe325so3746866a12.3
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Aug 2023 17:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1691539481; x=1692144281;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q753MXTz9z1YcPxBtklg+ZM2sNxutssP2J+C7z32EeY=;
        b=O6c22X7L/GLzPl6hJPk8Jro7XqRJmDsV394NNSP7USwH3ELDWmXHweiI2OaNH2dgnJ
         UhLecCM7sf234JhknKgpqlIUC2D/5bJmSo21xVH9NHwRBS/6o5o2R5ehrgVxwLXuUumV
         QV8IhenwEOGj+4uBFV1nZJag2aFk19zt4FyYc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691539481; x=1692144281;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q753MXTz9z1YcPxBtklg+ZM2sNxutssP2J+C7z32EeY=;
        b=EW/vyKFIdWgvPiJMUaIxrxPif6lx+nPK2GKDOKCTIVDWLOXRlHXp/HJep3L4hX69eY
         0oRjMIPifTFUYl/F7J+AdZETDWNsbf7LvG/gYSPciGKiTzQOGxl6wXyqhgvMha679Sus
         ixcB4iUBKlIdPRijpL0jU98zP4akowUWFywVa3h3AabDXudXMbFY9EcD7aprk1WOhLBv
         +jE/QRZaNWlmcXSJkX8/fmdvlic08KkyCF4c/5m+tM1iNhxct/UvQzcXWvfdeIlcgU4u
         qtS0pw6n/DluKaYTJFubu4e35dJKTgSfN22B+YgFiUlFM8RxNerG522T4p/prUr17IDk
         oCdw==
X-Gm-Message-State: AOJu0YwWfbMXpg5xi6P0lY1Bzk7TMiY7JpHQdVE4bfv4YxoqOn2zhk0G
        lpJIC5jaG+aBnhuEx6llrZRubg==
X-Google-Smtp-Source: AGHT+IE+nVYsSUbToI9ToOHU9cMo6NDjTJ6RPyx/CDUXO/RJo6/8V0QN+CvQIqlQunKKZ/fq2G9gGA==
X-Received: by 2002:a05:6a21:62a:b0:13d:ee19:7725 with SMTP id ll42-20020a056a21062a00b0013dee197725mr898777pzb.12.1691539481236;
        Tue, 08 Aug 2023 17:04:41 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id z1-20020aa785c1000000b00686b649cdd0sm8652697pfn.86.2023.08.08.17.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 17:04:40 -0700 (PDT)
Date:   Tue, 8 Aug 2023 17:04:40 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Justin Stitt <justinstitt@google.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-hardening@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] netfilter: x_tables: refactor deprecated strncpy
Message-ID: <202308081702.2F681E0E@keescook>
References: <20230808-net-netfilter-v1-0-efbbe4ec60af@google.com>
 <20230808-net-netfilter-v1-6-efbbe4ec60af@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808-net-netfilter-v1-6-efbbe4ec60af@google.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 08, 2023 at 10:48:11PM +0000, Justin Stitt wrote:
> Prefer `strscpy` to `strncpy` for use on NUL-terminated destination
> buffers.
> 
> This fixes a potential bug due to the fact that both `t->u.user.name`
> and `name` share the same size.
> 
> Signed-off-by: Justin Stitt <justinstitt@google.com>
> 
> ---
> Here's an example of what happens when dest and src share same size:
> |  #define MAXLEN 5
> |  char dest[MAXLEN];
> |  const char *src = "hello";
> |  strncpy(dest, src, MAXLEN); // -> should use strscpy()
> |  // dest is now not NUL-terminated
> ---
>  net/netfilter/x_tables.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index 470282cf3fae..714a38ec9055 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -768,7 +768,7 @@ void xt_compat_match_from_user(struct xt_entry_match *m, void **dstptr,
>  	m->u.user.match_size = msize;
>  	strscpy(name, match->name, sizeof(name));
>  	module_put(match->me);
> -	strncpy(m->u.user.name, name, sizeof(m->u.user.name));
> +	strscpy(m->u.user.name, name, sizeof(m->u.user.name));

Two hints here are that this is dealing with user-space memory copies, so
NUL-padding is needed (i.e. don't leak memory contents), and immediately
above is a strscpy() already, which means there is likely some reason
strncpy() is needed (i.e.  padding).

-- 
Kees Cook
