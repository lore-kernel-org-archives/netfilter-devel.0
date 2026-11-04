Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793802567;
	b=1akcyFNC31iCruTVTHd5/WA9NKtn/j+ZxW47Lv3u+3rMqoZgI1WsJypujtG2Fnrp/Q7z
	 AJZ5M+0p/g+t2y9Gz4Q4zgY6DmT1Eii7CdtrzbMt7trSQXTtfCQvnFDVtEKUUBAy3jFyK
	 kDBiRIUmmWPOA2oUFm8xZhMJF9DKd8sAIXl/ftcJ+r+3kirUd+rbpAANG3ZcajDqWQP6J
	 2Chx8DfqVn2HhEa0o31jvtTak5HEfZbvBrPfBsDlC7qX78rE5V1Jbg/7MOdALyJvqbflf
	 AId7xPj91Sv/BbZ5PGaLfPjrM8uzHDpvwtsalSLnXD+/l/f884ocuXCQnLEGZAonyjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793802567;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Xz3sb8BWuunlpYCoTGvQBeihdIazj1yMmpL1EBO9/qs=;
	b=4DJ3vRsAbN2DaDmrsWJLn+LmDAlbK3E95Mcp9TdSbfcspdeSg+LZ3qWyAa1eaa1KTMQd
	 6XMkz2VENTh0S2JeYrqseaOyozm/YO5q1v9G+MCf5GcVHECl9JWPE9YCdROMaBJPPMeph
	 RniEmJ2/lsCXxYRe3GBlBh6E5sH2ULRGo7haHJourXlUyOYxZxMMxjvnZY4w8vm0ugoh5
	 Fab/OHG7sgime9t6dwVApsFVmI0NPDIMqlnsVAKJ6VisQx+eWVDh7jvOnxWufnphCQp+l
	 tO//NR6bS9QgcDk8NHs9Rq0p5fA+kz4keNCTSo34Lvf7DKb+CVx7m/JFfuq4ZDs/7gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gRS1rRHN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105AC606A330;
	Wed,  4 Nov 2026 14:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gRS1rRHN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6266B1F000C1;
	Wed,  4 Nov 2026 14:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793802566;
	bh=Xz3sb8BWuunlpYCoTGvQBeihdIazj1yMmpL1EBO9/qs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=gRS1rRHNHRSJsts9JvGgJWF3hWpHvNoZuaISWb7KKCRXoc3M+ntSHJBgiKkAtdttR
	 y4wbhvzvQM8qTcWSI6ugqeLKZoS0OCIuFRIK/aHS+MZBA0fsnruwQN/CG6X+lS8ZRy
	 ZCHY1lXMRec+WCeL1uT/mi4d+Aejz8YCSDiqxf8GWO9JuEnUDXZQyAMrkKV6pXtIoC
	 lyxFNqAbUlEzkciJtQR08COMSJlD0r8ExWZley6pOq37uAOEMhbd9SWNDM0qenb2HX
	 +B2Ce1NGd65XXbKOmAXclPICYTsLYKMDyuA+ieGzZfsLPCZIXRbMToGPf3o2S2sFfh
	 uI6hEYbJWdauQ==
Subject: Re: [PATCH net 07/15] netfilter: nf_dup: preserve guard across
 NFQUEUE reinjection
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Wed, 04 Nov 2026 14:29:25 +0000
Message-ID: <179380256596.488856.13512803385415062400@kernel.org>
In-Reply-To: <20261103140308.591690-9-pablo@netfilter.org>
References: <20261103140308.591690-9-pablo@netfilter.org>
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

- [Low] The commit message for "netfilter: nf_dup: preserve guard across
  NFQUEUE reinjection" leaves out a behaviour change.
- [Low] The patch has Cc: stable@vger.kernel.org and Fixes: cd58bcd9787e
  (2010, xt_TEE), but it reads and writes current->in_nf_duplicate.

--

netfilter: nf_dup: preserve guard across NFQUEUE reinjection

This patch saves current->in_nf_duplicate in struct nf_queue_entry when
a packet is queued. nf_reinject() then restores it while hook traversal
resumes after a verdict, and puts back the verdict task's previous value
on exit. BH is now disabled for the whole of nf_reinject().

> Fixes: cd58bcd9787e ("netfilter: xt_TEE: have cloned packet travel through Xtables too")
> Cc: stable@vger.kernel.org

[Severity: Low]

Will this apply to the stable trees that this Fixes tag covers?

__nf_queue() and nf_reinject() read and write current->in_nf_duplicate.
That task_struct bit was only added by:

a1f1acb9c5db ("netfilter: nf_dup{4, 6}: Move duplication check to task_struct")

Older stable trees covered by the 2010 Fixes tag, such as 6.12, 6.6, 6.1,
5.15 and 5.10, still use the per-CPU nf_skb_duplicated guard. That flag
is also cleared after ip_local_out() returns, so the same bug seems to
exist there. This patch won't build against those trees, though.

Could a dependency note or backport hint be added? That would make it
clear those trees need a version that saves and restores the per-CPU
flag instead.

> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 90d887546f7db..a8aa7ad832c3f 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c

[ ... ]

> @@ -365,21 +366,30 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
>  	const struct nf_hook_entry *hook_entry;
>  	const struct nf_hook_entries *hooks;
>  	struct sk_buff *skb = entry->skb;
> +	bool old_in_nf_duplicate;
>  	const struct net *net;
>  	unsigned int i;
>  	int err;
>  	u8 pf;
>  
> +	DEBUG_NET_WARN_ONCE(current->in_nf_duplicate &&
> +			    !entry->in_nf_duplicate,
> +			    "%s called with unexpected duplication guard",
> +			    __func__);
> +	local_bh_disable();
> +	old_in_nf_duplicate = current->in_nf_duplicate;
> +

[ ... ]

> @@ -402,9 +412,7 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
>  	switch (verdict & NF_VERDICT_MASK) {
>  	case NF_ACCEPT:
>  	case NF_STOP:
> -		local_bh_disable();
>  		entry->state.okfn(entry->state.net, entry->state.sk, skb);
> -		local_bh_enable();
>  		break;

[ ... ]

> @@ -418,6 +426,9 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
>  	}
>  
>  	nf_queue_entry_free(entry);
> +out:
> +	current->in_nf_duplicate = old_in_nf_duplicate;
> +	local_bh_enable();
>  }

[Severity: Low]

This isn't a bug, but the commit message doesn't mention that the
BH-disabled region in nf_reinject() is now much wider.

Before this patch, local_bh_disable() and local_bh_enable() only wrapped
entry->state.okfn() in the NF_ACCEPT and NF_STOP case. Now every
reinjected NFQUEUE packet runs with BH disabled, duplicated or not. That
covers the NF_REPEAT hookfn re-run, nf_reroute(), nf_iterate() and the
nf_queue() re-queue path.

The change looks needed, because a softirq running on the current task
must not see the guard while it is set. Could the commit message say so
and explain why?

The message also only says that the guard is cleared:

  "The output call then returns and clears the guard before a later
  verdict resumes hook traversal."

It doesn't describe what users see. nf_dup_ipv4() clears the guard
unconditionally after the output call, and nf_dup_ipv6() does the same:

net/ipv4/netfilter/nf_dup_ipv4.c:nf_dup_ipv4() {
    ...
	if (nf_dup_ipv4_route(net, skb, gw, oif)) {
		current->in_nf_duplicate = true;
		ip_local_out(net, skb->sk, skb);
		current->in_nf_duplicate = false;
    ...
}

Say the duplicate is queued in LOCAL_OUT or POSTROUTING and reinjected
later. A TEE or nft dup rule further along then duplicates it again. That
new copy can be queued again, so each verdict makes another copy.

Could the changelog describe this behaviour?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103140308.591690-3-pablo%40netfilter.org
