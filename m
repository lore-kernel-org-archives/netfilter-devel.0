Return-Path: <SRS0=/MqZ=RG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A266C43381
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 08:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E35F120836
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 08:28:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cogentembedded-com.20150623.gappssmtp.com header.i=@cogentembedded-com.20150623.gappssmtp.com header.b="OxH5Ks7j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbfCCI2D (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Mar 2019 03:28:03 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40223 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbfCCI2D (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Mar 2019 03:28:03 -0500
Received: by mail-lf1-f66.google.com with SMTP id a8so1349011lfi.7
        for <netfilter-devel@vger.kernel.org>; Sun, 03 Mar 2019 00:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YKTRggL5L9UQrsmNwf6dCyCvArs3ypV88IVA6YRbRSQ=;
        b=OxH5Ks7jg3w3yah52B8q0tC1G7V7kNqHy58Kgb/vonG+0Y8X0kXkJ525Lg1vIbrhm3
         +Vy3B0NymUVl2fCYaU3FqDJUIs2ChtqS9ev45udwf0DnMIZ7TrPI8l1VU05x8krpF3SF
         QfoDheHyo8ElOV/B7Do0DuZjFHSgD2HQT0MF7757rF4PHh6p7YpXDMSeArmmPlJKuwkJ
         F2Yj2ale8ExOOI1ge2oBgCnpu8haCWTDJPnUOmcnmv8io9bfk33fBPnCmBNbuyrxHuM+
         NpVPgcadovaoOGHQ+4ec+oyznZ7jHfNffBNIEKukxwPGUhmJURKPnD0eYCCdwLzsslzD
         WLDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YKTRggL5L9UQrsmNwf6dCyCvArs3ypV88IVA6YRbRSQ=;
        b=sEHekCqRR0TBvjW+de3r24tXZdNTX9SWmpaFAJhtyN18jhFIafIUBkvjQ0hAk1AoJX
         02R3cK3n34BNTkS/8QY3QF5XkWBebmahA0VC5ep0kCioRZ7pY5t9yeifHLckOF6RobEx
         4cSRP/iH8ioQ7v3w6EcprbynJGYBc07ig1yqdWWgklAS1tVQ7JHnM5TrgKFl227RDmDr
         +HpsjXW451aRrlvVivw4tvku98ICb8Metc5F8uST+CN5mIMNLy8XjBCcy7mAevKQ7TvX
         2JCw+anEegYrmy0FbFGS35yTDuPSNSr6V6su6XC5XSH+W+s5nXZxIbqYELS8MhS2Enfq
         gErQ==
X-Gm-Message-State: APjAAAV4XbE4cnhVItjWkZcFRy4xQY6Wb6lyzQuwEk1l9uh/qDQ+rtX1
        Uap4QHIs5k4hZr6n1Z/quO5YjA==
X-Google-Smtp-Source: APXvYqy5UeSAlZVzTT6UdVHP6zi8OOz6gZZECeLeXslWfGsh+ENRzQV+0MeI8N34xjPKhdcGoPQ5Ug==
X-Received: by 2002:a19:610a:: with SMTP id v10mr2471505lfb.89.1551601680838;
        Sun, 03 Mar 2019 00:28:00 -0800 (PST)
Received: from [10.115.71.126] ([81.16.143.135])
        by smtp.gmail.com with ESMTPSA id t14sm780086lfk.83.2019.03.03.00.27.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Mar 2019 00:28:00 -0800 (PST)
Subject: Re: [PATCH 25/29] netfilter: nf_conntrack: ensure that
 CONNTRACK_LOCKS is power of 2
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <20190302183720.3220-1-pablo@netfilter.org>
 <20190302183720.3220-6-pablo@netfilter.org>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <404bb40f-74bf-c5c8-dab1-bfa507b36d2a@cogentembedded.com>
Date:   Sun, 3 Mar 2019 11:27:45 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190302183720.3220-6-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello!

On 02.03.2019 21:37, Pablo Neira Ayuso wrote:

> From: Li RongQing <lirongqing@baidu.com>
> 
> CONNTRACK_LOCKS is divisor when computer array index, if it is power of

    Computing?

> 2, compiler will optimize modulo operation as bitwise AND, or else
> modulo will lower performance.
> 
> Suggested-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[...]

MBR, Sergei
