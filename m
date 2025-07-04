Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9872C3265
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 11:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751630060; cv=none; b=bFrYBK08DRXWNnzVOOVjJe/mphe4mFTKGkfQxzxePG0sRbGt+CpT7PQNUwozNxJ80U0012ktQ6ZV9m5TtPJ2tqPoPAR5l95fi9ATPPZVJIrVOOpeUMM6aUG1gcAyxHBRjm2di74+kmlqOwM6/MjdJOwRrFRxoGb/ofgJlJ4QaPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751630060; c=relaxed/simple;
	bh=CGuQdoBpPztjicPi+bE5b+IiQ1sQ5Dd0ctayad8Geu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F6nkML/DGdmZF21YU0bPUk2/cScdhVTvFRvI0YReki8wNolf9CIu+nBsGIpZDKp3HuWclX1jkPy2x3kukK3MuhkOpIL9XSFriV9RvyR0qe5UZxjXXIncopvO11y5/UlG4vuHt+ULpconVjRVzdahT5iEswpLHxt9AVDMAnls4dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 03AC660491; Fri,  4 Jul 2025 13:54:15 +0200 (CEST)
Date: Fri, 4 Jul 2025 13:54:15 +0200
From: Florian Westphal <fw@strlen.de>
To: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Simon Horman <horms@kernel.org>,
	Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: Re: [PATCH nft 3/3] src: only print the mss and wscale of synproxy
 if they are present
Message-ID: <aGfA5_aH6QT5z_rf@strlen.de>
References: <20250704113947.676-1-dzq.aishenghu0@gmail.com>
 <20250704113947.676-4-dzq.aishenghu0@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250704113947.676-4-dzq.aishenghu0@gmail.com>

Zhongqiu Duan <dzq.aishenghu0@gmail.com> wrote:
> The listing of the synproxy statement will print a zero value
> for unpresented fields.
> 
> e.g., the rule add by `nft add rule inet t c synproxy wscale 8 sack-perm`
> will print as 'synproxy mss 0 wscale 8 sack-perm'.
> 
> Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
> ---
>  src/statement.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/statement.c b/src/statement.c
> index 695b57a6cc65..ced002f63115 100644
> --- a/src/statement.c
> +++ b/src/statement.c
> @@ -1058,7 +1058,7 @@ static void synproxy_stmt_print(const struct stmt *stmt,
>  	const char *ts_str = synproxy_timestamp_to_str(flags);
>  	const char *sack_str = synproxy_sack_to_str(flags);
>  
> -	if (flags & (NF_SYNPROXY_OPT_MSS | NF_SYNPROXY_OPT_WSCALE))
> +	if ((flags & NF_SYNPROXY_OPT_MSS) && (flags & NF_SYNPROXY_OPT_WSCALE))
>  		nft_print(octx, "synproxy mss %u wscale %u%s%s",
>  			  stmt->synproxy.mss, stmt->synproxy.wscale,
>  			  ts_str, sack_str);

This looks wrong, this will now only print it if both are set.
