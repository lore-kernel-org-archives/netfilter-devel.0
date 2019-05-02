Return-Path: <SRS0=YpbV=TC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5AAC04AA8
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 May 2019 12:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AE8520449
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 May 2019 12:56:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="BhPWILqe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfEBM4p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 May 2019 08:56:45 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38307 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfEBM4p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 May 2019 08:56:45 -0400
Received: by mail-wr1-f68.google.com with SMTP id k16so3225410wrn.5
        for <netfilter-devel@vger.kernel.org>; Thu, 02 May 2019 05:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n2s/Ea/B6Mpfi+OAnf//HNYD+K+2AWTvc4XY6a3/6Ek=;
        b=BhPWILqeHgEB2hlME3BYGQ+MneR4wlEk2A24Q9YjCz1ofSqrp4d2USN+X2GKgSNp91
         9jXOsMa7Xff+qdkZyyN1DdPIol0TjVDY90fCX7qOmOe+mrCnlQnwyD3xqCJuoair/5wI
         vYhb0Q/QIfTsbFFQrVTQ8RgY2wNGRtW+pGSzGoYy2MDIVDK3HbcvkLMoSEC0akk2C7hP
         1g/GoEs2M6TgJNIGzeXBSe6B2gyI7dqOsOypQIonJk61TSuVEqU7smTaa+d7eJ/5On/2
         Di4N/tvd9Ox5Fy0DK30SQu4jetp3ekCC2uoUKlwHJwcMcvT2/FD40s09jBRFlH6eDAG0
         zfWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=n2s/Ea/B6Mpfi+OAnf//HNYD+K+2AWTvc4XY6a3/6Ek=;
        b=hU2G+Hnx08onAvXnvi7NQpHP3Vcc82ra9MpeTaTczaWPVpmGgK5rW+ymXSc8Oe7m/E
         RnXWpyaWx/lq+mQOyM9sQbVATUlqkxedUwoouPPEouU7bzT6iIJCH5Ae2s1PhbLxeyY6
         b6+ILv2oUiT7n0ghF26Yu9RBpN0YFvpmOFlQMGlOr9yqp4P9LmhQmxEsQOnwIVRCmyhS
         2MKM3F1pQBMFZiJm4pHwnTIjBaz+5g/JxSYeM/YMfJIe5mdkxyuwTMwOxF7hATESzWeT
         f1f0+xRGAkLwOg7WgMJKZM71H019HTNAYK/vrY8ayUfSUXxP7pkg7ypUpZR98FHv7C4K
         wHoQ==
X-Gm-Message-State: APjAAAXcNi3Gb5xHRFeRMfZ6Iu5Qya/PwRUCxPh5/1JWA9+EvjVDrCkn
        LcP5gFZuf8e2/TfoOx12ywsNQg==
X-Google-Smtp-Source: APXvYqzw1zJ2+xWlFlIfF2a6RCEpA8mqNQdkTFmgZkDJ+Uu9gGuVekSCW2xPCrNBFg6diWe+W8wlFw==
X-Received: by 2002:adf:cd90:: with SMTP id q16mr2628191wrj.75.1556801803830;
        Thu, 02 May 2019 05:56:43 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:c51a:8579:612a:9e21? ([2a01:e35:8b63:dc30:c51a:8579:612a:9e21])
        by smtp.gmail.com with ESMTPSA id n2sm19394354wra.89.2019.05.02.05.56.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 05:56:43 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 07/31] netfilter: ctnetlink: Support L3 protocol-filter on
 flush
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Kristian Evensen <kristian.evensen@gmail.com>,
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
 <20190502113151.xcnutl2eedjkftsb@salvia>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <627088b3-7134-2b9a-8be4-7c96d51a3b94@6wind.com>
Date:   Thu, 2 May 2019 14:56:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190502113151.xcnutl2eedjkftsb@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le 02/05/2019 à 13:31, Pablo Neira Ayuso a écrit :
> On Thu, May 02, 2019 at 09:46:42AM +0200, Florian Westphal wrote:
>> Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
>>> I understand your point, but this is a regression. Ignoring a field/attribute of
>>> a netlink message is part of the uAPI. This field exists for more than a decade
>>> (probably two), so you cannot just use it because nobody was using it. Just see
>>> all discussions about strict validation of netlink messages.
>>> Moreover, the conntrack tool exists also for ages and is an official tool.
>>
>> FWIW I agree with Nicolas, we should restore old behaviour and flush
>> everything when AF_INET is given.  We can add new netlink attr to
>> restrict this.
> 
> Let's use nfgenmsg->version for this. This is so far set to zero. We
> can just update userspace to set it to 1, so family is used.
> 
> The version field in the kernel size is ignored so far, so this should
> be enough. So we avoid that extract netlink attribute.
Why making such a hack? If any userspace app set this field (simply because it's
not initialized), it will show up a new regression.
What is the problem of adding another attribute?
