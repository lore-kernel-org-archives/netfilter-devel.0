Return-Path: <SRS0=YpbV=TC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A0AC43219
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 May 2019 08:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08E882054F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 May 2019 08:27:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="BJL4AQlw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfEBI1V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 May 2019 04:27:21 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38283 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfEBI1V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 May 2019 04:27:21 -0400
Received: by mail-wm1-f65.google.com with SMTP id w15so1433092wmc.3
        for <netfilter-devel@vger.kernel.org>; Thu, 02 May 2019 01:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ao3kEYMCUqHOzBLJovAegoGQgAW4TxYose+CKc7SEJw=;
        b=BJL4AQlwArrxgv9YY1yFtN3r/okhFFdh7EuoGwhhbOIvl+LU+42RCQc4h+MHyaMMjp
         xBfgiSjv/JJGO1iGThsPR6Zi3cEz8FF69lIrYYwGLe+8ZWAEG/NR5vsi6QYP0ICPjCDR
         S8FZj8ct7dwWWHTy7RatzocikW8fcasFLqLyxwmOovyXULb9+WXS4Yf4EHmwf7NtQq+e
         nrg0Y4HRwwruKZJ7FhDkUkR5OzteTXvYa85w4PKp7hkSTG2+fMp1Ldd1FK8SkO0DuE+D
         zFfzPMBUVPPiHOlmQH3gxpjYwXlgJUX+cyB/qwfBQfk1b0cd++mrL+rEYzdBIokwC7N6
         BQ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Ao3kEYMCUqHOzBLJovAegoGQgAW4TxYose+CKc7SEJw=;
        b=kOqYVECS0QLTcP3F2fhlpCtjDBbUVydZ+QGUTD9EO8D//dTSPymTi92MDnexSYexNW
         HR1UAzxU8czwY2eQyVwcF3OU2bpWxrxOhuBgr9oSDvF97ro0nFbI1WOL+75HhDFzkUqu
         ooVCrpLr/KPi1jjmApfUFkbn/hpJ8r/AuUNBCl1eaW4tkTjWZcEJucqWPUAfvY3MQBTs
         gG0zwdHWJr1V6jtDeFBFRzbkoUyAmLD0u4UmDCeaaToTPRO63yZ4qH2056r+pzF62UPG
         9KXmE82WPZ2XBYEtpcjpHNTvqnSNdDiM+M2Hrc5P3mc5e97Cum1ih7mFHepD6X5wy8L5
         zuPA==
X-Gm-Message-State: APjAAAVxyfFk0Mh6TGhsii4vZqLtNXPjh5erD2hjDgjKfzoYKjnRaEyC
        F9cXwkKYc0sEFmAfWToa/rg6WQ==
X-Google-Smtp-Source: APXvYqyi+Pu/pZ/fRBYszac2eyuwuRB0aESCFCRNd20PX21fXOyR49jAo/D0ysYLfYXGA+bQbxloAA==
X-Received: by 2002:a7b:cb11:: with SMTP id u17mr1353408wmj.55.1556785639572;
        Thu, 02 May 2019 01:27:19 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:c51a:8579:612a:9e21? ([2a01:e35:8b63:dc30:c51a:8579:612a:9e21])
        by smtp.gmail.com with ESMTPSA id y7sm1216856wrg.45.2019.05.02.01.27.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 01:27:18 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 07/31] netfilter: ctnetlink: Support L3 protocol-filter on
 flush
To:     Florian Westphal <fw@strlen.de>
Cc:     Kristian Evensen <kristian.evensen@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
 <20181008230125.2330-8-pablo@netfilter.org>
 <33d60747-7550-1fba-a068-9b78aaedbc26@6wind.com>
 <CAKfDRXjY9J1yHz1px6-gbmrEYJi9P9+16Mez+qzqhYLr9MtCQg@mail.gmail.com>
 <51b7d27b-a67e-e3c6-c574-01f50a860a5c@6wind.com>
 <20190502074642.ph64t7uax73xuxeo@breakpoint.cc>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <a4f2df82-be23-ed46-79f5-749adc3c52c3@6wind.com>
Date:   Thu, 2 May 2019 10:27:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190502074642.ph64t7uax73xuxeo@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le 02/05/2019 à 09:46, Florian Westphal a écrit :
> Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
>> I understand your point, but this is a regression. Ignoring a field/attribute of
>> a netlink message is part of the uAPI. This field exists for more than a decade
>> (probably two), so you cannot just use it because nobody was using it. Just see
>> all discussions about strict validation of netlink messages.
>> Moreover, the conntrack tool exists also for ages and is an official tool.
> 
> FWIW I agree with Nicolas, we should restore old behaviour and flush
> everything when AF_INET is given.  We can add new netlink attr to
To avoid regression, we sould ignore it, AF_INET or not.

> restrict this.
Yes.
