Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C44DAC46CC7
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Nov 2023 23:04:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbjKNXE5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Nov 2023 18:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjKNXE4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Nov 2023 18:04:56 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A18FD2
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Nov 2023 15:04:53 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-28035cf6a30so5243742a91.3
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Nov 2023 15:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700003092; x=1700607892; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QRGfFV/08xkfUG2VQcu+cgAkHB1GFi9yAVO6n8qKxtw=;
        b=NRb3CssAmhXazrLPaXOxpuqo8cgtdxBXMJo8dKdemXZECl8XEqF5ILzLolC5WOjX0u
         p9GLQzLa8odNRJTpZWFEpGe0r2UVxLvItbKePiFByiNlVXjcKmIw5bbvk9j3eDvKewZK
         2UhEBe/rMaOeEiizwk1WB6coL5hafArdXifAsp6ztaJkP5VDyla7wA3UOR5+xVxFPxCF
         fhdB0ZDhla7VXhvs/YfTK++5KrG6UzNNHqULMtGAGSXG3Qzx68c0pGK2zstfuHo1GTDz
         1HGknL+9xrCwDvj6GBZ7gGzcv83MN1LSIGpEIVZe9gMS7xvmBP88vz4Hs4yPJRkvAQhQ
         yZEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700003092; x=1700607892;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QRGfFV/08xkfUG2VQcu+cgAkHB1GFi9yAVO6n8qKxtw=;
        b=mfGLPmsJyMmsnJvmqusM2IdCF5O7aj/qxE4Y1vE1jrHQXX+q1oV4UAhUmpjYKL195C
         81IHiHAZmvETZWX+LcDFuWq0r9SeCckCo1zj9xdNlFohdMjd+hvgfdpWZBotseBkl3h7
         SO5EFHeTs4acQ3wAAya7Mts/JwvFm71IqXabgO34yz5p+0ZeFSFxtmdA4+1n4CGx1R6y
         3Xa2mpQjcGHWowDHxEqjBve7LARTdgDJRBX0gGvruXeJo5Q7Cc/NCnaWmQHD+MPG240P
         TOIgBW5cPdj/BCQ0VlABFOVf0ByDDhHJ9ew85qoYYyS0LvJVwMxk9IoaKpj9QIg6mTbQ
         lExg==
X-Gm-Message-State: AOJu0Ywz4ESmvz83dOV6P82DAsY8ZGQ1YQAb+1oJa+46SMSUx/oMf02u
        +y/zbGjrwMPjDoCYuNNJoa6s1Ow2RGE=
X-Google-Smtp-Source: AGHT+IHehLQeq7iGUGceuqwrKHsNgfrbpWzSbUoMiixfie3AP9+SOmQUMJJw4NATIamdez8S8lWgdQ==
X-Received: by 2002:a17:90b:4b90:b0:281:554d:b317 with SMTP id lr16-20020a17090b4b9000b00281554db317mr9237444pjb.38.1700003092439;
        Tue, 14 Nov 2023 15:04:52 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id ha24-20020a17090af3d800b002776288537fsm5691934pjb.53.2023.11.14.15.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 15:04:52 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Wed, 15 Nov 2023 10:04:47 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: libnfnetlink dependency elimination (doc)
Message-ID: <ZVP9D9KPgMkxLiB/@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20231112065922.3414-1-duncan_roe@optusnet.com.au>
 <ZVORGxjxolo3vnz1@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZVORGxjxolo3vnz1@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, Nov 14, 2023 at 04:24:11PM +0100, Pablo Neira Ayuso wrote:
> On Sun, Nov 12, 2023 at 05:59:21PM +1100, Duncan Roe wrote:
> > Some of these documented changes haven't happened yet.
>
> Then we have to start by changes first, not the other way around.

Yes I know that, obviously:)

The point here is that nfnl_rcvbufsiz() has been advertised in the main page of
libnetfilter_queue HTML for a long time and there are likely a number of systems
out there that use it. When libnfnetlink is removed, libnetfilter_queue will
have to provide nfnl_rcvbufsiz() or those systems will start failing.

I have in mind that although libnetfilter_queue will provide nfnl_rcvbufsiz(),
there will be no documentation for it.

You will see in
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20231112065922.3414-2-duncan_roe@optusnet.com.au/
I replaced the advice to use nfnl_rcvbufsiz() (in 2 places) with advice to use
setsocketopt(). I only mentioned that programs calling nfnl_rcvbufsiz() will
continue to run.

So I offered this patch as the only documentation of how to use
nfnl_rcvbufsiz(). I need it for my testing, but it's fine with me if you don't
want to take it.

Cheers ... Duncan.
