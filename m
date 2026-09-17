Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B5D4446F5;
	Thu, 17 Sep 2026 07:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789630075; cv=none; b=d34zy7jVNz3p0A+THh/Xw8iK2FOq6cfOUCppBghTsaQYejECGZhFjzNarePUT9MHDEtt+2uYyMw2t3l5Ayc5SFJBPBWNc3TygCWmdQVXFaBtZMygAyeg0rOxCde0TcGNIUc6wDOgzVm30Mm/S21QvRBZ8OuvdKBG3gP5XzHFPyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789630075; c=relaxed/simple;
	bh=+kmAWEDpZ+DQcoked+ubtlBLMqbXPTX1uiakG8sx/v8=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aGEFTbu1mEyktmcKLcbkgqdQ4d7t4b0thXlR+4iorB9gyM/9Hde+jofSmm4qAYta3uArIomqCCS77dUgzkIFO7oXpzY4snqgh5lO2xTfYCiMWNnhBLLvoC61tXaHQMTvvFA2qlSCzi0apojglq0DUqAwmaALAHTKV/P7l5DlLdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kSW9v30A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kSW9v30A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340F91F000FF;
	Thu, 17 Sep 2026 07:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789630074;
	bh=QH2HYp3RnzjQwnN4aXpIjNR1GnmarzzCfjmzCQbJAsQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=kSW9v30AwM+vkCJgXGlN6CskVUeH+HCRzD888qt0p9N9kH9uDweU1v1SkPnINSbps
	 6faYqijB/P8n+pTENNPL2zrEcnIbDoQ5y5fR1FzHJV0usTFPE579i+NUDV4y09zbhV
	 sFDLwmWvOvTrsdDq8pqVa66x03uc5ybWvBklDzvOgeRiF5L97v3vtMNSLYmJYZj2wz
	 KzuRB9575rrM4FjxCN+dED8VRAT7foVZwtMSeRFq/sGaQK+4BbTxFblQ5NLik3fczd
	 /9FbJK5QRsQ2Ji7Vu7ew9sCh7VSw4wCI29qssTDA8Of/lBgIWTINW6EvI6G4mDlm6S
	 Tc3AqYXFk47BQ==
Subject: Re: [PATCH nf-next v5 2/3] netfilter: flowtable: teardown direct xmit
 flows when the fdb entry moves
From: netdev-bot+sashiko@kernel.org
To: julius@bairaktaris.de
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
 kadlec@netfilter.org, phil@nwl.cc, horms@kernel.org, davem@davemloft.net,
 razor@blackwall.org, ericwouds@gmail.com, dqfext@gmail.com,
 netdev@vger.kernel.org, coreteam@netfilter.org,
 linux-kselftest@vger.kernel.org, kuba@kernel.org
Date: Thu, 17 Sep 2026 07:27:52 +0000
Message-ID: <178963007270.22033.13091123590004831521@kernel.org>
In-Reply-To: <20260914072541.897040-3-julius@bairaktaris.de>
References: <20260914072541.897040-3-julius@bairaktaris.de>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 6 potential
issue(s) to consider:

Critical: 0 · High: 2 · Medium: 3 · Low: 1

- [High] The new fdb-move teardown is wired exclusively to the switchdev
  atomic notifier chain, but the sole emitter of…
- [High] nf_flow_table_switchdev_event() unconditionally does one
  kzalloc_obj(GFP_ATOMIC) + netdev_hold() + queue_work() for *every*…
- [Medium] The teardown assumes SWITCHDEV_FDB_DEL_TO_DEVICE always
  precedes an fdb move, but br_switchdev_fdb_notify()…
- [Medium] The invalidator listens only for SWITCHDEV_FDB_DEL_TO_DEVICE,
  but two bridge fdb paths move an existing entry to a different port…
- [Medium] The teardown of matching direct-xmit flows is deferred to a
  workqueue, but the bridge emits SWITCHDEV_FDB_DEL_TO_DEVICE *before*…
- [Low] The commit fixes a user-visible forwarding failure (a direct-xmit
  flow keeps sending to the stale bridge port after a host roams, and is…

--

netfilter: flowtable: teardown direct xmit flows when the fdb entry moves

The patch stores the bridge port ifindex in the direct xmit flow tuple and
registers a switchdev notifier that queues a work item on
SWITCHDEV_FDB_DEL_TO_DEVICE. The work item walks all flowtables in the
namespace and tears down flows whose bridge port, vid and destination
address match the deleted fdb entry.

[Severity: Low]
There is no Fixes: tag and no statement about the intended tree.

The commit message describes a user-visible forwarding failure with no
workaround, since the peer's retransmissions keep refreshing the stale
flow. The stale bridge path came in with FLOW_OFFLOAD_XMIT_DIRECT in
commit 7a27f6ab4135 ("netfilter: flowtable: use dev_fill_forward_path() to
obtain egress device"), whose message already mentioned that moving a peer
to another bridge port leaves the connection on the old path until timeout,
and suggested snooping fdb updates.

Would a 'Fixes: 7a27f6ab4135 ("netfilter: flowtable: use
dev_fill_forward_path() to obtain egress device")' tag be appropriate here,
or is this intended as nf-next material because it adds new infrastructure
(a dedicated workqueue plus a global switchdev notifier)? As submitted it
is hard to tell which tree is targeted.

> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index b308fb627640..e6e55a1cadaf 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c

[ ... ]

> @@ -761,6 +765,94 @@ void nf_flow_table_cleanup(struct net_device *dev)
>  }
>  EXPORT_SYMBOL_GPL(nf_flow_table_cleanup);
>  
> +static struct workqueue_struct *nf_flow_fdb_del_wq;
> +
> +struct nf_flow_fdb_del_work {
> +	struct work_struct	work;
> +	struct net_device	*dev;
> +	netdevice_tracker	dev_tracker;
> +	u16			vid;
> +	u8			addr[ETH_ALEN];
> +	bool			found;
> +};
> +
> +static bool nf_flow_tuple_fdb_match(const struct flow_offload_tuple *tuple,
> +				    const struct nf_flow_fdb_del_work *fw)
> +{
> +	return tuple->xmit_type == FLOW_OFFLOAD_XMIT_DIRECT &&
> +	       tuple->out.bridge_ifidx == fw->dev->ifindex &&
> +	       tuple->out.bridge_vid == fw->vid &&
> +	       ether_addr_equal(tuple->out.h_dest, fw->addr);
> +}
> +
> +static void nf_flow_table_do_fdb_del(struct nf_flowtable *flow_table,
> +				     struct flow_offload *flow, void *data)
> +{
> +	struct nf_flow_fdb_del_work *fw = data;
> +
> +	if (nf_flow_tuple_fdb_match(&flow->tuplehash[0].tuple, fw) ||
> +	    nf_flow_tuple_fdb_match(&flow->tuplehash[1].tuple, fw)) {
> +		flow_offload_teardown(flow);
> +		fw->found = true;
> +	}
> +}
> +
> +static void nf_flow_table_fdb_del_work(struct work_struct *work)
> +{
> +	struct nf_flow_fdb_del_work *fw;
> +	struct nf_flowtable *flowtable;
> +
> +	fw = container_of(work, struct nf_flow_fdb_del_work, work);
> +
> +	mutex_lock(&flowtable_lock);
> +	list_for_each_entry(flowtable, &flowtables, list) {
> +		if (!net_eq(read_pnet(&flowtable->net), dev_net(fw->dev)))
> +			continue;
> +
> +		fw->found = false;
> +		nf_flow_table_iterate(flowtable, nf_flow_table_do_fdb_del, fw);
> +		if (fw->found)
> +			mod_delayed_work(system_power_efficient_wq,
> +					 &flowtable->gc_work, 0);
> +	}
> +	mutex_unlock(&flowtable_lock);
> +
> +	netdev_put(fw->dev, &fw->dev_tracker);
> +	kfree(fw);
> +}

[Severity: High]
How much work can a bridged segment generate through this path? Every
fdb deletion produces one work item, and each work item takes the global
flowtable_lock in nf_flow_table_fdb_del_work() across a full
nf_flow_table_iterate() walk of every flowtable in the namespace, plus an
immediate extra gc walk via mod_delayed_work(..., 0) on a match.

Bridge fdb deletions are data-plane driven. Aging notifies for every
learned entry:

net/bridge/br_fdb.c:br_fdb_cleanup() {
	...
		if (!hlist_unhashed(&f->fdb_node))
			fdb_delete(br, f, true);
	...
}

and a source-MAC port move notifies too:

net/bridge/br_fdb.c:br_fdb_update() {
	...
			br_switchdev_fdb_notify(br, fdb, RTM_DELNEIGH);
			WRITE_ONCE(fdb->dst, source);
	...
}

Both reach nf_flow_table_switchdev_event() through fdb_notify() ->
br_switchdev_fdb_notify() -> call_switchdev_notifiers().

So a MAC flood or MAC flap from a host on the bridged segment turns cheap
frames into (fdb deletions) x (flow entries) of walking under one global
mutex. Since flowtable_lock is a single static mutex shared by all
namespaces, does this also stall flowtable creation and teardown in other
netns? Each pending item also pins a netdev reference until the walk
finishes, which delays unregistration.

Would it help to filter before allocating, the way
dsa_user_switchdev_event() only handles devices it owns, and to coalesce
or bound the number of in-flight items?

> +
> +/* The bridge notifies the old port before it moves an fdb entry. Flows
> + * sending directly to that port are torn down. Skipping the teardown on
> + * allocation failure leaves the flow to age out, the same as a missed fdb
> + * update does for a switchdev driver.
> + */
> +static int nf_flow_table_switchdev_event(struct notifier_block *nb,
> +					 unsigned long event, void *ptr)
> +{
> +	struct switchdev_notifier_fdb_info *fdb_info = ptr;
> +	struct nf_flow_fdb_del_work *fw;
> +
> +	if (event != SWITCHDEV_FDB_DEL_TO_DEVICE || fdb_info->is_local)
> +		return NOTIFY_DONE;

[Severity: Medium]
Is SWITCHDEV_FDB_DEL_TO_DEVICE always emitted when an fdb entry moves?
br_switchdev_fdb_notify() drops it for two entry classes:

net/bridge/br_switchdev.c:br_switchdev_fdb_notify() {
	...
	if (test_bit(BR_FDB_LOCKED, &fdb->flags))
		return;
	...
	if (test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags) &&
	    !test_bit(BR_FDB_STATIC, &fdb->flags) &&
	    !test_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags))
		return;
	...
}

br_fdb_update() still calls br_switchdev_fdb_notify(br, fdb, RTM_DELNEIGH)
and then commits WRITE_ONCE(fdb->dst, source) for those entries, so the
move happens but the request is swallowed inside the callee. That covers
locked-port entries and entries added with "bridge fdb add ... master
dynamic".

Flow creation does not exclude those entries either:

net/bridge/br_device.c:br_fill_forward_path() {
	...
	f = br_fdb_find_rcu(br, ctx->daddr, path->bridge.vlan_id);
	if (!f)
		return -1;

	dst = READ_ONCE(f->dst);
	...
}

so a direct xmit flow can be created against a locked or user-added
dynamic entry and then never torn down. Is a fallback trigger needed for
those cases?

[Severity: Medium]
Are the add-only fdb move paths covered? fdb_add_entry() changes the port
of an existing entry and reports it as a new entry:

net/bridge/br_fdb.c:fdb_add_entry() {
	...
		if (READ_ONCE(fdb->dst) != source) {
			WRITE_ONCE(fdb->dst, source);
			modified = true;
		}
	...
	fdb_notify(br, fdb, RTM_NEWNEIGH, true);
}

br_fdb_external_learn_add() does the same when an externally learned entry
changes port, overwriting fdb->dst and then calling fdb_notify(br, fdb,
RTM_NEWNEIGH, swdev_notify).

For a static entry that arrives as SWITCHDEV_FDB_ADD_TO_DEVICE, which the
filter above ignores, so a flow created while the entry pointed at the old
port keeps its stale bridge_ifidx and h_dest. Should the handler also act
on the add notification when the port changed, for example via "bridge fdb
replace ... master static" or a switchdev/VXLAN driver relearning the
entry?

> +
> +	fw = kzalloc_obj(*fw, GFP_ATOMIC);
> +	if (!fw)
> +		return NOTIFY_DONE;
> +
> +	INIT_WORK(&fw->work, nf_flow_table_fdb_del_work);
> +	fw->dev = fdb_info->info.dev;
> +	netdev_hold(fw->dev, &fw->dev_tracker, GFP_ATOMIC);
> +	fw->vid = fdb_info->vid;
> +	ether_addr_copy(fw->addr, fdb_info->addr);
> +	queue_work(nf_flow_fdb_del_wq, &fw->work);
> +
> +	return NOTIFY_DONE;
> +}

[Severity: Medium]
Can a flow created concurrently with the move escape the teardown walk?
The notification is sent before the new port is committed:

net/bridge/br_fdb.c:br_fdb_update() {
	...
			br_switchdev_fdb_notify(br, fdb, RTM_DELNEIGH);
			WRITE_ONCE(fdb->dst, source);
	...
}

so this is an "about to move" hint. Meanwhile a flow being set up on
another CPU resolves the port from the old dst:

net/netfilter/nf_flow_table_path.c:nft_dev_path_info() {
	...
		info->bridge_ifidx = stack->path[i + 1].dev->ifindex;
	...
}

and publishes the flow in flow_offload_add() with rhashtable_insert_fast(),
which does not take flowtable_lock. If the work item's walk completes
between the notification and that insertion, the stale flow is never seen.

br_fdb_update() only notifies when source != fdb->dst, so no further
SWITCHDEV_FDB_DEL_TO_DEVICE is generated for that host, and a later aging
DEL carries the new port, which cannot match tuple->out.bridge_ifidx.
Does the flow then persist for as long as return traffic refreshes it?

The reverse interleaving looks possible too: the work item carries no
event generation, so a delayed DEL can tear down a flow that was just
created against the new port after the address was relearned there.

> +
> +static struct notifier_block nf_flow_table_switchdev_nb = {
> +	.notifier_call = nf_flow_table_switchdev_event,
> +};
> +
>  void nf_flow_table_free(struct nf_flowtable *flow_table)
>  {
>  	mutex_lock(&flowtable_lock);
> @@ -838,6 +930,16 @@ static int __init nf_flow_table_module_init(void)
>  	if (ret)
>  		goto out_offload;
>  
> +	nf_flow_fdb_del_wq = alloc_workqueue("nf_flow_fdb_del", WQ_UNBOUND, 0);
> +	if (!nf_flow_fdb_del_wq) {
> +		ret = -ENOMEM;
> +		goto out_wq;
> +	}
> +
> +	ret = register_switchdev_notifier(&nf_flow_table_switchdev_nb);
> +	if (ret)
> +		goto out_switchdev;
> +

[Severity: High]
What happens in a CONFIG_NET_SWITCHDEV=n build? The only emitter of the
bridge fdb notification is compiled out there:

net/bridge/Makefile:
	bridge-$(CONFIG_NET_SWITCHDEV) += br_switchdev.o

and net/bridge/br_private.h supplies an empty stub instead:

static inline void
br_switchdev_fdb_notify(struct net_bridge *br,
			const struct net_bridge_fdb_entry *fdb, int type)
{
}

On this side register_switchdev_notifier() is also a stub returning 0 when
CONFIG_NET_SWITCHDEV=n, so nf_flow_table_module_init() sees success,
creates the "nf_flow_fdb_del" unbound workqueue and installs a notifier
block that can never be called.

The roaming station scenario in the commit message needs no switchdev
hardware, so a plain software bridge router with CONFIG_BRIDGE=y,
CONFIG_NF_FLOW_TABLE=m and CONFIG_NET_SWITCHDEV=n still keeps sending to
the old port. config NF_FLOW_TABLE in net/netfilter/Kconfig depends only on
NETFILTER_INGRESS, NF_CONNTRACK and NF_TABLES, so nothing expresses the new
dependency. Should this get a depends on NET_SWITCHDEV, an IS_ENABLED()
guard around the workqueue and notifier, or a bridge level notification
instead?

>  	ret = nf_flow_register_bpf();
>  	if (ret)
>  		goto out_bpf;

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260914072541.897040-1-julius%40bairaktaris.de
