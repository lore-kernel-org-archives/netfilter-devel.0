Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E07419F137
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Jun 2025 23:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749684599; cv=none; b=EIdjcblkwSG2ssQSm9ApIFmZvTRptWxfpLVVK5Wg/J2R5jfSF1ef0+ouK6Cz6VqkmcrLGEX0/BVNdMX0k7kL379gGy6A+0qbDRC8BTlHL0c9Rya1dw2Gidvi6g2j63nsPERjG7vKay8i5R51Poj4T10HlDYpnUckK6dmK9hrGAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749684599; c=relaxed/simple;
	bh=EVPap4nkscY6/IKjRxaICA2fYn5uWTXqYY50fXQxXOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B+fYYX2+m0nSHf2cehDAPVIt8+Z24wPtNYxUs7Fd3+vAkjVCVC81zFu+odKNg8FeQU0JcsozjsMN/dYU9w2kIs1f4oXs3vNRz6wPoAEcLjgFTyQIQawVLxU8FOrQtSmqrCQQVHysZuvx0J+/YmaeMmhiMxorfqPYCfTNj/RKSiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Ftwnao8A; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HMf8xsyZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Ftwnao8A";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HMf8xsyZ"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 997DB605F9; Thu, 12 Jun 2025 01:29:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749684593;
	bh=hiR0EhZ1F6hz1eTOKCWrxpyvXtnr3kn8/6iBOnsLYmA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ftwnao8AyljDRtHbkQLOugxUILxsLUT3zgVqagrxW1QocQVFgvE8lKurwwP9ibZtl
	 VlYHjMcYLfR0lTwCRO9Nl5keN3lS/4mf7TRlCqZgHaVEJ9s5nCknuW3AyaLhCKLYu8
	 Gp8BitMeAe8ZEpbWCJMhewYbxQKvz/nMtkKClnsIbKN/KYpOmQv0oMc8KB3O4hZ/ja
	 m6ovzhicZ5IptLMU7rBSlJcbIY3EtR0jc5lWnKr61s8dA704F7iz5BUsEIszEy4RHS
	 JSdOwLHJ3kgKTWsHlHPrh4AzZf+59VjKdC9w7NHqN+/BLvA8VfroNWYjs/VL+OsRlQ
	 gzcqKlrjI6Zag==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C3F6C605F9;
	Thu, 12 Jun 2025 01:29:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749684592;
	bh=hiR0EhZ1F6hz1eTOKCWrxpyvXtnr3kn8/6iBOnsLYmA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HMf8xsyZyyr8LknFWsUe5eoX6R+3oSlpd1B+JQYZuW2sy+LfyDVE5NpEB62L5cEa7
	 kgQo1q2rFuBqqxQmHq2eZgMB/O5lDkIMQf92wgsX5yfhLbYRjV4hI6alE6JgTTbkAH
	 CbM055hbF1u/eZ1jcP1V5YkWwcNcMF8lpOEDc5GsEicOYl+IXrA2SLuUu9Y/tlErZt
	 vkzEYMd8uG1lxQIDzMLK0WTRlyErFOnT97dpjW6CIw/iClv0OxNJkDC39pC/+sw3Pu
	 3+hShz40cOwLcrrxbAnS1lU9DXiAEcZjNNi3MmWUUgc2E6rKN8d5o2EfythS10rodD
	 u8R6B5yPxSRJg==
Date: Thu, 12 Jun 2025 01:29:50 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: fix crash when set name is null
Message-ID: <aEoRbjDUWw6lRyRy@calendula>
References: <20250606104152.7742-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250606104152.7742-1-fw@strlen.de>

On Fri, Jun 06, 2025 at 12:41:49PM +0200, Florian Westphal wrote:
> Bogon provides a handle but not a name.

No handle for delete map command:

                        |       SET             set_or_id_spec
                        {
                                $$ = cmd_alloc(CMD_DELETE, CMD_OBJ_SET, &$2, &@$, NULL);
                        }
                        |       MAP             set_spec
                                                ^^^^^^^^

This is incomplete:

f4a34d25f6d5 ("src: list set handle and delete set via set handle")

but this is also lacking handle support:

745e51d0b8f0 ("evaluate: remove set from cache on delete set command")

Then, reset command parser looks consistent:

83e0f4402fb7 ("Implement 'reset {set,map,element}' commands")

but cmd_evaluate_reset() calls cmd_evaluate_list() which cannot deal
with the handle.

Looking at delete command for other objects, same issue, eg.
chain_del_cache() also does not deal with this handle.

I think the way to go is to add another hashtable to look up for
object handles, I can post a patch for this purpose.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/cache.c                                            | 3 +++
>  src/evaluate.c                                         | 3 +++
>  tests/shell/testcases/bogons/nft-f/null_set_name_crash | 2 ++
>  3 files changed, 8 insertions(+)
>  create mode 100644 tests/shell/testcases/bogons/nft-f/null_set_name_crash
> 
> diff --git a/src/cache.c b/src/cache.c
> index 3ac819cf68fb..67ba35bee1fa 100644
> --- a/src/cache.c
> +++ b/src/cache.c
> @@ -840,6 +840,9 @@ struct set *set_cache_find(const struct table *table, const char *name)
>  	struct set *set;
>  	uint32_t hash;
>  
> +	if (!name)
> +		return NULL;
> +
>  	hash = djb_hash(name) % NFT_CACHE_HSIZE;
>  	list_for_each_entry(set, &table->set_cache.ht[hash], cache.hlist) {
>  		if (!strcmp(set->handle.set.name, name))
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 9c7f23cb080e..e8e4aa2df4ca 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -284,6 +284,9 @@ static int set_not_found(struct eval_ctx *ctx, const struct location *loc,
>  	const struct table *table;
>  	struct set *set;
>  
> +	if (!set_name)
> +		set_name = "";
> +
>  	set = set_lookup_fuzzy(set_name, &ctx->nft->cache, &table);
>  	if (set == NULL)
>  		return cmd_error(ctx, loc, "%s", strerror(ENOENT));
> diff --git a/tests/shell/testcases/bogons/nft-f/null_set_name_crash b/tests/shell/testcases/bogons/nft-f/null_set_name_crash
> new file mode 100644
> index 000000000000..e5d85b228a84
> --- /dev/null
> +++ b/tests/shell/testcases/bogons/nft-f/null_set_name_crash
> @@ -0,0 +1,2 @@
> +table y { }
> +reset set y handle 6
> -- 
> 2.49.0
> 
> 
