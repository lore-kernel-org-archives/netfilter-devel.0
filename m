From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2][priv_data-condition][part 1/2][core]
Date: Sat, 30 Sep 2006 18:54:19 +0200
Message-ID: <451EA13B.5050700@trash.net>
References: <200609250040.49298.max@nucleus.it>
	<200609251016.33590.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200609251016.33590.max@nucleus.it>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Massimiliano Hofer wrote:
> From 8fc22c9b95e4bfa7f56a303587bdcd6f01a6ce52 Mon Sep 17 00:00:00 2001
> From: Massimiliano Hofer <max@nucleus.it>
> Date: Mon, 25 Sep 2006 10:06:12 +0200
> Subject: [PATCH] priv_data
> 
> This patch adds support for instance specific data in matches and
> targets.
> I seize the opportunity of this massive function parameter change
> to rename checkentry as init.
> This is the core implementation. It won't compile without the
> corresponding updates in matches and targets (in the following
> patch).

I wish you would have updated my patch instead. It had more logical
argument ordering and a few other cleanups. It was also structured
in a way that left the tree compiling at each step, so we don't
make peoples life performing bisections unnecessarily hard.

> @@ -290,12 +300,16 @@ extern void xt_unregister_match(struct x
> @@ -390,13 +404,13 @@ extern int xt_compat_match_offset(struct
>  extern void xt_compat_match_from_user(struct xt_entry_match *m,
>  				      void **dstptr, int *size);
>  extern int xt_compat_match_to_user(struct xt_entry_match *m,
> -				   void __user **dstptr, int *size);
> +				   void * __user *dstptr, int *size);
>  
>  extern int xt_compat_target_offset(struct xt_target *target);
>  extern void xt_compat_target_from_user(struct xt_entry_target *t,
>  				       void **dstptr, int *size);
>  extern int xt_compat_target_to_user(struct xt_entry_target *t,
> -				    void __user **dstptr, int *size);
> +				    void * __user *dstptr, int *size);

This reintroduces a bug that was fixed a few days ago.

> diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
> index 78a44b0..d96f322 100644
> --- a/net/ipv4/netfilter/ip_tables.c
> +++ b/net/ipv4/netfilter/ip_tables.c
> @@ -548,25 +542,14 @@ check_entry(struct ipt_entry *e, const c
>  	}
>  
>  	j = 0;
> -	ret = IPT_MATCH_ITERATE(e, check_match, name, &e->ip, e->comefrom, &j);
> +	ret = IPT_MATCH_ITERATE(e, init_match, name, &e->ip, e->comefrom, &j);
>  	if (ret != 0)
>  		goto cleanup_matches;
>  
>  	t = ipt_get_target(e);
> -	target = try_then_request_module(xt_find_target(AF_INET,
> -						     t->u.user.name,
> -						     t->u.user.revision),
> -					 "ipt_%s", t->u.user.name);
> -	if (IS_ERR(target) || !target) {
> -		duprintf("check_entry: `%s' not found\n", t->u.user.name);
> -		ret = target ? PTR_ERR(target) : -ENOENT;
> -		goto cleanup_matches;
> -	}
> -	t->u.kernel.target = target;
> -
> -	ret = xt_check_target(target, AF_INET, t->u.target_size - sizeof(*t),
> -			      name, e->comefrom, e->ip.proto,
> -			      e->ip.invflags & IPT_INV_PROTO);
> +	ret = xt_init_target(t, "ipt", AF_INET,
> +			     name, e->comefrom, e->ip.proto,
> +			     e->ip.invflags & IPT_INV_PROTO);

x_tables can deduce the prefix from the address family.

>  	if (ret)
>  		goto err;
>  
> @@ -575,9 +558,11 @@ check_entry(struct ipt_entry *e, const c
>  			ret = -EINVAL;
>  			goto err;
>  		}
> -	} else if (t->u.kernel.target->checkentry
> -		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
> -						      e->comefrom)) {
> +	} else if (t->u.kernel.target->init
> +		   && !t->u.kernel.target->init(name, e, t->u.kernel.target,
> +		   				t->data,
> +						e->comefrom,
> +						t->u.kernel.priv_data)) {
>  		duprintf("ip_tables: check failed for `%s'.\n",
>  			 t->u.kernel.target->name);
>  		ret = -EINVAL;
> @@ -587,7 +572,7 @@ check_entry(struct ipt_entry *e, const c
>  	(*i)++;
>  	return 0;
>   err:
> -	module_put(t->u.kernel.target->me);
> +	xt_destroy_target(t);
>   cleanup_matches:
>  	IPT_MATCH_ITERATE(e, cleanup_match, &j);
>  	return ret;
> @@ -648,8 +633,9 @@ cleanup_entry(struct ipt_entry *e, unsig
>  	IPT_MATCH_ITERATE(e, cleanup_match, NULL);
>  	t = ipt_get_target(e);
>  	if (t->u.kernel.target->destroy)
> -		t->u.kernel.target->destroy(t->u.kernel.target, t->data);
> -	module_put(t->u.kernel.target->me);
> +		t->u.kernel.target->destroy(t->u.kernel.target, t->data,
> +					    t->u.kernel.priv_data);
> +	xt_destroy_target(t);
>  	return 0;
>  }
>  
> @@ -718,7 +704,7 @@ translate_table(const char *name,
>  	/* Finally, each sanity check must pass */
>  	i = 0;
>  	ret = IPT_ENTRY_ITERATE(entry0, newinfo->size,
> -				check_entry, name, size, &i);
> +				init_entry, name, size, &i);
>  
>  	if (ret != 0) {
>  		IPT_ENTRY_ITERATE(entry0, newinfo->size,
> @@ -1364,15 +1350,15 @@ struct compat_ipt_replace {
>  };
>  
>  static inline int compat_copy_match_to_user(struct ipt_entry_match *m,
> -		void __user **dstptr, compat_uint_t *size)
> +		void * __user *dstptr, compat_uint_t *size)

reintroduces the bug mentioned above.

>  {
>  	return xt_compat_match_to_user(m, dstptr, size);
>  }
>  
>  static int compat_copy_entry_to_user(struct ipt_entry *e,
> -		void __user **dstptr, compat_uint_t *size)
> +		void * __user *dstptr, compat_uint_t *size)
>  {
> -	struct ipt_entry_target *t;
> +	struct ipt_entry_target __user *t;
>  	struct compat_ipt_entry __user *ce;
>  	u_int16_t target_offset, next_offset;
>  	compat_uint_t origsize;
> @@ -1477,7 +1463,7 @@ check_compat_entry_size_and_hooks(struct
>  						     t->u.user.revision),
>  					 "ipt_%s", t->u.user.name);
>  	if (IS_ERR(target) || !target) {
> -		duprintf("check_entry: `%s' not found\n", t->u.user.name);
> +		duprintf("init_entry: `%s' not found\n", t->u.user.name);
>  		ret = target ? PTR_ERR(target) : -ENOENT;
>  		goto cleanup_matches;
>  	}
> @@ -1523,15 +1509,15 @@ static inline int compat_copy_match_from
>  	match = m->u.kernel.match;
>  	xt_compat_match_from_user(m, dstptr, size);
>  
> -	ret = xt_check_match(match, AF_INET, dm->u.match_size - sizeof(*dm),
> -			     name, hookmask, ip->proto,
> -			     ip->invflags & IPT_INV_PROTO);
> +	ret = xt_init_match(m, "ipt", AF_INET,
> +			    name, hookmask, ip->proto,
> +			    ip->invflags & IPT_INV_PROTO);
>  	if (ret)
>  		goto err;
>  
> -	if (m->u.kernel.match->checkentry
> -	    && !m->u.kernel.match->checkentry(name, ip, match, dm->data,
> -					      hookmask)) {
> +	if (m->u.kernel.match->init
> +	    && !m->u.kernel.match->init(name, ip, match, dm->data,
> +					hookmask, m->u.kernel.priv_data)) {

The ->checkentry/->init call should be performed in xt_init_match.

> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index 58522fc..5822202 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -303,10 +303,27 @@ int xt_find_revision(int af, const char 
>  }
>  EXPORT_SYMBOL_GPL(xt_find_revision);
>  
> -int xt_check_match(const struct xt_match *match, unsigned short family,
> -                   unsigned int size, const char *table, unsigned int hook_mask,
> -		   unsigned short proto, int inv_proto)
> -{
> +int xt_init_match(struct xt_entry_match *m, char *module_prefix,
> +		  unsigned short family, const char *table,
> +		  unsigned int hook_mask,
> +		  unsigned short proto, int inv_proto)
> +{
> +	struct xt_match *match;
> +	unsigned int size = (m->u.match_size - sizeof(*m));
> +
> +	match = try_then_request_module(xt_find_match(family, m->u.user.name,
> +						   m->u.user.revision),
> +					"%s_%s",
> +					module_prefix, m->u.user.name);
> +	if (IS_ERR(match) || !match) {
> +		duprintf("init_match: `%s' not found\n", m->u.user.name);
> +		m->u.kernel.match = NULL;
> +		m->u.kernel.priv_data = NULL;
> +		return match ? PTR_ERR(match) : -ENOENT;
> +	}
> +	m->u.kernel.match = match;
> +	m->u.kernel.priv_data = NULL;
> +
>  	if (XT_ALIGN(match->matchsize) != size) {
>  		printk("%s_tables: %s match: invalid size %Zu != %u\n",
>  		       xt_prefix[family], match->name,
> @@ -328,9 +345,30 @@ int xt_check_match(const struct xt_match
>  		       xt_prefix[family], match->name, match->proto);
>  		return -EINVAL;
>  	}
> +
> +	if (match->priv_size) {
> +		m->u.kernel.priv_data = kzalloc(match->priv_size,
> +						GFP_KERNEL);
> +		if (!m->u.kernel.priv_data) {
> +			printk("%s_tables: %s match: "
> +			       "unable to allocate memory\n",
> +			       xt_prefix[family], match->name);
> +			return -ENOMEM;

It should clean up behind itself.
