Return-Path: <SRS0=n11Q=TD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABDDEC43219
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 May 2019 17:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BE77206C3
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 May 2019 17:03:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="O9wWGzQM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbfECRC6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 May 2019 13:02:58 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41907 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728723AbfECRC6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 May 2019 13:02:58 -0400
Received: by mail-wr1-f65.google.com with SMTP id c12so8729855wrt.8
        for <netfilter-devel@vger.kernel.org>; Fri, 03 May 2019 10:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XHu3vi/ZqBd+l2noJLxBp3bwgBHRvX081zEBCbj+QOk=;
        b=O9wWGzQMYeqyhgSMnuAw8hfEh7pfboL00pDushOwy1Z0x6q9mzIuRzpKSsBy4KeUwi
         NuCIqChDaychWvbdNyaxI8ZxqRUkMvmpfqCycyarlRuL0sF94/SDZsyy1PlMBq/up4NR
         w9bDA+017Mv4COxYEViaxR49Zju1KKIaVOYB3fxdUDUM/xCc211vp7UP6teuxXpihG0Q
         9YPP6yjLHouIbB3vzMXEwg+YcQYFSaZrrHteejIz09mrxSaVqf6GG4kZXWL69YiobgXZ
         7eF90nqVnsMAUV8NdWjqyIaXGAJfKEtlnlMxsNT/nvvhxJ8d0KTBItRhtEXu78kRSUuI
         4Hcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=XHu3vi/ZqBd+l2noJLxBp3bwgBHRvX081zEBCbj+QOk=;
        b=XVUIzo4s7Yg8CcUDpthLRZ/JWk/JHOwnpanGjCb7ZAt3wq6cRAAq8xWmTLfs1HaUKb
         ZiYPvsMnkk/74Ufzv8hibZFuc3d7fQqfzM836taTREJWRK6B9Tm0uNUtNgASsNIkQfQ9
         m5IzJdAZ9NXHXs3I2Eh2HeKC1K8cWUF88AEEerDHQAvWbYqmeDeT2Au1kcKC/zAat3/7
         1L8kZDgENbiNL4pgSbK9ege9aVh4lUK7JAk4rUm9npgDuhvuUWrxR3EQUtOzV0oQPEqu
         gEZo88INZjRAxjQqCKyBNrH9OM+ap6u0Inrpts4AiXcBqEne9PzwSoMb+wni/oGueqCd
         ieQw==
X-Gm-Message-State: APjAAAVwG03thrLyyn8AHiTr3OwXnRoVhCK5KHhQvERqpSA2robUBVNQ
        4eyHCklezBv9hikvKQICEI65dA==
X-Google-Smtp-Source: APXvYqxOlACsmTaIE6bN0dZPOMv9HzaPkwTdP+TiiJkNuPCDasZZN3i7ETepOvDZgtZcg0nPTnPkxg==
X-Received: by 2002:adf:dcc7:: with SMTP id x7mr7588347wrm.197.1556902976646;
        Fri, 03 May 2019 10:02:56 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:657a:6ff4:4c9f:9842? ([2a01:e35:8b63:dc30:657a:6ff4:4c9f:9842])
        by smtp.gmail.com with ESMTPSA id k206sm5122791wmk.16.2019.05.03.10.02.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 10:02:55 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] netfilter: ctnetlink: Resolve conntrack L3-protocol flush
 regression
To:     Kristian Evensen <kristian.evensen@gmail.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>
References: <20190503154007.32495-1-kristian.evensen@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <0326116f-f163-5ae1-ce19-6a891323eb03@6wind.com>
Date:   Fri, 3 May 2019 19:02:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190503154007.32495-1-kristian.evensen@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Please, keep in CC all involved people.

Le 03/05/2019 à 17:40, Kristian Evensen a écrit :
> Commit 59c08c69c278 ("netfilter: ctnetlink: Support L3 protocol-filter
> on flush") introduced a user-space regression when flushing connection
> track entries. Before this commit, the nfgen_family field was not used
> by the kernel and all entries were removed. Since this commit,
> nfgen_family is used to filter out entries that should not be removed.
> One example a broken tool is conntrack. conntrack always sets
> nfgen_family to AF_INET, so after 59c08c69c278 only IPv4 entries were
> removed with the -F parameter.
> 
> Pablo Neira Ayuso suggested using nfgenmsg->version to resolve the
> regression, and this commit implements his suggestion. nfgenmsg->version
> is so far set to zero, so it is well-suited to be used as a flag for
> selecting old or new flush behavior. If version is 0, nfgen_family is
> ignored and all entries are used. If user-space sets the version to one
> (or any other value than 0), then the new behavior is used. As version
> only can have two valid values, I chose not to add a new
> NFNETLINK_VERSION-constant.
> 
> Fixes: 59c08c69c278 ("netfilter: ctnetlink: Support L3 protocol-filter
> on flush")
> 
Please, don't break the fixes line and don't separate it from other tags with an
empty line.

> Reported-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
Tested-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
