Return-Path: <SRS0=SAea=2Z=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 410F5C32767
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Jan 2020 09:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 171AA2464E
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Jan 2020 09:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgADJDR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 4 Jan 2020 04:03:17 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:17231 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgADJDR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Jan 2020 04:03:17 -0500
Received: from [192.168.1.6] (unknown [116.237.151.217])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 69EBA416D1;
        Sat,  4 Jan 2020 17:03:13 +0800 (CST)
Subject: Re: [PATCH nf] netfilter: nf_tables: unbind callbacks from flowtable
 destroy path
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200103170402.31306-1-pablo@netfilter.org>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <26948085-16a2-fd87-e0ad-60de30a755a9@ucloud.cn>
Date:   Sat, 4 Jan 2020 17:02:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200103170402.31306-1-pablo@netfilter.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVS0tMS0tLSUtMQktKWVdZKFlBSU
        I3V1ktWUFJV1kJDhceCFlBWTU0KTY6NyQpLjc#WQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PS46KBw*Tjg4PD9IOSooPjgp
        N0saFCFVSlVKTkxDSklDTkJPT0hJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SExVSk5KVUlKTFlXWQgBWUFIQklLNwY+
X-HM-Tid: 0a6f6fcb53192086kuqy69eba416d1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Acked-by: wenxu <wenxu@ucloud.cn>

ÔÚ 2020/1/4 1:04, Pablo Neira Ayuso Ð´µÀ:
> Callback unbinding needs to be done after nf_flow_table_free(),
> otherwise entries are not removed from the hardware.
>
> Update nft_unregister_flowtable_net_hooks() to call
> nf_unregister_net_hook() instead since the commit/abort paths do not
> deal with the callback unbinding anymore.
>
> Add a comment to nft_flowtable_event() to clarify that
> flow_offload_netdev_event() already removes the entries before the
> callback unbinding.
>
> Fixes: 8bb69f3b2918 ("netfilter: nf_tables: add flowtable offload control plane")
> Fixes ff4bf2f42a40 ("netfilter: nf_tables: add nft_unregister_flowtable_hook()")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Follows up after:
> https://patchwork.ozlabs.org/patch/1213936/
> https://patchwork.ozlabs.org/patch/1213406/
>
>   net/netfilter/nf_tables_api.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 273f3838318b..43f05b3acd60 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -5984,6 +5984,7 @@ nft_flowtable_type_get(struct net *net, u8 family)
>   	return ERR_PTR(-ENOENT);
>   }
>   
> +/* Only called from error and netdev event paths. */
>   static void nft_unregister_flowtable_hook(struct net *net,
>   					  struct nft_flowtable *flowtable,
>   					  struct nft_hook *hook)
> @@ -5999,7 +6000,7 @@ static void nft_unregister_flowtable_net_hooks(struct net *net,
>   	struct nft_hook *hook;
>   
>   	list_for_each_entry(hook, &flowtable->hook_list, list)
> -		nft_unregister_flowtable_hook(net, flowtable, hook);
> +		nf_unregister_net_hook(net, &hook->ops);
>   }
>   
>   static int nft_register_flowtable_net_hooks(struct net *net,
> @@ -6448,12 +6449,14 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
>   {
>   	struct nft_hook *hook, *next;
>   
> +	flowtable->data.type->free(&flowtable->data);
>   	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
> +		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
> +					    FLOW_BLOCK_UNBIND);
>   		list_del_rcu(&hook->list);
>   		kfree(hook);
>   	}
>   	kfree(flowtable->name);
> -	flowtable->data.type->free(&flowtable->data);
>   	module_put(flowtable->data.type->owner);
>   	kfree(flowtable);
>   }
> @@ -6497,6 +6500,7 @@ static void nft_flowtable_event(unsigned long event, struct net_device *dev,
>   		if (hook->ops.dev != dev)
>   			continue;
>   
> +		/* flow_offload_netdev_event() cleans up entries for us. */
>   		nft_unregister_flowtable_hook(dev_net(dev), flowtable, hook);
>   		list_del_rcu(&hook->list);
>   		kfree_rcu(hook, rcu);
