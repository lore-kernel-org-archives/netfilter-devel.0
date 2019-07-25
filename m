Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C804C7618B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 10:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1700622BEF
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 10:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387805AbfGYKuw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 06:50:52 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:57051 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728232AbfGYKuw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 06:50:52 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 7244541D4D;
        Thu, 25 Jul 2019 18:50:48 +0800 (CST)
Subject: Re: [PATCH nf-next v2 0/5] sipport nft_tunnel offload
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
References: <1564047969-26514-1-git-send-email-wenxu@ucloud.cn>
 <20190725101633.ya6kcet6vc4iggim@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <6f8f92d7-0813-f71f-1857-3998b49f32a2@ucloud.cn>
Date:   Thu, 25 Jul 2019 18:50:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725101633.ya6kcet6vc4iggim@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSkNNS0tLSE9MSkhMT05ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PBg6SCo*Ljg6NlYqDRNWIgIc
        OQ0wCgxVSlVKTk1PS05KQ09CQ05IVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSkxNSDcG
X-HM-Tid: 0a6c28c13d7f2086kuqy7244541d4d
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

sorry for this. Only the first patch modify because it is based on http://patchwork.ozlabs.org/patch/1136706/ which is not correct

On 7/25/2019 6:16 PM, Pablo Neira Ayuso wrote:
> On Thu, Jul 25, 2019 at 05:46:04PM +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> This series support tunnel meta match offload and
>> tunnel_obj ation offload. This series depends on
>> http://patchwork.ozlabs.org/project/netfilter-devel/list/?series=120961
> Oh, you sent a v2 and I was spending time to review v1 which is now
> useful anymore... This is starting to be very confusing :-(
>
