Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E27D2C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Feb 2021 10:24:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B34C64F37
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Feb 2021 10:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbhBBKX7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Feb 2021 05:23:59 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:41862 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbhBBKXz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Feb 2021 05:23:55 -0500
Received: by mail-wr1-f49.google.com with SMTP id p15so19773839wrq.8
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Feb 2021 02:23:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OpqAiphjryiJel6wTCOfgYsf28BTiejTsAO50rOy9Rg=;
        b=GBGZxXFfaEYZaRuG1I0bSbHIb/3AVkE5IMZqvbgRO53S+0ufRYtPKe7XHUzf3YEJUm
         mQMR9qiNmh3rPekclbDHZxwKlaW4RqKHbtT9F5FnBzSeZ9sbTJxgcRGqhQXoSSxUjtql
         zs6HGMEuISFVwddF5If1DfsEa7z/JiF0OFxAhwwO2Dr31a/lq1PZdZaYZkzyohTmCeFa
         bbIKk6C56EHVObKAecGxfXRW0whDJaVfpJopsa82tacv3LsAfcgGbm0W92B8Hs6md5bQ
         4KgoCfyWsuduo+94pkSu0O9qdUeJzbzKNkzUstP+45aiziIcvnFjdHe1P1FXh8E7s8na
         9Qsg==
X-Gm-Message-State: AOAM531DuF+iNWEW86jrlvohTIgm5z6gT6zGz9POP1PpItnfOBkLGNm5
        SaZTvFu1Eer3meyJR3ylYItlybyoXRY=
X-Google-Smtp-Source: ABdhPJyqVet79r6exZ7QXpshl4CmYGErDRnipcgdY/OZa41YKbjJPfB7j8dYdVlFnwB865Ov2nERMQ==
X-Received: by 2002:a5d:6c66:: with SMTP id r6mr22440706wrz.86.1612261393481;
        Tue, 02 Feb 2021 02:23:13 -0800 (PST)
Received: from [10.239.43.214] (79.red-80-24-233.staticip.rima-tde.net. [80.24.233.79])
        by smtp.gmail.com with ESMTPSA id j17sm2250411wmc.28.2021.02.02.02.23.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 02:23:12 -0800 (PST)
Subject: Re: [PATCH conntrack-tools] tests: conntrackd: move basic netns
 scenario setup to shell script
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20210201170015.28217-1-pablo@netfilter.org>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
Message-ID: <6dc09925-9c93-fdbb-12f4-c9cd2c7d1bb4@netfilter.org>
Date:   Tue, 2 Feb 2021 11:23:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210201170015.28217-1-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2/1/21 6:00 PM, Pablo Neira Ayuso wrote:
> This allows for running the script away from the test infrastructure,
> which is convenient when developing new tests. This also allows for
> reusing the same netns setup from new tests.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>   tests/conntrackd/scenarios.yaml               | 29 +--------
>   .../scenarios/basic/network-setup.sh          | 59 +++++++++++++++++++
>   2 files changed, 61 insertions(+), 27 deletions(-)
>   create mode 100755 tests/conntrackd/scenarios/basic/network-setup.sh
> 

Acked-by: Arturo Borrero Gonzalez <arturo@netfilter.org>

