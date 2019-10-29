Return-Path: <SRS0=pwfE=YW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50501CA9EC2
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Oct 2019 08:24:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C46C20717
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Oct 2019 08:24:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbfJ2IYC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Oct 2019 04:24:02 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:51956 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728757AbfJ2IYC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Oct 2019 04:24:02 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 474E041BA4;
        Tue, 29 Oct 2019 16:23:58 +0800 (CST)
Subject: Re: [PATCH nf-next] netfilter: nf_tables_offload: support offload iif
 types meta offload
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
References: <1571989584-940-1-git-send-email-wenxu@ucloud.cn>
 <20191028150518.ddqjqv6aamwv4uic@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <8718c5b3-4c42-8dc7-35ed-59d8e7df6c38@ucloud.cn>
Date:   Tue, 29 Oct 2019 16:23:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191028150518.ddqjqv6aamwv4uic@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS0xMQkJCQ0hLSU9OQkxZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NBQ6LAw5DTgzFx0ITxcYKSwr
        P09PFC1VSlVKTkxJSEhMT0hCQ0JJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSk5LSTcG
X-HM-Tid: 0a6e169d4eee2086kuqy474e041ba4
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

So it is better to extend the flow_dissector_key_meta to support iiftype match?


BR

wenxu

On 10/28/2019 11:05 PM, Pablo Neira Ayuso wrote:
> Please, have a look at:
>
> https://patchwork.ozlabs.org/patch/1185472/
>
> for supporting iif matching.
>
> Thanks.
>
