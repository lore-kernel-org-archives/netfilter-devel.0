Return-Path: <SRS0=chdK=V2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E24BC433FF
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 07:05:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 630D5206DD
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 07:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbfG2HFo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Jul 2019 03:05:44 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:5395 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbfG2HFo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Jul 2019 03:05:44 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 4228241655;
        Mon, 29 Jul 2019 15:05:36 +0800 (CST)
Subject: Re: [PATCH net-next v4 2/3] flow_offload: Support get default block
 from tc immediately
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <1564296769-32294-1-git-send-email-wenxu@ucloud.cn>
 <1564296769-32294-3-git-send-email-wenxu@ucloud.cn>
 <20190728131653.6af72a87@cakuba.netronome.com>
 <5eed91c1-20ed-c08c-4700-979392bc5f33@ucloud.cn>
 <20190728214237.2c0687db@cakuba.netronome.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <c405ff42-dfc5-6f3f-061c-7788e1204afa@ucloud.cn>
Date:   Mon, 29 Jul 2019 15:05:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190728214237.2c0687db@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS0lKQkJCQk5OSkxMSEpZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ni46Pxw4LDgySUoYDh4*IR8T
        FhowCjhVSlVKTk1PSENIQkhNTU9JVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSUxDQjcG
X-HM-Tid: 0a6c3c8c80492086kuqy4228241655
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 7/29/2019 12:42 PM, Jakub Kicinski wrote:
> On Mon, 29 Jul 2019 10:43:56 +0800, wenxu wrote:
>> On 7/29/2019 4:16 AM, Jakub Kicinski wrote:
>>> I don't know the nft code, but it seems unlikely it wouldn't have the
>>> same problem/need..  
>> nft don't have the same problem.  The offload rule can only attached
>> to offload base chain.
>>
>> Th  offload base chain is created after the device driver loaded (the
>> device exist).
> For indirect blocks the block is on the tunnel device and the offload
> target is another device. E.g. you offload rules from a VXLAN device
> onto the ASIC. The ASICs driver does not have to be loaded when VXLAN
> device is created.
>
> So I feel like either the chain somehow directly references the offload
> target (in which case the indirect infrastructure with hash lookup etc
> is not needed for nft), or indirect infra is needed, and we need to take
> care of replays.

So you mean the case is there are two card A and B both can offload vxlan.

First vxlan device offload with A.  And then the B driver loaded, So the rules

should replay to B device?



