Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB9AFC7618B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 07:30:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E36F22BF3
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 07:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388114AbfGYHaM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 03:30:12 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:16420 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387738AbfGYHaM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 03:30:12 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 9BFD641C1E;
        Thu, 25 Jul 2019 15:30:08 +0800 (CST)
Subject: Re: [PATCH nf] netfilter: nft_tunnel: Fix convert tunnel id to host
 endian
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
References: <1563960729-17767-1-git-send-email-wenxu@ucloud.cn>
 <20190725065401.bla2zttaadr4lzzz@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <ed42cd62-80be-a6e9-34c2-e2e2c038674f@ucloud.cn>
Date:   Thu, 25 Jul 2019 15:30:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725065401.bla2zttaadr4lzzz@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS0lKQkJCQk5OSkxMSEpZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PBw6Dyo4Njg2NlZCDykSOVYR
        QiwKFANVSlVKTk1PS0hCQ0tDQ0JCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSEpJSjcG
X-HM-Tid: 0a6c2809873f2086kuqy9bfd641c1e
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 7/25/2019 2:54 PM, Pablo Neira Ayuso wrote:
> On Wed, Jul 24, 2019 at 05:32:09PM +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> In the action store tun_id to reg in a host endian. But the
>> nft_cmp action get the user data in a net endian which lead
>> match failed.
>>
>> nft --debug=netlink add rule netdev firewall aclin ip daddr 10.0.0.7
>> tunnel key 1000 fwd to eth0
>>
>> [ meta load protocol => reg 1 ]
>> [ cmp eq reg 1 0x00000008 ]
>> [ payload load 4b @ network header + 16 => reg 1 ]
>> [ cmp eq reg 1 0x0700000a ]
>> [ tunnel load id => reg 1 ]
>> [ cmp eq reg 1 0xe8030000 ]
>> [ immediate reg 1 0x0000000f ]
>> [ fwd sreg_dev 1 ]
>>
>> Fixes: aaecfdb5c5dd ("netfilter: nf_tables: match on tunnel metadata")
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>>  net/netfilter/nft_tunnel.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
>> index 3d4c2ae..c9f4585 100644
>> --- a/net/netfilter/nft_tunnel.c
>> +++ b/net/netfilter/nft_tunnel.c
>> @@ -53,7 +53,7 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
>>  		     !(tun_info->mode & IP_TUNNEL_INFO_TX)) ||
>>  		    (priv->mode == NFT_TUNNEL_MODE_TX &&
>>  		     (tun_info->mode & IP_TUNNEL_INFO_TX)))
>> -			*dest = ntohl(tunnel_id_to_key32(tun_info->key.tun_id));
>> +			*dest = tunnel_id_to_key32(tun_info->key.tun_id);
> Something is wrong here:
>
> __be32 tunnel_id_to_key32(...)
>
> This function returns __be32 and you are now storing this in big
> endian, while description refers to "host endian".

The vlaue should store as the network endian in the reg(which is same as nft_paylaod). 

"tunnel key 1000" convert to [cmp eq reg 1 0xe8030000] which in network-endian

But original it is store as host endian so fix it. Maybe the description so bad and 
confuse you

