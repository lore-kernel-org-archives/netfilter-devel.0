Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C83B7C433ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 May 2021 08:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EA356128E
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 May 2021 08:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhEKIvS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 May 2021 04:51:18 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:40949 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbhEKIvP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 May 2021 04:51:15 -0400
Received: by mail-wr1-f51.google.com with SMTP id z17so199534wrq.7
        for <netfilter-devel@vger.kernel.org>; Tue, 11 May 2021 01:50:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a5kqlCjZqqyQQNsgHYf67D2U1MNZZSsRgVzD7YXDU7c=;
        b=YGy5FMSl/NkKHgutXoSAcd/X2A7+U04qfnRFcNpN1SnnOR6Gc71Hu54aRY8/TQYrrY
         lfeDpRKC844ICwrecNV5YwdtuVbGtzPjWaEYT1ny5bvGcewz0ETsjlpBibQc2b8n+4Q/
         FhPUD7qGP2SiauZx8uGnAhwmHUpG2IYmfWGUUyBkq+Df0Za/N+nZGz4tOVHuLmGfI/XN
         IDHCZoifK53ozZWEHGueP3EjGf5Q/RD/+FZrh0uFSmhQBMf+Ku3gMV1rsoi/QmFOQb14
         uZh+Taom0YhABa0wmz4rxjIPR+kqO3mHNvQrDngM9lO1RbRfP/cRfrvAWwsXDu+hvhi9
         l8Xg==
X-Gm-Message-State: AOAM530SrMcFB+9qb6DCW0mnXLvQ1nWOUlGxrFSdugcNSCdV/kvdtWw3
        Ku8i7qx86j02KGZj8H+x5Fg9di2Kdzi0NA==
X-Google-Smtp-Source: ABdhPJzTANZfo8PHfJ34SAvII38TZVtC2WSkqzk1URI014beLF55vYZfaC5hntJ142ues+RAtHGY4w==
X-Received: by 2002:adf:e9cf:: with SMTP id l15mr27051024wrn.209.1620723007683;
        Tue, 11 May 2021 01:50:07 -0700 (PDT)
Received: from [10.239.43.214] (79.red-80-24-233.staticip.rima-tde.net. [80.24.233.79])
        by smtp.gmail.com with ESMTPSA id a126sm2845514wmh.37.2021.05.11.01.50.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 01:50:07 -0700 (PDT)
Subject: Re: [PATCH nftables 2/2] src: add set element catch-all support
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20210510165322.130181-1-pablo@netfilter.org>
 <20210510165322.130181-2-pablo@netfilter.org>
 <20210511082441.GN12403@orbyte.nwl.cc>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
Message-ID: <5fd6a58e-7fed-a1e8-c527-fae71873dc34@netfilter.org>
Date:   Tue, 11 May 2021 10:50:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210511082441.GN12403@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 5/11/21 10:24 AM, Phil Sutter wrote:
> Hi Pablo,
> 
> On Mon, May 10, 2021 at 06:53:21PM +0200, Pablo Neira Ayuso wrote:
>> Add a catchall expression (EXPR_SET_ELEM_CATCHALL).
>>
>> Use the underscore (_) to represent the catch-all set element, e.g.
> 
> Why did you choose this over asterisk? We have the latter as wildcard
> symbol already (although a bit limited), so I think it would be more
> intuitive than underscore.
> 

Moreover,

instead of a symbol, perhaps an explicit word (string, like "default") may 
contribute to a more understandable syntax.
