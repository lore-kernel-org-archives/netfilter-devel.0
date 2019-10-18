Return-Path: <SRS0=5/AD=YL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 361FFCA9EA1
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 10:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EC80222BD
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 10:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390097AbfJRKkl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Oct 2019 06:40:41 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:12308 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731671AbfJRKkl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 06:40:41 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 08C3D419FD;
        Fri, 18 Oct 2019 18:40:37 +0800 (CST)
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add vlan support
To:     Florian Westphal <fw@strlen.de>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
References: <1571392968-1263-1-git-send-email-wenxu@ucloud.cn>
 <20191018102402.GY25052@breakpoint.cc>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <e7714199-ac8e-af7b-dc86-15f3aa19d3b2@ucloud.cn>
Date:   Fri, 18 Oct 2019 18:40:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191018102402.GY25052@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVT0pLS0tLS0NOQ0hLTUJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ni46GSo4Kjg*TBkaGlEqAxNW
        Q00aFBZVSlVKTkxKSEJOSUhDSkNNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSUlPSzcG
X-HM-Tid: 0a6dde7478f52086kuqy08c3d419fd
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 10/18/2019 6:24 PM, Florian Westphal wrote:
> wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> This patch implements the vlan expr type that can be used to
>> configure vlan tci and vlan proto
> Looks like a very small module with no external dependencies,
> I think you could make this a nft-builtin feature and just add
> nft_vlan.o to 'nf_tables-objs' in net/netfilter/Makefile, similar to
> nft_rt.
>
> What do you think?
>
> If you plan to extend this in the future then I'm fine with keeping it
> as a module.
It can add vlan tci / proto "get" expr and It also can support offload things in the future.
>> +static int nft_vlan_set_init(const struct nft_ctx *ctx,
>> +			     const struct nft_expr *expr,
>> +			     const struct nlattr * const tb[])
>> +{
>> +	struct nft_vlan *priv = nft_expr_priv(expr);
>> +	int err;
> I think you need to add
>
> 	if (!tb[NFTA_VLAN_ACTION] ||
> 	    !tb[NFTA_VLAN_SREG] ||
> 	    !tb[NFTA_VLAN_SREG2])
> 		return -EINVAL;
Will do.
>
> Other than that this looks good to me.
>
