Return-Path: <SRS0=rZfM=6X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D4DCC54E4A
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 May 2020 21:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDB7820708
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 May 2020 21:29:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DS//8w5Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgEIV3J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 May 2020 17:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbgEIV3I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 May 2020 17:29:08 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D94C061A0C
        for <netfilter-devel@vger.kernel.org>; Sat,  9 May 2020 14:29:08 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t12so4830295ile.9
        for <netfilter-devel@vger.kernel.org>; Sat, 09 May 2020 14:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/r+mneobwGheJFxkeH99ObM6GjbUjQh3TKRKScwkSHE=;
        b=DS//8w5QxBS9p8LFqc/CK79rczOOiOteVXP3u/qUQUV8Kn8BNjE+ioWkGw03RGIgHy
         7vzzHd0sx1H1Fd/Iij56UWvjV8zVOhU2KjcqnMpk/RhLhJD/Khy9qfWhSgHcjLu9P2yG
         GvIsSkI7hXb0keuWDGLWhD/15WqJYhXQ7IbO8YtGLzdpuIgu4dbqriH9yaXwjvPW89Cf
         vu7jHisinXwQpHGQSUHF8kZY345vq5EMvIYUluC3GSkNgom3VpKwoSG6SxQVDfqLOnWl
         1sEAR6x8Wvo1EDoSGfvgyCgL0VtMXaxjLL/FPYYS8J64aXOJCjssE3NXI7A/MJWFEhSY
         IEQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/r+mneobwGheJFxkeH99ObM6GjbUjQh3TKRKScwkSHE=;
        b=LAurf5yriusTzRmRgwI9HyTwn7Y31oNhyMa+c4Xrx3oazBiYYYZg4wsxwhCJz1pGZf
         /hSQKIFevCbPzB1OaJjO/R8kN05PrJnG+NIj6H/4zB7AqGq6MhfBo57B0kylgje5zgM/
         IpD+Yds357e71PgUhQaOC/09D2tAjC+gmTd6UR//nz7zpNuGIDWTADd8oozrmFwVCwO4
         TKoJCv9TQ3Z+hOfDoqF/G+VuGwvQImZKXyDr/nQ0bjCcOu99GoSRv0zqVhcv01vMpGM0
         EnROdyiUS9CNZIEBfK1gnRTF2CLbWZoyok9Qj/aM5A/ONdHbQXzdfpN5V1MkjFEGJ7uR
         1Dig==
X-Gm-Message-State: AGi0PuaFkWvk8o9nbM/qVO9cucyqpQncn1oc5dYEsbGlZQ+0Wnnc+yid
        eunwy96OKVYjOuS8O4XQxRg5j+7PBEbyHMnoi9klyA==
X-Google-Smtp-Source: APiQypKup595uKk5SGg8Thg2wE/gnspaYFn9WOvzGSPAYkzwqUoy16ANh2vBrhqbQc9918q9bfTzwrMZOkIq0FsD3OQ=
X-Received: by 2002:a05:6e02:4c4:: with SMTP id f4mr6158424ils.278.1589059747871;
 Sat, 09 May 2020 14:29:07 -0700 (PDT)
MIME-Version: 1.0
References: <CANP3RGeL_VuCChw=YX5W0kenmXctMY0ROoxPYe_nRnuemaWUfg@mail.gmail.com>
 <20200509211744.8363-1-jengelh@inai.de>
In-Reply-To: <20200509211744.8363-1-jengelh@inai.de>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Sat, 9 May 2020 14:28:55 -0700
Message-ID: <CANP3RGe3fnCwj5NUxKu4VDcw=_95yNkCiC2Y4L9otJS1Hnyd-g@mail.gmail.com>
Subject: Re: [PATCH] doc: document danger of applying REJECT to INVALID CTs
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

I *think* that your talk of 3 packets is not needed, ie. the initial
delayed packet doesn't have to be a retransmission.
It can be the first copy of that segment that gets massively delayed
and arrives late and causes problems,
by virtue of arriving after the retransmission already caused the
connection to move on.

Other than that this does seem perhaps a bit cleared than what I wrote.
