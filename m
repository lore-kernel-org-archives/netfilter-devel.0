Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FCD4FE2DE;
	Mon, 28 Sep 2026 23:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790639704; cv=none; b=kVYMffsPbLbYLmz54YlcSlHixlYo0a2TZgAEOHgj8gxuXmYLQSGNPq1ruswUIkAT5LHda6G1m0doHLa84fQnCjkN9fi2dzXyqirYIfYEJB57WrNI17rzzLzZ+OM2kqC9CYeUyRn7f/jC0ZZiOCD5OCynkVzz3C6rQGUVZU1JMi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790639704; c=relaxed/simple;
	bh=QBYPik9qF+x4tO+wKYbPzZqsc5C5CC5uh4V8CCdmfSI=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Gu60jkEIF3P025BUlgXOxsUW58YO3fhHFURnm+YPaFOz0D3LLMk2su+BJygavpY2m3ZvJpLPwx+CcfDUD/tQBNSVy0P60R5dfG5ZrOr30+Qp5xMZxNNplp7v9Y6tCV3h5d0CERRZ3puY4HscvyFkmuXgT5LZZFL1fVK/DN4T6FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lw8oz9fC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lw8oz9fC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AAD1F00893;
	Mon, 28 Sep 2026 23:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790639702;
	bh=PIUsr6pOKbfhrqP6UzZ1OSNoDNWxPWot4nii7/CbJ3o=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Lw8oz9fCYCluHYhY5uPxvM4v29zSYaR/QiTLt/kutYxvZGRLu2UCSwp/pwYsLK2Rb
	 YJ4h4xNG2MjxrMfe0efRRXZ/QQzm6r352DyrNUgm+upI3ycbHiS5bksyWTjyCiyqQG
	 ixbVVelM8yly3n6+PjSdHsg7n5McRcKjWiHhmru+5hg70hGBvfqAvYG8zlltjEWd36
	 KMsfcGDP5x+jtCzbnQEnZ4Eiiu0aoGL6Y1bpp12yiwDcdlaGxVtYModGj99FCnJjpN
	 yJDvhlafCdPUqJ0gsCKtlV4t7qUbuzw7qvnQoKPRpHYbb6VvWiwenVAwqwu2JrsJgp
	 KCqxTnQ7U36+A==
Subject: Re: [PATCH net 03/11] netfilter: nft_flow_offload: drop flowtable
 reference on init error path
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Mon, 28 Sep 2026 23:55:01 +0000
Message-ID: <179063970128.3145.14643290134256624202@kernel.org>
In-Reply-To: <20260927220816.268206-4-pablo@netfilter.org>
References: <20260927220816.268206-4-pablo@netfilter.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] One sentence in the commit message names the wrong callback.

--

netfilter: nft_flow_offload: drop flowtable reference on init error path

In nft_flow_offload_init(), nft_use_inc() raises the flowtable use count
before nf_ct_netns_get() is called. If nf_ct_netns_get() fails, that count
is never dropped. The patch saves the return value of nf_ct_netns_get() and
calls nft_use_dec() on failure, so the inc/dec pairing is restored inside
the init callback.

> The upper layers do not balance it either: nf_tables_newexpr()
> clears expr->ops when the expression init callback fails, so the
> nft_expr_more() iteration in nft_rule_expr_deactivate() and
> nf_tables_rule_destroy() stops right before the failed expression
> and its ->destroy callback, which would drop the reference, never
> runs.

[Severity: Low]
This isn't a bug, but does this paragraph name the wrong callback? In
net/netfilter/nft_flow_offload.c, the ->destroy callback only drops the
conntrack netns reference:

static void nft_flow_offload_destroy(const struct nft_ctx *ctx,
				     const struct nft_expr *expr)
{
	nf_ct_netns_put(ctx->net, ctx->family);
}

The flowtable use count is dropped through ->deactivate instead.
nft_flow_offload_deactivate() calls nf_tables_deactivate_flowtable(), and
that function does the decrement:

net/netfilter/nf_tables_api.c:nf_tables_deactivate_flowtable() {
	switch (phase) {
	case NFT_TRANS_PREPARE_ERROR:
	case NFT_TRANS_PREPARE:
	case NFT_TRANS_ABORT:
	case NFT_TRANS_RELEASE:
		nft_use_dec(&flowtable->use);
	...
}

On the nf_tables_newrule() error path, the callback that gets skipped for
the failed expression is this one:

	nft_rule_expr_deactivate(&ctx, rule, NFT_TRANS_PREPARE_ERROR);

It is skipped because nf_tables_newexpr() cleared expr->ops, which ends the
nft_expr_more() walk.

The code change looks correct. Could the commit message say that the
skipped ->deactivate callback is what would drop the reference, rather than
->destroy? That would help anyone checking the fix against
nft_flow_offload_destroy(), for example during a stable backport.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927220816.268206-2-pablo%40netfilter.org
