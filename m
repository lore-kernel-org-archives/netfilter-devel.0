Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF965C433DB
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Feb 2021 14:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADAC964F55
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Feb 2021 14:46:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234431AbhBBOpe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Feb 2021 09:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234558AbhBBOgd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Feb 2021 09:36:33 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22138C06178C
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Feb 2021 06:34:50 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id d6so19243981ilo.6
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Feb 2021 06:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bxl73venaa9cWERoVp0VscHZS3/IH5lSgUJLT8Av3Oc=;
        b=d5yDUwK8kbyroVDcNrW9Bed9kahFje2ZIU0BDehuW5DzhPmTw6AKATlvIgrv3J4sup
         aIo/FiNf8JoT4Hc5Hak+mLJocFm+sU/u992MZHifR/Vk1Vy162sQeLOaHALCaNiJbGRo
         OML/GI0PIO+UdFLcZ8smRhAhPEB81uhDI1ArrGScpj4MY6sy6aHAFWoy7FYSsBM4zZ8y
         BasAXhEgwWcGYwtGMAoiGGjfmc51b8AlNJGIgeBrkF+i00WuUU55rrkEzAbaCoaooN1y
         L9wDlcTrJVC2mJ9uCebXrUMygqRdWMyoY4OOn+vTf+7KKYGSCcbjpUs1+bjIJQtN65xg
         Nfyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bxl73venaa9cWERoVp0VscHZS3/IH5lSgUJLT8Av3Oc=;
        b=t0Gz5tWXYixgiWToXJE5D7zeq4wYZCrQ3zV1ZlUkW8/FFAwtMTFJYqFgiA0ZLDbuUk
         GXiIsDzkp0Ej2gQ5dmG/73M3Akc7O39fD+sqik9W8Pfy23lER3CZLGpL5ZXp6Jz9Wc48
         C1jJSlXotSBxju6Y8COhEqjclS38LkvHuQWwrq4bgale3WsVPM9uf8ipDkjjsk+7sYmA
         96R934Y7+b0tXfPb4yglTaY/VIlEK3sq4SV1oiwUqxvSSRJBTmwmMmxGZ0O2/FWeGioh
         mStmxcVb2c0luuwJkIigUpSKQt5iw1nY1hAG/YRFmxuMyeNXm5iMlPObwzH+kDvfOVCG
         Dz5Q==
X-Gm-Message-State: AOAM532Aa36TdF31pfjW3iU1DXq/UKbPz54BrOPEtPQSLT84ty1chDdq
        CDJ1B/612Np370pAwtjQ0QiN49y80o50Ya7+NkSlbA==
X-Google-Smtp-Source: ABdhPJwdCq6fIqid1NDIwXhIUsFuZbRVI0mELuQ6Hg5XtSZnefbtVLLxDzRUbY6f1swYl+qnJ9omvJfA21H0KTmRU6M=
X-Received: by 2002:a05:6e02:1251:: with SMTP id j17mr3978433ilq.216.1612276489189;
 Tue, 02 Feb 2021 06:34:49 -0800 (PST)
MIME-Version: 1.0
References: <20210202135544.3262383-1-leon@kernel.org>
In-Reply-To: <20210202135544.3262383-1-leon@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 2 Feb 2021 15:34:37 +0100
Message-ID: <CANn89iL4jGbr_6rr11nsHxmdh7uz=kqXuMhRb0nakWO3rBZwsQ@mail.gmail.com>
Subject: Re: [PATCH net 0/4] Fix W=1 compilation warnings in net/* folder
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Leon Romanovsky <leonro@nvidia.com>, coreteam@netfilter.org,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Julian Anastasov <ja@ssi.bg>,
        LKML <linux-kernel@vger.kernel.org>, lvs-devel@vger.kernel.org,
        Matteo Croce <mcroce@redhat.com>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        Simon Horman <horms@verge.net.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 2, 2021 at 2:55 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> From: Leon Romanovsky <leonro@nvidia.com>
>
> Hi,
>
> This short series fixes W=1 compilation warnings which I experienced
> when tried to compile net/* folder.
>

Ok, but we never had a strong requirement about W=1, so adding Fixes:
tag is adding
unnecessary burden to stable teams all around the world.
