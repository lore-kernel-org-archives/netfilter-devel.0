Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916BE443E3E;
	Thu, 30 Jul 2026 16:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427379; cv=none; b=HlQ5MgQy/xZCkls3OuWB0uMwyvIe9Wpd2dP0x97HXoekiXp2dGcWOi5apCSwU8cT+Mopz1b3m4ROdGtG6ACh1S0cGaOuEIvVWTYj6+l9ZiZUHr/IHNz8RrjDR8W64UHS5KdERGqIDvpINaZoSRc/Enx7B7ep7dfQoF+Ak6kqaVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427379; c=relaxed/simple;
	bh=oKKN7vPTXcNb+up+rhU9jhk8ikKqF+vFCsgKk5PAQwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=poKuSoaNRPDz6gbGvSDWXr8q/kZ/bYw/LTHYq7zfiDvZwWGZELGmOHmNRxqR+aPRivS/Q4d6eoEpYyFCJoDmiBGbYcKjFACA9udMCFelcRTMNnDKSaRul6+ZhUu3lHjDM3iL2r+ctWtqkvvngPL43voMpP6//YSV35Zimt8ZA6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ei9Uk7gR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ei9Uk7gR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015491F00A3A;
	Thu, 30 Jul 2026 16:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785427376;
	bh=LE8BMcBncnAjl1Bb+/+RIrPKgsOzsa425q/RfHXqxqI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ei9Uk7gR8VJqAbPe7E5tLrSXZHK41lAZLQmcIdkQZ9vPVvE6lFpYRGUfWHKO9fQtq
	 4vozsGGavoq1UIUCASvOOvNXtnBLmjQqZt2d4AQA0trguAmTDqsKH8SfUYwLE/N4A6
	 ANZZlidCA471YvT3rmQjF9ixjb34iBBU3NYOlcQy22P6JlO29babefoY7S9ppKYLrH
	 2cCB6RuCZO2WDZ4nMNPicd428tHeF/Jcx5/FagbvJgM94CF7IerCx34QXKJnKLENTt
	 Cpk2uTHVGxI5/iWfqXMnMgy3yff+YVDiwPW2K0/zMRZnXiNNcNEyHOIYQNQhLhizDx
	 Tws06ayFZkcmw==
Date: Thu, 30 Jul 2026 17:02:50 +0100
From: Simon Horman <horms@kernel.org>
To: Weiming Shi <bestswngs@gmail.com>
Cc: Claudiu Manoil <claudiu.manoil@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	syzbot+5a66db916cdde0dbcc1c@syzkaller.appspotmail.com,
	Xiang Mei <xmei5@asu.edu>, stable@vger.kernel.org
Subject: Re: [PATCH net v2] net: flow_offload: serialize driver callback lists
Message-ID: <20260730160250.GD51943@horms.kernel.org>
References: <20260719175028.988301-2-bestswngs@gmail.com>
 <20260726120338.488658-1-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726120338.488658-1-bestswngs@gmail.com>

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
Full review at: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260726120338.488658-1-bestswngs@gmail.com?part=1
---
--- Patch [1]: [PATCH net v2] net: flow_offload: serialize driver callback lists ---
commit 93c807b64d24dcddc15896bc3604b3d8341855e1
Author: Weiming Shi <bestswngs@gmail.com>

net: flow_offload: serialize driver callback lists

This adds a global flow-offload callback mutex that is held across direct
and indirect ndo_setup_tc() setup, callback ownership transfer and
rollback, moves indirect-unregister list removal into the flow-offload
core, and makes indirect-device registration transactional on setup
failure.

Link: https://lore.kernel.org/netdev/20260719175028.988301-2-bestswngs@gmail.com/

> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> index 7b17bca24f26..c994f878cacd 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
> @@ -1601,30 +1601,41 @@ int enetc_set_psfp(struct net_device *ndev, bool en)
>  
>  int enetc_psfp_init(struct enetc_ndev_priv *priv)
>  {
> +	int err = 0;
> +
> +	flow_block_cb_lock();
>  	if (epsfp.psfp_sfi_bitmap)
> -		return 0;
> +		goto out;
>  
>  	epsfp.psfp_sfi_bitmap = bitmap_zalloc(priv->psfp_cap.max_psfp_filter,
>  					      GFP_KERNEL);
> -	if (!epsfp.psfp_sfi_bitmap)
> -		return -ENOMEM;
> +	if (!epsfp.psfp_sfi_bitmap) {
> +		err = -ENOMEM;
> +		goto out;
> +	}

[Severity: High]
This isn't a bug introduced by this patch, but since this hunk rewrites
exactly the bitmap allocation site, is the psfp_sfi_bitmap lifecycle
asymmetric here?

The UNBIND path in enetc_setup_tc_psfp() frees the bitmap:

	case FLOW_BLOCK_UNBIND:
		...
		clear_bit(port, &epsfp.dev_bitmap);
		if (!epsfp.dev_bitmap)
			clean_psfp_all();

and clean_psfp_all() -> clean_psfp_sfi_bitmap() does bitmap_free() and
sets epsfp.psfp_sfi_bitmap = NULL.

The BIND path only does set_bit(port, &epsfp.dev_bitmap), it never
reallocates. enetc_psfp_init() is reached only from the inline
enetc_psfp_enable() in enetc.h, called from enetc_pf_set_features() on a
NETIF_F_HW_TC change and once at probe, and it early-returns when the
pointer is non-NULL.

So after "tc qdisc del dev eth0 clsact" followed by "tc qdisc add dev eth0
clsact" (features unchanged, so tc_can_offload() still passes), does the
first flower rule with a PSFP action hit a NULL dereference in
enetc_get_free_index()?

	index = find_first_zero_bit(epsfp.psfp_sfi_bitmap, max_size);

There is no NULL guard on any of the psfp_sfi_bitmap users.

>  
>  	spin_lock_init(&epsfp.psfp_lock);
>  
>  	if (list_empty(&enetc_block_cb_list))
>  		epsfp.dev_bitmap = 0;
>  
> -	return 0;
> +out:
> +	flow_block_cb_unlock();
> +	return err;
>  }
>  
>  int enetc_psfp_clean(struct enetc_ndev_priv *priv)
>  {
> -	if (!list_empty(&enetc_block_cb_list))
> -		return -EBUSY;
> +	int err = -EBUSY;
>  
> -	clean_psfp_all();
> +	flow_block_cb_lock();
> +	if (list_empty(&enetc_block_cb_list)) {
> +		clean_psfp_all();
> +		err = 0;
> +	}
> +	flow_block_cb_unlock();
>  
> -	return 0;
> +	return err;
>  }

[Severity: Low]
Is exporting the core mutex for drivers to take directly the intended
layering here?  The driver now runs bitmap_zalloc() and clean_psfp_all()
while holding a net/core mutex, which inverts the usual "core calls
driver" direction.

The new contract - a driver must hold flow_block_cb_mutex whenever it
touches its own driver_block_list - is expressed only as
lockdep_assert_held() inside flow_block_cb_is_busy() and
flow_block_cb_setup_simple(), and is not documented anywhere in
include/net/flow_offload.h.  Only ENETC was converted, so other drivers
that inspect their callback list outside ndo_setup_tc() remain
unprotected.

Would it be preferable to keep the mutex private to
net/core/flow_offload.c and give drivers a purpose-built helper instead?

> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 70a02ee14308..96a46ba2769d 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -647,6 +647,8 @@ struct flow_block_cb *flow_block_cb_lookup(struct flow_block *block,
>  void *flow_block_cb_priv(struct flow_block_cb *block_cb);
>  void flow_block_cb_incref(struct flow_block_cb *block_cb);
>  unsigned int flow_block_cb_decref(struct flow_block_cb *block_cb);
> +void flow_block_cb_lock(void);
> +void flow_block_cb_unlock(void);
>  
>  static inline void flow_block_cb_add(struct flow_block_cb *block_cb,
>  				     struct flow_block_offload *offload)
> @@ -741,7 +743,9 @@ void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
>  int flow_indr_dev_setup_offload(struct net_device *dev, struct Qdisc *sch,
>  				enum tc_setup_type type, void *data,
>  				struct flow_block_offload *bo,
> -				void (*cleanup)(struct flow_block_cb *block_cb));
> +				void (*cleanup)(struct flow_block_cb *block_cb),
> +				bool *indr_dev_added);
> +void flow_indr_dev_setup_abort(void *data);

[Severity: Low]
Could this be split into a series?  As it stands one patch with Fixes: +
Cc: stable carries at least five independent changes:

  - the new global mutex plus exported lock/unlock API
  - INIT_LIST_HEAD() of the block_cb auxiliary list nodes
  - moving the indirect-cleanup list_del(&block_cb->driver_list) into the
    core
  - transactional indirect-device registration, changing the prototype of
    the exported flow_indr_dev_setup_offload() and adding the exported
    flow_indr_dev_setup_abort()
  - a brand new TC rollback path for failed indirect binds

plus the unrelated ENETC change.

The single Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware
offload support") does not cover the TC-side changes (the moved
list_del() in tc_block_indr_cleanup() and the new
tcf_block_indr_bind_rollback()), which are not introduced by the nftables
offload commit.

>  bool flow_indr_dev_exists(void);
>  
>  #endif /* _NET_FLOW_OFFLOAD_H */
> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> index 5071d7fe6ce2..0b4d2a2cbaf8 100644
> --- a/net/core/flow_offload.c
> +++ b/net/core/flow_offload.c

[ ... ]

> @@ -317,11 +319,27 @@ unsigned int flow_block_cb_decref(struct flow_block_cb *block_cb)
>  }
>  EXPORT_SYMBOL(flow_block_cb_decref);
>  
> +static DEFINE_MUTEX(flow_block_cb_mutex);
> +
> +void flow_block_cb_lock(void)
> +{
> +	mutex_lock(&flow_block_cb_mutex);
> +}
> +EXPORT_SYMBOL(flow_block_cb_lock);

[Severity: Medium]
Should the scalability impact of a single system-wide mutex be discussed
in the commit message?

This mutex becomes the outermost lock on every flow-offload configuration
path (TC block bind/unbind, nftables chain offload, flowtable offload, TC
action offload, indirect device register/unregister, and even
flow_indr_dev_exists()), and it is held across the driver's
ndo_setup_tc().

The two sides acquire it with different outer locks:

nft_chain_offload_cmd()			(no RTNL)
    flow_block_cb_lock()
        dev->netdev_ops->ndo_setup_tc()

tcf_block_offload_bind()		(under RTNL)
    down_write(&block->cb_lock)
    flow_block_cb_lock()

So an nftables commit in one netns that stalls inside a driver or
firmware ndo_setup_tc() while holding flow_block_cb_mutex will stall any
RTNL holder waiting for that mutex, i.e. netdev configuration on
completely unrelated devices.

Were cheaper alternatives considered, such as a lock supplied per driver
callback list, taking RTNL in the nft offload path, or scoping the lock
per netdev?

> +
> +void flow_block_cb_unlock(void)
> +{
> +	mutex_unlock(&flow_block_cb_mutex);
> +}
> +EXPORT_SYMBOL(flow_block_cb_unlock);

[ ... ]

> @@ -486,6 +512,7 @@ void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
>  	struct flow_indr_dev *this, *next, *indr_dev = NULL;
>  	LIST_HEAD(cleanup_list);
>  
> +	flow_block_cb_lock();
>  	mutex_lock(&flow_indr_block_lock);
>  	list_for_each_entry_safe(this, next, &flow_block_indr_dev_list, list) {
>  		if (this->cb == cb &&
> @@ -499,11 +526,13 @@ void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
>  
>  	if (!indr_dev) {
>  		mutex_unlock(&flow_indr_block_lock);
> +		flow_block_cb_unlock();
>  		return;
>  	}
>  
>  	__flow_block_indr_cleanup(release, cb_priv, &cleanup_list);
>  	mutex_unlock(&flow_indr_block_lock);
> +	flow_block_cb_unlock();
>  
>  	tcf_action_reoffload_cb(cb, cb_priv, false);
>  	flow_block_indr_notify(&cleanup_list);

[Severity: High]
This isn't a bug introduced by this patch, but does the indirect cleanup
path still leave the very corruption window the patch aims to close?

flow_block_cb_unlock() runs before flow_block_indr_notify(), and
flow_block_indr_notify() calls this->indr.cleanup(this), i.e.
tc_block_indr_cleanup() in net/sched/cls_api.c:

	rtnl_lock();
	down_write(&block->cb_lock);
	list_move(&block_cb->list, &bo.cb_list);
	tcf_block_unbind(block, &bo);

so that deletion from block->flow_block.cb_list happens with only RTNL +
cb_lock held.

Meanwhile the register side splices into the same list head with a
disjoint lock set:

net/core/flow_offload.c:existing_qdiscs_register() {
	...
	cb(cur->dev, cur->sch, cb_priv, cur->type, &bo, cur->data, cur->cleanup);
	list_splice(&bo.cb_list, cur->cb_list);
	...
}

That runs from flow_indr_dev_register() holding flow_block_cb_mutex +
flow_indr_block_lock, but neither RTNL nor block->cb_lock (cb_list here
is bo->cb_list_head, i.e. &block->flow_block.cb_list, recorded by
indir_dev_add()).

Can two indirect-offload drivers (or repeated load/unload of one) then
run splice and list_del concurrently on one live tcf_block cb_list, and
produce the same "list_del corruption ... next->prev should be" splat?
Note tc_block_indr_cleanup() itself takes RTNL, so it cannot simply be
pulled under the new mutex.

> @@ -603,18 +632,31 @@ static int indir_dev_remove(void *data)
>  int flow_indr_dev_setup_offload(struct net_device *dev,	struct Qdisc *sch,
>  				enum tc_setup_type type, void *data,
>  				struct flow_block_offload *bo,
> -				void (*cleanup)(struct flow_block_cb *block_cb))
> +				void (*cleanup)(struct flow_block_cb *block_cb),
> +				bool *indr_dev_added)
>  {
>  	struct flow_indr_dev *this;
>  	u32 count = 0;
>  	int err;
>  
> +	lockdep_assert_held(&flow_block_cb_mutex);
> +
> +	if (indr_dev_added)
> +		*indr_dev_added = false;
> +
>  	mutex_lock(&flow_indr_block_lock);
>  	if (bo) {
> -		if (bo->command == FLOW_BLOCK_BIND)
> -			indir_dev_add(data, dev, sch, type, cleanup, bo);
> -		else if (bo->command == FLOW_BLOCK_UNBIND)
> +		if (bo->command == FLOW_BLOCK_BIND) {
> +			err = indir_dev_add(data, dev, sch, type, cleanup, bo);
> +			if (!err) {
> +				if (indr_dev_added)
> +					*indr_dev_added = true;
> +			} else if (err != -EEXIST) {
> +				goto out_unlock;
> +			}
> +		} else if (bo->command == FLOW_BLOCK_UNBIND) {
>  			indir_dev_remove(data);
> +		}
>  	}

[Severity: Medium]
Does this turn a previously silent degradation into a user-visible
failure?

Before this change the return value of indir_dev_add() was discarded, so
a failed bookkeeping allocation did not affect the outcome.  Now an
-ENOMEM from indir_dev_add() aborts the whole setup before any indirect
driver callback runs, and cls_api propagates it:

net/sched/cls_api.c:tcf_block_offload_cmd() {
	...
	if (err < 0)
		return err;
	cb_count = list_count_nodes(&bo.cb_list);
	err = tcf_block_setup(block, &bo);
	if (err)
		return err;
	...
}

net/sched/cls_api.c:tcf_block_offload_bind() {
	...
	if (err == -EOPNOTSUPP)
		goto no_offload_dev_inc;
	if (err)
		goto err_unlock;
	...
}

Only -EOPNOTSUPP still reaches the software fallback, so "tc qdisc add"
on an indirect device, nft base-chain offload and flowtable offload can
now fail to user space where they previously succeeded with
block->nooffloaddevcnt++.  The same applies to a non-EOPNOTSUPP error
from tp->ops->reoffload during filter replay, which tcf_block_setup() now
forwards.

The commit message only says "keep indirect-device registration
transactional on setup failure".  Could it state this new failure mode
explicitly, given the Cc: stable tag?

>  
>  	list_for_each_entry(this, &flow_block_indr_dev_list, list) {
> @@ -623,14 +665,35 @@ int flow_indr_dev_setup_offload(struct net_device *dev,	struct Qdisc *sch,
>  			count++;
>  	}
>  
> +	err = (bo && list_empty(&bo->cb_list)) ? -EOPNOTSUPP : count;
> +
> +out_unlock:
>  	mutex_unlock(&flow_indr_block_lock);
>  
> -	return (bo && list_empty(&bo->cb_list)) ? -EOPNOTSUPP : count;
> +	return err;
>  }
>  EXPORT_SYMBOL(flow_indr_dev_setup_offload);
>  
> +void flow_indr_dev_setup_abort(void *data)
> +{
> +	lockdep_assert_held(&flow_block_cb_mutex);
> +
> +	mutex_lock(&flow_indr_block_lock);
> +	WARN_ON_ONCE(indir_dev_remove(data));
> +	mutex_unlock(&flow_indr_block_lock);
> +}
> +EXPORT_SYMBOL(flow_indr_dev_setup_abort);

[Severity: Low]
Would it be better for the core to undo its own bookkeeping rather than
export partial state plus an abort call?

indir_dev_add()/indir_dev_remove() are internal to
net/core/flow_offload.c, yet callers now receive bool *indr_dev_added and
must remember to call flow_indr_dev_setup_abort() on every later failure.
The same snippet is duplicated in nf_tables_offload.c (twice),
nf_flow_table_offload.c and cls_api.c (twice), with three different
failure semantics for one core operation: nft and flowtable only unwind
the indr_dev bookkeeping, cls_api additionally unwinds installed
callbacks.

Some of the new arms are also dead, since nft_flow_offload_bind() only
does list_splice() and returns 0, and nf_flow_table_block_setup() cannot
fail for BIND.

If a future caller forgets the abort, does the stale struct
flow_indir_dev_info left on flow_indir_dev_list later drive a bogus
replay through existing_qdiscs_register()?

> +
>  bool flow_indr_dev_exists(void)
>  {
> -	return !list_empty(&flow_block_indr_dev_list);
> +	bool exists;
> +
> +	flow_block_cb_lock();
> +	mutex_lock(&flow_indr_block_lock);
> +	exists = !list_empty(&flow_block_indr_dev_list);
> +	mutex_unlock(&flow_indr_block_lock);
> +	flow_block_cb_unlock();
> +
> +	return exists;
>  }
>  EXPORT_SYMBOL(flow_indr_dev_exists);

[Severity: Medium]
Is the global mutex needed for this predicate?  flow_indr_dev_exists() is
a cheap existence test used by nft_chain_offload_support() in
net/netfilter/nf_tables_offload.c, and taking flow_block_cb_mutex here
imposes the new outermost-lock ordering constraint on all of its callers.

> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 801a3dd9ceea..2612978b27b4 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c

[ ... ]

> @@ -1273,21 +1269,29 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
>  {
>  	struct netlink_ext_ack extack = {};
>  	struct flow_block_offload bo;
> +	bool indr_dev_added = false;
>  	int err;
>  
>  	if (!nf_flowtable_hw_offload(flowtable))
>  		return nf_flow_offload_xdp_setup(flowtable, dev, cmd);
>  
> +	flow_block_cb_lock();
> +	down_write(&flowtable->flow_block_lock);
>  	if (dev->netdev_ops->ndo_setup_tc)
>  		err = nf_flow_table_offload_cmd(&bo, flowtable, dev, cmd,
>  						&extack);
>  	else
>  		err = nf_flow_table_indr_offload_cmd(&bo, flowtable, dev, cmd,
> -						     &extack);
> -	if (err < 0)
> -		return err;
> +						     &extack,
> +						     &indr_dev_added);
> +	if (err >= 0)
> +		err = nf_flow_table_block_setup(flowtable, &bo, cmd);
> +	if (err < 0 && indr_dev_added)
> +		flow_indr_dev_setup_abort(flowtable);
> +	up_write(&flowtable->flow_block_lock);
> +	flow_block_cb_unlock();
>  
> -	return nf_flow_table_block_setup(flowtable, &bo, cmd);
> +	return err;
>  }
>  EXPORT_SYMBOL_GPL(nf_flow_table_offload_setup);
>  
> diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
> index 8998a24651ff..7189e8c4e5a0 100644
> --- a/net/netfilter/nf_tables_offload.c
> +++ b/net/netfilter/nf_tables_offload.c

[ ... ]

> @@ -426,19 +425,28 @@ static int nft_indr_block_offload_cmd(struct nft_base_chain *basechain,
>  {
>  	struct netlink_ext_ack extack = {};
>  	struct flow_block_offload bo;
> +	bool indr_dev_added = false;
>  	int err;
>  
>  	nft_flow_block_offload_init(&bo, dev_net(dev), cmd, basechain, &extack);
>  
>  	err = flow_indr_dev_setup_offload(dev, NULL, TC_SETUP_BLOCK, basechain, &bo,
> -					  nft_indr_block_cleanup);
> -	if (err < 0)
> +					  nft_indr_block_cleanup,
> +					  &indr_dev_added);
> +	if (err < 0) {
> +		if (indr_dev_added)
> +			flow_indr_dev_setup_abort(basechain);
>  		return err;
> +	}
>  
>  	if (list_empty(&bo.cb_list))
>  		return -EOPNOTSUPP;

[Severity: Low]
Should this exit also call flow_indr_dev_setup_abort()?  It is the only
error return of the restructured function that skips the new cleanup.

The branch is dead today, since flow_indr_dev_setup_offload() already
folds the empty-cb_list case into -EOPNOTSUPP:

net/core/flow_offload.c:flow_indr_dev_setup_offload() {
	...
	err = (bo && list_empty(&bo->cb_list)) ? -EOPNOTSUPP : count;
	...
}

with bo non-NULL here, and its only other negative return is -ENOMEM via
goto out_unlock.  Should it become reachable, would this exit leave the
flow_indir_dev_info created by indir_dev_add() on flow_indir_dev_list with
data pointing at a base chain the failing nft transaction is about to
destroy?

>  
> -	return nft_block_setup(basechain, &bo, cmd);
> +	err = nft_block_setup(basechain, &bo, cmd);
> +	if (err < 0 && indr_dev_added)
> +		flow_indr_dev_setup_abort(basechain);
> +
> +	return err;
>  }

[ ... ]

> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index fee4524adc98..1c230e33e1a5 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c

[ ... ]

> @@ -845,21 +847,66 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
>  		return tcf_block_setup(block, &bo);
>  	}
>  
> -	flow_indr_dev_setup_offload(dev, sch, TC_SETUP_BLOCK, block, &bo,
> -				    tc_block_indr_cleanup);
> -	tcf_block_setup(block, &bo);
> +	err = flow_indr_dev_setup_offload(dev, sch, TC_SETUP_BLOCK, block, &bo,
> +					  tc_block_indr_cleanup,
> +					  indr_dev_added);
> +	if (err < 0)
> +		return err;
> +	cb_count = list_count_nodes(&bo.cb_list);
> +	err = tcf_block_setup(block, &bo);
> +	if (err)
> +		return err;
> +	if (indr_cb_count)
> +		*indr_cb_count = cb_count;
> +	if (indr_unlocked_driver_cb)
> +		*indr_unlocked_driver_cb = bo.unlocked_driver_cb;
>  
>  	return -EOPNOTSUPP;
>  }
>  
> +static void
> +tcf_block_indr_bind_rollback(struct tcf_block *block, struct net_device *dev,
> +			     struct Qdisc *sch, struct tcf_block_ext_info *ei,
> +			     unsigned int cb_count, bool unlocked_driver_cb,
> +			     bool remove_indr_dev)
> +{
> +	struct flow_block_offload bo = {};
> +	struct flow_block_cb *block_cb;
> +
> +	tcf_block_offload_init(&bo, dev, sch, FLOW_BLOCK_UNBIND,
> +			       ei->binder_type, &block->flow_block,
> +			       tcf_block_shared(block), NULL);
> +	bo.unlocked_driver_cb = unlocked_driver_cb;
> +
> +	if (remove_indr_dev)
> +		flow_indr_dev_setup_abort(block);
> +
> +	/* tcf_block_bind() splices this bind's callbacks at the list head. */
> +	while (cb_count--) {
> +		if (WARN_ON_ONCE(list_empty(&block->flow_block.cb_list)))
> +			break;
> +
> +		block_cb = list_first_entry(&block->flow_block.cb_list,
> +					    struct flow_block_cb, list);
> +		list_del_init(&block_cb->driver_list);
> +		list_del_init(&block_cb->indr.list);
> +		list_move(&block_cb->list, &bo.cb_list);
> +	}
> +	tcf_block_unbind(block, &bo);
> +}

[Severity: Low]
Is identifying "this bind's callbacks" by popping cb_count entries off the
head of block->flow_block.cb_list robust enough?

The count is taken from bo.cb_list before tcf_block_setup(), and the
recovery relies on tcf_block_bind() using list_splice() (head insertion)
and on nothing else inserting in between.  The
WARN_ON_ONCE(list_empty(...)) inside the pop loop suggests the invariant
isn't structurally guaranteed.

If the splice direction in tcf_block_bind() ever changes, or another
writer inserts into that list, would this unbind and free callbacks owned
by a different binder?

Separately, tcf_block_offload_cmd() still returns -EOPNOTSUPP as the
success sentinel for the indirect path while carrying three new
out-parameters, so a caller passing NULL loses the rollback ability
silently.  Could the bind's callbacks be tracked explicitly instead, for
example on a local list?

[Severity: Low]
Which lock protects block_cb->indr.list here?  This helper does
list_del_init(&block_cb->indr.list) on the file-global
flow_block_indr_list while holding only block->cb_lock and the new
flow_block_cb_mutex.

Every mutator of that list in net/core/flow_offload.c takes
flow_indr_block_lock, e.g.

net/core/flow_offload.c:__flow_block_indr_cleanup() {
	...
		list_del_init(&this->driver_list);
		list_move(&this->indr.list, cleanup_list);
	...
}

and flow_indr_dev_setup_abort() itself takes flow_indr_block_lock for the
equivalent bookkeeping.  Today the lock sets do intersect on
flow_block_cb_mutex, so there is no race, but the rule becomes implicit.
Could a comment plus lockdep asserts (including on the exported
flow_indr_block_cb_alloc(), which has none) be added?

> +
>  static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
>  				  struct tcf_block_ext_info *ei,
>  				  struct netlink_ext_ack *extack)
>  {
>  	struct net_device *dev = q->dev_queue->dev;
> +	bool indr_unlocked_driver_cb = false;
> +	bool indr_dev_added = false;
> +	unsigned int indr_cb_count = 0;
>  	int err;
>  
>  	down_write(&block->cb_lock);
> +	flow_block_cb_lock();
>  
>  	/* If tc offload feature is disabled and the block we try to bind
>  	 * to already has some offloaded filters, forbid to bind.

[ ... ]

> @@ -888,6 +936,15 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
>  	err = 0;
>  	block->nooffloaddevcnt++;
>  err_unlock:
> +	if (err && indr_cb_count)
> +		tcf_block_indr_bind_rollback(block, dev, q, ei,
> +					     indr_cb_count,
> +					     indr_unlocked_driver_cb,
> +					     indr_dev_added);
> +	else if (err && indr_dev_added)
> +		flow_indr_dev_setup_abort(block);
> +out_unlock:
> +	flow_block_cb_unlock();
>  	up_write(&block->cb_lock);
>  	return err;
>  }

[ ... ]

> @@ -1649,7 +1710,8 @@ static int tcf_block_bind(struct tcf_block *block,
>  
>  err_unroll:
>  	list_for_each_entry_safe(block_cb, next, &bo->cb_list, list) {
> -		list_del(&block_cb->driver_list);
> +		list_del_init(&block_cb->driver_list);
> +		list_del_init(&block_cb->indr.list);

[Severity: Low]
Same question as above for this site: the err_unroll path now mutates the
global flow_block_indr_list without flow_indr_block_lock, and
tcf_block_bind()/tcf_block_unbind() only assert block->cb_lock.

>  		if (i-- > 0) {
>  			list_del(&block_cb->list);
>  			tcf_block_playback_offloads(block, block_cb->cb,
