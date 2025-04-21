Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC9EC2ED
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Apr 2025 18:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745260673; cv=none; b=oCJs9EpbaErUs9hxMaHFHV9QDTvOLlJgHXBVQt7X0hGN7ZDGOC+cg9qgT1AscvVPyU6JqiGnsYE/+f1KGh3hJWDaEOx9YqqZ00IsNxlbCWqmiwFKzzy6Mzm4in8Mii1Yp6g75M2xa8CbIusiK+/GG/h0VyebW226Gg7OkjrOVnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745260673; c=relaxed/simple;
	bh=D70XntGS5zLUj1WifpsDsmvvZSoFq6IsApQmencUKQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qqrjox/lw27sLvEMD+bd6f2d22G8jnaxL3w32+UdatJY1h0AoyioXDgA25U51OLsy8zWnskw0PUj/wUG+PReFw6KY1nHk8Bj4kIbS+pPCZxXxVpUuLaT/snKtNZHF2mbESub3rUXPzZ3X1NGpHO5HATDYtbR4YmdUl/2y98lSSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PGrORw02; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=F+J76eeN; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PGrORw02";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="F+J76eeN"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 7CF5B6038C; Mon, 21 Apr 2025 20:37:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745260661;
	bh=Jqm4UhUQECkpxLNkZwvnmtdG/3sioHow8F6tDaaVH2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PGrORw02/tEUB+v19NEA4edLDmWwPrOTR4D2l/LZC4MyNIUoUtoiNOfI7p0zwibXY
	 3vtpAfgs4c7xQFjF4Ld/y8dEvHvQMEJ1f7qjN/TvN95HjAWsUNbdwMvbd0SOQMYYYT
	 2WEm1NzWXc8hNTkh5N1G38xhxePArEt4uSW92vGUZ3UXPG6PTpBWiA2+b31hXHPPcU
	 pu1bh15FKSAIdn4XXDdKwmLImBt1SUWTM15yBySiDl6gGTGTgSlsWfEPiKPV9ygosE
	 2KI37QfjwzE+MCIo2ED18U/d/rzf5hyN1QQGQZUEylf3JjFxTMHcvXeW5gMLl/lhzN
	 yfz1Db3+OYz6Q==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4909A6031E;
	Mon, 21 Apr 2025 20:37:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745260660;
	bh=Jqm4UhUQECkpxLNkZwvnmtdG/3sioHow8F6tDaaVH2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F+J76eeNzkYjjaFeIZCBAcpQBGnBUj+uXOgKQFaiGCHSFid09m2gRq01/hUY80ypq
	 enNxuZSLHz6bHtQjMcXqPXj5xbUx/xBdfr2+X7CEZSuXU8QoV8tUIG/Fmu0fLmlCpC
	 GCSsvqosbSSfexwxcJGDcczZthXfjFv973r9VA8lOvbmQApGUne7MakVdsxuINpsRI
	 CZlyouHoXXGchyJBLmC/wNnhN4g5c4cDPD09jpZqvyVU1Wb1aGTEx84mSnQ6o6I0XB
	 Yi66qAFbmkB4Rm+dZlUxBVStMgF0spLdd+0Tza6qlJgFqTg+3Yh2dXJ7d23mJAac02
	 m4E7lD8zyNyzQ==
Date: Mon, 21 Apr 2025 20:37:37 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Kevin Vigouroux <ke.vigouroux@laposte.net>
Subject: Re: [PATCH nft] evalute: make vlan pcp updates work
Message-ID: <aAaQcZdvH76tVvh_@calendula>
References: <20250419114442.45696-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250419114442.45696-1-fw@strlen.de>

On Sat, Apr 19, 2025 at 01:44:39PM +0200, Florian Westphal wrote:
> On kernel side, nft_payload_set_vlan() requires a 2 or 4 byte
> write to the vlan header.
> 
> As-is, nft emits a 1 byte write:
>   [ payload load 1b @ link header + 14 => reg 1 ]
>   [ bitwise reg 1 = ( reg 1 & 0x0000001f ) ^ 0x00000020 ]
> 
> ... which the kernel doesn't support.  Expand all vlan header updates to
> a 2 or 4 byte write and update the existing vlan id test case.
> 
> Reported-by: Kevin Vigouroux <ke.vigouroux@laposte.net>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks

> ---
>  src/evaluate.c                                | 42 +++++++++++++++++--
>  .../shell/testcases/packetpath/vlan_mangling  |  2 +
>  2 files changed, 40 insertions(+), 4 deletions(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index d13b11413244..9c7f23cb080e 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -3258,6 +3258,40 @@ static bool stmt_evaluate_payload_need_csum(const struct expr *payload)
>  	return desc && desc->checksum_key;
>  }
>  
> +static bool stmt_evaluate_is_vlan(const struct expr *payload)
> +{
> +	return payload->payload.base == PROTO_BASE_LL_HDR &&
> +	       payload->payload.desc == &proto_vlan;
> +}
> +
> +/** stmt_evaluate_payload_need_aligned_fetch
> + *
> + * @payload:	payload expression to check
> + *
> + * Some types of stores need to round up to an even sized byte length,
> + * typically 1 -> 2 or 3 -> 4 bytes.
> + *
> + * This includes anything that needs inet checksum fixups and also writes
> + * to the vlan header.  This is because of VLAN header removal in the
> + * kernel: nftables kernel side provides illusion of a linear packet, i.e.
> + * ethernet_header|vlan_header|network_header.
> + *
> + * When a write to the vlan header is performed, kernel side updates the
> + * pseudoheader, but only accepts 2 or 4 byte writes to vlan proto/TCI.
> + *
> + * Return true if load needs to be expanded to cover even amount of bytes
> + */
> +static bool stmt_evaluate_payload_need_aligned_fetch(const struct expr *payload)
> +{
> +	if (stmt_evaluate_payload_need_csum(payload))
> +		return true;
> +
> +	if (stmt_evaluate_is_vlan(payload))
> +		return true;
> +
> +	return false;
> +}
> +
>  static int stmt_evaluate_exthdr(struct eval_ctx *ctx, struct stmt *stmt)
>  {
>  	struct expr *exthdr;
> @@ -3287,7 +3321,7 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
>  	unsigned int masklen, extra_len = 0;
>  	struct expr *payload;
>  	mpz_t bitmask, ff;
> -	bool need_csum;
> +	bool aligned_fetch;
>  
>  	if (stmt->payload.expr->payload.inner_desc) {
>  		return expr_error(ctx->msgs, stmt->payload.expr,
> @@ -3310,7 +3344,7 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
>  	if (stmt->payload.val->etype == EXPR_RANGE)
>  		return stmt_error_range(ctx, stmt, stmt->payload.val);
>  
> -	need_csum = stmt_evaluate_payload_need_csum(payload);
> +	aligned_fetch = stmt_evaluate_payload_need_aligned_fetch(payload);
>  
>  	if (!payload_needs_adjustment(payload)) {
>  
> @@ -3318,7 +3352,7 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
>  		 * update checksum and the length is not even because
>  		 * kernel checksum functions cannot deal with odd lengths.
>  		 */
> -		if (!need_csum || ((payload->len / BITS_PER_BYTE) & 1) == 0)
> +		if (!aligned_fetch || ((payload->len / BITS_PER_BYTE) & 1) == 0)
>  			return 0;
>  	}
>  
> @@ -3334,7 +3368,7 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
>  				  "uneven load cannot span more than %u bytes, got %u",
>  				  sizeof(data), payload_byte_size);
>  
> -	if (need_csum && payload_byte_size & 1) {
> +	if (aligned_fetch && payload_byte_size & 1) {
>  		payload_byte_size++;
>  
>  		if (payload_byte_offset & 1) { /* prefer 16bit aligned fetch */
> diff --git a/tests/shell/testcases/packetpath/vlan_mangling b/tests/shell/testcases/packetpath/vlan_mangling
> index e3fd443ebcf9..3fc2ebb2a517 100755
> --- a/tests/shell/testcases/packetpath/vlan_mangling
> +++ b/tests/shell/testcases/packetpath/vlan_mangling
> @@ -48,12 +48,14 @@ table netdev t {
>  
>  	chain in {
>  		type filter hook ingress device veth0 priority filter;
> +		vlan pcp 0 counter
>  		ether saddr da:d3:00:01:02:03 vlan id 123 jump in_update_vlan
>  	}
>  
>  	chain out_update_vlan {
>  		vlan type arp vlan id set 123 counter
>  		ip daddr 10.1.1.1 icmp type echo-reply vlan id set 123 counter
> +		vlan pcp set 6 counter
>  	}
>  
>  	chain out {
> -- 
> 2.49.0
> 
> 
