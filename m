Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F81AC04A6A
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Aug 2023 19:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbjHJTHp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 15:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235428AbjHJTHo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 15:07:44 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3722D4A
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Aug 2023 12:07:40 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1bbbbb77b38so9494585ad.3
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Aug 2023 12:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1691694460; x=1692299260;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nmOwYu+wAsqoAkxbWGneNadnCgLM0c5R8LClfgUNH9I=;
        b=QkOkm0aFedzWAtuNszKzcm0KrHyY4YEWT0ltIriL5dNGRCGtKtfbjQGZDoRu8PHTGL
         2q19rGzd320iFiPEMeYLLVjDrO+n8xsOaMVVVB1p6UAnbmbd6CBz92szKDrxxgg9pRQn
         Rn8S9Iw75DpdEDSpYWSO36hoPOuxO4htgB28E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691694460; x=1692299260;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nmOwYu+wAsqoAkxbWGneNadnCgLM0c5R8LClfgUNH9I=;
        b=bXpa2fZPKZxXitwZ2FoQeMxCyKnT7DfP67W0ahbZfSir3kZf9PT/Pe7+iEINev2yTt
         HIrkVHru+V8A3OYw+vJhn3iJdl6nGPSO1SHJ0R2dJDt/CRckj59p+Hn2w9fVk+c4Bhsu
         NQ5WgHa2+LMeo8105KpEDKbxnKEh0vDmilQxIvJxkYqiwWiCIYxdVk7LJ2rBB0pre8QG
         S4Lm4NDyq/xyRrmMC8tpqZtTKcoQQGQ1fFFoTIY+GmMLjasiDLUgzVQylGiQ50CNwRYT
         IWrw7B3f+jFECq9Zil0DhfePe6lFyj70B/ca4X19rQMzx9ibaeddJroeXum48/ypqfOt
         Efbw==
X-Gm-Message-State: AOJu0Yy2ZKiMJtGCNOl1wS44pRFcVyskxO+mSxbR2on4CWdcPTBvAyKL
        53FA+17c6wkWs2Rm4ZmyaNz4uw==
X-Google-Smtp-Source: AGHT+IEmgnGLrUOSbaCk2ycL3uzAZ+J06bwEXpv2ztZy56vch26GG8o6dUtXoEcAdUqVf+nIc0tC+A==
X-Received: by 2002:a17:902:d4c3:b0:1bb:bc6d:457 with SMTP id o3-20020a170902d4c300b001bbbc6d0457mr3391924plg.36.1691694460449;
        Thu, 10 Aug 2023 12:07:40 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id r2-20020a170902be0200b001bbbbda70ccsm2134447pls.158.2023.08.10.12.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 12:07:39 -0700 (PDT)
Date:   Thu, 10 Aug 2023 12:07:39 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Justin Stitt <justinstitt@google.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-hardening@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/7] netfilter: ipset: refactor deprecated strncpy
Message-ID: <202308101206.35C628E5@keescook>
References: <20230809-net-netfilter-v2-0-5847d707ec0a@google.com>
 <20230809-net-netfilter-v2-1-5847d707ec0a@google.com>
 <20230809201926.GA3325@breakpoint.cc>
 <CAFhGd8oNsGEAmSYs4H3ppm1t2DrD8Br5wwg+VuNtwfoOA_-64A@mail.gmail.com>
 <q49499n7-54p3-1soo-8s83-7p84724o08p7@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <q49499n7-54p3-1soo-8s83-7p84724o08p7@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 09, 2023 at 11:54:48PM +0200, Jan Engelhardt wrote:
> 
> On Wednesday 2023-08-09 23:40, Justin Stitt wrote:
> >On Wed, Aug 9, 2023 at 1:19 PM Florian Westphal <fw@strlen.de> wrote:
> >>
> >> Justin Stitt <justinstitt@google.com> wrote:
> >> > Use `strscpy_pad` instead of `strncpy`.
> >>
> >> I don't think that any of these need zero-padding.
> >It's a more consistent change with the rest of the series and I don't
> >believe it has much different behavior to `strncpy` (other than
> >NUL-termination) as that will continue to pad to `n` as well.
> >
> >Do you think the `_pad` for 1/7, 6/7 and 7/7 should be changed back to
> >`strscpy` in a v3? I really am shooting in the dark as it is quite
> >hard to tell whether or not a buffer is expected to be NUL-padded or
> >not.
> 
> I don't recall either NF userspace or kernelspace code doing memcmp
> with name-like fields, so padding should not be strictly needed.

My only concern with padding is just to make sure any buffers copied to
userspace have been zeroed. I would need to take a close look at how
buffers are passed around here to know for sure...

-- 
Kees Cook
