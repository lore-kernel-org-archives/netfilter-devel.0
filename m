Return-Path: <SRS0=uSEi=V5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A7F4C433FF
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 13:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1868820838
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 13:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbfHANmJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 09:42:09 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:3013 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfHANmJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 09:42:09 -0400
Received: from [192.168.1.4] (unknown [114.92.198.84])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 48D7E4116F;
        Thu,  1 Aug 2019 21:42:05 +0800 (CST)
Subject: Re: [PATCH nf-next v2 03/11] netfilter: nf_tables_offload: split
 nft_offload_reg to match and action type
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
References: <1564061644-31189-1-git-send-email-wenxu@ucloud.cn>
 <1564061644-31189-4-git-send-email-wenxu@ucloud.cn>
 <20190801121553.kmi5ttszf534zmi4@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <7f855769-2fc9-50b9-810e-d1eb84802501@ucloud.cn>
Date:   Thu, 1 Aug 2019 21:41:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190801121553.kmi5ttszf534zmi4@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVQ01DS0tLSk9CTElNQ0xZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MiI6LSo*Mjg2FE81VjM#Sk8x
        HzMaCi1VSlVKTk1PTU1NQklOTE9CVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKT1VC
        SVVKQkNVQ09ZV1kIAVlBSkJLSjcG
X-HM-Tid: 0a6c4d6a91652086kuqy48d7e4116f
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I will repost the series based on this patch

在 2019/8/1 20:15, Pablo Neira Ayuso 写道:
> On Thu, Jul 25, 2019 at 09:33:58PM +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> Currently the nft_offload_reg is only can be used for match condition.
>> Can not be used for action. Add nft_offload_reg_type to make nft_offload_reg
>> can be used for action also.
> I think this patch provides what you need:
>
> https://patchwork.ozlabs.org/patch/1140431/
>
> that is access to the data that the immediate stores in the registers.
>
