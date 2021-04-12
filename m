Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42460C433B4
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Apr 2021 01:18:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C2026120D
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Apr 2021 01:18:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236235AbhDLBS0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 11 Apr 2021 21:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235323AbhDLBSZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Apr 2021 21:18:25 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB14C061574
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Apr 2021 18:18:08 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id s5so3076799qkj.5
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Apr 2021 18:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K6B61cD3u58VSmwS9pQlfcRqRgugD2XwphTZWgcsTvU=;
        b=EGTc3QSzxVweG25r5JxGPCc5Jk3QNPG7Guiz8wrh1V5pq9rY5kjbBQYBCVHDirJcvq
         2722PLduCFQJhGammQFBj9SVKOrRxX/MsUszC50PpxMV+I6YMiHJ8St/KEFAF2Pemipx
         mAb9krYO+NH2cmP0y3r5DYde1iv79KqCUAWa64l0ZsrgqmdPc0ij0KJ0N6qla5LaoWNV
         G6pwubM3sEoBW7ypHvgbH6wCVA29t9J6p6kgMIUWyDefiFBW/DdpbggmFO7Usk/R2Xsd
         9iz1Kzhs234H/HSSWLyKG0hnvH5an8iQvFxM3DzygYx5SrWZt10eixHkTRiJQ29+07nv
         jASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K6B61cD3u58VSmwS9pQlfcRqRgugD2XwphTZWgcsTvU=;
        b=YNnrBf4Zj+pNfhLqhIACBacRlIyPOEmJst6OZqCHaWXr1EeYv3pFil7jduqMVOwQ6s
         +mlD+nxFWLBml87Hfa3t+I2dJEmWiQYme5k1ygym1ExYM+qUS3GEQItxkMBIpcyq5ine
         5jNlBbQPlv4+1jof0rNSXarFgI4DEj1eGM+1XzEbDcNHvzT8SD2ZsH9XdieadO9saTKU
         GNp+wDiRWoovWKpTuC1KMR6hyqHTqnxISFygALuBg+Ia0fG5Fg3CbiHD3kRQtyqTzuUw
         pv1Gbc02MTbo4eY1hDoKagWYoWPzWMh2g8Lpo6DZo0sfH4p8O/s2rrymyCD4sTHeHMaH
         Hc8w==
X-Gm-Message-State: AOAM5336aD0j7sGxJFBnImULV3rJKOaD4L9ckzwHNyLA5l6co/C5Uznm
        2/HpE3rclNTxbqY0r/fI9gPcMPwNfOg=
X-Google-Smtp-Source: ABdhPJxmwInB+wZ4QCT6MwKl3HswbYhmN3wPzndDi/+gzhbsoIEL2QdUYsx5Vjlj0SmeOrpfR9R4QA==
X-Received: by 2002:a05:620a:699:: with SMTP id f25mr25017935qkh.249.1618190288018;
        Sun, 11 Apr 2021 18:18:08 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.157])
        by smtp.googlemail.com with ESMTPSA id q125sm7025859qkf.68.2021.04.11.18.18.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Apr 2021 18:18:07 -0700 (PDT)
Subject: Re: [PATCH nf-next] netfilter: Dissect flow after packet mangling
To:     Ido Schimmel <idosch@idosch.org>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        dsahern@kernel.org, roopa@nvidia.com, nikolay@nvidia.com,
        msoltyspl@yandex.pl, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20210411193251.1220655-1-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <be90fae7-f634-1f54-992e-226c442fb894@gmail.com>
Date:   Sun, 11 Apr 2021 18:18:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210411193251.1220655-1-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 4/11/21 1:32 PM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Netfilter tries to reroute mangled packets as a different route might
> need to be used following the mangling. When this happens, netfilter
> does not populate the IP protocol, the source port and the destination
> port in the flow key. Therefore, FIB rules that match on these fields
> are ignored and packets can be misrouted.
> 
> Solve this by dissecting the outer flow and populating the flow key
> before rerouting the packet. Note that flow dissection only happens when
> FIB rules that match on these fields are installed, so in the common
> case there should not be a penalty.
> 
> Reported-by: Michal Soltys <msoltyspl@yandex.pl>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> Targeting at nf-next since this use case never worked.
> ---
>  net/ipv4/netfilter.c | 2 ++
>  net/ipv6/netfilter.c | 2 ++
>  2 files changed, 4 insertions(+)
> 

Once this goes in, can you add tests to one of the selftest scripts
(e.g., fib_rule_tests.sh)?

