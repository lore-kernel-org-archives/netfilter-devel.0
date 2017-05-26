From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf-next 7/9] netfilter: nf_tables: allow large allocations
 for new sets
Date: Fri, 26 May 2017 18:02:34 +0800
Message-ID: <CAML_gOcajZUmbsFb56BFwAFe-hje-jT3nvF3A99JOg9khTMMdA@mail.gmail.com>
References: <1495619453-22307-1-git-send-email-pablo@netfilter.org> <1495619453-22307-8-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f180.google.com ([209.85.217.180]:34460 "EHLO
        mail-ua0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756588AbdEZKCk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 May 2017 06:02:40 -0400
Received: by mail-ua0-f180.google.com with SMTP id u10so3374633uaf.1
        for <netfilter-devel@vger.kernel.org>; Fri, 26 May 2017 03:02:40 -0700 (PDT)
In-Reply-To: <1495619453-22307-8-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2017-05-24 17:50 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
[...]
> -       err = -ENOMEM;
> -       set = kzalloc(sizeof(*set) + size + udlen, GFP_KERNEL);
> +       alloc_size = sizeof(*set) + size + udlen;
> +       if (alloc_size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER))
> +               set = kzalloc(alloc_size, GFP_KERNEL | __GFP_NOWARN |
> +                                         __GFP_NORETRY);
>         if (set == NULL)
> +               set = vzalloc(alloc_size);

I think maybe we can use "set = kvzalloc(alloc_size, GFP_KERNEL);" to simplify
the above codes.
