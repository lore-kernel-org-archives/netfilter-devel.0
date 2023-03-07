Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC5DC6FD1B
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 09:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbjCGJUL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 04:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjCGJUK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 04:20:10 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B4D86DE7
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 01:20:06 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id s11so49550032edy.8
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Mar 2023 01:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1678180805;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zu/hjvWXlUQhawKgHr39aKzFHFibVYuD00ads5+zLRQ=;
        b=bjzwJQ9uC4VEnNp28JY112LiyASziAeFsi32aKqEOWXqmCVe/3gPesr7t/pV4I/YPZ
         N457FtXlvI7xpy35IzsWxORDdm9GEPt0N+lo95LkfKh+6pHyntaLVExi3Uyr0D/9B01i
         l7d4yP7WK840gSbICf/o7YXHjnm955hxXJSa5tgUGsNwS5OgWhy5y6nYbvJnw0i2+9gD
         QMPreLlnDhnRSB98IuYM/X7ajry1j+7ow6ifM25oARzQEiju6bOYMXik6QvHxnh+gJz8
         BMBKSy+3Rsvdshd7gJgt5OVP5X4kHNRcqYLoCcgrsmnnPMpaKc/F8bUiSMAN61M3X0bK
         l36A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678180805;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zu/hjvWXlUQhawKgHr39aKzFHFibVYuD00ads5+zLRQ=;
        b=tHQ9TW6iOgN/YGfVAMBb9tZMCq2puUkAacI3cS4SI0Zqazt+3vSbvPzqhj+VWvbLDf
         ZTskbql0pAJA7JmCI8DtrUvMdXA/gCg9jEES/E1Mkr015k+zL1GwDeJwH+zdTBL2Keq8
         kX5lHt67D9jfKw9pnkhTJEf9aq6H+rNRySyL6zea5VwlM7Uuq/TanMKWPx2dVDqRDKen
         AB9EWNQScWuB/DOieXC2T/yVWwvJcXnS+JmIXbd6NfOlDmEiXmFg7hMJqZd3I858i96b
         LYByjypgq6SOww5NiFO4Zweal8N2bYz0Tr/255hzmw5s1c+PPtCnxr2bZvS0C8+Saozg
         RlKA==
X-Gm-Message-State: AO0yUKV1tJrCjGRPkHPD7fLSPwHgihXnv5puhNwCGQt4hMtzmoFPdjGP
        94cC6Z3H5o3KzWGoIAY7J9BkpA==
X-Google-Smtp-Source: AK7set+mFVAMIXdWzLWwuXV1apjF3mwxvpxsM8dKiUjZ4IFlSGeJznDezn05zLQCg/m97aIqs7WDKg==
X-Received: by 2002:a50:ee02:0:b0:4c3:6ac8:2aac with SMTP id g2-20020a50ee02000000b004c36ac82aacmr12044793eds.35.1678180805304;
        Tue, 07 Mar 2023 01:20:05 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id m26-20020a50999a000000b004af73333d6esm6439765edb.53.2023.03.07.01.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 01:20:05 -0800 (PST)
Message-ID: <583cc2c7-7883-57fe-6b48-25e5e43c3ec0@blackwall.org>
Date:   Tue, 7 Mar 2023 11:20:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH nf-next 2/6] netfilter: bridge: check len before accessing
 more nh data
Content-Language: en-US
To:     Xin Long <lucien.xin@gmail.com>, netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Aaron Conole <aconole@redhat.com>
References: <cover.1677888566.git.lucien.xin@gmail.com>
 <e5ea0147b3314ad9db5140c7b307472efbd114bd.1677888566.git.lucien.xin@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <e5ea0147b3314ad9db5140c7b307472efbd114bd.1677888566.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 04/03/2023 02:12, Xin Long wrote:
> In the while loop of br_nf_check_hbh_len(), similar to ip6_parse_tlv(),
> before accessing 'nh[off + 1]', it should add a check 'len < 2'; and
> before parsing IPV6_TLV_JUMBO, it should add a check 'optlen > len',
> in case of overflows.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/bridge/br_netfilter_ipv6.c | 47 ++++++++++++++++------------------
>  1 file changed, 22 insertions(+), 25 deletions(-)


Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


