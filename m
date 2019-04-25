Return-Path: <SRS0=ai/f=S3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE07C10F03
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 07:22:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9E49217D7
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 07:22:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbfDYHWV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 03:22:21 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54022 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727435AbfDYHWU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 03:22:20 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 73B1DC3160BF9F590EBC;
        Thu, 25 Apr 2019 15:22:17 +0800 (CST)
Received: from [127.0.0.1] (10.184.189.20) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Thu, 25 Apr 2019
 15:22:08 +0800
Subject: Re: [PATCH v2] net: netfilter: Fix ipv6 rp_filter dropping vrf
 packets by mistake
To:     David Ahern <dsahern@gmail.com>, <pablo@netfilter.org>,
        <kadlec@blackhole.kfki.hu>, <fw@strlen.de>, <davem@davemloft.net>,
        <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Mingfangsen <mingfangsen@huawei.com>
References: <7662b7eb-89a4-adac-1e46-2c09816641f2@huawei.com>
 <05222a41-c60b-0c05-6beb-26a143deea36@gmail.com>
From:   linmiaohe <linmiaohe@huawei.com>
Message-ID: <58b71ee4-c665-4cff-a9fb-5af9d402e1ea@huawei.com>
Date:   Thu, 25 Apr 2019 15:21:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <05222a41-c60b-0c05-6beb-26a143deea36@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.189.20]
X-CFilter-Loop: Reflected
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 2019/4/24 23:24, David Ahern wrote:
> On 4/24/19 3:12 AM, linmiaohe wrote:
>> From: Miaohe Lin <linmiaohe@huawei.com>
>>
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
>> Signed-off-by: linmiaohe <linmiaohe@huawei.com>
>> ---
>>  net/ipv6/netfilter/ip6t_rpfilter.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
>> index c3c6b09acdc4..cf1070ab1252 100644
>> --- a/net/ipv6/netfilter/ip6t_rpfilter.c
>> +++ b/net/ipv6/netfilter/ip6t_rpfilter.c
>> @@ -73,6 +73,12 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
>>  		goto out;
>>  	}
>>
>> +	if (netif_is_l3_master(dev)) {
>> +		dev = dev_get_by_index_rcu(dev_net(dev), IP6CB(skb)->iif);
>> +		if (!dev)
>> +			goto out;
>> +	}
>> +
>>  	if (rt->rt6i_idev->dev == dev || (flags & XT_RPFILTER_LOOSE))
>>  		ret = true;
>>   out:
>>
> 
> What about the case where XT_RPFILTER_LOOSE is set? flowi6_oif needs to
> be set to the dev->ifindex if dev is an l3 master.
> 

Thanks, you are right. I miss the case when XT_RPFILTER_LOOSE is set. flowi6_oif
needs to be set to the device ifindex if dev is an l3 master or l3 slave which
looks like this in function rpfilter_lookup_reverse6:

} else if ((flags & XT_RPFILTER_LOOSE) == 0) {
	fl6.flowi6_oif = dev->ifindex;
} else if (netif_is_l3_master(dev) || netif_is_l3_slave(dev))
	fl6.flowi6_oif = dev->ifindex;

> And looking at the IPv4 version I do not see how it could be correct
> either. Have you tested it?
> 
> .
> 

I thought rp_filter is ok with ipv4 version because it works in my enviroment. But
I forgot rp_filter func in my enviroment is provided by sysctl rather than iptables
rpfilter. So I tested again and found we need to fix ipv4 version too.

Thanks for your remind, I will fix all of these and send a patch v2 soon.
Thanks.

