From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 02/10] nf_conntrack: Introduces a extension
	infrastructure
Date: Mon, 25 Jun 2007 12:01:02 +0200
Message-ID: <467F925E.7090703@trash.net>
References: <200706250314.l5P3EeGY021239@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, netfilter-devel@lists.netfilter.org,
	pablo@netfilter.org, kadlec@blackhole.kfki.hu
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706250314.l5P3EeGY021239@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> +static void *
> +nf_ct_ext_create(struct nf_ct_ext **ext, enum nf_ct_ext_id id, int gfp)
> +{
> +	unsigned int off, len, real_len;
> +	struct nf_ct_ext_type *t;
> +
> +	rcu_read_lock();
> +	t = rcu_dereference(nf_ct_ext_types[id]);
> +	BUG_ON(t == NULL);
> +	off = ALIGN(sizeof(struct nf_ct_ext), t->align);
> +	len = off + t->len;
> +	real_len = t->alloc_size;
> +	rcu_read_unlock();
> +
> +	*ext = kmalloc(real_len, gfp);
> +	if (!*ext)
> +		return NULL;
> +
> +	memset(*ext, 0, len);

Minor improvement: you could use kzalloc above

> +
> +	(*ext)->offset[id] = off;
> +	(*ext)->len = len;
> +	(*ext)->real_len = real_len;
> +
> +	return (void *)(*ext) + off;
> +}
> +
> +void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, int gfp)


Does any caller actually use something besides GFP_ATOMIC for gfp?

> +{
> +	struct nf_ct_ext *new;
> +	int i, newlen, newoff;
> +	struct nf_ct_ext_type *t;
> +
> +	if (!ct->ext)
> +		return nf_ct_ext_create(&ct->ext, id, gfp);
> +
> +	if (nf_ct_ext_exist(ct, id))
> +		return NULL;
> +
> +	rcu_read_lock();
> +	t = rcu_dereference(nf_ct_ext_types[id]);
> +	BUG_ON(t == NULL);
> +
> +	newoff = ALIGN(ct->ext->len, t->align);
> +	newlen = newoff + t->len;
> +	rcu_read_unlock();
> +
> +	if (newlen >= ct->ext->real_len) {
> +		new = kmalloc(newlen, gfp);
> +		if (!new)
> +			return NULL;
> +
> +		memcpy(new, ct->ext, ct->ext->len);

And maybe krealloc here?

> +
> +		for (i = 0; i < NF_CT_EXT_MAX; i++) {
> +			if (!nf_ct_ext_exist(ct, i))
> +				continue;
> +
> +			rcu_read_lock();
> +			t = rcu_dereference(nf_ct_ext_types[i]);
> +			if (t && t->move)
> +				t->move(ct, ct->ext + ct->ext->offset[id]);
> +			rcu_read_unlock();
> +		}
> +		kfree(ct->ext);
> +		new->real_len = newlen;
> +		ct->ext = new;
> +	}
> +
> +	ct->ext->offset[id] = newoff;
> +	ct->ext->len = newlen;
> +	memset((void *)ct->ext + newoff, 0, newlen - newoff);
> +	return (void *)ct->ext + newoff;
> +}
> +EXPORT_SYMBOL(__nf_ct_ext_add);
> +
> +static void update_alloc_size(enum nf_ct_ext_id id)
> +{
> +	int i, j;
> +	struct nf_ct_ext_type *t1, *t2;
> +	enum nf_ct_ext_id min = 0, max = NF_CT_EXT_MAX - 1;
> +
> +	/* unnecessary to update all types */
> +	if ((nf_ct_ext_types[id]->flags & NF_CT_EXT_F_PREALLOC) == 0) {
> +		min = id;
> +		max = id;
> +	}
> +
> +	/* This assumes that extended areas in conntrack for the types
> +  	   whose NF_CT_EXT_F_PREALLOC bit set are allocated in order */
> +	for (i = min; i <= max; i++) {
> +		t1 = nf_ct_ext_types[i];
> +		if (!t1)
> +			continue;
> +
> +		t1->alloc_size = sizeof(struct nf_ct_ext)
> +				 + ALIGN(sizeof(struct nf_ct_ext), t1->align)
> +				 + t1->len;
> +		for (j = 0; j < NF_CT_EXT_MAX; j++) {
> +			t2 = nf_ct_ext_types[j];
> +			if (t2 == NULL || t2 == t1 ||
> +			    (t2->flags & NF_CT_EXT_F_PREALLOC) == 0)
> +				continue;
> +
> +			t1->alloc_size = ALIGN(t1->alloc_size, t2->align)
> +					 + t2->len;
> +		}
> +		if (t1->alloc_size < NF_CT_EXT_MIN_SIZE)
> +			t1->alloc_size = NF_CT_EXT_MIN_SIZE;
> +	}
> +}
> +
> +/* This MUST be called in process context. */
> +int nf_ct_extend_register(struct nf_ct_ext_type *type)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&nf_ct_ext_type_mutex);
> +	if (nf_ct_ext_types[type->id]) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	/* This ensures that nf_ct_ext_create() can allocate enough area
> +	   before updating alloc_size */
> +	type->alloc_size = ALIGN(sizeof(struct nf_ct_ext), type->align)
> +			   + type->len;
> +	rcu_assign_pointer(nf_ct_ext_types[type->id], type);
> +	update_alloc_size(type->id);
> +out:
> +	mutex_unlock(&nf_ct_ext_type_mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(nf_ct_extend_register);
> +
> +/* This MUST be called in process context. */
> +void nf_ct_extend_unregister(struct nf_ct_ext_type *type)
> +{
> +	mutex_lock(&nf_ct_ext_type_mutex);
> +	rcu_assign_pointer(nf_ct_ext_types[type->id], NULL);


This seems to need synchronize_rcu().

> +	update_alloc_size(type->id);
> +	mutex_unlock(&nf_ct_ext_type_mutex);
> +}
> +EXPORT_SYMBOL_GPL(nf_ct_extend_unregister);
