Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB08BC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jan 2022 13:33:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiACNdd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Jan 2022 08:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiACNdd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Jan 2022 08:33:33 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F52C061761
        for <netfilter-devel@vger.kernel.org>; Mon,  3 Jan 2022 05:33:32 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id e5so69934150wrc.5
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Jan 2022 05:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J5pMq3Ww9R/LlJJYIk27KwbvZZ9RQNKj3zhwRyRMb5A=;
        b=H23e9SiNCqJxNr/4HszDVQZI6Tqza1E3iBkXSX8Xv1znswpholMt+eiA6qDsTrPzgn
         0gsx6D4slBCQotvqpX5l3/jl5Xa2H8UEebs9RC2cpWJ+wVIh2Y6NSl6VJch6QyCceLif
         Kvmmv8vqILCCJ0t352fPZf2w4pZU03Au94FkspdXtWS9faGeg808MsSWu6SIkWUyXMlf
         EohC9jesSbdISZUkQKAxFNYg8ZSueAg8cNo7l5zvxt+grxYzGwvd4/zjabZiVkHd8qGX
         uG7f5lMlzR23gBR/RVX7lPRY9pAhiSnYq6sre1w6iUx0D+Pd6kwJdpozvHbUYmNWyjhw
         lozg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=J5pMq3Ww9R/LlJJYIk27KwbvZZ9RQNKj3zhwRyRMb5A=;
        b=a2Zb04kYunLIWwuzg4yirKFwNE03kqMnPC0w3vfyYP8XHYQaXrtPgVKVOHNbIUM78Q
         1ko+QWK7YPjnzT6jy5z1L6Kqj7GGUu4CPSrT1p6yX48G39PtE3Y0hndxLOUUphbCGB1Y
         xRG5YnRzl6oFjnBdaYgvXlfImXQz5jBsEulEfmnTmK8D/NphS+2TOiPC3NzksQRGWsHf
         1pRLTkDIA3xz4kKg+u3cFmQgtPNGL+jOths0CLorRm65jTMYYsktv7HvIp3DlrIQz7mm
         +SlCHG7XAcn6ZHZtadyjQ3WWfBRFIVVuWBifz1rloQG6PmDZo6x8B3+jPPGBhVSiJOTb
         Y+lA==
X-Gm-Message-State: AOAM531tRUCLl6V6fsaGci0dt+uUewpJjxO6fX/mMscRqgLI1YuZ0eZi
        miYu3xwJ3Yj3V60R/riNXDa96NMQ2tgzvA==
X-Google-Smtp-Source: ABdhPJz1RnIsWxS8Z4G2so5doEYzzlpI9bDJDpuqFGVuNemb8P2iaQoaZOzDxSwMqmgDF5gsDV//uQ==
X-Received: by 2002:a5d:60c8:: with SMTP id x8mr40279555wrt.695.1641216810658;
        Mon, 03 Jan 2022 05:33:30 -0800 (PST)
Received: from ?IPv6:2a01:e0a:b41:c160:b97a:ae5f:e798:c587? ([2a01:e0a:b41:c160:b97a:ae5f:e798:c587])
        by smtp.gmail.com with ESMTPSA id m21sm33276051wrb.2.2022.01.03.05.33.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jan 2022 05:33:30 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH nftables,v2 0/7] ruleset optimization infrastructure
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220102221452.86469-1-pablo@netfilter.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <94b1dbf5-154a-dd41-83a3-dfc01f8f4836@6wind.com>
Date:   Mon, 3 Jan 2022 14:33:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220102221452.86469-1-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le 02/01/2022 à 23:14, Pablo Neira Ayuso a écrit :
> Hi,
> 
> This patchset adds a new -o/--optimize option to enable ruleset
> optimization. Two type of optimizations are supported in this batch:
> 
> * Use a set to compact several rules with the same selector using a set,
>   for example:
> 
>       meta iifname eth1 ip saddr 1.1.1.1 ip daddr 2.2.2.3 accept
>       meta iifname eth1 ip saddr 1.1.1.2 ip daddr 2.2.2.5 accept
>       meta iifname eth2 ip saddr 1.1.1.3 ip daddr 2.2.2.6 accept
> 
>    into:
> 
>       meta iifname . ip saddr . ip daddr { eth1 . 1.1.1.1 . 2.2.2.6, eth1 . 1.1.1.2 . 2.2.2.5 , eth1 . 1.1.1.3 . 2.2.2.6 } accept
nit: it would probably be better with this result ;-)
meta iifname . ip saddr . ip daddr { eth1 . 1.1.1.1 . 2.2.2.3, eth1 . 1.1.1.2 .
2.2.2.5 , eth2 . 1.1.1.3 . 2.2.2.6 } accept


Regards,
Nicolas
