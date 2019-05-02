Return-Path: <SRS0=YpbV=TC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC6E4C43219
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 May 2019 07:28:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58A682081C
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 May 2019 07:28:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="EPCdfGR0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbfEBH2s (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 May 2019 03:28:48 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33350 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfEBH2r (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 May 2019 03:28:47 -0400
Received: by mail-wr1-f66.google.com with SMTP id e28so1845438wra.0
        for <netfilter-devel@vger.kernel.org>; Thu, 02 May 2019 00:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qFic4ZCJHq3vK52L3neHzBnAuNqEWHD8/WodEeFmKUw=;
        b=EPCdfGR07x/XReMXooZCRNQ1xr9mPc2lIqPeZIXxH/bM5yQ6pWgVJGMbqr8SJlwrrw
         YUzXn4wQe731WM99IMPfq8Bb5FQqwrbzWA8UghmwEfX9+46BLXEqg+Vkf+yaCHPIKHij
         VlTxD5iAis+GFz/Y7sgPeOCnAmJ/IYX1Ja6rJtAL50TLO0KJErRimC1uE6JcMNMPnnjj
         15jnJaHE/cILH1GKg82No7AuvoU3tfg9R3foh65eEMgCmUFVBrgDUoOucYsGecOkXjdH
         Gslvnbu23HhzjT8X8Vrt8r1lf2wW3YfQxv1pTqJpblLV3bKbGBYreRfh/2Z73x8nEyI1
         pFEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=qFic4ZCJHq3vK52L3neHzBnAuNqEWHD8/WodEeFmKUw=;
        b=W/FxiW+GDVtNBR5rXsnVUgM9NYeIDjR9u6e71aXWxUWLTKuI98y+MyTOEnhNsSZ9zh
         sL71OshBgw3lRYmq0HohODaoK/VVHjnF+sxO/s5c5JLOUnDG8JjrC0mpC4InnU3c8CWb
         uHTx9kxQsEDYVvFjewqaDVW9v0hyno3rIFh0EVEyDHnMSBNugwDfyzXNAczaUH2EsBK8
         f0PA0fGjY0xXG8PHWD4SatJSodyBMt3CS7LC9qun+Cq8ATobYLXQEDjXZuSEN13dDldN
         pFRUyQuoBbBd1dqXILtbWdRwX+w1XbdoJrg71kWVJI0yAabOdzoQvKoeP8cYLYMO5Ki5
         wadw==
X-Gm-Message-State: APjAAAU5SuJQyPUGkTsdA4sx2z+fQciFdhNamcRGGIezaaXyacg20mJs
        xZmf9svDjeJMw91sebUNXOKrHQ==
X-Google-Smtp-Source: APXvYqzuK+iNfWJu3+vrAFi9NAetVXJfc70FYtdC2USIBs/yvwJaWyLAN9gMDHkiJjJ29rkM95paHQ==
X-Received: by 2002:adf:eb89:: with SMTP id t9mr1632853wrn.109.1556782125989;
        Thu, 02 May 2019 00:28:45 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:c51a:8579:612a:9e21? ([2a01:e35:8b63:dc30:c51a:8579:612a:9e21])
        by smtp.gmail.com with ESMTPSA id r8sm21128163wrg.22.2019.05.02.00.28.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 00:28:44 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 07/31] netfilter: ctnetlink: Support L3 protocol-filter on
 flush
To:     Kristian Evensen <kristian.evensen@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
 <20181008230125.2330-8-pablo@netfilter.org>
 <33d60747-7550-1fba-a068-9b78aaedbc26@6wind.com>
 <CAKfDRXjY9J1yHz1px6-gbmrEYJi9P9+16Mez+qzqhYLr9MtCQg@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <51b7d27b-a67e-e3c6-c574-01f50a860a5c@6wind.com>
Date:   Thu, 2 May 2019 09:28:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAKfDRXjY9J1yHz1px6-gbmrEYJi9P9+16Mez+qzqhYLr9MtCQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le 01/05/2019 à 10:47, Kristian Evensen a écrit :
> Hello,
> 
> On Thu, Apr 25, 2019 at 12:07 PM Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
>> Since this patch, there is a regression with 'conntrack -F', it does not flush
>> anymore ipv6 conntrack entries.
>> In fact, the conntrack tool set by default the family to AF_INET and forbid to
>> set the family to something else (the '-f' option is not allowed for the command
>> 'flush').
> 
> I am very sorry for my late reply and for the trouble my change has
> caused. However, I am not sure if I agree that it triggers a
> regression. Had conntrack for example not set any family and my change
> caused only IPv4 entries to be flushed, then I agree it would have
> been a regression. If you ask me, what my change has exposed is
> incorrect API usage in conntrack. One could argue that since conntrack
> explicitly sets the family to AF_INET, the fact that IPv6 entries also
> has been flushed has been incorrect. However, if the general consensus
> is that this is a regression, I am more than willing to help in
> finding a solution (if I have anything to contribute :)).
I understand your point, but this is a regression. Ignoring a field/attribute of
a netlink message is part of the uAPI. This field exists for more than a decade
(probably two), so you cannot just use it because nobody was using it. Just see
all discussions about strict validation of netlink messages.
Moreover, the conntrack tool exists also for ages and is an official tool.


Regards,
Nicolas
