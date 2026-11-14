Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794622550;
	b=coofF7YrxDOv7Bns8z2q5Xzbi9adoajLtxuGq5TmcA6r/2cczn+D1z65e1gHGb/iumoW
	 HN4A2flwa3i77NYi8eJdqTqPe2eOBJFEAvg3erVGMQI1e0rAcPv3Usm0gJjD95wYFM+9R
	 cLvpFnVV94c0Cs4SY5xGLQuGXIrfuJrZqxVvlCi/53BQSIT+LdqD4Gb08klp6DnXrwWLT
	 RnrvsAtIAhFv6moW/eJrEIXMWYTSsXbgtiIEaxxuiQpbo1sIdG+UCOAGLfi4odTITfc6s
	 BOw0OX9m+kTytRWMMPDcH50eqQnl/+QbGlOT9YIqcChPHpRjhEq7ZwBdg1M2etuYhHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794622550;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=UhKg19WmHWcCDhoq+fCZ7tMD7STH5vjOVAh4jEFeDvU=;
	b=UZusJHEfjVwUi7wFmHGDfjlg4r7hUj4hgbp8ewJih+Abg+5I7MEHYZoOMsZfiP3mn4K9
	 zpPvQ0kNuHp6KGN8NnmA6tIycIz6X7nUQdZ68slVP+U2oHnjxBjbUZHPr2oCPmb64oMVn
	 HiKNvgwMeZdLguaRz7h1bYa4unw/0EIkKd29ESA+NXWhgH00nQsvb2YZNOfANvkDwOYHY
	 A0xOyBQlGnrt+H9oEZwWLCD/aL1HUMsuCtyyDcGlnO5X6yMwnspGBEmLbhv7IYO8i0/Cl
	 f1ILY8sc21Ug2WRWl18jGeTx4v08rQpvsBC5JNLFlQCMz0P2jh3sqPbxujF7HmoBBuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QNKpNm+m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6220460A2609;
	Sat, 14 Nov 2026 02:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QNKpNm+m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40D11F000C6;
	Sat, 14 Nov 2026 02:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794622550;
	bh=UhKg19WmHWcCDhoq+fCZ7tMD7STH5vjOVAh4jEFeDvU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=QNKpNm+m3TTK/R7vy68UN0TlnYlYIjfkJ7gAD5WE2MS7oighyPLX80tzC9Awrn2Cs
	 VBZD0bTwH7VaRILLMlg37aIYj4Cy+C8uE0Vhi7PdZuQfmKwiTkk4idRIzM8hWCCd57
	 3Q1g/QXOyFTTdBagdZSCDOUkkFr7zCI2XXsHgNBQCwnwG5jDh53n1BMyrpD8q7a1Uj
	 +oQ3G0Qjen3/zaMsi7X4oKA1kFaT/FnVxQxJnULFhmsbeHmegsM0DgDNd15msYDmzD
	 0eqsy+t408wzHWghsguRhyG9r2YKc6o7yOp9l+TlCC/UN7KyBitg4vihWlnpfMaalu
	 ChyOG5/aEqD4A==
Subject:
 Re: [PATCH net 14/15] ipvs: wait grace period before reusing destinations
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Sat, 14 Nov 2026 02:15:49 +0000
Message-ID: <179462254924.2199510.13893062636821703551@kernel.org>
In-Reply-To: <20261113011447.2357709-15-pablo@netfilter.org>
References: <20261113011447.2357709-15-pablo@netfilter.org>
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

- [Low] The commit message for "ipvs: wait grace period before reusing
  destinations" describes the change against an earlier revision of the…

--

ipvs: wait grace period before reusing destinations

This patch adds a conditional RCU grace-period wait in ip_vs_add_dest()
right after a destination is taken from dest_trash, before its estimator
is restarted. Trash insertions are batched so that one rcu_state cookie
covers each removal. A need_gp flag makes ip_vs_rs_hash() wait before it
rehashes a destination that was unhashed during an edit.

> When a destination is retrieved from dest_trash, ip_vs_add_dest() currently
> restarts its estimator before waiting for the grace period.

[ ... ]

> ip_vs_start_estimator() rewrites the node on its temporary list on success,
> or initializes it on failure, before the current wait. A reader can then
> follow the changed link or stop traversing the chain early.

[Severity: Low]
Does this wording describe the change against an earlier revision of the
patch rather than the tree it applies to?

In the parent tree, the trash-reuse path in ip_vs_add_dest() has no
grace-period wait. ip_vs_trash_get_dest() is followed directly by
ip_vs_start_estimator() and __ip_vs_update_dest(). There is also no
rcu_state, need_gp or cond_synchronize_rcu() anywhere under
net/netfilter/ipvs/ in the parent tree.

So "currently restarts its estimator before waiting" and "before the
current wait" point to a wait that does not exist in the baseline. The
patch adds the wait rather than moving it.

> The grace-period cookie is also saved when a live destination is unhashed
> for an edit and consumed when it is rehashed. Describe rcu_state as the
> cookie for an unlink, covering both trash and rehash cases.

The sentence "Describe rcu_state as the cookie for an unlink" reads like a
note between patch versions about rewording the comment on the new
struct ip_vs_dest::rcu_state field. It does not describe a change against
the baseline.

The patch is tagged for stable. Could the message say plainly that before
this patch n_list, d_list and est->list were reused with no grace period?
It could then say that the patch adds cond_synchronize_rcu() right after
the dest is taken from the trash, and a need_gp wait in ip_vs_rs_hash()
for the edit/rehash case.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261113011447.2357709-2-pablo%40netfilter.org
