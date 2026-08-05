Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1048132E121;
	Wed,  5 Aug 2026 00:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785888938; cv=none; b=fBwX0WX+jx1B5UpGUcvqf3GD5gNyfRfN5D2tq8s26hgNh02SmEzn7/71p4H871Y1ILdNKaSSiM6qHeFG5pRhTPs+nZ9tng4pzDZ4kCQkCYYyd6Yd8iSY+cmXWZEorIjG+3vwPGwAtJNApo57tMeFVO+hRnWaIi6E87lu29i/NMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785888938; c=relaxed/simple;
	bh=nIQeHjgMVaZLbskbdo3rHMFsHh4uawloNW/hCJi2i8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAReYO3BahbFkkx2hZoaupRW3j8uvL4CZnmCFmNIn7E1NrjTeV19jNiFnPsFQBtQQOsG4qGGAZX3vtqLcJGJCRMkNGzbHAEFgrg+nfTwihGeTzhF7ClAHDoUZzwQN1MXaAKfqh2ZAxzLEqWI1QrGoWbDX8O4XV+kh19MOa9bOo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XAQCcE77; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XAQCcE77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9981F00A3D;
	Wed,  5 Aug 2026 00:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785888936;
	bh=vfii4wLnz80JdgEYiEuYqm/7LkljATDzKbzE5sj147g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XAQCcE77pNI+PfWx1CHiqnCdMM74oT1N4Qkfnb+106xb3gjwR90wVSM/JO3zqgiA5
	 AyXOpE/yTD5dQBC+ZGUcRWtdY9Q+NuWFZnq5jevC0+9vGLedu653tCX+FIvqkN5B9P
	 g99f69BwkPrSpVkHwcsu6Z+fBnCR7M3JYh6Rqpgx17DYGDbYbYKfxIHtwEIS4wNWRb
	 Ct+9miTb8kzQzmLeYt/6Yg3typgGCV1rZ8QD7Bq2e7o7wAVIdT8JtGX+PSVDAjgbKK
	 DfJVXpEFjPvXDwiTd4TwchcnwF89m6mANfs/8k2Bwcr1oCRniMBDmi/AGg1TcRdXLL
	 YAHhH/l6pQ8Cw==
From: Jakub Kicinski <kuba@kernel.org>
To: pablo@netfilter.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: Re: [PATCH net 10/10] netfilter: nft_ct: move custom expectation support to helper
Date: Tue,  4 Aug 2026 17:15:35 -0700
Message-ID: <20260805001535.3978948-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260731151806.849724-11-pablo@netfilter.org>
References: <20260731151806.849724-11-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
netfilter: nft_ct: move custom expectation support to helper

This reworks the nftables ct expectation object so that the expectation is
no longer created directly from the rule evaluation, but from an internal
conntrack helper that is allocated per object and attached to the conntrack
entry. nf_conntrack_helper_free() is split out of
nf_conntrack_helper_unregister() and exported so the internal helper can be
released when the object goes away.

Link: https://patch.msgid.link/20260715144755.00ea7dfcd9f@proton.me

A few questions about the commit message first.

> Originally, the ct expectation support called nf_ct_helper_ext_add() for
> confirmed conntracks, which is invalid, triggering a splat. This was
> fixed by commit 1710eb913bdc ("netfilter: nft_ct: skip expectations for
> confirmed conntrack") which restricted it to confirmed conntracks.

[Severity: Low]
Is this description inverted?  That commit skips confirmed conntracks, so
it restricted the feature to unconfirmed ones, which is also the guard this
patch keeps in nft_ct_expect_obj_eval():

	if (!ct || nf_ct_is_template(ct) || nf_ct_is_confirmed(ct)) {
		regs->verdict.code = NFT_BREAK;
		return;
	}

> Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")

[Severity: Low]
The Fixes tag points at the 2019 feature commit, but the implementation
relies on struct nf_conntrack_helper::ct_refcnt, which git blame on
include/net/netfilter/nf_conntrack_helper.h attributes to commit
ac46f3f35b6e68 (2026-06-04), on the refcount_inc_not_zero() guarded
help->helper assignment in __nf_ct_try_assign_helper(), and on the
kzalloc_obj() slab macro.

Would a note about stable applicability be worth adding, since a tree
without the ct_refcnt rework would not build this and has no equivalent
lifetime scheme for an unregistered helper?

> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> index 500509b17663e..1197e8793494b 100644
> --- a/net/netfilter/nf_conntrack_helper.c
> +++ b/net/netfilter/nf_conntrack_helper.c
> @@ -456,13 +456,8 @@ static bool expect_iter_me(struct nf_conntrack_expect *exp, void *data)
>  	return this == me;
>  }
>  
> -void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
> +void nf_conntrack_helper_free(struct nf_conntrack_helper *me)
>  {
> -	mutex_lock(&nf_ct_helper_mutex);
> -	hlist_del_rcu(&me->hnode);
> -	nf_ct_helper_count--;
> -	mutex_unlock(&nf_ct_helper_mutex);
> -
>  	/* This helper is going away, disable it. */
>  	rcu_assign_pointer(me->help, NULL);
>  
> @@ -476,6 +471,17 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
>  	if (refcount_dec_and_test(&me->ct_refcnt))
>  		kfree_rcu(me, rcu);
>  }
> +EXPORT_SYMBOL_GPL(nf_conntrack_helper_free);
> +
> +void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
> +{
> +	mutex_lock(&nf_ct_helper_mutex);
> +	hlist_del_rcu(&me->hnode);
> +	nf_ct_helper_count--;
> +	mutex_unlock(&nf_ct_helper_mutex);
> +
> +	nf_conntrack_helper_free(me);
> +}
>  EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
>  
>  void nf_ct_helper_init(struct nf_conntrack_helper *helper,

[ ... ]

> diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> index 03a88c77e0f02..30c9358dbf48a 100644
> --- a/net/netfilter/nft_ct.c
> +++ b/net/netfilter/nft_ct.c
> @@ -1226,6 +1228,73 @@ static int nft_ct_expect_timeout_get(const struct nlattr *attr, u32 *val)
>  	return 0;
>  }
>  
> +struct nft_ct_expect_data {
> +	struct nft_ct_expect_obj	obj;
> +	enum ip_conntrack_dir		dir;
> +	atomic_t			num_expects;
> +};
> +
> +static int ct_expect_help(struct sk_buff *skb, unsigned int protoff,
> +			  struct nf_conn *ct, enum ip_conntrack_info ctinfo)
> +{
> +	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
> +	struct nft_ct_expect_data *expect_data;
> +	struct nf_conntrack_expect *exp;
> +	int ret = NF_ACCEPT;
> +
> +	expect_data = nfct_help_data(ct);
> +	if (!expect_data)
> +		return NF_ACCEPT;
> +
> +	if (expect_data->dir != dir)
> +		return NF_ACCEPT;
> +
> +	if (!atomic_add_unless(&expect_data->num_expects, 1, expect_data->obj.size))
> +		return NF_ACCEPT;

[Severity: Medium]
Does this change the meaning of NFTA_CT_EXPECT_SIZE?  The old gate in
nft_ct_expect_obj_eval() was:

	if (help->expecting[NF_CT_EXPECT_CLASS_DEFAULT] >= priv->size) {

that is a limit on live expectations, and nf_ct_unlink_expect() decrements
expecting[] once an expectation is consumed or times out.

num_expects here is only ever decremented on failure, so it looks like a
cumulative lifetime cap instead: after size expectations have been created,
no further expectation is created for that conntrack even when the previous
ones are long gone.

The other difference is when the callback runs.  nf_confirm() calls
helper_cb() for every packet of the flow once nfct_help(ct) is set, so with
size >= 2 the first packets of an already established connection re-enter
ct_expect_help() and re-insert the same expectation through the refresh
path in __nf_ct_expect_check():

	if (master_matches(i, expect, flags) && expect_matches(i, expect)) {
		...
		nf_ct_unlink_expect(i);
		break;

Should the commit message describe these two behaviour changes, since it
presents the patch as only moving the feature into a helper?

> +
> +	exp = nf_ct_expect_alloc(ct);
> +	if (!exp) {
> +		atomic_dec(&expect_data->num_expects);
> +		return NF_DROP;
> +	}
> +
> +	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
> +			  &ct->tuplehash[!dir].tuple.src.u3,
> +			  &ct->tuplehash[!dir].tuple.dst.u3,
> +			  expect_data->obj.l4proto, NULL, &expect_data->obj.dport);

[Severity: Low]
Does NFTA_CT_EXPECT_L3PROTO still do anything after this?  The old eval
passed the configured value:

	u16 l3num = priv->l3num;
	...
	if (l3num == NFPROTO_INET)
		l3num = nf_ct_l3num(ct);

Here nf_ct_l3num(ct) is used unconditionally and priv->l3num is not read by
any datapath code, while nft_ct_expect_obj_init() still parses and
range-checks the attribute and nft_ct_expect_obj_dump() still echoes it
back.  In an inet table, which is the one case where priv->l3num is allowed
to differ from ctx->family, "l3proto ipv4" now has no effect on which
conntracks get expectations.

> +	exp->timeout += expect_data->obj.timeout;
> +
> +	if (nf_ct_expect_related(exp, 0) != 0) {
> +		atomic_dec(&expect_data->num_expects);
> +		ret = NF_DROP;
> +	}

[Severity: Medium]
Can this blackhole an established flow?  The budget is given back on
failure and nf_confirm() runs the callback for every packet:

	ret = helper_cb(skb, protoff, ct, ctinfo);
	if (ret != NF_ACCEPT)
		return ret;

So for a persistent failure the retry happens per packet and each retry
drops the packet.  A persistent failure looks reachable: once expectation E
has been consumed or expired, another conntrack creating a byte-identical
tuple takes the clash path in __nf_ct_expect_check() rather than the
replace path:

	} else if (expect_clash(i, expect)) {
		ret = -EBUSY;
		goto out;

A full expect table (-EMFILE) has the same shape.  Before this patch the
NF_DROP could only happen for the unconfirmed first packet; now every
subsequent packet of the confirmed connection in that direction is dropped
for as long as the clash lasts.

> +
> +	nf_ct_expect_put(exp);
> +
> +	return ret;
> +}
> +
> +static int nft_ct_expect_helper_alloc(struct nft_ct_expect_obj *priv)
> +{
> +	struct nf_conntrack_helper *ct_expect_helper;
> +
> +	ct_expect_helper = kzalloc_obj(struct nf_conntrack_helper);

[Severity: Low]
Should this be accounted to the memcg?  kzalloc_obj() with no gfp argument
is GFP_KERNEL, while the equivalent allocation of the same struct in
nf_conntrack_helper_register() uses:

	new_helper = kzalloc_obj(*new_helper, GFP_KERNEL_ACCOUNT);

as do the nfnetlink_cthelper allocations.  The object is created from an
NFT_MSG_NEWOBJ request and can outlive the ruleset, since every conntrack
that got the helper assigned holds an extra ct_refcnt.

> +	if (!ct_expect_helper)
> +		return -ENOMEM;
> +
> +	snprintf(ct_expect_helper->name, sizeof(ct_expect_helper->name), "%s",
> +		 "nft_ct_expect");
> +	ct_expect_helper->me = THIS_MODULE;
> +	ct_expect_helper->expect_policy[NF_CT_EXPECT_CLASS_DEFAULT].max_expected = priv->size;

[Severity: Low]
This assignment skips the normalization that every registered helper gets
in __nf_conntrack_helper_register():

	if (!me->expect_policy[i].max_expected)
		me->expect_policy[i].max_expected = NF_CT_EXPECT_MAX_CNT;

With "size 0", which nft_ct_expect_obj_init() accepts, the attached helper
ends up with max_expected == 0.  __nf_ct_expect_check() then evaluates:

	p = &helper->expect_policy[expect->class];
	if (master_help->expecting[expect->class] >= p->max_expected)
		evict_oldest_expect(master_help, expect, p);

as always true, so any other creator of an expectation for that master
(ctnetlink, for instance) takes the eviction path every time.  Is
max_expected == 0 intended here?

There is also a mismatch of meaning: max_expected is a refillable
concurrent limit against master_help->expecting[], whereas the num_expects
gate in ct_expect_help() treats the same configured value as a cumulative
cap.

> +	rcu_assign_pointer(ct_expect_helper->help, ct_expect_help);
> +	refcount_set(&ct_expect_helper->ct_refcnt, 1);
> +
> +	/* No need to register this helper, this is internal. */
> +	priv->helper = ct_expect_helper;

[Severity: Low]
The helper's tuple stays zeroed here, so tuple.dst.protonum == 0, unlike
every helper built by nf_ct_helper_init() which sets a real IPPROTO_*.
The two dispatchers of ->help() disagree about that value.  nf_confirm()
calls the callback unconditionally, while nf_ct_helper() used by act_ct and
openvswitch filters first:

	if (helper->tuple.dst.protonum != proto)
		return NF_ACCEPT;

which can never match protonum 0.  So on the act_ct/OVS path this helper is
silently skipped and no expectation is ever created.

I could not construct a concrete hook ordering where nf_ct_helper() runs
before nf_confirm() has already created the expectation, so this may be
harmless today, but what protonum is intended for this helper?
NFTA_CT_EXPECT_L4PROTO describes the expected child connection, not the
master, so no obvious value is available at object init time.

> +
> +	return 0;
> +}
> +
>  static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
>  				  const struct nlattr * const tb[],
>  				  struct nft_object *obj)

[ ... ]

> @@ -1273,13 +1344,26 @@ static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
>  	priv->dport = nla_get_be16(tb[NFTA_CT_EXPECT_DPORT]);
>  	priv->size = nla_get_u8(tb[NFTA_CT_EXPECT_SIZE]);
>  
> -	return nf_ct_netns_get(ctx->net, ctx->family);
> +	err = nf_ct_netns_get(ctx->net, ctx->family);
> +	if (err < 0)
> +		return err;
> +
> +	err = nft_ct_expect_helper_alloc(priv);
> +	if (err < 0) {
> +		nf_ct_netns_put(ctx->net, ctx->family);
> +		return err;
> +	}
> +
> +	return err;
>  }
>  
>  static void nft_ct_expect_obj_destroy(const struct nft_ctx *ctx,
> -				       struct nft_object *obj)
> +				      struct nft_object *obj)
>  {
> +	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
> +
>  	nf_ct_netns_put(ctx->net, ctx->family);
> +	nf_conntrack_helper_free(priv->helper);
>  }

[Severity: High]
Is it acceptable to run nf_conntrack_helper_free() once per destroyed
object here?  It does:

	rcu_assign_pointer(me->help, NULL);
	synchronize_rcu();
	nf_ct_expect_iterate_destroy(expect_iter_me, me);

so one full RCU grace period plus a walk of the entire global expectation
hash under spin_lock_bh(&nf_conntrack_expect_lock), work that previously
only happened on helper module unregistration.

In the abort path this runs from __nf_tables_abort():

	synchronize_rcu();

	list_for_each_entry_safe_reverse(trans, next, &nft_net->commit_list, list) {
		nft_trans_list_del(trans);
		nf_tables_abort_release(trans);
	}

which reaches nft_obj_destroy() -> nft_ct_expect_obj_destroy() while
nft_net->commit_mutex and nfnl_lock are still held.  A batch that creates N
ct expect objects and then fails therefore serializes N grace periods under
the per-netns nftables mutex, with N chosen by the caller.
__nft_release_table() on netns exit has the same property.

The commit-release path already does one synchronize_rcu() for the whole
batch, and nf_tables_commit_release() carries the comment "Memory reclaim
happens asynchronously from work queue to prevent expensive
synchronize_rcu() in commit phase".  Could the helper release be deferred
to that work queue instead?

>  
>  static int nft_ct_expect_obj_dump(struct sk_buff *skb,
> @@ -1302,50 +1386,39 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
>  				   const struct nft_pktinfo *pkt)
>  {
>  	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
> -	struct nf_conntrack_expect *exp;
> +	struct nft_ct_expect_data *expect_data;
>  	enum ip_conntrack_info ctinfo;
>  	struct nf_conn_help *help;
> -	enum ip_conntrack_dir dir;
> -	u16 l3num = priv->l3num;
>  	struct nf_conn *ct;
>  
>  	ct = nf_ct_get(pkt->skb, &ctinfo);
> -	if (!ct || nf_ct_is_confirmed(ct) || nf_ct_is_template(ct)) {
> +	if (!ct || nf_ct_is_template(ct) || nf_ct_is_confirmed(ct)) {
>  		regs->verdict.code = NFT_BREAK;
>  		return;
>  	}
> -	dir = CTINFO2DIR(ctinfo);
>  
>  	help = nfct_help(ct);
> -	if (!help)
> -		help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
> -	if (!help) {
> -		regs->verdict.code = NF_DROP;
> -		return;
> -	}
> -
> -	if (help->expecting[NF_CT_EXPECT_CLASS_DEFAULT] >= priv->size) {
> +	if (help) {
>  		regs->verdict.code = NFT_BREAK;
>  		return;
>  	}

[Severity: High]
Does this permanently disable the statement for conntracks that already
carry a helper extension?  The old code reused an existing extension:

	help = nfct_help(ct);
	if (!help)
		help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);

and created the expectation either way.  Now any conntrack with
nfct_help(ct) != NULL takes NFT_BREAK, which also aborts the remainder of
the rule, so "ct expect set e counter accept" no longer reaches accept and
the chain policy applies instead.

Three in-tree ways to be in that state before nft rules run:

  init_conntrack() for a conntrack born from an expectation with
  assign_helper set:

	help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
	if (help && refcount_inc_not_zero(&assign_helper->ct_refcnt))
		rcu_assign_pointer(help->helper, assign_helper);

  __nf_ct_try_assign_helper() during nf_conntrack_in() when the template
  carries a helper:

	if (help == NULL) {
		help = nf_ct_helper_ext_add(ct, flags);

  and a ruleset that runs "ct helper set" (nft_ct_helper_obj_eval()) or a
  second ct expect object on the same connection.

Should this case fall back to attaching the expectation data anyway, or at
least be documented?

>  
> -	exp = nf_ct_expect_alloc(ct);
> -	if (exp == NULL) {
> +	help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
> +	if (!help) {
>  		regs->verdict.code = NF_DROP;
>  		return;
>  	}
>  
> +	expect_data = nfct_help_data(ct);
> +	if (!expect_data) {
> +		regs->verdict.code = NFT_BREAK;
> +		return;
> +	}
> +	expect_data->obj = *priv;

[Severity: Low]
This copies the whole struct nft_ct_expect_obj, which now includes the raw
struct nf_conntrack_helper *helper pointer, into the conntrack helper
extension private area, without taking a reference for that copy.  Only
help->helper, referenced on the next line, is a valid handle.

Since the conntrack extension can outlive the nft object,
expect_data->obj.helper becomes stale once nft_ct_expect_obj_destroy() ->
nf_conntrack_helper_free() drops the last reference and kfree_rcu() runs.
Nothing reads it today, so this is latent, but would it be clearer to copy
only the fields ct_expect_help() uses?

It also spends 8 of the 32 bytes available in nf_conn_help->data, and
struct nft_ct_expect_data is already at the NF_CT_HELPER_BUILD_BUG_ON
limit.

> +	expect_data->dir = CTINFO2DIR(ctinfo);
>  
> -	nf_ct_expect_put(exp);
> +	if (help && refcount_inc_not_zero(&priv->helper->ct_refcnt))
> +		rcu_assign_pointer(help->helper, priv->helper);
>  }

[ ... ]
