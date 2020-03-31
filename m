Return-Path: <SRS0=TvDw=5Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3901C43331
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Mar 2020 16:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92B35212CC
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Mar 2020 16:41:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m+WZnXE5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730923AbgCaQly (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Mar 2020 12:41:54 -0400
Received: from mail-vk1-f195.google.com ([209.85.221.195]:33674 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730543AbgCaQlx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Mar 2020 12:41:53 -0400
Received: by mail-vk1-f195.google.com with SMTP id f63so5886201vkh.0
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 09:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wCYQayx3iX0110qvIb2aGvmYrLe1/2odpUqnIm574ns=;
        b=m+WZnXE5bRETadPsiXWXKge74C3dQ5nxbKdMN3v6vlg0CaF3DMlbfLuaAdt/sRy+od
         IVf1Gz2Je92mAd0HInFZe8NVLszBKdaMB3O0+49l9DCcUstSoaV5UQmVoLUw/MGomKvq
         zKSxpJSEbpUjP7y5WEt5X/RasCqeUKZczcDeo4VS/hwd90APWIb/6fRTRE/PCOZF5CS9
         r583RJri0B6XFS/mBSmjGUmB0zmA6Uqd82aL+2384Q02dLDIwD8oWLnnKBmGGyjg0yZk
         jiKmoHcCLERCBLJXgQeI/bYsb3+6uOvVA7SoHnp8U5ZTyCCu+JwYdnCBcyi+tjEXSxo5
         6vuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wCYQayx3iX0110qvIb2aGvmYrLe1/2odpUqnIm574ns=;
        b=JSg8gFcTLYKUVpnDAMk1VSOcCS8qVZ4kZRT9jmbFGeFeBN0ESWHOoCBi+6s9gjZJJV
         pcchqzv2YM/mIGxz2VAQtx/YoJoaGXodWmrWYbLLREdPOM1iAlX2uBVp3eQCnCzl+lsb
         QDYonsd+euS/9zN/K47u9zlWxpCx2GjMpmoqZvdFvvwl5gLJnxKu1GCH0WkP6vuVImfh
         aYYSi15CIGhfqdxkYU1yIP/zr5Zx9uJKyds6bSCdxCb7eWs+dxEcX2x/qGxk+/i0z0Py
         Wf7JWE5oYHSV/pcAJuVjDcyHrKFkkLZWjpwcnPBue+z0hAzvm1Sq1/Ugi52XXGwfS+5W
         Lgdg==
X-Gm-Message-State: AGi0Pubm8vJo7jhRE9vmibDuApQvLbyUkUfr3GOn21BFsmYRWvAydKSY
        UfN0IlEj70Y4VU0+K+NDeF5sj7zdz+M1NbY3gerrT0lwCeo=
X-Google-Smtp-Source: APiQypJ3gV/E5ItMhiCjFWxTulmpoFYSBjhtX1yaCeVz0MjK0BxEQnUzKTzryis3e8S673j+zHAlRPTKTyX9K8Q0ILo=
X-Received: by 2002:a1f:9645:: with SMTP id y66mr12207504vkd.56.1585672911223;
 Tue, 31 Mar 2020 09:41:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200331163559.132240-1-zenczykowski@gmail.com> <20200331163904.ilucynm3brvgfezw@salvia>
In-Reply-To: <20200331163904.ilucynm3brvgfezw@salvia>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 31 Mar 2020 09:41:39 -0700
Message-ID: <CANP3RGf5Y=-GX=b=jWURaBdDvey0zb-_MkXj6W+TWtRvM4C3sw@mail.gmail.com>
Subject: Re: [PATCH] netfilter: IDLETIMER target v1 - match Android layout
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

By client code do you mean code for the iptables userspace binary?
