Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5248C33CAF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 23:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5A352077C
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 23:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390244AbgAPXF1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 18:05:27 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:30556 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388411AbgAPXF1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 18:05:27 -0500
Received: from [192.168.1.4] (unknown [180.157.109.243])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 9722340CCA;
        Fri, 17 Jan 2020 07:05:22 +0800 (CST)
Subject: Re: [PATCH nf-next v4 0/4] netfilter: flowtable: add indr-block
 offload
From:   wenxu <wenxu@ucloud.cn>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
References: <1578996040-6413-1-git-send-email-wenxu@ucloud.cn>
Message-ID: <ff794ea0-11b7-51fa-0f9b-32481ec90e7a@ucloud.cn>
Date:   Fri, 17 Jan 2020 07:04:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <1578996040-6413-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSUhPS0tLSUtOQkJITU5ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PUk6DBw6Ojg9GjBREyEjNB4Z
        UTMKCz9VSlVKTkxCSUpOQklJQ0hKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpDS1VK
        TkxVSktCVUlPSFlXWQgBWUFKQk5MNwY+
X-HM-Tid: 0a6fb09aa6592086kuqy9722340cca
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi pablo,


How about this series? Expect for your feedback. Thanks.


BR

wenxu

ÔÚ 2020/1/14 18:00, wenxu@ucloud.cn Ð´µÀ:
> From: wenxu <wenxu@ucloud.cn>
>
> This patch provide tunnel offload based on route lwtunnel.
> The first two patches support indr callback setup
> Then add tunnel match and action offload.
>
> This version just rebase to the nf-next.
>
> Pablo, please give me some feedback. If you feel this series is ok, please
> apply it. Thanks.
>
> wenxu (4):
>    netfilter: flowtable: add nf_flow_table_block_offload_init()
>    netfilter: flowtable: add indr block setup support
>    netfilter: flowtable: add tunnel match offload support
>    netfilter: flowtable: add tunnel encap/decap action offload support
>
>   net/netfilter/nf_flow_table_offload.c | 239 +++++++++++++++++++++++++++++++---
>   1 file changed, 222 insertions(+), 17 deletions(-)
>
