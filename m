Return-Path: <SRS0=n11Q=TD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4372C04AAA
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 May 2019 07:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8910A205F4
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 May 2019 07:02:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="e6fYFR+G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbfECHCq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 May 2019 03:02:46 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43971 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfECHCq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 May 2019 03:02:46 -0400
Received: by mail-wr1-f66.google.com with SMTP id a12so6369251wrq.10
        for <netfilter-devel@vger.kernel.org>; Fri, 03 May 2019 00:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q4GB8dUDBUrfR8RceX90h6C1IAenPkt0gX+UGWoL71w=;
        b=e6fYFR+GXwr3DkqbVm9LIvr65yHlXbdk/iUulw6JJFl8cvMXYR02H5POxa2t/PC3TK
         /SaN3qGSn2z0K3SFAgrhR3gjxwstvTzoUm7AjnfvLyXc2sZjp2FN/8QBpn3Tf8PXyENj
         6defLm77xrYHHUOjUUMumBa2ZKQtl1SLQ2ZD5eMIPZyU8bq5jQ43Nh1A0BI/0OzKWXly
         ctCpqvonrPez/nGSSaOE4CdRIwOBzi/MZhgGMKrm5ZFO3y5UJEA54OGY9p5HnoH3PibF
         spWuLGYqKz2G90y+H2/r7nm5xx5rb+3xHMCX2+70ymb9d0aZcVhudVorGvaENKsTABNa
         XLew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=q4GB8dUDBUrfR8RceX90h6C1IAenPkt0gX+UGWoL71w=;
        b=VBdh63APgdPRjOPZJILbgON+h/p/uLhhtlasU/EQxXaXrwfL6pcHMbAIQ4Pfcspt/I
         rI/hISSEBPFusdHrtTM1rCQET5GexhsR/2EESwBbcPUkRrQrXQZbBPLmAXS6NAYKfr6O
         p5HtRukpz8wpVDK2mNecj8lrcKIVMXYvyf89f89jlF/yQYy7w8bTVR+yYEZBLVH4rBaj
         Q6s1EA0ZrtV2vATVHYu+Iyr71WfeCTDGm6WAfJ3OtsV4qaMN04WzZoPhT9PvKoZ1Cla8
         2Ufy6F4ZTfyJiAnmgBpSlGwHaOzdYTWQkCZe4j5soC8KltShrHtGISaCV3uBqssJrxvX
         XBYg==
X-Gm-Message-State: APjAAAVGy7ou6ZY1LHBcicRM7d1An5KJvANU/CalJgbo9I1ju2qHkTix
        qquMA2NtblUmF/QEtR6LIc9cag==
X-Google-Smtp-Source: APXvYqz/T1ENfzxvoXBU7ZPulPnp13v5CFPUy5m+/fW8qjj8MVLigScFoiAeZuEhQh0MwfHircMp3A==
X-Received: by 2002:adf:db05:: with SMTP id s5mr5596501wri.247.1556866963947;
        Fri, 03 May 2019 00:02:43 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:9d85:cd02:d5cd:3fb? ([2a01:e35:8b63:dc30:9d85:cd02:d5cd:3fb])
        by smtp.gmail.com with ESMTPSA id c131sm1229100wma.31.2019.05.03.00.02.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 00:02:43 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 07/31] netfilter: ctnetlink: Support L3 protocol-filter on
 flush
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Kristian Evensen <kristian.evensen@gmail.com>,
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
 <627088b3-7134-2b9a-8be4-7c96d51a3b94@6wind.com>
 <20190502150637.6f7vqoxiheytg4le@salvia>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <7c0e2fec-3bf8-9adc-2968-074e84f00bb4@6wind.com>
Date:   Fri, 3 May 2019 09:02:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190502150637.6f7vqoxiheytg4le@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le 02/05/2019 à 17:06, Pablo Neira Ayuso a écrit :
> On Thu, May 02, 2019 at 02:56:42PM +0200, Nicolas Dichtel wrote:
>> Le 02/05/2019 à 13:31, Pablo Neira Ayuso a écrit :
>>> On Thu, May 02, 2019 at 09:46:42AM +0200, Florian Westphal wrote:
>>>> Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
>>>>> I understand your point, but this is a regression. Ignoring a field/attribute of
>>>>> a netlink message is part of the uAPI. This field exists for more than a decade
>>>>> (probably two), so you cannot just use it because nobody was using it. Just see
>>>>> all discussions about strict validation of netlink messages.
>>>>> Moreover, the conntrack tool exists also for ages and is an official tool.
>>>>
>>>> FWIW I agree with Nicolas, we should restore old behaviour and flush
>>>> everything when AF_INET is given.  We can add new netlink attr to
>>>> restrict this.
>>>
>>> Let's use nfgenmsg->version for this. This is so far set to zero. We
>>> can just update userspace to set it to 1, so family is used.
>>>
>>> The version field in the kernel size is ignored so far, so this should
>>> be enough. So we avoid that extract netlink attribute.
>>
>> Why making such a hack? If any userspace app set this field (simply because it's
>> not initialized), it will show up a new regression.
>> What is the problem of adding another attribute?
> 
> The version field was meant to deal with this case.
> 
> It has been not unused so far because we had no good reason.
> 
Fair point, agreed.


Thank you,
Nicolas
