Return-Path: <SRS0=4EdP=WW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 890CBC3A59F
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Aug 2019 13:56:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63D302080C
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Aug 2019 13:56:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732159AbfHZN4F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Aug 2019 09:56:05 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:19549 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731592AbfHZN4E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Aug 2019 09:56:04 -0400
Received: from [192.168.1.4] (unknown [116.234.4.202])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 2D4DE41650;
        Mon, 26 Aug 2019 21:56:01 +0800 (CST)
Subject: Re: [PATCH nf-next v2] netfilter: nf_table_offload: Fix the incorrect
 rcu usage in nft_indr_block_get_and_ing_cmd
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
References: <1566220952-27225-1-git-send-email-wenxu@ucloud.cn>
 <20190826082350.srv23fnbipovzkvu@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <e0b08c4d-c041-fe3f-e9d7-d28a703d4900@ucloud.cn>
Date:   Mon, 26 Aug 2019 21:55:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826082350.srv23fnbipovzkvu@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVT0hLS0tLSEtOSkxOTENZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MiI6Oio6UTgwVjwSFVFWNEwV
        UStPCUNVSlVKTk1NQ0lMTE1KSEhNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SE9VT1VJS0lZV1kIAVlBSkJISDcG
X-HM-Tid: 0a6cce364e842086kuqy2d4de41650
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


在 2019/8/26 16:38, Pablo Neira Ayuso 写道:
> On Mon, Aug 19, 2019 at 09:22:32PM +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> The flow_block_ing_cmd() needs to call blocking functions while iterating
>> block_ing_cb_list, nft_indr_block_get_and_ing_cmd is in the cb_list,
>> So it is the incorrect rcu case. To fix it just traverse the list under
>> the commit mutex.
> The flow_indr_block_call() is called from a path that already holds
> this lock.

The flow_indr_block_call already hodls this lock. But the flow_block_ing_cmd is not called

by flow_indr_block_call. It is called by offloaded driver with unregister event for indr_dev.

>
