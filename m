Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3A2C001E0
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Aug 2023 21:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbjHIVkz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Aug 2023 17:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232435AbjHIVky (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Aug 2023 17:40:54 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBB91BFB
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Aug 2023 14:40:53 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-99c4923195dso41261666b.2
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Aug 2023 14:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691617252; x=1692222052;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iDXCpn35Ad7J9f0GEXMuzOeFfEoO9YYwjjKca2hgV+s=;
        b=1l6WWpjTsrbthqxhqFGUE8vjdistC/b68tPuqorgdfs9jwlQbok4bWgV5WSKec9y3j
         4KZRPqOwBNt7ekYP8bPwGHCegv/pb40YWXzlPOQZL7SYPw+UB8TH8bc7AwjwOlTGWmTb
         1k1y3vCIcXfIlcOcIfY9lvJsbvf0745T0vsVX0j4dOp2ChfqhSKVQhqQGY0AVGj45k1q
         P49NZVxzeDswm3Cg3rGPuPlVfj6zIdq8uRCY3qDy9rjZJTb6VbDOnWz0llsfbErm/x0B
         GcQsXjrob1op8XZkdMoGgrBV0Njc19OsCegP0BOkcYFsDSvlmmWfTnj1k0jHKNpjNzgC
         LrSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691617252; x=1692222052;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iDXCpn35Ad7J9f0GEXMuzOeFfEoO9YYwjjKca2hgV+s=;
        b=ZCvyXXnjejNpS3HFTO1Iynb6u3sNYPY+nIo4Hrop3c2nBJtFghG42Z+ZNbpEwYkGq5
         jOYs/4X/kS6Mp9l//8CctSstYWgnGS8qBxzuI8fBge7L3Pz/MMoxeDMg2xiJYIAlyocb
         0i2E59oD40Jrw08YQCVXwDLW32bDLoHN/6uBXMJtK4giA4lT3TTgB9N/DtqVYybo9Wl9
         MQM3aaTyDN2JXpFMYi8+DyJc6/ZS02tDk5NsMsEqMTSA97yugxiGM25J3a0OuaE+QhI/
         7uFgtZgGrHCIphbT0Spa5u5CweXRlIN1kFBx1X3NTsspZvvNRQNpSrLVZ6pBtS6buK8i
         XGTQ==
X-Gm-Message-State: AOJu0Yw6dW65KX1KeL+in3svrsyuxutl/djg63hA7q2NyN6gxQtOmGZm
        QIJ3RU2VyNNc5xrcgcPyTdkmQ6KC4MhIUeLIvhlMjA==
X-Google-Smtp-Source: AGHT+IFZ3NZAFSyxJj8icElVTaEEzHs0mTmf5HaiCvahAmIMW6IV58Wp/pOQOKWT3GQpfjDAato2Bd0/2ySUKL6nrTc=
X-Received: by 2002:a17:907:788c:b0:99b:bc51:8ca3 with SMTP id
 ku12-20020a170907788c00b0099bbc518ca3mr323484ejc.1.1691617252270; Wed, 09 Aug
 2023 14:40:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230809-net-netfilter-v2-0-5847d707ec0a@google.com>
 <20230809-net-netfilter-v2-1-5847d707ec0a@google.com> <20230809201926.GA3325@breakpoint.cc>
In-Reply-To: <20230809201926.GA3325@breakpoint.cc>
From:   Justin Stitt <justinstitt@google.com>
Date:   Wed, 9 Aug 2023 14:40:39 -0700
Message-ID: <CAFhGd8oNsGEAmSYs4H3ppm1t2DrD8Br5wwg+VuNtwfoOA_-64A@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] netfilter: ipset: refactor deprecated strncpy
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 9, 2023 at 1:19=E2=80=AFPM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Justin Stitt <justinstitt@google.com> wrote:
> > Use `strscpy_pad` instead of `strncpy`.
>
> I don't think that any of these need zero-padding.
It's a more consistent change with the rest of the series and I don't
believe it has much different behavior to `strncpy` (other than
NUL-termination) as that will continue to pad to `n` as well.

Do you think the `_pad` for 1/7, 6/7 and 7/7 should be changed back to
`strscpy` in a v3? I really am shooting in the dark as it is quite
hard to tell whether or not a buffer is expected to be NUL-padded or
not.
