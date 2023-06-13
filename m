Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81CD8EB64D8
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Jun 2023 19:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbjFMT0i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Jun 2023 15:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjFMT0f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Jun 2023 15:26:35 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F95E19F
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Jun 2023 12:26:29 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-25bba0692edso2012226a91.2
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Jun 2023 12:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1686684389; x=1689276389;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+SosEkKxrJ4iAWZXd5DjfQpM6I+3FcUNGS4ZB6BQj4A=;
        b=JdzTuCqkydZaMrlBB6HTchxSO433vMvvLmkR4+JQpTxqGXNu1MkqdKezS1kWnXeC1Q
         grWqoJ4OFbqkQarU9txPOzOt9IXUAlOrWIE+XgJGBzLtDYyifdcngX8QR/fZVRlL/+vX
         rDkjGqQQ/sbh8tygrKUmbTadtIv4M6LPXRaLA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686684389; x=1689276389;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+SosEkKxrJ4iAWZXd5DjfQpM6I+3FcUNGS4ZB6BQj4A=;
        b=CP+0yLPw69hUgWBpeQT1ZAi2w0189YyqH2mwwtflljxZ3rzNnLBfvM3V5EOrxtxQbk
         elanqM41403I9e2wjXOwEhTcISwQt8/xjGFoj8+8c2AwFMVky8kOl2TkPkcDCmsoCG8M
         8fI2e7uSUjlOcscMgTabqOD1xfLxgBDDz6mfCoKBjZU7VsZnrVw940XpUEi84yqSCScY
         JIHDlxef79VrDH7HvGekmEim2SsbPhf+/pYUwB5mq47TB7Sby+Hf20BT4myRfZf2j3OP
         a22WyzvYLcw33wnpqI6Whmsv33wCjZPFp+Ht73AySnhHU5VsLQ8Q5pCmKqM0Qb8ADvF9
         9URA==
X-Gm-Message-State: AC+VfDxEK0Z4U9zqxogty9SymmgFnrepV9fxJ4WmAkIfKlp8k9059VJs
        cwHVkqZv0k3nSa5c0Kw3Cwmxqw==
X-Google-Smtp-Source: ACHHUZ44VzTwH+0xXpJiQxXjGR6yiAwRkrzjcnEdzxWQzJhz/bD17uN1IGN7Ir14/V9fVnunMHnE4A==
X-Received: by 2002:a17:90b:4f44:b0:253:727e:4b41 with SMTP id pj4-20020a17090b4f4400b00253727e4b41mr10151302pjb.34.1686684388826;
        Tue, 13 Jun 2023 12:26:28 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id s64-20020a635e43000000b0053efc8ac7e9sm9724096pgb.29.2023.06.13.12.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 12:26:28 -0700 (PDT)
Date:   Tue, 13 Jun 2023 12:26:28 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Azeem Shaikh <azeemshaikh38@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        linux-hardening@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: ipset: Replace strlcpy with strscpy
Message-ID: <202306131225.6EADAF4@keescook>
References: <20230613003437.3538694-1-azeemshaikh38@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613003437.3538694-1-azeemshaikh38@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 13, 2023 at 12:34:37AM +0000, Azeem Shaikh wrote:
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
> 
> Direct replacement is safe here since return value from all
> callers of STRLCPY macro were ignored.

Yeah, the macro name is probably not super helpful here. It seems like
it should have originally be named IFNAME_CPY or something.

> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
> 
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>

But, regardless:

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
