Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA6BCDB47E
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Oct 2023 08:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376528AbjJTIwv convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Oct 2023 04:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376487AbjJTIwu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2023 04:52:50 -0400
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9E191
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2023 01:52:46 -0700 (PDT)
X-UUID: 3af636141d3a40d582ae32fbf154629b-20231020
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.32,REQID:272499b5-07d1-4e35-bebc-ee6f1b76d0e3,IP:15,
        URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-9,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:6
X-CID-INFO: VERSION:1.1.32,REQID:272499b5-07d1-4e35-bebc-ee6f1b76d0e3,IP:15,UR
        L:0,TC:0,Content:0,EDM:0,RT:0,SF:-9,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:6
X-CID-META: VersionHash:5f78ec9,CLOUDID:5c392ac0-14cc-44ca-b657-2d2783296e72,B
        ulkID:231020165232WM5C82SF,BulkQuantity:0,Recheck:0,SF:19|44|64|66|38|24|1
        7|102,TC:nil,Content:0,EDM:-3,IP:-2,URL:1,File:nil,Bulk:nil,QS:nil,BEC:nil
        ,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI,
        TF_CID_SPAM_ULS
X-UUID: 3af636141d3a40d582ae32fbf154629b-20231020
Received: from node4.com.cn [(39.156.73.12)] by mailgw
        (envelope-from <xiaolinkui@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 318984719; Fri, 20 Oct 2023 16:52:30 +0800
Received: from node4.com.cn (localhost [127.0.0.1])
        by node4.com.cn (NSMail) with SMTP id 3808A16001CC8;
        Fri, 20 Oct 2023 16:52:30 +0800 (CST)
X-ns-mid: postfix-65323FCE-988482754
Received: from [172.20.125.11] (unknown [172.20.125.11])
        by node4.com.cn (NSMail) with ESMTPA id A46F816001CC8;
        Fri, 20 Oct 2023 08:52:28 +0000 (UTC)
Message-ID: <0fb13f84-821f-7131-e67e-d51e15153692@kylinos.cn>
Date:   Fri, 20 Oct 2023 16:52:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 1/1] netfilter: ipset: fix race condition between
 swap/destroy and kernel side add/del/test
Content-Language: en-US
To:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
References: <20231019191937.3931271-1-kadlec@netfilter.org>
 <20231019191937.3931271-2-kadlec@netfilter.org>
From:   Linkui Xiao <xiaolinkui@kylinos.cn>
In-Reply-To: <20231019191937.3931271-2-kadlec@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On 10/20/23 03:19, Jozsef Kadlecsik wrote:
> Linkui Xiao reported that there's a race condition when ipset swap and destroy is
> called, which can lead to crash in add/del/test element operations. Swap then
> destroy are usual operations to replace a set with another one in a production
> system. The issue can in some cases be reproduced with the script:
>
> ipset create hash_ip1 hash:net family inet hashsize 1024 maxelem 1048576
> ipset add hash_ip1 172.20.0.0/16
> ipset add hash_ip1 192.168.0.0/16
> iptables -A INPUT -m set --match-set hash_ip1 src -j ACCEPT
> while [ 1 ]
> do
> 	# ... Ongoing traffic...
>          ipset create hash_ip2 hash:net family inet hashsize 1024 maxelem 1048576
>          ipset add hash_ip2 172.20.0.0/16
>          ipset swap hash_ip1 hash_ip2
>          ipset destroy hash_ip2
>          sleep 0.05
> done
>
> In the race case the possible order of the operations are
>
> 	CPU0			CPU1
> 	ip_set_test
> 				ipset swap hash_ip1 hash_ip2
> 				ipset destroy hash_ip2
> 	hash_net_kadt
>
> Swap replaces hash_ip1 with hash_ip2 and then destroy removes hash_ip2 which
> is the original hash_ip1. ip_set_test was called on hash_ip1 and because destroy
> removed it, hash_net_kadt crashes.
>
> The fix is to protect both the list of the sets and the set pointers in an extended RCU
> region and before calling destroy, wait to finish all started rcu_read_lock().
>
> The first version of the patch was written by Linkui Xiao <xiaolinkui@kylinos.cn>.
>
> Closes: https://lore.kernel.org/all/69e7963b-e7f8-3ad0-210-7b86eebf7f78@netfilter.org/
> Reported by: Linkui Xiao <xiaolinkui@kylinos.cn>
> Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
> ---
>   net/netfilter/ipset/ip_set_core.c | 28 +++++++++++++++++++++++-----
>   1 file changed, 23 insertions(+), 5 deletions(-)
>
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index e564b5174261..7eedd2825e0c 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -704,13 +704,18 @@ ip_set_rcu_get(struct net *net, ip_set_id_t index)
>   	struct ip_set_net *inst = ip_set_pernet(net);
>   
>   	rcu_read_lock();
> -	/* ip_set_list itself needs to be protected */
> +	/* ip_set_list and the set pointer need to be protected */
>   	set = rcu_dereference(inst->ip_set_list)[index];
> -	rcu_read_unlock();
>   
>   	return set;
>   }
>   
> +static inline void
> +ip_set_rcu_put(struct ip_set *set __always_unused)
> +{
> +	rcu_read_unlock();
> +}
> +
>   static inline void
>   ip_set_lock(struct ip_set *set)
>   {
> @@ -736,8 +741,10 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
>   	pr_debug("set %s, index %u\n", set->name, index);
>   
>   	if (opt->dim < set->type->dimension ||
> -	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
> +	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC)) {
> +		ip_set_rcu_put(set);
>   		return 0;
> +	}
>   
>   	ret = set->variant->kadt(set, skb, par, IPSET_TEST, opt);
>   
> @@ -756,6 +763,7 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
>   			ret = -ret;
>   	}
>   
> +	ip_set_rcu_put(set);
>   	/* Convert error codes to nomatch */
>   	return (ret < 0 ? 0 : ret);
>   }
> @@ -772,12 +780,15 @@ ip_set_add(ip_set_id_t index, const struct sk_buff *skb,
>   	pr_debug("set %s, index %u\n", set->name, index);
>   
>   	if (opt->dim < set->type->dimension ||
> -	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
> +	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC)) {
> +		ip_set_rcu_put(set);
>   		return -IPSET_ERR_TYPE_MISMATCH;
> +	}
>   
>   	ip_set_lock(set);
>   	ret = set->variant->kadt(set, skb, par, IPSET_ADD, opt);
>   	ip_set_unlock(set);
> +	ip_set_rcu_put(set);
>   
>   	return ret;
>   }
> @@ -794,12 +805,15 @@ ip_set_del(ip_set_id_t index, const struct sk_buff *skb,
>   	pr_debug("set %s, index %u\n", set->name, index);
>   
>   	if (opt->dim < set->type->dimension ||
> -	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
> +	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC)) {
> +		ip_set_rcu_put(set);
>   		return -IPSET_ERR_TYPE_MISMATCH;
> +	}
>   
>   	ip_set_lock(set);
>   	ret = set->variant->kadt(set, skb, par, IPSET_DEL, opt);
>   	ip_set_unlock(set);
> +	ip_set_rcu_put(set);
>   
>   	return ret;
>   }
> @@ -874,6 +888,7 @@ ip_set_name_byindex(struct net *net, ip_set_id_t index, char *name)
>   	read_lock_bh(&ip_set_ref_lock);
>   	strscpy_pad(name, set->name, IPSET_MAXNAMELEN);
>   	read_unlock_bh(&ip_set_ref_lock);
> +	ip_set_rcu_put(set);
>   }
>   EXPORT_SYMBOL_GPL(ip_set_name_byindex);
>   
> @@ -1188,6 +1203,9 @@ static int ip_set_destroy(struct sk_buff *skb, const struct nfnl_info *info,
>   	if (unlikely(protocol_min_failed(attr)))
>   		return -IPSET_ERR_PROTOCOL;
>   
> +	/* Make sure all readers of the old set pointers are completed. */
> +	synchronize_rcu();
> +
>   	/* Must wait for flush to be really finished in list:set */
>   	rcu_barrier();
>   
This patch is valid in my case.But I have a question, if there are many 
concurrent ipsets.
One ip_set_test was not completed, and another ip_set_test also came in, 
there are always
some rcu_read_lock() without unlock. The ip_set_destroy will always wait 
to finish all started
rcu_read_lock().  Is there a problem?
Actually, ip_set_destroy should only need to wait for the ipset (the one 
that was swapped) to
finish ip_set_test. It is unnecessary to wait for other ipsets ongoing 
traffic.

Best regards,
Linkui Xiao


