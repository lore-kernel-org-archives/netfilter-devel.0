Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F054524887A
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 09:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747820122; cv=none; b=hvyd8ZBZbM8n0DGQiwNUwoKO7wAioLtTsNGMkxnkM6Cfip3C9RcHY7O0hXlwrp1R/5OGlrES1w0Pzj6C6cZVXK5Z+ReFKRSSo6yKRqD7X0rSes/T87XC7O9D6PSSpUHXf43lPsVrpUL2Riah9QaBPxcpy0dL9zAYdLl3WbwQ5zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747820122; c=relaxed/simple;
	bh=n1ez93h8ihDRKxcDt7ebTgrKD6istJuZrmCGppn90xo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JXM5SQ6NALwa97zglQ4YzltxF95flZBMViEnF8vbVuK6JlqtTv/aJX8tQRFsqvyH5tP0ujBmmh2aCyI2zYMruRO470acjZjcNRVUIDiKaXXJotwzVFofEV0oTBjdtGUCSRju4tWaAJULbGb881M9TWzZqwMXB8G4wrd57eT2XTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jz5VPXrf; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PYyePrar; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jz5VPXrf";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PYyePrar"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0CD6E606ED; Wed, 21 May 2025 11:35:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747820116;
	bh=sK1557DCXWRqN0wGPzZNtBBAufeheZjmqJ3kWaisnn0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jz5VPXrfKIrY4o+eUHhqW5zllqCwGNh7+ztzGfowmahWpw+cvF1JuXKAmR2OUY25U
	 tiBPdew4bNqGEBUzJaMYhosMHO7hBIV+bbRLlcfCJ056XI1zruhHl734d8oJAhLtvE
	 Akkoqx/4iidvZIY4akJI1bpwwTL6SO1HMvbyuY+2aD9AkeDjoBu49BTgZW/a/16uQP
	 JqvptyL3YBqgXtr8rAiEYYx/VJ9bekGIm9HKdXlGFD4dLNZd9u9kaR2WO59SScYAeL
	 ZAGkeVmIyiaBsKDEdP39Q47DbLdsP9cD4I8A8wb1QwPmpjA33lJaWUakB6CgAegMMm
	 HCBy6Sfvzn4jA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 344EA606ED;
	Wed, 21 May 2025 11:35:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747820115;
	bh=sK1557DCXWRqN0wGPzZNtBBAufeheZjmqJ3kWaisnn0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PYyePrarIYQyWcvN2FPyjUf9a5+ZvAewWu+VakB9bxppoiYSNVjJSSsDEvJtqBObP
	 3LPhdIGDh/PzkWiFf5z6YqkJ3Dy3yiKsnT0COh4TQKTce4uPR5f9fkOYTO/W1Tm7f+
	 fbDzq8n/+G8sidtSGCH1kYrq8+Z0/sNvFI5bOUMA11h9VIsqL302SgJCTcjS0cdRtz
	 pZflQArEv+GKQOmiL9A73t0UQRyIo3Jh+eG6E6g93GTnS/1MSwst7onUTeHscaGYh2
	 T1Pf852MJpNbrG6cLwLCWQy1bFRm00Mh5+Az99QkX6xRT2TumBTKjUGPL4XUTmzNtP
	 iiIJuIOSlt0/Q==
Date: Wed, 21 May 2025 11:35:13 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 2/2] netfilter: nf_tables: add packets conntrack
 state to debug trace info
Message-ID: <aC2eUd6OOxn9ramP@calendula>
References: <20250508150855.6902-1-fw@strlen.de>
 <20250508150855.6902-3-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250508150855.6902-3-fw@strlen.de>

Hi Florian,

On Thu, May 08, 2025 at 05:08:52PM +0200, Florian Westphal wrote:
> Add the minimal relevant info needed for userspace ("nftables monitor
> trace") to provide the conntrack view of the packet:
> 
> - state (new, related, established)
> - direction (original, reply)
> - status (e.g., if connection is subject to dnat)
> - id (allows to query ctnetlink for remaining conntrack state info)
> 
> Example:
> trace id a62 inet filter PRE_RAW packet: iif "enp0s3" ether [..]
>   [..]
> trace id a62 inet filter PRE_MANGLE conntrack: ct direction original ct state new ct id 32
> trace id a62 inet filter PRE_MANGLE packet: [..]
>  [..]
> trace id a62 inet filter IN conntrack: ct direction original ct state new ct status dnat-done ct id 32
>  [..]
> 
> In this case one can see that while NAT is active, the new connection
> isn't subject to a translation.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  2 +
>  net/netfilter/nf_tables_trace.c          | 65 +++++++++++++++++++++++-
>  2 files changed, 66 insertions(+), 1 deletion(-)
[...]
> diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
> index 580c55268f65..ba8b0a8c00e6 100644
> --- a/net/netfilter/nf_tables_trace.c
> +++ b/net/netfilter/nf_tables_trace.c
[...]
> +	if (nla_put_be32(nlskb, NFT_CT_STATE, htonl(state)))
> +		goto nla_put_failure;
> +
> +	if (ct) {
> +		u32 id = ct_hook->get_id(&ct->ct_general);
> +		u32 status = READ_ONCE(ct->status);
> +		u8 dir = CTINFO2DIR(ctinfo);
> +
> +		if (nla_put_u8(nlskb, NFT_CT_DIRECTION, dir))
> +			goto nla_put_failure;
> +
> +		if (nla_put_be32(nlskb, NFT_CT_ID, (__force __be32)id))
> +			goto nla_put_failure;
> +
> +		if (status && nla_put_be32(nlskb, NFT_CT_STATUS, htonl(status)))
> +			goto nla_put_failure;

NFT_CT_* is enum nft_ct_keys which is not intended to be used as
netlink attribute.

NFT_CT_STATE is 0 which is usually reserved for _UNSPEC in netlink
attribute definitions.

My suggestion is that you define new attributes for this, it is
boilerplate code to be added to uapi.

Thanks.
