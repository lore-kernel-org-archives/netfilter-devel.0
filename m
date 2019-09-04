Return-Path: <SRS0=dC0K=W7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB604C3A5A9
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 19:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8C42208E4
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 19:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbfIDTk3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Sep 2019 15:40:29 -0400
Received: from correo.us.es ([193.147.175.20]:38478 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728152AbfIDTk3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 15:40:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6EDCD303D00
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Sep 2019 21:40:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 61C60DA8E8
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Sep 2019 21:40:25 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 56D56DA72F; Wed,  4 Sep 2019 21:40:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 10129DA72F;
        Wed,  4 Sep 2019 21:40:23 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Sep 2019 21:40:23 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DEC2E4265A5A;
        Wed,  4 Sep 2019 21:40:22 +0200 (CEST)
Date:   Wed, 4 Sep 2019 21:40:24 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2 3/3] netfilter: nf_tables_offload: clean
 offload things when the device unregister
Message-ID: <20190904194024.q2rxmdpnthgkono4@salvia>
References: <1567580851-15042-1-git-send-email-wenxu@ucloud.cn>
 <1567580851-15042-4-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567580851-15042-4-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thanks for working on this.

On Wed, Sep 04, 2019 at 03:07:31PM +0800, wenxu@ucloud.cn wrote:
> diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
> index 9657001..9fa3bdb 100644
> --- a/net/netfilter/nf_tables_offload.c
> +++ b/net/netfilter/nf_tables_offload.c
> @@ -396,17 +396,78 @@ static void nft_indr_block_cb(struct net_device *dev,
>  	mutex_unlock(&net->nft.commit_mutex);
>  }
>  
> +static void nft_offload_chain_clean(struct nft_chain *chain)
> +{
> +	struct nft_rule *rule;
> +
> +	list_for_each_entry(rule, &chain->rules, list) {
> +		nft_flow_offload_rule(chain, rule,
> +				      NULL, FLOW_CLS_DESTROY);
> +	}
> +
> +	nft_flow_offload_chain(chain, FLOW_BLOCK_UNBIND);
> +}
> +
> +static int nft_offload_netdev_event(struct notifier_block *this,
> +				    unsigned long event, void *ptr)
> +{
> +	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
> +	struct nft_base_chain *basechain;
> +	struct net *net = dev_net(dev);
> +	struct nft_table *table;
> +	struct nft_chain *chain;
> +
> +	if (event != NETDEV_UNREGISTER)
> +		return NOTIFY_DONE;
> +
> +	mutex_lock(&net->nft.commit_mutex);
> +	list_for_each_entry(table, &net->nft.tables, list) {
> +		if (table->family != NFPROTO_NETDEV)
> +			continue;
> +
> +		list_for_each_entry(chain, &table->chains, list) {
> +			if (!nft_is_base_chain(chain) ||
> +			    !(chain->flags & NFT_CHAIN_HW_OFFLOAD))
> +				continue;
> +
> +			basechain = nft_base_chain(chain);
> +			if (strncmp(basechain->dev_name, dev->name, IFNAMSIZ))
> +				continue;
> +
> +			nft_offload_chain_clean(chain);
> +			mutex_unlock(&net->nft.commit_mutex);
> +			return NOTIFY_DONE;
> +		}
> +	}
> +	mutex_unlock(&net->nft.commit_mutex);

This code around the mutex look very similar to nft_block_indr_cb(),
could you consolidate this? Probably something like
nft_offload_netdev_iterate() and add a callback.

> +	return NOTIFY_DONE;
> +}
> +
>  static struct flow_indr_block_ing_entry block_ing_entry = {
>  	.cb	= nft_indr_block_cb,
>  	.list	= LIST_HEAD_INIT(block_ing_entry.list),
>  };
>  
> -void nft_offload_init(void)
> +static struct notifier_block nft_offload_netdev_notifier = {
> +	.notifier_call	= nft_offload_netdev_event,

No need for priority because of registration order, right?
