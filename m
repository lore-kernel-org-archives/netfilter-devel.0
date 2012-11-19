From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ipset: Increase the number of maximal sets
 automatically as needed
Date: Mon, 19 Nov 2012 18:32:06 +0100
Message-ID: <20121119173206.GA27443@1984>
References: <alpine.DEB.2.00.1211191742240.22835@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Eric Dumazet <eric.dumazet@gmail.com>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39229 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab2KSRcL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2012 12:32:11 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211191742240.22835@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Mon, Nov 19, 2012 at 05:45:39PM +0100, Jozsef Kadlecsik wrote:
> Hi Pablo,
>
> Please consider applying the next patch for the nf-next tree as it's a new
> feature. You can also pull the patch from here:
>
>         git://blackhole.kfki.hu/nf-next master
>
> The max number of sets was hardcoded at kernel cofiguration time.
> The patch adds the support to increase the max number of sets automatically.
>
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>  net/netfilter/ipset/ip_set_core.c |   59 ++++++++++++++++++++++++++++++++-----
>  1 files changed, 51 insertions(+), 8 deletions(-)
>
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index 778465f..05bc604 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -31,6 +31,7 @@ static DEFINE_RWLOCK(ip_set_ref_lock);		/* protects the set refs */
>  static struct ip_set **ip_set_list;		/* all individual sets */
>  static ip_set_id_t ip_set_max = CONFIG_IP_SET_MAX; /* max number of sets */
>
> +#define IP_SET_INC	64
>  #define STREQ(a, b)	(strncmp(a, b, IPSET_MAXNAMELEN) == 0)
>
>  static unsigned int max_sets;
> @@ -344,12 +345,26 @@ __ip_set_put(ip_set_id_t index)
>   * so it can't be destroyed (or changed) under our foot.
>   */
>
> +static inline struct ip_set *
> +ip_set_rcu_get(ip_set_id_t index)
> +{
> +	struct ip_set *set, **list;
> +
> +	rcu_read_lock();
> +	/* ip_set_list itself needs to be protected */
> +	list = rcu_dereference(ip_set_list);
> +	set = list[index];

You can simplify the two lines above with:
        list = rcu_dereference(ip_set_list[index]);

> +	rcu_read_unlock();

Note that out of the rcu_read_unlock that `set' pointer is not granted
to be valid.

So you have to call rcu_read_unlock once you are sure you don't need
to access your `set' object anymore, eg.

int ip_set_test(...)
{
        struct ip_set *set;
        int ret = 0;

        rcu_read_lock();
        set = rcu_dereference(ip_set_list[index]);

        ...

        rcu_read_unlock();

        /* Convert error codes to nomatch */
        return (ret < 0 ? 0 : ret);
}
EXPORT_SYMBOL_GPL(ip_set_test);

> +
> +	return set;
> +}
> +
>  int
>  ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
>  	    const struct xt_action_param *par,
>  	    const struct ip_set_adt_opt *opt)
>  {
> -	struct ip_set *set = ip_set_list[index];
> +	struct ip_set *set = ip_set_rcu_get(index);
>  	int ret = 0;
>
>  	BUG_ON(set == NULL);
> @@ -388,7 +403,7 @@ ip_set_add(ip_set_id_t index, const struct sk_buff *skb,
>  	   const struct xt_action_param *par,
>  	   const struct ip_set_adt_opt *opt)
>  {
> -	struct ip_set *set = ip_set_list[index];
> +	struct ip_set *set = ip_set_rcu_get(index);
>  	int ret;
>
>  	BUG_ON(set == NULL);
> @@ -411,7 +426,7 @@ ip_set_del(ip_set_id_t index, const struct sk_buff *skb,
>  	   const struct xt_action_param *par,
>  	   const struct ip_set_adt_opt *opt)
>  {
> -	struct ip_set *set = ip_set_list[index];
> +	struct ip_set *set = ip_set_rcu_get(index);
>  	int ret = 0;
>
>  	BUG_ON(set == NULL);
> @@ -440,6 +455,7 @@ ip_set_get_byname(const char *name, struct ip_set **set)
>  	ip_set_id_t i, index = IPSET_INVALID_ID;
>  	struct ip_set *s;
>
> +	rcu_read_lock();
>  	for (i = 0; i < ip_set_max; i++) {
>  		s = ip_set_list[i];
>  		if (s != NULL && STREQ(s->name, name)) {
> @@ -448,6 +464,7 @@ ip_set_get_byname(const char *name, struct ip_set **set)
>  			*set = s;
>  		}
>  	}
> +	rcu_read_unlock();
>
>  	return index;
>  }
> @@ -462,8 +479,10 @@ EXPORT_SYMBOL_GPL(ip_set_get_byname);
>  void
>  ip_set_put_byindex(ip_set_id_t index)
>  {
> +	rcu_read_lock();
>  	if (ip_set_list[index] != NULL)
>  		__ip_set_put(index);
> +	rcu_read_unlock();
>  }
>  EXPORT_SYMBOL_GPL(ip_set_put_byindex);
>
> @@ -477,7 +496,7 @@ EXPORT_SYMBOL_GPL(ip_set_put_byindex);
>  const char *
>  ip_set_name_byindex(ip_set_id_t index)
>  {
> -	const struct ip_set *set = ip_set_list[index];
> +	const struct ip_set *set = ip_set_rcu_get(index);
>
>  	BUG_ON(set == NULL);
>  	BUG_ON(set->ref == 0);
> @@ -525,10 +544,12 @@ ip_set_nfnl_get_byindex(ip_set_id_t index)
>  		return IPSET_INVALID_ID;
>
>  	nfnl_lock();
> +	rcu_read_lock();
>  	if (ip_set_list[index])
>  		__ip_set_get(index);
>  	else
>  		index = IPSET_INVALID_ID;
> +	rcu_read_unlock();
>  	nfnl_unlock();
>
>  	return index;
> @@ -730,10 +751,9 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
>  	 * and check clashing.
>  	 */
>  	ret = find_free_id(set->name, &index, &clash);
> -	if (ret != 0) {
> +	if (ret == -EEXIST) {
>  		/* If this is the same set and requested, ignore error */
> -		if (ret == -EEXIST &&
> -		    (flags & IPSET_FLAG_EXIST) &&
> +		if ((flags & IPSET_FLAG_EXIST) &&
>  		    STREQ(set->type->name, clash->type->name) &&
>  		    set->type->family == clash->type->family &&
>  		    set->type->revision_min == clash->type->revision_min &&
> @@ -741,7 +761,30 @@ ip_set_create(struct sock *ctnl, struct sk_buff *skb,
>  		    set->variant->same_set(set, clash))
>  			ret = 0;
>  		goto cleanup;
> -	}
> +	} else if (ret == -IPSET_ERR_MAX_SETS) {
> +		struct ip_set **list, **tmp;
> +		ip_set_id_t i = ip_set_max + IP_SET_INC;
> +
> +		if (i < ip_set_max)
> +			/* Wraparound */
> +			goto cleanup;
> +
> +		list = kzalloc(sizeof(struct ip_set *) * i, GFP_KERNEL);
> +		if (!list)
> +			goto cleanup;
> +		memcpy(list, ip_set_list, sizeof(struct ip_set *) * ip_set_max);
> +		/* Both lists are valid */
> +		tmp = rcu_dereference(ip_set_list);
> +		rcu_assign_pointer(ip_set_list, list);
> +		/* Make sure all current packets have passed through */
> +		synchronize_net();
> +		/* Use new list */
> +		index = ip_set_max;
> +		ip_set_max = i;
> +		kfree(tmp);
> +		ret = 0;
> +	} else if (ret)
> +		goto cleanup;
>
>  	/*
>  	 * Finally! Add our shiny new set to the list, and be done.
> --
> 1.7.0.4
>
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
>           H-1525 Budapest 114, POB. 49, Hungary
