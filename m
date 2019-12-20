Return-Path: <SRS0=tkBW=2K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664C3C43603
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 01:27:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 383EB24676
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 01:27:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sOY3z/uj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfLTB1t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 20:27:49 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:41625 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbfLTB1s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 20:27:48 -0500
Received: by mail-qv1-f65.google.com with SMTP id x1so3010803qvr.8
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Dec 2019 17:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RXOh7wrzOCLV5Xd1ilv5qq9uZKKUOM9cJmaiVy0wAgc=;
        b=sOY3z/ujZGImiiZrCziyubbJ4636RfNzFQITVCfofNBZlFR8Y8GuR6+zeGz+NHl+/k
         jxGuJo/l19onBK9eOwOBTw1Jj60k06yxJVhhaz12fvG/mwi4r+kVjQRqDb5Hf1ywquqj
         PKBGxn/vGKk+PgFb0Rf+13JaVpBpIFi+uo7uvT5pQkyH/N43W8/m18twa9u/peNgbleD
         jUt4kzUNtUsi7xOlqYRGsl70wVEPBJp8f8bmNdRqpdeBXzUOLWmNNSs4jTgSanGFKPLS
         t/XfyUusmmd/oMLe+BffKoxx9tdRKPfpckY0guv26XpGT3Xujwrc4rD/dU4tZboNdIrt
         EaaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RXOh7wrzOCLV5Xd1ilv5qq9uZKKUOM9cJmaiVy0wAgc=;
        b=pSqr79/CI3LQP13aDnDiuZqk2nMPQVP+ex8K7t362xXTHEemOB0LR3CpzZGnVmg0gt
         N6t6kRsur+vyj8lajGkO53WXBHewFB+gLoKoTifpSYDTVpIWCSEbUWtBB7+nbvWRquT1
         3E5VCDd9ZLfjVFJqlvAfYGxJ/0MRLOfKF9keqUwwH3DX2r7AmKRi7/uclyFvbX8s0eQx
         QSP0/nhLqFteU4MpOzSTbtJOrWryBrZ6N8qt9K8HB7IgsE2w/YDMVKtulvSouekRC2aO
         p68Xzn4SikQjH9mnRVA6w7GkpOXjG66kAs4fFxaI7bdN4XDqvdZgJnJkmsPlilWEeZYQ
         vGjQ==
X-Gm-Message-State: APjAAAXzHk9HVCS6GQuVela3j2E2U2y4G6OxJXmza8LSfzqTG2jqSRbH
        Vq8Cm6wcY6K9DcK3bJT4BKE=
X-Google-Smtp-Source: APXvYqxLF/40I/++PMTlJCHyesML7FzBxMGt6MjrbFTI1VxoCCak4PJ0B+ksA1ci43o7TljiYOUETg==
X-Received: by 2002:ad4:46e4:: with SMTP id h4mr10669270qvw.181.1576805267873;
        Thu, 19 Dec 2019 17:27:47 -0800 (PST)
Received: from [10.10.10.183] (71-218-148-139.hlrn.qwest.net. [71.218.148.139])
        by smtp.googlemail.com with ESMTPSA id o33sm2538280qta.27.2019.12.19.17.27.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2019 17:27:47 -0800 (PST)
Subject: Re: [PATCH nf-next 9/9] netfilter: nft_meta: add support for slave
 device ifindex matching
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Martin Willi <martin@strongswan.org>,
        David Ahern <dsahern@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Benjamin Poirier <bpoirier@cumulusnetworks.com>
References: <20191218110521.14048-1-fw@strlen.de>
 <20191218110521.14048-10-fw@strlen.de>
 <ce5758ce-7541-3b6b-d61c-ae59219ef898@gmail.com>
 <20191219170815.GD795@breakpoint.cc>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <45af5078-b5d3-3a90-1c9e-5ccde2a8fe5d@gmail.com>
Date:   Thu, 19 Dec 2019 18:27:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191219170815.GD795@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 12/19/19 10:08 AM, Florian Westphal wrote:
> David Ahern <dsahern@gmail.com> wrote:
>> On 12/18/19 4:05 AM, Florian Westphal wrote:
>>> Allow to match on vrf slave ifindex or name.
>>>
>>> In case there was no slave interface involved, store 0 in the
>>> destination register just like existing iif/oif matching.
>>>
>>> sdif(name) is restricted to the ipv4/ipv6 input and forward hooks,
>>> as it depends on ip(6) stack parsing/storing info in skb->cb[].
>>>
>>> Cc: Martin Willi <martin@strongswan.org>
>>> Cc: David Ahern <dsahern@kernel.org>
>>> Cc: Shrijeet Mukherjee <shrijeet@gmail.com>
>>> Signed-off-by: Florian Westphal <fw@strlen.de>
>>> ---
>>>  include/uapi/linux/netfilter/nf_tables.h |  4 ++
>>>  net/netfilter/nft_meta.c                 | 76 +++++++++++++++++++++---
>>>  2 files changed, 73 insertions(+), 7 deletions(-)
>>>
>>
>> do you have an example that you can share?
> 
> nft add rule inet filter input meta sdifname "eth0" accept
> 
> so its similar to existing iif(name) that test for the input device.
> 
> This is the nft equivalent for the "slavedev" match that Martin proposed
> here:
> 
> http://patchwork.ozlabs.org/patch/1211435/
> 

Thanks for the example. I still have not found the time to get up to
speed with nft. I am glad to see netfilter matches on the enslaved
interface with VRF; it's a much needed feature.
