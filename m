Return-Path: <SRS0=xvfr=2C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8300EC43603
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Dec 2019 10:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EBF821655
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Dec 2019 10:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbfLLKGk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 05:06:40 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:40942 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728302AbfLLKGj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 05:06:39 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 878EE4198B;
        Thu, 12 Dec 2019 18:06:33 +0800 (CST)
Subject: Re: [PATCH nf 0/4] netfilter: nf_flow_table_offload: something fixes
From:   wenxu <wenxu@ucloud.cn>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
References: <1576143835-19749-1-git-send-email-wenxu@ucloud.cn>
Message-ID: <2cc2128e-e957-7d4d-2a27-2feb0839f472@ucloud.cn>
Date:   Thu, 12 Dec 2019 18:06:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1576143835-19749-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS0xDQkJCTE5MTE1NTElZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NSo6EDo*Czg0PUgeGA5WNys1
        CxQaFBJVSlVKTkxNSk9OSkJIQ05PVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSk1ISDcG
X-HM-Tid: 0a6ef9930ae82086kuqy878ee4198b
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi pablo,


Please drop this series. I will resend one. Tanks

On 12/12/2019 5:43 PM, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
>
> wenxu (4):
>   netfilter: nf_flow_table_offload: fix dst_neigh lookup
>   netfilter: nf_flow_table_offload: check the status of dst_neigh
>   netfilter: nf_flow_table_offload: fix miss dst_neigh_lookup for ipv6
>   netfilter: nf_flow_table_offload: fix the nat port mangle.
>
>  net/netfilter/nf_flow_table_offload.c | 56 +++++++++++++++++++++++++----------
>  1 file changed, 41 insertions(+), 15 deletions(-)
>
