Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB186C7618B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 10:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD6EC22BEF
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 10:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbfGYKpJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 06:45:09 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:48767 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbfGYKpJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 06:45:09 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id E95D441B51;
        Thu, 25 Jul 2019 18:45:05 +0800 (CST)
Subject: Re: [PATCH nf-next 2/7] netfilter: nf_tables_offload: add
 offload_actions callback
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
References: <1563886364-11164-1-git-send-email-wenxu@ucloud.cn>
 <1563886364-11164-3-git-send-email-wenxu@ucloud.cn>
 <20190725101429.mldb64bfhr67254m@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <9d73cbdf-d3df-ceb0-0c44-71e61ee420d4@ucloud.cn>
Date:   Thu, 25 Jul 2019 18:44:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725101429.mldb64bfhr67254m@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVQ0lIS0tLSEpKQ05KTllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PSo6Hww6EzgrPlYVHR8pEykc
        TQ8wCj1VSlVKTk1PS05KTktNSkpOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSU1JSjcG
X-HM-Tid: 0a6c28bc038b2086kuqye95d441b51
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 7/25/2019 6:14 PM, Pablo Neira Ayuso wrote:
> On Tue, Jul 23, 2019 at 08:52:39PM +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> There will be zero one or serval actions for some expr. such as
>> payload set and immediate
>>
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>>  include/net/netfilter/nf_tables.h         | 7 ++++++-
>>  include/net/netfilter/nf_tables_offload.h | 2 --
>>  net/netfilter/nf_tables_offload.c         | 4 ++--
>>  net/netfilter/nft_immediate.c             | 2 +-
>>  4 files changed, 9 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
>> index 9b62456..9285df2 100644
>> --- a/include/net/netfilter/nf_tables.h
>> +++ b/include/net/netfilter/nf_tables.h
>> @@ -785,7 +785,7 @@ struct nft_expr_ops {
>>  	int				(*offload)(struct nft_offload_ctx *ctx,
>>  						   struct nft_flow_rule *flow,
>>  						   const struct nft_expr *expr);
>> -	u32				offload_flags;
>> +	int				(*offload_actions)(const struct nft_expr *expr);
> I don't understand why you need to add this? is it for payload?


yes it is used for set payload  and immediately  actions. It maybe splited to several actions. The immediate action

may conatian 1 or 0 actions

>
