Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111E89476
	for <netfilter-devel@vger.kernel.org>; Sat, 22 Mar 2025 22:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742681880; cv=none; b=pa/44Rgr3TdrvS+PjPvMASeXKUkdVAT8SO20WdrYrlcSJYG9onVF2RvT3xH0AXXW7YCAEXAdLQu/I/6xust4/wqYWFHZsOD+wUB8QVSOK1sFssuT9LtlSBDe379LdZtktY6m0Yj491irF+3rlXI4Joq7dGIKse1WqheGpwxT2zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742681880; c=relaxed/simple;
	bh=Jg6RHcSnVEsuPJVFDCmnzgK4KUMs5wL/WxF5+kvSXPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nOXMrBAl58fq6vMivw+IhltPWjRnYfpLIRcu9ajcEzeAWo8vGTEIMOnUEzhvy5pb5JrxDh7f1wJkG3yPydQGpBMb58UBaJI/Ozvk/vlMRhtkvEZASHTjMKXsE0MYnB2nfblI0VpOCB1gz8pi41TA6uw8Q+OiCLawgK4ksoLDcGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WPJZ7qRT; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AniBBSF9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WPJZ7qRT";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AniBBSF9"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 250C560394; Sat, 22 Mar 2025 23:17:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742681875;
	bh=aiO2eTwFAuB3LvtPwzTM6hGo2iFbPGJUz7dKcjI1/0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WPJZ7qRTdI8Kno2VKzUiUIRY7dVIaRuGAASJDSVVGNlupClsX9GrcbjKqFnoWlFyF
	 HAbwfrfAVxBfEKjwV3EcT0BIRNBwEXG8ItYM6P5hhmx62a7vQGREfd542G5spRR7Hk
	 mq5eSUfRPmplcEZ7vJ+Zf+qoQYz3L6fc9EYsAkns8CYw0EKRQ6i1w+8w33HkxamJbk
	 feVo2pwGX3fX92mAZs1Uw/yx/nhsNQaC4LJlRF7k0ydZGLRq49LtatbbLiMohaQYXJ
	 OAfAvS15uvSX/USrPpeR+6oybYzAP6L4Nk//yFH1N5W3anZn6HemHandLQwVgjRbuL
	 moLe+Deelx10Q==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 60E0A60391;
	Sat, 22 Mar 2025 23:17:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742681874;
	bh=aiO2eTwFAuB3LvtPwzTM6hGo2iFbPGJUz7dKcjI1/0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AniBBSF9+Y5R6dl01JJm7z7zCgOMXFX+dxooy5Jm65k/bVoVwR6eY7lbEgOFBPN88
	 cm5A3RXhzhn1UP13P9kkVUdLA71OxDYrbvjQM2Kvwp7FenEzCBXNX+PueeamDjG17Z
	 ygf0C5igQJAtdN7yRCzeyPyk46+q5lIwDetJZYR3sZL3lhqbm0/RX7Owx7NyQx1g8o
	 BEtpoDQ0Qt28nclbnZSUoUEenaXjEJJiUmM1WfQ9+UArnmYTjtqJeKk4AhQzvFsDYY
	 35g4p/6/9yHy26AFxwn50qEAHqxzwiwXrk05z1Omg/04O+px3MVqAeGfII3qkWgDB9
	 H4wu43g1no78A==
Date: Sat, 22 Mar 2025 23:17:51 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2] evaluate: don't update cache for anonymous chains
Message-ID: <Z983D9qBbJHOdkHm@calendula>
References: <20250321143008.7980-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250321143008.7980-1-fw@strlen.de>

On Fri, Mar 21, 2025 at 03:30:05PM +0100, Florian Westphal wrote:
> Chain lookup needs a name, not a numerical id.

Thanks for this v2.

> After patch, loading bogon gives following errors:
> 
> Error: No symbol type information a b index 1 10.1.26.a
> 
> v2: Don't return an error, just make it a no-op (Pablo Neira Ayuso)

Fixes: c330152b7f77 ("src: support for implicit chain bindings")

I suggest to modify the comment below before you apply:

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/evaluate.c                                            | 7 +++++++
>  .../bogons/nft-f/null_deref_on_anon_chain_update_crash    | 8 ++++++++
>  2 files changed, 15 insertions(+)
>  create mode 100644 tests/shell/testcases/bogons/nft-f/null_deref_on_anon_chain_update_crash
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index a27961193da5..26aa0ef53241 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -5371,6 +5371,13 @@ static int rule_cache_update(struct eval_ctx *ctx, enum cmd_ops op)
>  	if (!table)
>  		return table_not_found(ctx);
>  
> +	/* chain is anonymous: no update needed, rules cannot be added
> +	 * or removed from anon chains after the chain was committed to
> +	 * kernel.
> +	 */

I suggest this comment:

        /* chain is anonymous, adding new rules via index is not supported. */

note that this bogon test you provide is actually putting everything
in the same transaction. Your comment regarding kernel behaviour is
correct, but it does not apply to rule_cache_update(). The issue is
that rule_cache_update() does not need to update the cache if this
chain is anonymous.

Thanks.

> +	if (!rule->handle.chain.name)
> +		return 0;
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
