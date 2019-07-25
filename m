Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0697C76194
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 11:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6499229F3
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 11:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391461AbfGYLAA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 07:00:00 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:3520 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388173AbfGYLAA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 07:00:00 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 8BDC241CAA;
        Thu, 25 Jul 2019 18:59:53 +0800 (CST)
Subject: Re: [PATCH net-next 2/3] flow_offload: Support get tcf block
 immediately
To:     Florian Westphal <fw@strlen.de>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <1564048533-27283-1-git-send-email-wenxu@ucloud.cn>
 <1564048533-27283-2-git-send-email-wenxu@ucloud.cn>
 <20190725102434.c72m32tpsjwf7nff@breakpoint.cc>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <28d218f1-39b3-57ab-086e-f153ddc8f749@ucloud.cn>
Date:   Thu, 25 Jul 2019 18:59:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725102434.c72m32tpsjwf7nff@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVT0JOS0tLSklIQkxMTU1ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MCo6Pzo5Hzg2OlYCHRceK0k6
        MDkaCyNVSlVKTk1PS05JSEJITE1DVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSU1JSTcG
X-HM-Tid: 0a6c28c98eee2086kuqy8bdc241caa
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


@tc_indr_block_dev_get funcion,

static struct tc_indr_block_dev *tc_indr_block_dev_get(struct net_device *dev)
{
    struct tc_indr_block_dev *indr_dev;

    indr_dev = tc_indr_block_dev_lookup(dev);
    if (indr_dev)
        goto inc_ref;

    indr_dev = kzalloc(sizeof(*indr_dev), GFP_KERNEL);
    if (!indr_dev)
        return NULL;

    INIT_LIST_HEAD(&indr_dev->cb_list);
    indr_dev->dev = dev;
    indr_dev->block = tc_dev_ingress_block(dev);

when the indr device register. It will call __tc_indr_block_cb_register-->tc_indr_block_dev_get,

It can get the indr_dev->block immediately through tc_dev_ingress_block,

But when the indr_block_dev_get put in the common flow_offload.  It can not direct access 

tc_dev_ingress_block.



On 7/25/2019 6:24 PM, Florian Westphal wrote:
> wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> It provide a callback to find the tcf block in
>> the flow_indr_block_dev_get
> Can you explain why you're making this change?
> This will help us understand the concept/idea of your series.
>
> The above describes what the patch does, but it should
> explain why this is callback is added.
>
