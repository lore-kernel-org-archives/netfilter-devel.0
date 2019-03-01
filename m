Return-Path: <SRS0=xc7Z=RE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 693B6C43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 10:43:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E56A2087E
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 10:43:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PV55fjs9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbfCAKn6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Mar 2019 05:43:58 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:50745 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbfCAKn5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Mar 2019 05:43:57 -0500
Received: by mail-it1-f194.google.com with SMTP id m137so19472172ita.0
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Mar 2019 02:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xUTBgPVR9CUfxFXHCwKcDn+kxgDOp/LqKR3eZEXZXLU=;
        b=PV55fjs9rgMFomkm8y8Ea2t+uO7dMqnHnuTSnQY3gD/abhj2sme4yH4aGaubE2INuu
         NJpLGlxxnx/dfQJrevqwQ1bkQR0MvkJA9ZzrOm0LjNwGt0SZcPJH0DvOOlmDM3vGozsE
         gwlnRmwTnjQQlwWgIcA+wCgaaQLmURI/BkqGSIR0kKFybqNxPs6yC46MKJktyvYI9BrP
         xoKArowbpNPCarWCDoEbYIaxe9L//z/PrsgJ5jNVILyhALMVut9d4fs8x2mKGsalq1ca
         jRDmJlSCzknR9BjiAPCfmMllapbiB8VyVBPOQ8sj8UkU5+zNVVhfIASgaf4rK1wBFDih
         0zZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xUTBgPVR9CUfxFXHCwKcDn+kxgDOp/LqKR3eZEXZXLU=;
        b=iFc/ivb0fYPT4h9BulTSkBKeRJbbUewD+Q8f3VFqKcIURNMucHYrYBWsG9jXwGcaJ0
         BLOObFLYrmyFGzTtbPJuIBJIzWIerIlSKdVB5Z+k/J5sb0vyD/8FjxiQicRsenVDx4yY
         ntfWdJSwtGbCUwZLU+4FaqAugbYNuEndNXHgLTy8Tm+8Z5ORYTz8nt5StDvuIGTzpRe9
         KizDVPAFWHBMCcwAp4GpJINv8Mkcz96z/dMehlec+os+uDqPO1RL6ftoXl1skNoz8XSQ
         XjWylFnW2q8qYVwzZCTES870/kq2sih86jA2JwGFpRZRitnD77QEzHvbu1M0Oq3FaHSb
         Kmjw==
X-Gm-Message-State: AHQUAuYIPpEgvUtu/WDSEQs/kIT/EZ6n5bfsCI4yO4T5PvAGwZH+xars
        CBhhlWcnwWGDNJvFLVMRB0zm1Qy7oeAxJi0LBxA=
X-Google-Smtp-Source: AHgI3IZwVqDkquCtZbVkWRt81TQlsYl4hcF1oYWh2upJCGanO9URZMyV6e2RAD6MGgM1rw1WYu6+tN9Dp0TyE85/Yuw=
X-Received: by 2002:a24:328c:: with SMTP id j134mr2970724ita.71.1551437036657;
 Fri, 01 Mar 2019 02:43:56 -0800 (PST)
MIME-Version: 1.0
References: <20190301092401.GA17755@nebula>
In-Reply-To: <20190301092401.GA17755@nebula>
From:   Karuna Grewal <karunagrewal98@gmail.com>
Date:   Fri, 1 Mar 2019 16:13:44 +0530
Message-ID: <CAHRz_yYbpvjwjrL7kgvXyJjFrStQPHkK2mZC=UwbdbzrxYv9ow@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nft_meta: Extend support for NFT_META_TSTAMP_NS
To:     pablo@netfilter.org, arturo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 1, 2019 at 2:54 PM Karuna Grewal <karunagrewal98@gmail.com> wrote:
>
> Meta evaluation function is extended to suport NFT_META_TSTAMP_NS option
> by exposing the 64 bit timestamp of the packet to two 32 bit registers.
> + * @NFT_META_TSTAMP_NS: packet arriavl time (skb->tstamp)
>   */
Please disregard this patch due to the trivial mistake which I've
fixed in the latest version.
