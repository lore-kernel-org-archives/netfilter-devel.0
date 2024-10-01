Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D361CEADA
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Oct 2024 18:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727808382; cv=none; b=AsVTDmRyYTMg2W/JTH/V/yhaMzQq5K4Rh9O7tSSLxD6Vx14AvfkMGUu4QNKJbSIJ0bxoD2JJLFd4DMpWUHRKfyQwq7L0nJUVB3Xu0lLDlKkMxMRz+HDFi5LZ8SIA4HULZIyHsdJsgPvwAHXua3aIdRhQcQJUGO4NkubEVJd6WK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727808382; c=relaxed/simple;
	bh=drmq/sc8sAWgVxzinrDYW2tNvq2tqAXWsGlXLwwd7/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gzSpfooxd+/g7p86FRzpvCKBGwekAERMwSKjnt//jzJkQ1DngWy28/Uh5mIAPusYzwewg5PTvf47WvBc+v88tIXR+Ta8Bv4WU3ADAsBbC6/Bw0jWkbGFbXvvNoSz1pyo5eZr+Kqu1Mby+ioA9IpyoMeMRg8MqGcGILzMx7ZE3HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=59880 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1svhsz-00AEr2-CL; Tue, 01 Oct 2024 20:46:15 +0200
Date: Tue, 1 Oct 2024 20:46:12 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] rule: Don't append a newline when printing a
 rule
Message-ID: <ZvxDdJzlL5JpyG2t@calendula>
References: <20241001175034.14037-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241001175034.14037-1-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

On Tue, Oct 01, 2024 at 07:45:22PM +0200, Phil Sutter wrote:
> Since commit c759027a526ac, printed rules may or may not end with a
> newline depending on whether userdata was present or not. Deal with this
> inconsistency by avoiding the trailing newline in all cases.

LGTM, thanks Phil.

> Fixes: c759027a526ac ("rule, set_elem: remove trailing \n in userdata snprintf")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> This supersedes the previous patch with subject: Partially revert "rule,
> set_elem: remove trailing \n in userdata snprintf" by solving the
> problem in the opposite direction. As correctly assessed by Pablo, this
> way is consistent with other printers.
> 
> I tested the change with nftables and iptables testsuites. It breaks a
> single test in the latter which compares full ruleset debug output
> against a record. To fix that, one could just pass --ignore-blank-lines
> parameter to the diff call.
> ---
>  src/rule.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/src/rule.c b/src/rule.c
> index 811d5a213f835..c22918a8f3527 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -573,23 +573,21 @@ static int nftnl_rule_snprintf_default(char *buf, size_t remain,
>  		sep = " ";
>  	}
>  
> -	ret = snprintf(buf + offset, remain, "\n");
> -	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
> -
>  	list_for_each_entry(expr, &r->expr_list, head) {
> -		ret = snprintf(buf + offset, remain, "  [ %s ", expr->ops->name);
> +		ret = snprintf(buf + offset, remain,
> +			       "\n  [ %s ", expr->ops->name);
>  		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>  
>  		ret = nftnl_expr_snprintf(buf + offset, remain, expr,
>  					     type, flags);
>  		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>  
> -		ret = snprintf(buf + offset, remain, "]\n");
> +		ret = snprintf(buf + offset, remain, "]");
>  		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>  	}
>  
>  	if (r->user.len) {
> -		ret = snprintf(buf + offset, remain, "  userdata = { ");
> +		ret = snprintf(buf + offset, remain, "\n  userdata = { ");
>  		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>  
>  		for (i = 0; i < r->user.len; i++) {
> -- 
> 2.43.0
> 
