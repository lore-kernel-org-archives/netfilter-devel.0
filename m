Return-Path: <SRS0=4amC=5K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C42C54FCF
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Mar 2020 02:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F366E20658
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Mar 2020 02:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgCYC7W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Mar 2020 22:59:22 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:60260 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727253AbgCYC7W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Mar 2020 22:59:22 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id B79F15C0F49;
        Wed, 25 Mar 2020 10:59:15 +0800 (CST)
Subject: Re: [PATCH nf-next 1/3] netfilter: conntrack: export
 nf_ct_acct_update()
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200324175009.3118-1-pablo@netfilter.org>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <cb62c78f-dd8f-5773-0a3b-7ae11ba8839d@ucloud.cn>
Date:   Wed, 25 Mar 2020 10:59:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200324175009.3118-1-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVTEtKS0tLS0JPT0pITE1ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NFE6SAw5UTg6EhIqUSItGDcJ
        LzhPFClVSlVKTkNOSktOSk5OQktMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBT0lOQzcG
X-HM-Tid: 0a710fa136e42087kuqyb79f15c0f49
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 3/25/2020 1:50 AM, Pablo Neira Ayuso wrote:
> This function allows you to update the conntrack counters.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netfilter/nf_conntrack_acct.h |  2 ++
>  net/netfilter/nf_conntrack_core.c         | 15 +++++++--------
>  2 files changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/include/net/netfilter/nf_conntrack_acct.h b/include/net/netfilter/nf_conntrack_acct.h
> index f7a060c6eb28..df198c51244a 100644
> --- a/include/net/netfilter/nf_conntrack_acct.h
> +++ b/include/net/netfilter/nf_conntrack_acct.h
> @@ -65,6 +65,8 @@ static inline void nf_ct_set_acct(struct net *net, bool enable)
>  #endif
>  }
>  
> +void nf_ct_acct_update(struct nf_conn *ct, u32 dir, unsigned int bytes);
> +
>  void nf_conntrack_acct_pernet_init(struct net *net);
>  
>  int nf_conntrack_acct_init(void);
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index a18f8fe728e3..a55c1d6f8191 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -863,9 +863,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
>  }
>  EXPORT_SYMBOL_GPL(nf_conntrack_hash_check_insert);
>  
> -static inline void nf_ct_acct_update(struct nf_conn *ct,
> -				     enum ip_conntrack_info ctinfo,
> -				     unsigned int len)
> +void nf_ct_acct_update(struct nf_conn *ct, u32 dir, unsigned int bytes)
>  {
>  	struct nf_conn_acct *acct;
>  
> @@ -873,10 +871,11 @@ static inline void nf_ct_acct_update(struct nf_conn *ct,
>  	if (acct) {
>  		struct nf_conn_counter *counter = acct->counter;
>  
> -		atomic64_inc(&counter[CTINFO2DIR(ctinfo)].packets);
> -		atomic64_add(len, &counter[CTINFO2DIR(ctinfo)].bytes);
> +		atomic64_inc(&counter[dir].packets);
> +		atomic64_add(bytes, &counter[dir].bytes);
>  	}
>  }
> +EXPORT_SYMBOL_GPL(nf_ct_acct_update);

This function only add one packet once. Maybe is not so suit for all the scenario

such as the HW flowtable offload get the counter from HW periodicly.

>  
>  static void nf_ct_acct_merge(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
>  			     const struct nf_conn *loser_ct)
> @@ -890,7 +889,7 @@ static void nf_ct_acct_merge(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
>  
>  		/* u32 should be fine since we must have seen one packet. */
>  		bytes = atomic64_read(&counter[CTINFO2DIR(ctinfo)].bytes);
> -		nf_ct_acct_update(ct, ctinfo, bytes);
> +		nf_ct_acct_update(ct, CTINFO2DIR(ctinfo), bytes);
>  	}
>  }
>  
> @@ -1931,7 +1930,7 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
>  		WRITE_ONCE(ct->timeout, extra_jiffies);
>  acct:
>  	if (do_acct)
> -		nf_ct_acct_update(ct, ctinfo, skb->len);
> +		nf_ct_acct_update(ct, CTINFO2DIR(ctinfo), skb->len);
>  }
>  EXPORT_SYMBOL_GPL(__nf_ct_refresh_acct);
>  
> @@ -1939,7 +1938,7 @@ bool nf_ct_kill_acct(struct nf_conn *ct,
>  		     enum ip_conntrack_info ctinfo,
>  		     const struct sk_buff *skb)
>  {
> -	nf_ct_acct_update(ct, ctinfo, skb->len);
> +	nf_ct_acct_update(ct, CTINFO2DIR(ctinfo), skb->len);
>  
>  	return nf_ct_delete(ct, 0, 0);
>  }
