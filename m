Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B817424660
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jul 2026 12:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783600581; cv=none; b=NYl7zMsHOxIkx+syR602lKOVumUs7ic6LQAHf3YlYuN+l+7kcTJKKJJIzHfOrxtspapjopiWV7WfCTlyyTg7LY7wUxqhi4CbyKyT+cou27l1VKL/NATZqOixLlwqnFYfCDKHUNhX5eFCONAE2Hc+VvTHRSseGBhEWC3M6UdCA3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783600581; c=relaxed/simple;
	bh=0gzWslr8DDJQLr+jNwLfDKAridLF+cutPPfXJH0rP+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KovrYQzgHWXr+Sz9hit4c+XRiSu9AjAS9V5pydIxTpUE4H1G1XkGmsAQDJ5PrELej9Kc7HgK3J81KfBmG0T27s5C6VAj2aujd5EJTau9++I+SwDP9Mgi8s9okLmyBhI29gID2OMycOhvA0EPBdxUXXp/94wTjkz8rYTVLTsdGHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 01E39602A9; Thu, 09 Jul 2026 14:36:17 +0200 (CEST)
Date: Thu, 9 Jul 2026 14:36:12 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [nf-next PATCH 2/4] netfilter: nfnetlink_hook: Deref hook entry
 using READ_ONCE()
Message-ID: <ak-VvHgZDCI5nIzv@strlen.de>
References: <20260708161940.1477671-1-phil@nwl.cc>
 <20260708161940.1477671-3-phil@nwl.cc>
 <ak-PECbcevqjy91_@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak-PECbcevqjy91_@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Are we sure net/netfilter/core.c is safe to be walked over rcu in its
> current state? Could the dummy_ops be exposed through nfnetlink_hook?

What do you mean with 'safe'?
The walk is safe from memory safety point of view.

dummy_ops *can* be exposed.

Otherwise, hook unregister can fail when low on memory:
ATM, in case we unregister hook and then fail to alloc the replacement
blob (that is same as live one minus the removed hook) we leave the
dummy stub in so old hook function is no longer executed and leave the
outdated/stale blob in place.

One alternative to dummy-ops usage is to keep a spare blob around so we
can avoid the new memory allocation when a hook goes away.

Then, on delete:

1. use the spare (which is large enough) instead
   and prepare the new blob (without removed fn).
2. swap the spare with live version.
3. attempt to allocate a new spare.
   if that fails, force a synchronize_rcu() and make
   the 'old' live the new spare.
   Else, use the new spare and avoid the,
   synchronize_rcu(), old-live is handed off to call_rcu.

Hook-add would always have to keep the size of the spare
up to date, so it is always large enough to hold the
current amount of live hooks.

Its a bit more work, but it avoids the need for dummy_ops.
LLM should be able to generate the transformation patches.

> Maybe net/netfilter/core.c needs a revisited to use
> rcu_assign_pointer() to assign the hook_ops to the blob, then
> nfnetlink_hook uses rcu_dereference() instead of READ_ONCE.

Why?  What is the concern?

> Then the RCU semantics of the hooks would exposed in a better way?
>
> That would made double use of RCU, one from the blob and then for the
> hook_ops.

Its technically not needed, I think, the hook_ops are not supposed
to be munged while the blob is active.

Adding extra rcu_dereference adds additional barriers for each hook/elem
in the blob...

> The hooks are now released using kfree_rcu(), at least in the recent
> nf_nat core updates they are.

Yes.
