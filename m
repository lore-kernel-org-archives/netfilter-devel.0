Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2274558105
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Apr 2024 22:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712097788; cv=none; b=ZAEnnjP9wlMHXQ1Tkt9qR5RLINTobUdoB9z+vqdPn8J2+hcIP1+CPuXGlfolYWudcHMhhyxDb99IcmIbsx2bp3NvT6s9KRSAeC3JW4314bNrJjjVPYxf8rzR377exj4ontzHgA7oEXCde09oyfHDWBrqZVuXICKzfVJ6DS0zAeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712097788; c=relaxed/simple;
	bh=zxf39aOWY8yF7/8B1Z1FLXZpgmNMkRhQXRDWNcstJ9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UQg/jn+3r6wvpcJ+lcizlue5Db+aQKpGbucEQcQG0wYfJRBHr4tNgfWA4Ab73q+7fWKFNu7gXgU81g9J4LYvHFaIlrvyUjYw5DGWjeqyXZ4go4DW0/bsLaEsqMjEsyRV8pAm/OHHNXWKNGKZk/ePTSVY9U6KYBi9jnPTqwJ6usc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Wed, 3 Apr 2024 00:42:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables] evaluate: add support for variables in map
 expressions
Message-ID: <ZgyJ8yUi8CyOpEHX@calendula>
References: <20240324145908.2643098-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240324145908.2643098-1-jeremy@azazel.net>

On Sun, Mar 24, 2024 at 02:59:07PM +0000, Jeremy Sowden wrote:
> It is possible to use a variable to initialize a map, which is then used in a
> map statement:
> 
>   define m = { ::1234 : 5678 }
> 
>   table ip6 nat {
>     map m {
>       typeof ip6 daddr : tcp dport;
>       elements = $m
>     }
>     chain prerouting {
>       ip6 nexthdr tcp redirect to ip6 daddr map @m
>     }
>   }
> 
> However, if one tries to use the variable directly in the statement:
> 
>   define m = { ::1234 : 5678 }
> 
>   table ip6 nat {
>     chain prerouting {
>       ip6 nexthdr tcp redirect to ip6 daddr map $m
>     }
>   }
> 
> nft rejects it:
> 
>   /space/azazel/tmp/ruleset.1067161.nft:5:47-48: Error: invalid mapping expression variable
>       ip6 nexthdr tcp redirect to ip6 daddr map $m
>                                   ~~~~~~~~~     ^^
> 
> Extend `expr_evaluate_map` to allow it.
> 
> Add a test-case.

Thanks for your patch.

> Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1067161
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  src/evaluate.c                                |  1 +
>  .../shell/testcases/maps/anonymous_snat_map_1 | 16 +++++
>  .../maps/dumps/anonymous_snat_map_1.json-nft  | 58 +++++++++++++++++++
>  .../maps/dumps/anonymous_snat_map_1.nft       |  5 ++
>  4 files changed, 80 insertions(+)
>  create mode 100755 tests/shell/testcases/maps/anonymous_snat_map_1
>  create mode 100644 tests/shell/testcases/maps/dumps/anonymous_snat_map_1.json-nft
>  create mode 100644 tests/shell/testcases/maps/dumps/anonymous_snat_map_1.nft
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 1682ba58989e..d49213f8d6bd 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -2061,6 +2061,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)

expr_evaluate_objmap() also needs a similar fix.

>  	mappings->set_flags |= NFT_SET_MAP;
>  
>  	switch (map->mappings->etype) {
> +	case EXPR_VARIABLE:
>  	case EXPR_SET:
>  		if (ctx->ectx.key && ctx->ectx.key->etype == EXPR_CONCAT) {
>  			key = expr_clone(ctx->ectx.key);
