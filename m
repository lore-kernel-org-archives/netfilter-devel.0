Return-Path: <SRS0=NFxu=6Z=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B6BC47255
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 May 2020 15:40:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9FB5206E6
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 May 2020 15:40:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BYLl8csg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730362AbgEKPk7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 May 2020 11:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727994AbgEKPk7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 May 2020 11:40:59 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE128C061A0E
        for <netfilter-devel@vger.kernel.org>; Mon, 11 May 2020 08:40:58 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id f3so10202508ioj.1
        for <netfilter-devel@vger.kernel.org>; Mon, 11 May 2020 08:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9CCSGXafHVSnIXhbAh+LGQBsCZa4Z8BhGBIa+lgcjmo=;
        b=BYLl8csgC5nReFg7N3q4ELadcsyXiDNkVzsG4HvR9AqlK+JUqlzeuT2lX0FSRXGkHj
         lGza0Xp6BmHZ109hvF/K5T/zuPL3tgMem8fX//QTHI31ZmvEv0tVh3eLMr5IP7/giAHd
         q3FKxbViL0k/V9OMs7iwNW4c6JlV7NT4hNHIz04avooKeHpjQ3dRjuhSa3s01Nh0EM8C
         FI7qLwJsGbyf81xUpliQyRmsZKPYjco0xcS8JhHV3jFmgnNsXP68YD6B2ysclU1Ucyfd
         jvVns+k9LNNv+Isq5lGJvZpAL+n+eGjotP9w0ku9IEMl63MMWLfYpkIc4h24TnSz3Q/3
         ilsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9CCSGXafHVSnIXhbAh+LGQBsCZa4Z8BhGBIa+lgcjmo=;
        b=f6AUidmhrLIYk6ayjD0h1RplRN1YJET9CuUNabBJwezrPKUJwbm+Zmmti9qYY1jlEe
         Wh2AK1RXX6X98W0P6zvAL9KOklh45hu0D5zk16JQtQHdo+STNxLaEtNvdHCMdA23IX5i
         V2uDAXzY/X9I5cWsuhbatEwSoUh6D4dJWLGVss08dUh9xpABQ82dukiWcwcdhbe6W6Cz
         K9Ls4bdv8pghL9GS4h+E89AmrrxII41sAXg0h8yLy4YtNw1BCuq6wxdrCt6tz5qg3i9r
         Ctom3YUrCJKSzRvsyFXO/TSxornYa6KJmgORoNYmLhFddUqB4lS+TBKHbjiBLKymUFwe
         smww==
X-Gm-Message-State: AGi0Pua7TznEzSBJ+56wy/ruXtgOQuqmArCWfRMAwjHnQe4Snzl0PynV
        TruYeY7A1hCyqQMU6G9uNHJa+H9tUB82uPu8VUJBkw==
X-Google-Smtp-Source: APiQypLw4pFm0gM+89b/L4vgjIctDDr+fTS97FGEkMZEn+FZUe6C/Xtd+WzATfGPrjkNruF1SibKdj3ZMQqc/ssM+UM=
X-Received: by 2002:a6b:d219:: with SMTP id q25mr15850901iob.202.1589211658061;
 Mon, 11 May 2020 08:40:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200421081542.108296-1-zenczykowski@gmail.com> <20200511121053.GA22168@salvia>
In-Reply-To: <20200511121053.GA22168@salvia>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Mon, 11 May 2020 08:40:46 -0700
Message-ID: <CANP3RGeEK7j_6LH5e2czMcDRR4xo79rnGh4euSLPvojrLE8d4g@mail.gmail.com>
Subject: Re: [PATCH] iptables: flush stdout after every verbose log.
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

> Applied, thanks for explaning.

You're welcome!
