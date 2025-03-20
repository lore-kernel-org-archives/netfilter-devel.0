Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A1421CA00
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 17:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742492268; cv=none; b=n9Fv2AJ9x0izSafkteI2DjfVQ6ODiiT40Fvw8pOcImM8kOoi/KNpY0JJkizExYS6I7YaLAsNSZX6QdjFFLBQw+d+THUMKKqwbo1HACNu4bCAW5JlP8K6k/TZDa9RsdC16G++QOiquG8DIbAYxgg25qIrmr/rwaC8IzkAIPwtZiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742492268; c=relaxed/simple;
	bh=l4qxWog+hfLGF3bvqlukd21jm5habpECW0/3lEu4Lk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oXbVve8N2QRG7pI6Zwmm+ATSJlk9RCIHjLl7f93phtzQzwQJ5e9Z2+OofccaVM5RaHH/GP99+xFbWVx0/S3ZpqydfMiwQJAZ9pN/CrSEtJVu8YaDYCJb5vyIefrHsS+VRn5/Vw0CxuLgqbV4By7JNsEtbThqLkuqmoMPRyNWpDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gscEtzkW; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TcL5m7qU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gscEtzkW";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TcL5m7qU"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id F3BB3603A9; Thu, 20 Mar 2025 18:37:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742492258;
	bh=NfstR9fKGaIncqixHV4wSqQ2dy3/G379ZOJ1EEOgqik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gscEtzkW9WIOPFa8jZIk9+3ARj9bdJqi4O3IRbIo6VSAK5iyU9kicr2NEQHyXL02X
	 lfFcYEmQaKDW1XTfSA4Es3dyllcKGdRG3EHvjyeWeNfwpWwu7njDgOeJgrvUZUPRCk
	 8qWGutd/JOFaN005VKVhVfy3Ub1Ef47IDZTZX7StN/HsUHFfQb/db/F6XDylAmvEDg
	 Kh6x5WoK5l0z0dSSDkgTHmDn6ndlYvwgsmuKpC5Sfn+SOq3SQmsmgusefC9GYSdjLw
	 E0UMMXXntca0Ea3xaqSMd4EF/OqvZrWNmHLCBuMblwodLRzR/iYsYMQGGGGOTK5vKS
	 8gCmsZMORVxBA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5AD44603A4;
	Thu, 20 Mar 2025 18:37:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742492253;
	bh=NfstR9fKGaIncqixHV4wSqQ2dy3/G379ZOJ1EEOgqik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TcL5m7qUfU8/5Pggr/U/QFvBWAcD5S7sNKteRSHmOv+bW8Vpzym6pVv3UlgmfzNwD
	 OsSCftrydJHQdAFK44H/1TwJmwOCNBuNL/GzCF+RPPsZpFDTwUV7mXqt8kACwuawpG
	 FBxNQRFVM6Xpy7VSfG8CTUFhLLbMUTfUoxst3ZrDdeEML9bQ8w8UVJKyvhPAr9wSP4
	 BhT3Q9A3e2Vwp623nGGe/Vp3d8t50X4HQK74PJ3gBP5OmXwdvC5YuGBTuS8L0yHOEz
	 o+gOGRT04NhWDwY3YuwzgwvB7onDHrTZ6bVjftQ1hurdI6DjFV037a3r4iwxGPuuaV
	 f1xVagCPhU2WQ==
Date: Thu, 20 Mar 2025 18:37:30 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] rule: return error if table does not exist
Message-ID: <Z9xSWqE-2S_SX52I@calendula>
References: <20250320133145.31833-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250320133145.31833-1-fw@strlen.de>

On Thu, Mar 20, 2025 at 02:31:42PM +0100, Florian Westphal wrote:
> The bogon triggers segfault due to NULL dereference.  Error out and set
> errno to ENOENT; caller uses strerror() in the errmsg.
> 
> After fix, loading reproducer results in:
> /tmp/A:2:1-18: Error: Could not process rule: No such file or directory
> list table inet p
> ^^^^^^^^^^^^^^^^^^
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.

> ---
>  src/rule.c                                                | 8 +++++++-
>  .../testcases/bogons/nft-f/list_a_deleted_table_crash     | 3 +++
>  2 files changed, 10 insertions(+), 1 deletion(-)
>  create mode 100644 tests/shell/testcases/bogons/nft-f/list_a_deleted_table_crash
> 
> diff --git a/src/rule.c b/src/rule.c
> index 3edfa4715853..00fbbc4c080a 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -2380,10 +2380,16 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
>  	if (nft_output_json(&ctx->nft->output))
>  		return do_command_list_json(ctx, cmd);
>  
> -	if (cmd->handle.table.name != NULL)
> +	if (cmd->handle.table.name != NULL) {
>  		table = table_cache_find(&ctx->nft->cache.table_cache,
>  					 cmd->handle.table.name,
>  					 cmd->handle.family);
> +		if (!table) {
> +			errno = ENOENT;
> +			return -1;
> +		}
> +	}
> +
>  	switch (cmd->obj) {
>  	case CMD_OBJ_TABLE:
>  		if (!cmd->handle.table.name)
> diff --git a/tests/shell/testcases/bogons/nft-f/list_a_deleted_table_crash b/tests/shell/testcases/bogons/nft-f/list_a_deleted_table_crash
> new file mode 100644
> index 000000000000..b802430bb6cc
> --- /dev/null
> +++ b/tests/shell/testcases/bogons/nft-f/list_a_deleted_table_crash
> @@ -0,0 +1,3 @@
> +table inet p
> +list table inet p
> +delete  table inet p
> -- 
> 2.48.1
> 
> 
