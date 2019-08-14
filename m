Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E494CC0650F
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C162F2084F
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfHNI2w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 04:28:52 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:5414 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfHNI2w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 04:28:52 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 23ECD41A2B;
        Wed, 14 Aug 2019 16:28:45 +0800 (CST)
Subject: Re: [PATCH nf-next v3 5/9] netfilter: nft_tunnel: support
 NFT_TUNNEL_SRC/DST_IP match
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
References: <1564668086-16260-1-git-send-email-wenxu@ucloud.cn>
 <1564668086-16260-6-git-send-email-wenxu@ucloud.cn>
 <20190813181930.ljrisiq2iszcddlk@salvia>
 <ba98af8c-fcd3-50dd-770d-ddb85a887031@ucloud.cn>
 <20190814080037.w7xi2htgshg2adsd@salvia>
 <20190814081915.xnogz4ktan6siowo@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <5690e59a-1e03-1463-a876-c592949ceb64@ucloud.cn>
Date:   Wed, 14 Aug 2019 16:28:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190814081915.xnogz4ktan6siowo@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS0xNQkJCTENITkpOQkhZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PBg6Qio*IzgrEzlKKSgiNA4c
        CwxPCghVSlVKTk1OTExKSElOSElIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSU9DSjcG
X-HM-Tid: 0a6c8f3e5f3c2086kuqy23ecd41a2b
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 8/14/2019 4:19 PM, Pablo Neira Ayuso wrote:
> On Wed, Aug 14, 2019 at 10:00:37AM +0200, Pablo Neira Ayuso wrote:
> [...]
>>>>> @@ -86,6 +110,8 @@ static int nft_tunnel_get_init(const struct nft_ctx *ctx,
>>>>>  		len = sizeof(u8);
>>>>>  		break;
>>>>>  	case NFT_TUNNEL_ID:
>>>>> +	case NFT_TUNNEL_SRC_IP:
>>>>> +	case NFT_TUNNEL_DST_IP:
>>>> Missing policy updates, ie. nft_tunnel_key_policy.
>>> I don't understand why it need update nft_tunnel_key_policy
>>> which is used for tunnel_obj action. This NFT_TUNNEL_SRC/DST_IP is used
>>> for tunnel_expr
>> It seems there is no policy object for _get_eval(), add it.
> There is. It is actually nft_tunnel_policy.

nft_tunnel_policy contain a NFTA_TUNNEL_KEY

NFTA_TUNNEL_KEY support NFT_TUNNEL_ID, NFT_TUNNEL_SRC/DST_IP

I think the NFTA_TUNNEL_KEY  means a match key which can be tun_id, tun_src, tun_dst

