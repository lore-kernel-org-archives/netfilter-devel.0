Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC5535C6B3;
	Sat, 22 Aug 2026 19:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787428352; cv=none; b=WJKesHDPNSw9dTOcUhPY2uHvTFu8y4BzE+WOpSW1HIxA5bxMuAmQv4ZU2KSofr87xl95Dat+qt22YMRy73jJHpz5jSTTgP9dNYW1S6jI83CrrBCDNuoVX3gPAJ+5FriMtpvX9FuWlqKmiR+krCEd1IXsavvzUkBYXhtbsTWIxhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787428352; c=relaxed/simple;
	bh=DDSQG0YTmPN70vhZ5heV8FldIgtoTMseXM/RPgNLpzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBTh7KvAt/v2TW6pLBxfn80M2IecIr5XWDs2W5AuYF/WUjD+ZGBJhNQM1DfrKTTxc+6flJ58IgSvXzZDDzjjTR2w/0OXheBJ5axVRXnq3hJJAUcA0P9kcwmQ55s1V/KDba66hsK7CWa5AkTyyMTGYNYGOFHXpHkT0rT15IUfHGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kewWpmXr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kewWpmXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95ABA1F000E9;
	Sat, 22 Aug 2026 19:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787428350;
	bh=6iEer5yYBqesO3j/DLpaZgcrBEZ9aOZfrMNyVlTbvp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kewWpmXrzBOO0rGRmYwRWq4Cq5vrxjGhUV7VNcilbr8VXL8vcoHWaDD3FNwz6/xSN
	 h7tYieYZDdR8ansxgCOAKzNT5B5afXwgU0BOPT3Jg5KN4JwzPC0htaoy7B67/XTIot
	 gvhc7GnTYkbY2fv1ECgUWICkbnye3OCLgKY4BpPNnDaSu019/LmcSLlYFs/iOazsFw
	 qGvH8KioFyjjlypcemvGNpbnLdczDI2FjFzOY++anoxgj6mz5KK75Q2dcCQrFy7nML
	 /SW97Wll+C8yHqX2rrR69Uz+U7dxVK2/Am31y5h2xTSg8CFYzTkUfpdw0Gxs21Fv7L
	 fxkHWlT4qu+Fg==
From: Jakub Kicinski <kuba@kernel.org>
To: pablo@netfilter.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: Re: [PATCH net 08/10] netfilter: nf_tables: fix device name and prefix match in hook lookup
Date: Sat, 22 Aug 2026 12:52:30 -0700
Message-ID: <20260822195230.2202763-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260821153833.245589-9-pablo@netfilter.org>
References: <20260821153833.245589-9-pablo@netfilter.org>
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
netfilter: nf_tables: fix device name and prefix match in hook lookup

This changes nft_hook_list_find() so a hook spec only matches another
spec of the same kind (prefix vs exact name) and the same length,
replacing the previous strncmp() over min(hook->ifnamelen,
this->ifnamelen).  hook_is_prefix() also gains a const argument.

Closes: https://lore.kernel.org/netfilter-devel/CANE+tVrDeNCHQVmsqkV2ozeBqyE3GtRDMhZgsg1bhw10yGNTRQ@mail.gmail.com/

> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 20c562174b278..d160f6ea0dc29 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c

[ ... ]

> @@ -2445,8 +2445,11 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
>  	struct nft_hook *hook;
>  
>  	list_for_each_entry(hook, hook_list, list) {
> -		if (!strncmp(hook->ifname, this->ifname,
> -			     min(hook->ifnamelen, this->ifnamelen))) {
> +		if (hook_is_prefix(hook) != hook_is_prefix(this))
> +			continue;
> +		if (hook->ifnamelen != this->ifnamelen)
> +			continue;
> +		if (!strncmp(hook->ifname, this->ifname, hook->ifnamelen)) {
>  			if (hook->flags & NFT_HOOK_REMOVE)
>  				continue;
>  

[Severity: Critical]
nft_hook_list_find() has two callers with different expectations, and this
turns it into a pure identity comparator for both.  The delete/get paths
(nf_tables_delchain_hook(), nft_flowtable_del_hook()) want identity, but
the add paths use it as an overlap rejector:

nf_tables_parse_netdev_hooks()
	if (nft_hook_list_find(hook_list, hook)) {
		NL_SET_BAD_ATTR(extack, tmp);
		nft_netdev_hook_free(hook);
		err = -EEXIST;
		goto err_hook;
	}

and the same in nf_tables_updchain(), nft_register_flowtable_net_hooks()
and nft_flowtable_update().

The Fixes-referenced commit 6d07a289504a states the min() compare was
deliberate: "When checking for duplicate hooks, compare the shortest
prefix so a device may never match more than a single hook spec."  Does
this change intentionally drop that invariant?

Concretely, is this still rejected after the patch?

  nft add chain netdev t c \
    '{ type filter hook ingress devices = { "eth*", "eth0" } ; }'

Before, prefix "eth" (ifnamelen 3) and exact "eth0" (ifnamelen 5) matched
via strncmp(..., min(3, 5)) and gave -EEXIST.  Now
hook_is_prefix(hook) != hook_is_prefix(this) short-circuits, so both hooks
end up in the same hook_list.  Prefix "eth" versus prefix "eth0" is
likewise separated by the ifnamelen compare.

nft_netdev_hook_alloc() then builds one nf_hook_ops per matching netdev
per hook:

	for_each_netdev(net, dev) {
		if (strncmp(dev->name, hook->ifname, hook->ifnamelen))
			continue;
		...
		ops->dev = dev;
		list_add_tail(&ops->list, &hook->ops_list);
	}

so two distinct nft_hook objects each own an ops with ops->dev == eth0,
and nft_netdev_register_hooks() registers both.  nf_hook_entries_grow()
only rejects duplicates for NF_HOOK_OP_BPF, so both land in
eth0->nf_hooks_ingress and the base chain is evaluated twice per packet.
For flowtables the cross-flowtable -EEXIST guard in
nft_register_flowtable_net_hooks() is bypassed the same way, so the same
device gets two FLOW_BLOCK_BIND calls.

Can this also leave a dangling struct net_device pointer?  Both notifier
loops service only the first hook that owns an ops for the device, because
of the unconditional break after the switch:

net/netfilter/nft_chain_filter.c:nft_netdev_event() {
	list_for_each_entry(hook, &basechain->hook_list, list) {
		ops = nft_hook_find_ops(hook, dev);
		...
		switch (event) {
		case NETDEV_UNREGISTER:
			...
			nf_unregister_net_hook(dev_net(dev), ops);
			list_del_rcu(&ops->list);
			kfree_rcu(ops, rcu);
			break;
		...
		}
		break;
	}
	return 0;
}

nft_flowtable_event() in nf_tables_api.c has the same trailing break.  On
ip link del eth0 only the first hook's ops is unregistered and freed; the
second hook keeps a registered nf_hook_ops whose ops->dev points at the
device that is then freed, since nf_hook_ops holds no device reference.

A later teardown (nft delete chain, nft delete table, dormant toggle,
netns exit) walks every ops:

net/netfilter/nf_tables_api.c:nft_netdev_unregister_hooks() {
	list_for_each_entry_safe(hook, next, hook_list, list) {
		if (!(table->flags & NFT_TABLE_F_DORMANT)) {
			list_for_each_entry(ops, &hook->ops_list, list)
				nf_unregister_net_hook(net, ops);
		}
	...
}

and __nf_unregister_net_hook() reaches nf_hook_entry_head(net, pf,
reg->hooknum, reg->dev), which does dev_net(dev) and returns
&dev->nf_hooks_ingress, i.e. a read and then a write through the stale
pointer.  For flowtables, nft_unregister_flowtable_ops() additionally
calls ->setup(..., ops->dev, FLOW_BLOCK_UNBIND) on the freed device.  The
orphaned nf_hook_entries blob is also leaked.

On NETDEV_REGISTER the same break means only one of two covering hooks
gains an ops, so the other stays permanently unhooked.

Would it work to keep the strict identity match only for the
delete/update lookups and retain the prefix-overlap semantics for the
add/-EEXIST paths, e.g. as two separate helpers?  Alternatively, should
the unconditional break in nft_netdev_event() and nft_flowtable_event()
be dropped so every matching hook is serviced?

The commit message describes only the delete/update lookup semantics; the
fact that configurations previously rejected with -EEXIST are now
accepted is not mentioned.  Could that be spelled out?
