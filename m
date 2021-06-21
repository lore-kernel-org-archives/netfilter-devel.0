Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898D8C4743C
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Jun 2021 17:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74F2260C3F
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Jun 2021 17:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhFURFs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Jun 2021 13:05:48 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:39643 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbhFURFX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Jun 2021 13:05:23 -0400
Received: by mail-wm1-f48.google.com with SMTP id l18-20020a1ced120000b029014c1adff1edso14399340wmh.4
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Jun 2021 10:03:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+/klDYI9k0btgFfu9RuMGO16CqS/CX2ipm8HmIjgs4U=;
        b=WPk9pdm/eD3sJoAMj7eC1DKS2Ka1dFpvpBVx4nsDJMAZLIMlBy9BZZ3YM7HPSxOMlG
         ZkxeTSR65chuigur0vnV809rzemMkhlw2pSFctVFOnjrY6r1HN9S+i521i3hyzy7rE1b
         RxK5uIYpzsOwWRiVk9YG59L9hTSJozxlwRl61j7hYtoqDfRUZ1c5I2cYUhaOmEd7rBAC
         lSYX4yiE2vt1wP+/rN/Ddp8aRXM/lCnmAWfY9Ij9qOiTZYQpqkzYQUw5YCKi/9XwdTFU
         meKFWVYd3hmz9OS4y16FR4cd5S13MiianzhhunhGbTSghMwAagiiWfcUONmOiuaT6kgd
         OgVg==
X-Gm-Message-State: AOAM531c9AYnVJA0cGAK6sVrABPg3K1Ga139CKo8oQdV6iN/qfuoEg3B
        Pc4J1ROKqciSPK224v4SU4Q=
X-Google-Smtp-Source: ABdhPJx9HpSAgqy6L0e2tR+sZiR+YvqFLcg2C7+3WfdycPrz7qbUNcmr+FjZNwngtlOoWl45B1o5LQ==
X-Received: by 2002:a1c:df09:: with SMTP id w9mr24310336wmg.91.1624294987171;
        Mon, 21 Jun 2021 10:03:07 -0700 (PDT)
Received: from [192.168.1.130] ([213.194.132.177])
        by smtp.gmail.com with ESMTPSA id t11sm18769182wrz.7.2021.06.21.10.03.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 10:03:06 -0700 (PDT)
Subject: Re: [PATCH nf-next] docs: networking: Update connection tracking
 offload sysctl parameters
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        netfilter-devel@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20210617065006.5893-1-ozsh@nvidia.com>
 <04c84d18-5707-6423-5736-a70114df0f15@netfilter.org>
 <20210621162605.GA3397@salvia>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
Message-ID: <b8e9cc32-0f38-84b2-35c8-a53c2d1c8a35@netfilter.org>
Date:   Mon, 21 Jun 2021 19:03:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210621162605.GA3397@salvia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 6/21/21 6:26 PM, Pablo Neira Ayuso wrote:
> 
> I think I can extend the flowtable documentation to include this
> information:
> 
> https://www.kernel.org/doc/html/latest/networking/nf_flowtable.html
> 
> to refer to this new sysctl knobs too.
> 

That would be cool :-)
