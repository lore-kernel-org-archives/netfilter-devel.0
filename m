Return-Path: <SRS0=+PqO=WE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8196EC433FF
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Aug 2019 06:07:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E3B1214C6
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Aug 2019 06:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbfHHGHX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Aug 2019 02:07:23 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:13312 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfHHGHX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Aug 2019 02:07:23 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id D44DA416A7;
        Thu,  8 Aug 2019 14:07:17 +0800 (CST)
Subject: Re: [PATCH nf-next v3 4/9] netfilter: nft_payload: add
 nft_set_payload offload support
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@01.org, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org
References: <1564668086-16260-5-git-send-email-wenxu@ucloud.cn>
 <201908072022.CVdglwtY%lkp@intel.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <22d05030-0791-5daa-78d3-9590e9e391dc@ucloud.cn>
Date:   Thu, 8 Aug 2019 14:07:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <201908072022.CVdglwtY%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVQ0xMS0tLSEhKQ0xDTU1ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PAw6Mjo4KDg9HEwOPQ4*TTxD
        NT0aCj1VSlVKTk1OSU9PT0hDSExJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBT0lLQzcG
X-HM-Tid: 0a6c6fd6b6ff2086kuqyd44da416a7
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch is also no this problem.  Because it is based on http://patchwork.ozlabs.org/patch/1140431/

On 8/7/2019 8:18 PM, kbuild test robot wrote:
> Hi,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on nf-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/wenxu-ucloud-cn/netfilter-nf_tables_offload-support-more-expr-and-obj-offload/20190804-144846
> base:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/pablo/nf-next.git master
> config: x86_64-rhel (attached as .config)
> compiler: gcc-7 (Debian 7.4.0-10) 7.4.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    net//netfilter/nft_payload.c: In function 'nft_payload_set_offload':
>>> net//netfilter/nft_payload.c:571:36: error: 'struct nft_offload_reg' has no member named 'data'
>      const struct nft_data *data = &reg->data;
>                                        ^~
>
> vim +571 net//netfilter/nft_payload.c
>
>    564	
>    565	static int nft_payload_set_offload(struct nft_offload_ctx *ctx,
>    566					   struct nft_flow_rule *flow,
>    567					   const struct nft_expr *expr)
>    568	{
>    569		const struct nft_payload_set *priv = nft_expr_priv(expr);
>    570		struct nft_offload_reg *reg = &ctx->regs[priv->sreg];
>  > 571		const struct nft_data *data = &reg->data;
>    572		struct flow_action_entry *entry;
>    573		u32 len = priv->len;
>    574		u32 offset, last;
>    575		int n_actions, i;
>    576	
>    577		if (priv->base != NFT_PAYLOAD_LL_HEADER || len > 16)
>    578			return -EOPNOTSUPP;
>    579	
>    580		offset = priv->offset;
>    581		n_actions = len >> 2;
>    582		last = len & 0x3;
>    583	
>    584		for (i = 0; i < n_actions; i++) {
>    585			entry = &flow->rule->action.entries[ctx->num_actions++];
>    586	
>    587			entry->id = FLOW_ACTION_MANGLE;
>    588			entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_ETH;
>    589			entry->mangle.mask = 0;
>    590			entry->mangle.val = data->data[i];
>    591			entry->mangle.offset = offset;
>    592			offset = offset + 4;
>    593		}
>    594	
>    595		if (last) {
>    596			entry = &flow->rule->action.entries[ctx->num_actions++];
>    597	
>    598			entry->id = FLOW_ACTION_MANGLE;
>    599			entry->mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_ETH;
>    600			entry->mangle.mask = ~((1 << (last * 8)) - 1);
>    601			entry->mangle.val = data->data[i];
>    602			entry->mangle.offset = offset;
>    603		}
>    604	
>    605		return 0;
>    606	}
>    607	
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
