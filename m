Return-Path: <SRS0=7QpW=T7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC443C28CC2
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 09:06:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84D3E2666E
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 09:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfEaJF5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 May 2019 05:05:57 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17634 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726768AbfEaJF5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 May 2019 05:05:57 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A8B726336D0F26F8ECF0;
        Fri, 31 May 2019 17:05:54 +0800 (CST)
Received: from [127.0.0.1] (10.133.213.239) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 31 May 2019
 17:05:52 +0800
Subject: Re: [PATCH net-next] netfilter: nf_conntrack_bridge: Fix build error
 without IPV6
To:     Pablo Neira Ayuso <pablo@netfilter.org>
References: <20190531024643.3840-1-yuehaibing@huawei.com>
 <19095cab-fbc5-f200-a40c-cb4c1a12fbc6@huawei.com>
 <20190531080257.62mfimdlwuv42bk3@salvia>
CC:     <kadlec@blackhole.kfki.hu>, <fw@strlen.de>,
        <linux-kernel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netfilter-devel@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <c65a989a-9b5d-b98e-1bdd-7820a34847c2@huawei.com>
Date:   Fri, 31 May 2019 17:05:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20190531080257.62mfimdlwuv42bk3@salvia>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 2019/5/31 16:02, Pablo Neira Ayuso wrote:
> On Fri, May 31, 2019 at 11:06:49AM +0800, Yuehaibing wrote:
>> +cc netdev
>>
>> On 2019/5/31 10:46, YueHaibing wrote:
>>> Fix gcc build error while CONFIG_IPV6 is not set
>>>
>>> In file included from net/netfilter/core.c:19:0:
>>> ./include/linux/netfilter_ipv6.h: In function 'nf_ipv6_br_defrag':
>>> ./include/linux/netfilter_ipv6.h:110:9: error: implicit declaration of function 'nf_ct_frag6_gather' [-Werror=implicit-function-declaration]
>>>
>>> Reported-by: Hulk Robot <hulkci@huawei.com>
>>> Fixes: 764dd163ac92 ("netfilter: nf_conntrack_bridge: add support for IPv6")
>>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>>> ---
>>>  include/linux/netfilter_ipv6.h | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
>>> index a21b8c9..4ea97fd 100644
>>> --- a/include/linux/netfilter_ipv6.h
>>> +++ b/include/linux/netfilter_ipv6.h
>>> @@ -96,6 +96,8 @@ static inline int nf_ip6_route(struct net *net, struct dst_entry **dst,
>>>  #endif
>>>  }
>>>  
>>> +int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user);
>>> +
> 
> This is already defined in:
> 
> include/net/netfilter/ipv6/nf_defrag_ipv6.h
> 
> Probably this?

Yes, this works for me.

> 

