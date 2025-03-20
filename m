Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C783B22256C
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 09:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742463276; cv=none; b=UuZl4ZEpdDbPOXSsucXg7NZwBND+ryT7C0qt4zVJW4TU1DijJSTPNCoD9BsKWBy3vtq5QdUunTa0BlHTcfvPzMepq4CMnUDhjKM3+OvHzGhnmOMRZm9MOLaO/jKbKn6MyQog40kUIOyrHzYDLwGFEVGj0WVx7J9+BiFKLauH2S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742463276; c=relaxed/simple;
	bh=xQAGojUc7VWbvZNwGUh0Pl56BSCducBw7+kKb0TI9t8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=utW7oyx9Ww4C7pPFomhETmz9HAjnpAdlqtHevAX1dUQXIJtpfGK1R+qfjCXESOD52TPfPbfdDgDQIFhqoC85T565pbgPxfSbaHToPOnF3WO3WuMxVDNtitgAsQFBkhg1ruou5YOECVQ5B+j+CkpRFdI6qSZYkm7QUvvqcmTpEmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ILL7mJtE; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ILL7mJtE; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ILL7mJtE";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ILL7mJtE"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E920B6039D; Thu, 20 Mar 2025 10:34:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742463267;
	bh=uy8UHaHwsqe48gOAS/9NSwlDP/eVAVl+pbSqh0kkDwY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ILL7mJtERVmoDVDo44LUT0S5q8Df1o8Ic87i5nWA0rpFQHBYxcFoxK3b+rMzxRRPy
	 Y0KH52A9yqEOcnnRwjh73stpzbaQhiqOlYMW5rns7unK1tS/pGFm5z9KNVWsZfPfDg
	 cUMeNUtc72CznBJk6eRA2zq6xeP8fkpFoKnVT7qzih4EDCV8vE5WqZoBx/sW5mzs4b
	 7LlxZdf3l+MXK1m5UyeF27+GtiNDMCo5BaD2aaIn5IPtmjDy1EfuETU59eq90MnfT+
	 4/TYjc+K6KNjFLpNuzNOxJAk/NhfDvVOkK20OU1ITRRwbbldvphxmO9SOhzBnwCx80
	 CXcVOnjM5SJ5A==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 431BD6038E;
	Thu, 20 Mar 2025 10:34:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742463267;
	bh=uy8UHaHwsqe48gOAS/9NSwlDP/eVAVl+pbSqh0kkDwY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ILL7mJtERVmoDVDo44LUT0S5q8Df1o8Ic87i5nWA0rpFQHBYxcFoxK3b+rMzxRRPy
	 Y0KH52A9yqEOcnnRwjh73stpzbaQhiqOlYMW5rns7unK1tS/pGFm5z9KNVWsZfPfDg
	 cUMeNUtc72CznBJk6eRA2zq6xeP8fkpFoKnVT7qzih4EDCV8vE5WqZoBx/sW5mzs4b
	 7LlxZdf3l+MXK1m5UyeF27+GtiNDMCo5BaD2aaIn5IPtmjDy1EfuETU59eq90MnfT+
	 4/TYjc+K6KNjFLpNuzNOxJAk/NhfDvVOkK20OU1ITRRwbbldvphxmO9SOhzBnwCx80
	 CXcVOnjM5SJ5A==
Date: Thu, 20 Mar 2025 10:34:24 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: don't allow nat map with specified protocol
Message-ID: <Z9vhIHU9pp4mMe8I@calendula>
References: <20250320083944.12541-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250320083944.12541-1-fw@strlen.de>

On Thu, Mar 20, 2025 at 09:39:20AM +0100, Florian Westphal wrote:
> Included bogon asserts:
> src/netlink_linearize.c:1305: netlink_gen_nat_stmt: Assertion `stmt->nat.proto == NULL' failed.
> 
> The comment right above the assertion says:
>   nat_stmt evaluation step doesn't allow
>   STMT_NAT_F_CONCAT && stmt->nat.proto.

Oops.

> ... except it does allow it.  Disable this.
> 
> Fixes: c68314dd4263 ("src: infer NAT mapping with concatenation from set")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.

> ---
>  src/evaluate.c                                           | 4 ++++
>  tests/shell/testcases/bogons/nat_map_and_protocol_assert | 5 +++++
>  2 files changed, 9 insertions(+)
>  create mode 100644 tests/shell/testcases/bogons/nat_map_and_protocol_assert
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 95b9b3d547d9..3a453d010538 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -4196,6 +4196,10 @@ static int stmt_evaluate_nat_map(struct eval_ctx *ctx, struct stmt *stmt)
>  	int addr_type;
>  	int err;
>  
> +	if (stmt->nat.proto)
> +		return stmt_binary_error(ctx, stmt, stmt->nat.proto,
> +				  "nat map and protocol are mutually exclusive");
> +
>  	if (stmt->nat.family == NFPROTO_INET)
>  		expr_family_infer(pctx, stmt->nat.addr, &stmt->nat.family);
>  
> diff --git a/tests/shell/testcases/bogons/nat_map_and_protocol_assert b/tests/shell/testcases/bogons/nat_map_and_protocol_assert
> new file mode 100644
> index 000000000000..67f2ae873cd1
> --- /dev/null
> +++ b/tests/shell/testcases/bogons/nat_map_and_protocol_assert
> @@ -0,0 +1,5 @@
> +table t {
> + chain y {
> +  snat to ip saddr . tcp sport map { 1.1.1.1 . 1 : 1.1.1.2 . 1 } : 6
> + }
> +}
> -- 
> 2.48.1
> 
> 
