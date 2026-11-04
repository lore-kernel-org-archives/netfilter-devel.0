Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793802568;
	b=rCqUgmvBz034X2oeavkdL6i/C5v8uJZ2q2D2hD7MKe2ZvqllpfmqwVF351zCs2G1ulLR
	 eLhOLGbIqaW5HhA23lqGT3v6hxqCqA86kr3rI9+rXbahyYJIDrpouJHXq5bQK3+y51BZY
	 TQoob2FoAFkNL/hMoFBtlrqER9aqpR+p9hEFyTHwW3kAYDdQZ6G9r3Y64sy38i6q27tn4
	 hQI5jA1jdVDgcp2wKboS4PfrXlhykfIfpySFS96YgaIi9usyxmsye13K2LGeoGS1w35cs
	 mNsLIVu6n9pOgauXllTghrtmuJII/ruCHxRidix0y7EvUg6faIY936NeDTQRWHhwvnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793802568;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=HjZiL2EWVteAt/2L+qFJ7Kn3/mgXU92yKdkjMMjuGU0=;
	b=ElvKMlGjxCmk+IKGLEJEnyHUhYNVLykSaj0dp+/x7B6HRaLNh/YfTXHajxG/h/3dOkyE
	 Kj13uf4hnxJWC7XXoS+puYiQq+gwYhZKcrYVtbbZcRwwQ8Gm2mjznz69EFta3sZWIQD1v
	 uzZK+51hAdEnRJska36VGztK28UUR7t9hR0sIAMqua04dTMwYlz8ouyYyYO5vN6QV89Lp
	 TJPjX/HRvuMwY84B+33/+jmn+7G1SPRK/t1XI+qicWniZvodyPRsGl1bSYvd8oS6Cak8x
	 /aMgHdL7fQEREeMBblCJh/BgkHeMIDXqXQpm7E6mHh/xV/jLkBLefVbET4orQNGoFDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FDCZIwnG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5A9606A334;
	Wed,  4 Nov 2026 14:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FDCZIwnG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837691F00A02;
	Wed,  4 Nov 2026 14:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793802568;
	bh=HjZiL2EWVteAt/2L+qFJ7Kn3/mgXU92yKdkjMMjuGU0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=FDCZIwnGpJ/pgXcBClKdCNK5O2qgTCXxgAm/AGU5VGqmjOfhbmUQ/8pMeANcWbwaG
	 Jj9lT/O2xHTstkMCsiORL5WbwKECGGdmjXiqn3WlrJWSXbGjKKlDuQ5G9wLC4LJkJv
	 TKH4Z+r6re9jGTG6/Msl+tWOv4zC46gDIIFVt9rGWA4IiEs6cRDOgReTDrOOy12hCc
	 kYCy6OysSZYEFMgO0Z6QZLFUXfcq7Hhbrn+wOijBpXHYmTcUjNjJ0CCogKyu+yzv7d
	 jGjUEl5CpJKcZuWVXYzFglzyT1iw50zj3dU/VFjAzd3Cwi+oFa5H1g4nZqziVWD2l3
	 JbGMQWMu+8tjQ==
Subject: Re: [PATCH net 13/15] netfilter: nf_tables: fix memleak when rule
 deletion fails with hardware offload
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Wed, 04 Nov 2026 14:29:27 +0000
Message-ID: <179380256708.488856.2178919556830092736@kernel.org>
In-Reply-To: <20261103140308.591690-15-pablo@netfilter.org>
References: <20261103140308.591690-15-pablo@netfilter.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message calls the bug fixed in nft_delrule()
  (net/netfilter/nf_tables_api.c) a plain "memleak", but the old error…

--

netfilter: nf_tables: fix memleak when rule deletion fails with hardware offload

The patch moves the flow rule allocation in nft_delrule() so it runs after
the rule has been deactivated. This means the -ENOENT error path no longer
drops an already built flow rule. nft_flow_rule_destroy() now accepts a
NULL flow, and the NULL check in the nf_tables_newrule() error path is
removed.

Link: https://patch.msgid.link/20261028062204.1079089-1-hdthky0@gmail.com/

> Allocate flow rule object after transaction has been allocation and rule
> deactivation has been performed, otherwise memleak is possible.  Let the

[Severity: Low]

The code change looks correct. Should the commit message also mention the
net_device reference leak?

Before this patch, when nf_tables_delrule_deactivate() returned -ENOENT in
nft_delrule(), only the transaction was freed:

	err = nf_tables_delrule_deactivate(ctx, rule);
	if (err < 0) {
		nft_trans_destroy(trans);
		return err;
	}

nft_trans_destroy() only does kfree(trans). The flow rule already stored
in nft_trans_flow_rule(trans) never reached nft_flow_rule_destroy().

Take a rule in an NFT_CHAIN_HW_OFFLOAD chain that uses fwd or dup to a
device. For that rule, nft_fwd_dup_netdev_offload() in
net/netfilter/nf_dup_netdev.c holds a device reference that only
nft_flow_rule_destroy() drops:

	dev = dev_get_by_index(ctx->net, oif);
	...
	/* nft_flow_rule_destroy() releases the reference on this device. */
	entry->dev = dev;

So each failed delete leaked a netdev refcount as well as the memory. A
leaked refcount can leave unregister_netdevice() waiting for the device to
become free, and that blocks netns teardown.

This path is easy to reach. __nft_rule_lookup() matches only on
rule->handle and does no genmask check. Deleting the same handle twice in
one batch therefore hits the -ENOENT path in nft_delrule().

Could the changelog mention the netdev reference leak, so stable
backporters can judge the impact of this fix?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103140308.591690-3-pablo%40netfilter.org
