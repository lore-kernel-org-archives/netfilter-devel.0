Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4305BC432C0
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 03:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11C4F20833
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 03:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbfLBDRI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Dec 2019 22:17:08 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:41786 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727285AbfLBDRI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Dec 2019 22:17:08 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 43BF841CF1;
        Mon,  2 Dec 2019 11:16:51 +0800 (CST)
Subject: Re: [PATCH nf] netfilter: nf_tables_offload: Fix check the
 NETDEV_UNREGISTER in netdev event
From:   wenxu <wenxu@ucloud.cn>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
References: <1573618867-9755-1-git-send-email-wenxu@ucloud.cn>
Message-ID: <a7a98d09-f030-7fe7-b97d-23c9ee1415d5@ucloud.cn>
Date:   Mon, 2 Dec 2019 11:16:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1573618867-9755-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSEJKS0tLSk5KTUhPSUlZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Oi46Ijo4PzgwAwEOGhpCMTEj
        Dk8aCgJVSlVKTkxOSU5NTUpKT0hDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSUtMTjcG
X-HM-Tid: 0a6ec49c5a0c2086kuqy43bf841cf1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi pablo,


Any comments about this patch?


BR

wenxu

On 11/13/2019 12:21 PM, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> It should check the NETDEV_UNREGISTER in  nft_offload_netdev_event
>
> Fixes: 06d392cbe3db ("netfilter: nf_tables_offload: remove rules when the device unregisters")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  net/netfilter/nf_tables_offload.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
> index e25dab8..b002832 100644
> --- a/net/netfilter/nf_tables_offload.c
> +++ b/net/netfilter/nf_tables_offload.c
> @@ -446,6 +446,9 @@ static int nft_offload_netdev_event(struct notifier_block *this,
>  	struct net *net = dev_net(dev);
>  	struct nft_chain *chain;
>  
> +	if (event != NETDEV_UNREGISTER)
> +		return 0;
> +
>  	mutex_lock(&net->nft.commit_mutex);
>  	chain = __nft_offload_get_chain(dev);
>  	if (chain)
