Return-Path: <SRS0=+PqO=WE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF3E7C0650F
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Aug 2019 06:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84A9C20880
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Aug 2019 06:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfHHGG7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Aug 2019 02:06:59 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:12306 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730149AbfHHGG7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Aug 2019 02:06:59 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id B7CE4418B0;
        Thu,  8 Aug 2019 14:06:51 +0800 (CST)
Subject: Re: [PATCH nf-next v3 3/9] netfilter: nft_fwd_netdev: add fw_netdev
 action support
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@01.org, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org
References: <1564668086-16260-4-git-send-email-wenxu@ucloud.cn>
 <201908072042.KC67W3dl%lkp@intel.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <7557d542-c47b-3c1c-e428-28a03e1162be@ucloud.cn>
Date:   Thu, 8 Aug 2019 14:06:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <201908072042.KC67W3dl%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUhIS0tLSk5CSU1ITUpZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PCI6Aww4Azg1OkwtVg4eTktC
        EwoaCQxVSlVKTk1OSU9PT0pPT0JMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSE9CSTcG
X-HM-Tid: 0a6c6fd650512086kuqyb7ce4418b0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch is no this problem.  Because it is based on http://patchwork.ozlabs.org/patch/1140431/

On 8/7/2019 8:15 PM, kbuild test robot wrote:
> Hi,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on nf-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/wenxu-ucloud-cn/netfilter-nf_tables_offload-support-more-expr-and-obj-offload/20190804-144846
> base:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/pablo/nf-next.git master
> config: x86_64-allyesconfig (attached as .config)
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
>    net/netfilter/nft_fwd_netdev.c: In function 'nft_fwd_netdev_offload':
>>> net/netfilter/nft_fwd_netdev.c:73:36: error: 'struct nft_offload_reg' has no member named 'data'
>      const struct nft_data *data = &reg->data;
>                                        ^~
>
> vim +73 net/netfilter/nft_fwd_netdev.c
>
>     66	
>     67	static int nft_fwd_netdev_offload(struct nft_offload_ctx *ctx,
>     68					  struct nft_flow_rule *flow,
>     69					  const struct nft_expr *expr)
>     70	{
>     71		const struct nft_fwd_netdev *priv = nft_expr_priv(expr);
>     72		struct nft_offload_reg *reg = &ctx->regs[priv->sreg_dev];
>   > 73		const struct nft_data *data = &reg->data;
>     74		struct flow_action_entry *entry;
>     75		struct net_device *dev;
>     76		int oif = -1;
>     77	
>     78		entry = &flow->rule->action.entries[ctx->num_actions++];
>     79	
>     80		memcpy(&oif, data->data, sizeof(oif));
>     81		dev = __dev_get_by_index(ctx->net, oif);
>     82		if (!dev)
>     83			return -EOPNOTSUPP;
>     84	
>     85		entry->id = FLOW_ACTION_REDIRECT;
>     86		entry->dev = dev;
>     87	
>     88		return 0;
>     89	}
>     90	
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
