Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB32481ABB;
	Mon, 19 Oct 2026 04:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792385396; cv=none; b=bRFePXNXnTiIRWz7OVZddgQkzL67guVOBxz/oIG7FxD/j8h1CZKBcWpFS/Um1JP+44uTb5Y0KjpnWRBCPh7iUAk2l9yBNL8RbARWzyw3Ba9xoonuxJFQw8CK9W/tRoAKBbsstj30Z37b2uI1P0TGqOz9wn0Kp/tQBYFTW5R24N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792385396; c=relaxed/simple;
	bh=ke6NDE0gtn25bpqFitqWZ7wDU0VL/NWKOAqy7Bt20ng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D0UshUMdcD3RWGiG8woLgWT6/jPsW0SIoGX+/JNUz/my8xwvHFElyx/hkqTJmoXpZMSvUeTyTTdpGIzp3AvDw0isi/l5LqgyR69zV3pkpqV/YurOvQDjtYGxKE568ZjyVtH0kLGDVIMEAKNfUq+NAZixId+3HiVDQAOKvwOrOCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0087D60272; Mon, 19 Oct 2026 06:49:47 +0200 (CEST)
Date: Mon, 19 Oct 2026 06:49:47 +0200
From: Florian Westphal <fw@strlen.de>
To: aojea@google.com
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@kernel.org, horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net-next 04/15] netfilter: nf_queue: limit the hook drop
 flush to the unregistered hook point
Message-ID: <atWhayNce2rqLQUL@strlen.de>
References: <20261018005638.1776148-5-pablo@netfilter.org>
 <179237288267.3135.9555179349652175002@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <179237288267.3135.9555179349652175002@kernel.org>

netdev-bot+sashiko@kernel.org <netdev-bot+sashiko@kernel.org> wrote:

@Antonio: TL;DR: if Pablo wants a v2, please send a new patch that adds
the needed nf_queue_nf_hook_drop() calls in brnf and conntrack.

Otherwise, please followup after this hits net-next tree.

> - [High] Use-after-free of module code: after this patch, `rmmod
>   br_netfilter` no longer drops queued packets that point into…
> - [Medium] Conntrack module unload can now stall on queued packets, and
>   the commit message does not mention it.
> - [Low] The commit message has no Fixes: tag.
> 
> --
> 
> [Severity: Low]
> Should this have a Fixes: tag?

Absolutely NOT.

> Without the trailer, stable maintainers may miss this fix. The message
> also does not say the omission is deliberate.

This is NOT a fix.  And the problems highlight that this belongs
in -next and not in stable trees.

> [Severity: High]
> After this change, can packets whose okfn points into br_netfilter.ko stay
> queued after that module is unloaded?

Yes, br nf strikes again.

> Is a flush-all, such as nf_queue_nf_hook_drop(net, NULL), needed in the
> br_netfilter exit path, or some other flush at module teardown for callers
> whose okfn is module code?

Yes, needs to be added for brnf.  Could be handled as a followup,
though, ample of time to fix this until this gets into a non-rc kernel.

> [Severity: Medium]
> Could rmmod nf_conntrack now block while userspace holds verdicts for
> queued packets?
>
> Before this patch, that unregistration flushed every queued entry. This
> released the nf_conn references held through skb->_nfct.
> 
> This runs while pernet_ops_rwsem is held for write. Netns creation and
> teardown would stall until a verdict is sent or the queue socket is
> closed.
> 
> The commit message says nf_ct_iterate_destroy() keeps the NULL flush on
> module exit. That path covers helpers and NAT, not nf_conntrack itself,
> and the message does not mention this case.

> Should nf_conntrack's exit path also flush with NULL?

Yes, nf_conntrack_fini_net() would be a candiate.

But unlike the brnf case I think this one is relatively harmless.

If v2 wanted: add
