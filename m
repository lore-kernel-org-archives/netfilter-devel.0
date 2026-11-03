Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714383;
	b=V8sQnYo9EhgV24spt/4iMj8e7GhTVg7Tdgq1BF3UTGpczB5mTvhIkJiARfJTB5tZc4w8
	 YIrKjUVaOd9/UZUu5YUE69ZIik49HL8fOuK9EVsjo1IwTtPnfFpId+3PGjFPGa89z7V9G
	 GVxof2Fhrbv9GEOFqdtONzYpvtNGO4brbmAg3rU0Q8dtmquCdCl69Bk8he5aDujT0AmGv
	 BEoBV2trgcIlJ5fo6gDX3vfsSNLN/MXpUOAm6ZBlfcjpHrIUH6PjcWpJ8JVMqe43sAeNv
	 TiQyY8CUGLE3pdweZfyNVJsUDjOS4+1ppuvlW9dF1nNZ3bWgazlPUIj9XaxOTUw+EPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714383;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=ZPI1deSmPnKRyZfGw23StKALU0KD8fvpy2hoNr56wK8=;
	b=2W/oWeLigq4NlOmS2KQT9TlDPoHRvEDjHZ2boIFOOOOQmIuRNyki8jy6tMwmzE4ICvif
	 nSaK0KiRGvf+P6kWiHp91q0/ZQOWJwN9OCn30OLU3fHJTTbzvPaV+NCkqMO+hPZUkzKux
	 NG9fWd05eNV2/rZNtm8cfhph2ZNWR5y5i9dvbQUNmcwT7LV7zFgnfTfHx1taHzCHpBHAY
	 wx2M6N6l7e8eTAJMzYVOyW2TWfADzuJ4J0//uvyU6UWPAG+FwSWG5lEmj7qtP7Gj64sb0
	 n2IquqIThqLumXEOmBXYlYAEWSLRfa3C2j/7Fv2ir3Y3SPCNp/NV3nB1SOP2F2IrzfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=PuKy9TH9;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C331B606D818;
	Tue,  3 Nov 2026 13:59:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C331B606D818
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=PuKy9TH9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793714380;
	bh=ZPI1deSmPnKRyZfGw23StKALU0KD8fvpy2hoNr56wK8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PuKy9TH9wqtXN3t4f0GKGgM0F32FLxVpQccOFSytbK1TjhYcHRZ/PViJB3tFVH3DF
	 BhEEU/2T7E9e22ssTY2DHdp2/dNLTWxUUBCiPFZTt2nNZO8Bur7lcQveXSA0mTkIak
	 TW71IxGdRsNrPeUKbfG1MBbr/reV3yCxp8Xuk6ZP7CgEEsc3sklzCw9Sy0yBmM0Kpv
	 NifJHT0JwcMdrZlhQOP3Ywj6XyT15AvLMsUy2bbhNXzk8bZBQQz2+22qNnbIsZIqb3
	 zqJP3RL11K4KFJElL9o9PbWNV4/YvbWtI03NzzGTkpsWISWbXtHS0rjrtDBNqWQw6H
	 GT2B6BgStNlNw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 042CD60060;
	Tue,  3 Nov 2026 14:59:40 +0100 (CET)
Date: Tue, 3 Nov 2026 14:59:37 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: jgc3silva@gmail.com
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Sven Auhagen <sven.auhagen@voleatech.de>,
	Oz Shlomo <ozsh@nvidia.com>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: flowtable: do not clear the offload bit
 twice
Message-ID: <aunoySCHzqwI1QIz@chamomile>
References: <20261103-flowtable-offload-bit-v1-1-20f5952c00a1@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261103-flowtable-offload-bit-v1-1-20f5952c00a1@gmail.com>

On Tue, Nov 03, 2026 at 09:52:56AM +0000, João Silva via B4 Relay wrote:
> From: João Silva <jgc3silva@gmail.com>
> 
> An expired hardware flow remains in the flowtable until its asynchronous
> hardware deletion completes. Teardown clears IPS_OFFLOAD_BIT, so a packet
> can create a replacement flow referencing the same conntrack entry while
> the old flow is still waiting for deletion.
> 
> The next GC pass calls flow_offload_teardown() on the expired old flow
> again, clearing the replacement's offload bit. More packets can then
> create additional flows for the same conntrack entry. A pending hardware
> work item can also delay deletion and expose the same repeated teardown.
> 
> Commit d2d31ea8cd80 ("netfilter: conntrack: fix erronous removal of
> offload bit") closed this window for software flows by unlinking them in
> the same GC pass and made the conntrack state fixup one-shot, but
> hardware flows stay linked until NF_FLOW_HW_DEAD is set.
> 
> Make clearing IPS_OFFLOAD_BIT part of the existing one-time teardown
> transition, alongside the conntrack state fixup. Subsequent teardown calls
> must not alter the offload state now owned by a replacement flow.

Let's better target nf-next for this, this looks like LLM triggered
for correctness.

Thanks.

> Fixes: e5eaac2beb54 ("netfilter: flowtable: fix TCP flow teardown")
> Signed-off-by: João Silva <jgc3silva@gmail.com>
> ---
>  net/netfilter/nf_flow_table_core.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 0d72dc8ae47a..709b55b74cc7 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -398,9 +398,11 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
>  
>  void flow_offload_teardown(struct flow_offload *flow)
>  {
> +	if (test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags))
> +		return;
> +
>  	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
> -	if (!test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags))
> -		flow_offload_fixup_ct(flow);
> +	flow_offload_fixup_ct(flow);
>  }
>  EXPORT_SYMBOL_GPL(flow_offload_teardown);
>  
> 
> ---
> base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
> change-id: 20261103-flowtable-offload-bit-f15bfd1d38ed
> 
> Best regards,
> -- 
> João Silva <jgc3silva@gmail.com>
> 
> 
