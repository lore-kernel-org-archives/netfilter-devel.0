Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71EB5C43334
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Jul 2022 21:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiGLVG0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Jul 2022 17:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiGLVGZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Jul 2022 17:06:25 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9155BD039E
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Jul 2022 14:06:22 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 81ECACC00F4;
        Tue, 12 Jul 2022 23:06:17 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 12 Jul 2022 23:06:15 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 0611FCC00F3;
        Tue, 12 Jul 2022 23:06:14 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id D9D103431DE; Tue, 12 Jul 2022 23:06:14 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id D863D343155;
        Tue, 12 Jul 2022 23:06:14 +0200 (CEST)
Date:   Tue, 12 Jul 2022 23:06:14 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Vishwanath Pai <vpai@akamai.com>
cc:     pablo@netfilter.org, fw@strlen.de, johunt@akamai.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ipset: ipset list may return wrong member
 count on bitmap types
In-Reply-To: <20220629212109.3045794-1-vpai@akamai.com>
Message-ID: <73de8f7a-365-ef8c-77fa-52c6ad94cde@netfilter.org>
References: <20220629212109.3045794-1-vpai@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Vishwanath,

On Wed, 29 Jun 2022, Vishwanath Pai wrote:

> We fixed a similar problem before in commit 7f4f7dd4417d ("netfilter:
> ipset: ipset list may return wrong member count for set with timeout").
> The same issue exists in ip_set_bitmap_gen.h as well.

Could you rework the patch to solve the issue the same way as for the hash 
types (i.e. scanning the set without locking) like in the commit 
33f08da28324 (netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" 
reports)? I know the bitmap types have got a limited size but it'd be 
great if the general method would be the same across the different types.

Best regards,
Jozsef
 
> Test case:
> 
> $ ipset create test bitmap:ip range 10.0.0.0/8 netmask 24 timeout 5
> $ ipset add test 10.0.0.0
> $ ipset add test 10.255.255.255
> $ sleep 5s
> 
> $ ipset list test
> Name: test
> Type: bitmap:ip
> Revision: 3
> Header: range 10.0.0.0-10.255.255.255 netmask 24 timeout 5
> Size in memory: 532568
> References: 0
> Number of entries: 2
> Members:
> 
> We return "Number of entries: 2" but no members are listed. That is
> because when we run mtype_head the garbage collector hasn't run yet, but
> mtype_list checks and cleans up members with expired timeout. To avoid
> this we can run mtype_expire before printing the number of elements in
> mytype_head().
> 
> Reviewed-by: Joshua Hunt <johunt@akamai.com>
> Signed-off-by: Vishwanath Pai <vpai@akamai.com>
> ---
>  net/netfilter/ipset/ip_set_bitmap_gen.h | 46 ++++++++++++++++++-------
>  1 file changed, 34 insertions(+), 12 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
> index 26ab0e9612d8..dd871305bd6e 100644
> --- a/net/netfilter/ipset/ip_set_bitmap_gen.h
> +++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
> @@ -28,6 +28,7 @@
>  #define mtype_del		IPSET_TOKEN(MTYPE, _del)
>  #define mtype_list		IPSET_TOKEN(MTYPE, _list)
>  #define mtype_gc		IPSET_TOKEN(MTYPE, _gc)
> +#define mtype_expire		IPSET_TOKEN(MTYPE, _expire)
>  #define mtype			MTYPE
>  
>  #define get_ext(set, map, id)	((map)->extensions + ((set)->dsize * (id)))
> @@ -88,13 +89,44 @@ mtype_memsize(const struct mtype *map, size_t dsize)
>  	       map->elements * dsize;
>  }
>  
> +/* We should grab set->lock before calling this function */
> +static void
> +mtype_expire(struct ip_set *set)
> +{
> +	struct mtype *map = set->data;
> +	void *x;
> +	u32 id;
> +
> +	for (id = 0; id < map->elements; id++)
> +		if (mtype_gc_test(id, map, set->dsize)) {
> +			x = get_ext(set, map, id);
> +			if (ip_set_timeout_expired(ext_timeout(x, set))) {
> +				clear_bit(id, map->members);
> +				ip_set_ext_destroy(set, x);
> +				set->elements--;
> +			}
> +		}
> +}
> +
>  static int
>  mtype_head(struct ip_set *set, struct sk_buff *skb)
>  {
>  	const struct mtype *map = set->data;
>  	struct nlattr *nested;
> -	size_t memsize = mtype_memsize(map, set->dsize) + set->ext_size;
> +	size_t memsize;
> +
> +	/* If any members have expired, set->elements will be wrong,
> +	 * mytype_expire function will update it with the right count.
> +	 * set->elements can still be incorrect in the case of a huge set
> +	 * because elements can timeout during set->list().
> +	 */
> +	if (SET_WITH_TIMEOUT(set)) {
> +		spin_lock_bh(&set->lock);
> +		mtype_expire(set);
> +		spin_unlock_bh(&set->lock);
> +	}
>  
> +	memsize = mtype_memsize(map, set->dsize) + set->ext_size;
>  	nested = nla_nest_start(skb, IPSET_ATTR_DATA);
>  	if (!nested)
>  		goto nla_put_failure;
> @@ -266,22 +298,12 @@ mtype_gc(struct timer_list *t)
>  {
>  	struct mtype *map = from_timer(map, t, gc);
>  	struct ip_set *set = map->set;
> -	void *x;
> -	u32 id;
>  
>  	/* We run parallel with other readers (test element)
>  	 * but adding/deleting new entries is locked out
>  	 */
>  	spin_lock_bh(&set->lock);
> -	for (id = 0; id < map->elements; id++)
> -		if (mtype_gc_test(id, map, set->dsize)) {
> -			x = get_ext(set, map, id);
> -			if (ip_set_timeout_expired(ext_timeout(x, set))) {
> -				clear_bit(id, map->members);
> -				ip_set_ext_destroy(set, x);
> -				set->elements--;
> -			}
> -		}
> +	mtype_expire(set);
>  	spin_unlock_bh(&set->lock);
>  
>  	map->gc.expires = jiffies + IPSET_GC_PERIOD(set->timeout) * HZ;
> -- 
> 2.25.1
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
