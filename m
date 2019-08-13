Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F9EC32750
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 10:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B53722067D
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 10:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbfHMK4L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 06:56:11 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:32833 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728292AbfHMK4L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 06:56:11 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id A21AB417DB;
        Tue, 13 Aug 2019 18:56:06 +0800 (CST)
Subject: Re: [PATCH nf-next v6 8/8] netfilter: Support the bridge family in
 flow table
From:   wenxu <wenxu@ucloud.cn>
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
References: <1564053176-28605-1-git-send-email-wenxu@ucloud.cn>
 <1564053176-28605-9-git-send-email-wenxu@ucloud.cn>
Message-ID: <39536e32-4a6c-a0df-d909-a58a595e13cc@ucloud.cn>
Date:   Tue, 13 Aug 2019 18:56:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1564053176-28605-9-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVT0pIS0tLSUlNS0lLQ0pZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Kww6TDo6Gjg5Ezo5SBA5SSs3
        KU8wCwtVSlVKTk1OTUJITE1NQkhOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBT0xMQzcG
X-HM-Tid: 0a6c8a9eec752086kuqya21ab417db
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi pablo,


How about this patch? There are any question about this series?


BR

wenxu

On 7/25/2019 7:12 PM, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> This patch add the bridge flow table type. Implement the datapath
> flow table to forward both IPV4 and IPV6 traffic through bridge.
>
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
> v6: rebase Kconfig file to master
>
>  net/bridge/netfilter/Kconfig                |  8 +++++
>  net/bridge/netfilter/Makefile               |  1 +
>  net/bridge/netfilter/nf_flow_table_bridge.c | 48 +++++++++++++++++++++++++++++
>  3 files changed, 57 insertions(+)
>  create mode 100644 net/bridge/netfilter/nf_flow_table_bridge.c
>
> diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
> index 5040fe4..ad100cb 100644
> --- a/net/bridge/netfilter/Kconfig
> +++ b/net/bridge/netfilter/Kconfig
> @@ -41,6 +41,14 @@ config NF_CONNTRACK_BRIDGE
>  
>  	  To compile it as a module, choose M here.  If unsure, say N.
>  
> +config NF_FLOW_TABLE_BRIDGE
> +	tristate "Netfilter flow table bridge module"
> +	depends on NF_FLOW_TABLE && NF_CONNTRACK_BRIDGE
> +	help
> +          This option adds the flow table bridge support.
> +
> +	  To compile it as a module, choose M here.
> +
>  menuconfig BRIDGE_NF_EBTABLES
>  	tristate "Ethernet Bridge tables (ebtables) support"
>  	depends on BRIDGE && NETFILTER && NETFILTER_XTABLES
> diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
> index 8e2c575..627b269 100644
> --- a/net/bridge/netfilter/Makefile
> +++ b/net/bridge/netfilter/Makefile
> @@ -8,6 +8,7 @@ obj-$(CONFIG_NFT_BRIDGE_REJECT)  += nft_reject_bridge.o
>  
>  # connection tracking
>  obj-$(CONFIG_NF_CONNTRACK_BRIDGE) += nf_conntrack_bridge.o
> +obj-$(CONFIG_NF_FLOW_TABLE_BRIDGE) += nf_flow_table_bridge.o
>  
>  # packet logging
>  obj-$(CONFIG_NF_LOG_BRIDGE) += nf_log_bridge.o
> diff --git a/net/bridge/netfilter/nf_flow_table_bridge.c b/net/bridge/netfilter/nf_flow_table_bridge.c
> new file mode 100644
> index 0000000..c4fdd4a
> --- /dev/null
> +++ b/net/bridge/netfilter/nf_flow_table_bridge.c
> @@ -0,0 +1,48 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/netfilter.h>
> +#include <net/netfilter/nf_flow_table.h>
> +#include <net/netfilter/nf_tables.h>
> +
> +static unsigned int
> +nf_flow_offload_bridge_hook(void *priv, struct sk_buff *skb,
> +			    const struct nf_hook_state *state)
> +{
> +	switch (skb->protocol) {
> +	case htons(ETH_P_IP):
> +		return nf_flow_offload_ip_hook(priv, skb, state);
> +	case htons(ETH_P_IPV6):
> +		return nf_flow_offload_ipv6_hook(priv, skb, state);
> +	}
> +
> +	return NF_ACCEPT;
> +}
> +
> +static struct nf_flowtable_type flowtable_bridge = {
> +	.family		= NFPROTO_BRIDGE,
> +	.init		= nf_flow_table_init,
> +	.free		= nf_flow_table_free,
> +	.hook		= nf_flow_offload_bridge_hook,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static int __init nf_flow_bridge_module_init(void)
> +{
> +	nft_register_flowtable_type(&flowtable_bridge);
> +
> +	return 0;
> +}
> +
> +static void __exit nf_flow_bridge_module_exit(void)
> +{
> +	nft_unregister_flowtable_type(&flowtable_bridge);
> +}
> +
> +module_init(nf_flow_bridge_module_init);
> +module_exit(nf_flow_bridge_module_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("wenxu <wenxu@ucloud.cn>");
> +MODULE_ALIAS_NF_FLOWTABLE(7); /* NFPROTO_BRIDGE */
