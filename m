Return-Path: <SRS0=Os8a=S2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB27C10F11
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Apr 2019 09:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BCA7218B0
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Apr 2019 09:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfDXJMA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Apr 2019 05:12:00 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7248 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727558AbfDXJMA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Apr 2019 05:12:00 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1987F76AA964D2CD4006;
        Wed, 24 Apr 2019 17:11:57 +0800 (CST)
Received: from [127.0.0.1] (10.184.189.20) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Wed, 24 Apr 2019
 17:11:50 +0800
Subject: Re: [PATCH] net: netfilter: Fix ipv6 rp_filter dropping vrf packets
 by mistake
To:     Florian Westphal <fw@strlen.de>
CC:     <pablo@netfilter.org>, <kadlec@blackhole.kfki.hu>,
        <dsahern@gmail.com>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <netfilter-devel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mingfangsen <mingfangsen@huawei.com>
References: <094b7376-f796-71b6-7a81-28866b0f882b@huawei.com>
 <20190424080214.vadrfiufcv6xa3cm@breakpoint.cc>
From:   linmiaohe <linmiaohe@huawei.com>
Message-ID: <867b9625-a34a-f4a9-0af1-19b3bba3c214@huawei.com>
Date:   Wed, 24 Apr 2019 17:11:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190424080214.vadrfiufcv6xa3cm@breakpoint.cc>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.189.20]
X-CFilter-Loop: Reflected
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 2019/4/24 16:02, Florian Westphal wrote:
> linmiaohe <linmiaohe@huawei.com> wrote:
> 
> [ CC dsa, dropped some CCs ]
> 
>> When firewall is enabled with rp_filter, vrf ipv6 packets
>> will be dropped because in device is vrf but out device
>> is an enslaved device. So rt->rt6i_idev->dev != dev and
>> maybe return false in func rpfilter_lookup_reverse6.
>>
>> Here is the out message when I ping the peer:
>> ip vrf exec vrf1 ping 2013::2 -c 1
>> 1 packets transmitted, 0 received, 100% packet loss, time 0ms
>>
>> The drop info in /var/log/message:
>> Apr 24 14:59:45 localhost kernel: [81316.158259] rpfilter_DROP: IN=vrf1
>> OUT= MAC=52:54:00:9e:dd:c1:52:54:00:4f:81:38:86:dd
>> SRC=2013:0000:0000:0000:0000:0000:0000:0002
>> DST=2013:0000:0000:0000:0000:0000:0000:0001 LEN=104 TC=0 HOPLIMIT=64
>> FLOWLBL=1032942 PROTO=ICMPv6 TYPE=129 CODE=0 ID=14943 SEQ=1
>>
>> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>> ---
>>  net/ipv6/netfilter/ip6t_rpfilter.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
>> index c3c6b09acdc4..5cbc91f53736 100644
>> --- a/net/ipv6/netfilter/ip6t_rpfilter.c
>> +++ b/net/ipv6/netfilter/ip6t_rpfilter.c
>> @@ -73,6 +73,12 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
>>  		goto out;
>>  	}
>>
>> +	if (netif_is_l3_master(dev)) {
>> +		dev = __dev_get_by_index(dev_net(dev), IP6CB(skb)->iif);
>> +		if (!dev)
>> +			goto out;
> 
> I suspect this should be 'dev_get_by_index_rcu'.
> 
> .
> 
You are right, it's my mistake.Thanks for your remind.I will send v2
to fix this. Thanks.

