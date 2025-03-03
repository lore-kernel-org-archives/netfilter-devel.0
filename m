Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96AB2C181
	for <netfilter-devel@vger.kernel.org>; Mon,  3 Mar 2025 01:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740966339; cv=none; b=l2K/6f3OmBkFw88Oax31sj/u+LYAOdsqLd6Asv/rqtBC2K3+Dty6tDhD4MbR5S4+M2nmWHGbvYsBX1mQhlSz98cGzyi2aP1D5uwXqX+uCQRJFz79Ugf1C0ycbe+C/dSCJTT69tc7gp4rgLDjJ2bFMaOqmLmQTFJDf/lrjpPYkhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740966339; c=relaxed/simple;
	bh=CLewMQAgbYVDnIProV9VYg3K5rXFn7tbZ3iOiTaPX9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IPkSevkn9itRIi9FfODX/Wzua6h65e86b2lFEPx3Rj+HlUHiZ0DVKXHKAJ75FU6Y6G92L586033tMZ21U/Y6KS5zrS+HLfNJFogx4rTla3Rk13P4OTquJUPEVaDWYaP8qg6ctgjWzqMN9Kf3D7C0liqC0waubmzcAtAEQAq1rdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tous3-0004y6-9B; Mon, 03 Mar 2025 02:45:27 +0100
Date: Mon, 3 Mar 2025 02:45:27 +0100
From: Florian Westphal <fw@strlen.de>
To: Anton Moryakov <ant.v.moryakov@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] src: fix deref of null.ret in rule.c
Message-ID: <20250303014527.GA18770@breakpoint.cc>
References: <20250302194435.666393-1-ant.v.moryakov@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250302194435.666393-1-ant.v.moryakov@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Anton Moryakov <ant.v.moryakov@gmail.com> wrote:
> Fix potential null pointer dereference in `do_list_flowtable`.
> 
> The pointer `table` is initialized to NULL and passed to `do_list_flowtable`,
> where it may be dereferenced. This can lead to a crash if `table` remains NULL.
> 
> Changes:
> - Added a NULL check for the `table` pointer before calling `do_list_flowtable`.
> - Return an error code (-1) if `table` is NULL to handle the case where the table is not found.

This changelog doesn't match the patch.

> index f7582914..59d3f3ac 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -1556,7 +1556,7 @@ static int do_delete_setelems(struct netlink_ctx *ctx, struct cmd *cmd)
>  	const struct set *set = cmd->elem.set;
>  	struct expr *expr = cmd->elem.expr;
>  
> -	if (set_is_non_concat_range(set) &&
> +	if (set && set_is_non_concat_range(set) &&
>  	    set_to_intervals(set, expr, false) < 0)
>  		return -1;

You need to explain how "set" can be NULL here.

This gets allocated in nft_cmd_expand, where set was
already dereferenced.

