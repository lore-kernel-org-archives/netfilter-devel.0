Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5D749E12E;
	Fri, 11 Sep 2026 00:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789087609; cv=none; b=iQAfb+QdrEPz/UAOS5yjQvEqyvqEhXoaH3G89GvSd89H3+P68ddulCRDb927OXv9/5Y/Y3tHQOs+EQVzdAMyI0mjri5YWtpSVAgSjDWb4sK7rViEoZkvVdH9Wq0hMXWY2R6z5ihGwRpa7pPYXqYYF2wMD5FEN7W9lYOG8cRKQt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789087609; c=relaxed/simple;
	bh=34aMvopukcGCrRjzEwxQESkBi4yPukkSReLU50rmW8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ReGOhy03v47fOYADF6Kc8ITBRuu/6QUWdED1n9dTyiBUpmRav8tLz45qLT88WF4WtxtAGg8GSHqPy44h+H1Mp2L5V+LpfjcmgxEP1ALYxqoro8HHNy+6knlfjO7MY871iZi15Md6rTt2QV5hPZoTrSMwgZgdaCtR4ox2YdEQPCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NUf8+Wcf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NUf8+Wcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27621F000FF;
	Fri, 11 Sep 2026 00:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789087608;
	bh=apyN4di2S1WNp8Pmxi+8S+a8yWkGRLG/9W7cf0bM0Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NUf8+WcfwxvHHFjS7/yVFE0y4IYVM3DITwrJmWeFG92TCX5TypaqVjMlA91uYIq2B
	 n/JhpAua/EuqR9MS9pCBqTALvre8Jc1uukVa56GZU/VXmpepHiG7uMZNxHJyHFEYrK
	 K4AqN6CUq5A/kA74xjRYPYRPSm3PDN1sZU7/VEFn5+nJIv/2LQyQdIBdcu23r0Yz07
	 oS9An9F7vWq+RABMATR3ruryGuTdAHBUIXRKH/X/D/PoIrNrRcLQnUKPkUeWnCGFnj
	 KDpEZYnGJepiRLA+C9A8/cZCCKRFPMV+Y+Mv7Fz1y5p84NdZvJ5yWK6V82hfDok2dz
	 WCHAOvJsyHASw==
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
Subject: Re: [PATCH net 3/7] netfilter: nf_nat: unregister and release hooks on error
Date: Thu, 10 Sep 2026 17:46:46 -0700
Message-ID: <20260911004646.2877858-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909221844.1650275-4-pablo@netfilter.org>
References: <20260909221844.1650275-4-pablo@netfilter.org>
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
netfilter: nf_nat: unregister and release hooks on error

This defers assigning nat_proto_net->nat_hook_ops until the nested nat hook
has actually been inserted, and adds an error path that unregisters the base
nat hooks and frees the nat_ops array plus the per-hook private data when
insertion fails.  The code change itself looks right and restores the
"nat_hook_ops != NULL implies users > 0" invariant.

The question below is only about the changelog wording.

> However, sashiko reports that nf_hook_entries_insert_raw() fails, then
> ->users count remains at zero and nf_nat_unregister_fn() could hit
> WARN_ON() since base nat hooks with no users is unexpected in the
> unregistration path.

[Severity: Medium]
Is this WARN_ON() actually reachable from the described sequence?

The WARN is the users == 0 check at the top of nf_nat_unregister_fn():

	mutex_lock(&nf_nat_proto_mutex);
	if (WARN_ON(nat_proto_net->users == 0))
		goto unlock;

Every in-tree caller seems to unregister only ops whose registration
returned 0.  ipt_nat_register_lookups() (and the ip6 counterpart) unwinds
with:

	ret = nf_nat_ipv4_register_fn(net, &ops[i]);
	if (ret) {
		while (i)
			nf_nat_ipv4_unregister_fn(net, &ops[--i]);

so the failing index is never unregistered, and for i == 0 nothing is
unregistered at all.

nf_nat_inet_register_fn() in nf_nat_proto.c unregisters only the IPv6 half
on IPv4 failure, and that half had returned 0, so users for IPv6 is at
least 1:

	ret = nf_nat_register_fn(net, NFPROTO_IPV4, ops, nf_nat_ipv4_ops,
				 ARRAY_SIZE(nf_nat_ipv4_ops));
	if (ret)
		nf_nat_unregister_fn(net, NFPROTO_IPV6, ops,
					ARRAY_SIZE(nf_nat_ipv6_ops));

For nft_chain_nat, nf_tables_addchain()'s err_register_hook path does
nft_chain_del() plus nft_trans_destroy() without calling
nf_tables_unregister_hook(), and nf_tables_table_enable() disables only the
chains that registered successfully.

The leftover state after the pre-patch failure also stays self-consistent:
nat_hook_ops is non-NULL with users == 0, so the next successful
nf_nat_register_fn() takes the existing-ops path, bumps users to 1 without
re-registering base hooks, and its matching unregister brings users back to
0 with exactly one nf_unregister_net_hooks().

> +err_unregister_hooks:
> +	if (nat_proto_net->nat_hook_ops) {
> +		mutex_unlock(&nf_nat_proto_mutex);
> +		return ret;
> +	}
> +	nf_unregister_net_hooks(net, nat_ops, ops_count);
> +err_free_hooks:
> +	mutex_unlock(&nf_nat_proto_mutex);
> +	for (i = 0; i < ops_count; i++) {
> +		priv = nat_ops[i].priv;
> +		kfree_rcu(priv, rcu_head);
> +	}
> +	kfree_rcu(nat_ops, rcu);

Isn't the failure this new path actually fixes a leak rather than a WARN?

On the first nat registration for a family in a netns, an
nf_hook_entries_insert_raw() failure (for example the allocation inside
nf_hook_entries_grow()) previously left the base nat hooks registered in
that netns forever, still traversing every packet, and leaked both the
kmemdup_array()'d nat_ops array and the four nf_nat_lookup_hook_priv
allocations.  Nothing reclaims them later, since nat_net_ops declares only
.id and .size:

	static struct pernet_operations nat_net_ops = {
		.id = &nat_net_id,
		.size = sizeof(struct nat_net),
	};

Could the changelog describe that signature instead, so anyone bisecting or
backporting looks for leaked hook registrations and memory rather than a
WARN splat?
