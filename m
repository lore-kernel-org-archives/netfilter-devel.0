Return-Path: <SRS0=Lm+H=63=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF33C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 16:29:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C97C72054F
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 16:29:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sl4294rl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389597AbgEMQ3U (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 May 2020 12:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730731AbgEMQ3T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 May 2020 12:29:19 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A972C061A0E
        for <netfilter-devel@vger.kernel.org>; Wed, 13 May 2020 09:29:18 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id n11so273251ilj.4
        for <netfilter-devel@vger.kernel.org>; Wed, 13 May 2020 09:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u51Ie3hxAKPu1qbArRB4HGjjejkk5lYjufdOHA0vJws=;
        b=sl4294rl0ziF7iRGRKbjVmcmV1+TL81FMJU0HJhYAceWuVWN/1Hu8BAgasC1Pzlyze
         iDauye8ghZYuPf+/EWuUqpKS9FPtqsf+SZ3cGvRZJdb/zMt88x2k+HNWrWLCZsj/IZeE
         NVPPZwa/hBCizPDkAI5yBqWjhkwz7U9wN6pRZ8znJ94wsPrNdb5NMBM5h9jy+XoqaKcu
         KV7Ar7k6dvQws5rPgmELah4pLWggy4d6PO9U4v0I9dZzx3CoXuJs2D/Z+RCX7kJrw0Dp
         Z76FbuZYx0wvNOI5CnkMRvjuupbm1En1F8e9FnIGW0AWcSeUI/tYo16rT8sf1ESxMOq9
         j0og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u51Ie3hxAKPu1qbArRB4HGjjejkk5lYjufdOHA0vJws=;
        b=s1/Kc1Hv3G9g+6qfQTFjbjbOesB3RH+pcJyu7ogDr7/Y6NXQMhN1GSqN1L7JjQigDT
         0qkFosVlnwNj/9hMJSypBZr5p5SVJ1Y8xVvMunQJdbbUTO8bAMw86011F7iyVtj8EVm/
         8ZWn1IOUzIDN1Yy7oTtH9AmOC3L7vLdIdvYG2hYzVn1yhO+AP4rtWYeBiOkW+FV87u33
         GNEd4pwquxQXmXePY6VWjDBdbdEmhnbGHrbfrE6ezj0Ir7oiwLoqqbOAPc1KxH49xxiu
         IJIo1/nBE9hmUL548FRB5oWq4MjOIX/5NF/ef6VswFDB5nI4xt6sbpHY4SoBGTDIYaRY
         4sig==
X-Gm-Message-State: AOAM5315nnEeg7bR4F8jISOteLScXlOaipaQw4CcttlT+4M1mWChrzqE
        +BZldJFPeTrGKrfoYWC7MONHXj1RU4ALU6i5Xj64Dg==
X-Google-Smtp-Source: ABdhPJzYLxVVXf+n6CL/Szt7SA0ZEqYbJBye1HUm+xogk/LS1J1ffGLd9GGxHIyu2SuVzCEPELcUXLRTpqyKWxTecls=
X-Received: by 2002:a05:6e02:544:: with SMTP id i4mr259501ils.145.1589387356960;
 Wed, 13 May 2020 09:29:16 -0700 (PDT)
MIME-Version: 1.0
References: <CANP3RGfNH1m=-rFdkAmGUt3vxFqaGmJnW+RKP-faU6WwOKWoZg@mail.gmail.com>
 <20200513093944.9752-1-jengelh@inai.de>
In-Reply-To: <20200513093944.9752-1-jengelh@inai.de>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Wed, 13 May 2020 09:29:05 -0700
Message-ID: <CANP3RGdUALH97LB2jHryrFsGYq=h2xwDTVRWuaG_-H-9squsXg@mail.gmail.com>
Subject: Re: [PATCH v4] doc: document danger of applying REJECT to INVALID CTs
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux NetDev <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Apparently no, did you send the wrong patch?
But since you'll have to resend again, 2 more minor stylistic comments.

> +P_2 being succesful in reaching its destination and advancing the connection
successful

> +state normally. It is conceivable that the late-arriving P may be considered to
> +be not associated with any connection tracking entry. Generating a reject
s/be not/not be/ is probably better

> +only DROP these.
would 'those' be better?

> +P_2 being succesful in reaching its destination and advancing the connection
ditto
