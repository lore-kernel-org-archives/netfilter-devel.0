Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD6BC433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Feb 2021 10:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D74E464F54
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Feb 2021 10:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhBBKY0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Feb 2021 05:24:26 -0500
Received: from mail-wr1-f53.google.com ([209.85.221.53]:35122 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhBBKYW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Feb 2021 05:24:22 -0500
Received: by mail-wr1-f53.google.com with SMTP id l12so19840810wry.2
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Feb 2021 02:24:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D7LrCkjf3ns46bNBMA2HunrWHARBvTTu1pgtsf6UDA4=;
        b=gtVtHhYBzxHnck9qqGmclfpSufcT/U84X+n2lJvwxAZbfPd2bdLU5sP1/vnS5GRYzE
         MujUEBA2eZLgp25TLOSQe1u9Tf6lhUp1Y9A+ixckbbIQoS9GMxV5tMoGA8uZlY9D1DNM
         rbEfJIGnpcxYfvvjd4w0TVcF6jbfAVqrNA0ViEQCLOS9g+SqM+00UrI73blj11MHNjzV
         Xo7Hg9sRrEkgvGmbu3BgT6VUz9HCeMy/sOgStTpuK5C5BGdp83IP7gyZauWkVP0QKxCe
         g7B9fJy7pPnfZ4ciJ6BtWf/Toa3gsd+rR52pgOr83SjpxdN49dAjJkLE2aqehTjzw76U
         pmzQ==
X-Gm-Message-State: AOAM530WXL/ytepS2dlIAfN6KKK9/XxpNZ3nHlkOGC7TCdzLVdp/EFCj
        38T6NKDu6nVV+pLFeynXHKYnGa6ESEM=
X-Google-Smtp-Source: ABdhPJzEyZGJVps6VvRGokAPCRTMUY+mB7QmiasdWrwGZBOHMWHQNhDra/ajT2TblWvyJ81mtN01og==
X-Received: by 2002:a5d:6541:: with SMTP id z1mr22536424wrv.128.1612261420874;
        Tue, 02 Feb 2021 02:23:40 -0800 (PST)
Received: from [10.239.43.214] (79.red-80-24-233.staticip.rima-tde.net. [80.24.233.79])
        by smtp.gmail.com with ESMTPSA id q7sm31698580wrx.18.2021.02.02.02.23.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 02:23:40 -0800 (PST)
Subject: Re: [conntrack-tools PATCH 1/3] tests: introduce new python-based
 framework for running tests
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <161144773322.52227.18304556638755743629.stgit@endurance>
 <20210201033147.GA20941@salvia>
 <949b08b1-d7c7-c040-7218-9df63562c032@netfilter.org>
 <20210201170551.GA28275@salvia>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
Message-ID: <d1e44dac-8240-b7c6-4a7a-4220d00feef3@netfilter.org>
Date:   Tue, 2 Feb 2021 11:23:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210201170551.GA28275@salvia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2/1/21 6:05 PM, Pablo Neira Ayuso wrote:
> That's fine, but before we add more tests, please let's where to move
> more inlined configurations in the yaml files to independent files
> that can be reused by new tests.
> 

ok!
