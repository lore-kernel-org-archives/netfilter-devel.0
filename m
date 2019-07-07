Return-Path: <SRS0=JlPR=VE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB22C0650E
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jul 2019 10:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B3332070D
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jul 2019 10:18:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="QgKXGMFs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfGGKSl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Jul 2019 06:18:41 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45610 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbfGGKSl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Jul 2019 06:18:41 -0400
Received: by mail-wr1-f68.google.com with SMTP id f9so13967980wre.12
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Jul 2019 03:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KXHWxa+UIM+ThdVUlxz38rZf4jSw8EKB5eFGTypm9Ag=;
        b=QgKXGMFsdVMywqzdKUqCAG91YW26BFQYhEKmHy4VVOZ7lDfZLlNlRY5fmPtcGMQ/4C
         HjsPCdjYcv1i4fG4t8vt1ZV8HbOZN6jbENOWCbdRgFhdT/bD7/CiDpCF/6Ev5LmfAej1
         Nuamn/hJfbUyQW1JlNKs7Ifz4XlY7dVmQ3mPg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KXHWxa+UIM+ThdVUlxz38rZf4jSw8EKB5eFGTypm9Ag=;
        b=WV0riZB0mlSvaXEbiuQgPNFe5sF6pzjWPcn6sJUiZF9Sz1qzMOF0Q1mNSgpRtzSxi9
         t8WAn+k7yB2HXPsb6TpAiJB1Vf9jZdz8dVUQd+8BdH4DGpZ7ovH2QTP/LkZD+f6iBSaa
         AN36KgFcZC+mBdjg3VLT8OQ81wR8Fnqy53Z4NLz8+3hiJQkFGEhUiunMm+ibSeG8WxDm
         9loD+P+bca5FyXr/VKuyXHBS+z+ua/l6OfFYrYQBDXCdcFptVJWmRGBS2s4BCzZIIT1h
         4j9c5yFVhVUoWNX54zodHROzy5bjWQ3zDt55EeZRtIO9Uke0xh9udta1JjCxcLwoUeX8
         7T3A==
X-Gm-Message-State: APjAAAWdr4mBjB0J0sm/RUqvYwYFJHGwhq2xVE5Zg7LZ6znBhn5zjSnN
        achV8YQqYJIcA62sAY2Bhzqi8A==
X-Google-Smtp-Source: APXvYqwgLB4g+IEeu3Z0Y9B8ohFGqSc8X3Y9QYq/vE/DNIAa1Yvcf8Odiw7mhGj4lSooVuF2kENe2g==
X-Received: by 2002:adf:e9c6:: with SMTP id l6mr13694052wrn.216.1562494719206;
        Sun, 07 Jul 2019 03:18:39 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a64sm18257285wmf.1.2019.07.07.03.18.38
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Jul 2019 03:18:38 -0700 (PDT)
Subject: Re: [PATCH 3/5 nf-next v4] bridge: add br_vlan_get_info_rcu()
To:     wenxu@ucloud.cn, pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <1562422552-26065-1-git-send-email-wenxu@ucloud.cn>
 <1562422552-26065-3-git-send-email-wenxu@ucloud.cn>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <970ad7dd-60bd-c731-287f-9ebc12ee0427@cumulusnetworks.com>
Date:   Sun, 7 Jul 2019 13:18:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562422552-26065-3-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 06/07/2019 17:15, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This new function allows you to fetch vlan info from packet path.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  include/linux/if_bridge.h |  7 +++++++
>  net/bridge/br_vlan.c      | 25 +++++++++++++++++++++++++
>  2 files changed, 32 insertions(+)
> 

Looks good, thanks!
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>


