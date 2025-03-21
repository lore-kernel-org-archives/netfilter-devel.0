Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2794B1DFF7
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Mar 2025 12:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742561615; cv=none; b=A3JYbnKS4WHN8Zeta4PaQE9aj7rBnlXIovAZr/0AotAlp/I9R8xseyOTCqoZkb1b665wV5HUgdz1R0sk/OJfeMc087/xq+YMQvE3lm3Vodv0qZBkpeFVf0kOR1SisvYbxWsQkLZv+YCFat9zal88Rnvs7JXPK7t/Ew5jEGEVMXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742561615; c=relaxed/simple;
	bh=3aLWz7m5bQO6Grrmc5lx3lpImkHyq2qKsHCW+nhf4kM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WqvQ/V/42hHadv70FxZHUc4r681ujIr2W4tYNYjHsLreupf2SV+CSBtyFJ0FR2A2/H4y5yYnExlL9/kUMPc0NTPgPkMlm7aKrUDTL/wMPXNMEb8a1HGU+l1wr5Xczr5xO3uo5m35gs4arUqkxiDBJ5cJplJ3qek15a0ql7VO3g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lSQkqkXn; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IVNAMYWk; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lSQkqkXn";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IVNAMYWk"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6F1FC6036F; Fri, 21 Mar 2025 13:53:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742561610;
	bh=dAt2i+Qr2ytn/LtXucIrxJ6l8R/qMqlphOcBk+wlaDE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lSQkqkXnatOWyKQzw9rjaxkHnHVU0clgncwbtHW26+yCwWvQuAv3GuBBtXi4+yCJD
	 NGEJZFki8Zv87mlSIC+WHrGm8Nu6SGsa74wlxT/afqk2we1md8d4IyFH3tWGyquZBa
	 Wu7VcoVV0moNC1QKsjtdwVs/DrmSlVR7cLsBsS0/48LzjoCsR7U0ViLWmFjUdXD0ty
	 1KYI6OhYSQuH3VfvHFEm4GEhAH5eugPR2iKmd57iELs1B3A6bBBHWy3sL4HbhcXC7X
	 rz61yr4xaaqve88XD93jQFmwH+qi1hDckK4QrfamdAAxqW/r0eUNVBwlFGpN1bnfBR
	 xNSbNsj6reS5w==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C65796036F;
	Fri, 21 Mar 2025 13:53:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742561609;
	bh=dAt2i+Qr2ytn/LtXucIrxJ6l8R/qMqlphOcBk+wlaDE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IVNAMYWkvrt4a6eXh6Uv6yweLmTQxf76nTb3SwB+/FZEZH+X7Ih8IvcoX1Igeovob
	 YiR+EcWFPh7YAf16BvTXfXRW1Byw75spMWpyKAsnm7yedz1snge6rSD5qLN+5qv1Je
	 vqkXxKxy0JmOwF4TPLloZwrq9ubFGiA1F7KsMT6+2bXLk+pb6miTrioc8vcn9rVWB7
	 uKEEcJ2M/Skx7tkt8sktwR5sKhsI/oVMduZs2RnVhuyTKIBTcm1E04CGO7Y5x02c8h
	 mirLzZnSOFbCXUsDyf1A4B9GmT6DUYcg9xlvP9aYedhoZZgovbZMrYn5Q8jdWpMgsO
	 EfUWjbmUP6GOA==
Date: Fri, 21 Mar 2025 13:53:26 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: don't update cache for anonymous chains
Message-ID: <Z91hRuByR5QtstqP@calendula>
References: <20250321114641.9510-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250321114641.9510-1-fw@strlen.de>

On Fri, Mar 21, 2025 at 12:46:38PM +0100, Florian Westphal wrote:
> Chain lookup needs a name, not a numerical id.
> After patch, loading bogon gives following errors:
> 
> Error: No such file or directory chain c {
> Error: No symbol type information a b index 1 10.1.26.a
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/evaluate.c                                            | 3 +++
>  .../bogons/nft-f/null_deref_on_anon_chain_update_crash    | 8 ++++++++
>  2 files changed, 11 insertions(+)
>  create mode 100644 tests/shell/testcases/bogons/nft-f/null_deref_on_anon_chain_update_crash
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index a27961193da5..09df7f158acc 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -5371,6 +5371,9 @@ static int rule_cache_update(struct eval_ctx *ctx, enum cmd_ops op)
>  	if (!table)
>  		return table_not_found(ctx);
>  
> +	if (!rule->handle.chain.name)
> +		return chain_not_found(ctx);

rule_cache_update() is invoked because of index, which toggle
NFT_CACHE_UPDATE.

Maybe rule_cache_update() should be skipped for anonymous chain
instead? ie. return 0.

> +
>  	chain = chain_cache_find(table, rule->handle.chain.name);
>  	if (!chain)
>  		return chain_not_found(ctx);
> diff --git a/tests/shell/testcases/bogons/nft-f/null_deref_on_anon_chain_update_crash b/tests/shell/testcases/bogons/nft-f/null_deref_on_anon_chain_update_crash
> new file mode 100644
> index 000000000000..310486c59ee0
> --- /dev/null
> +++ b/tests/shell/testcases/bogons/nft-f/null_deref_on_anon_chain_update_crash
> @@ -0,0 +1,8 @@
> +table ip f {
> +        chain c {
> +                jump {
> +                        accept
> +                }
> +        }
> +}
> +a b index 1 10.1.26.a
> -- 
> 2.48.1
> 
> 
