Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFF01BF7FF
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Oct 2024 11:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727781854; cv=none; b=QLbrB8OCsDXCYZVsZdQbrpHr0GbpGjq6PIfVXuCnru0eqS3djqb+tBW2mqq0dUnRFaaPEY4Dh+K75OW9LY3quO8uWyCcj2w7B6fb0LYZoks3Y4jtP3U8HdIYrYmFmFwadr5m8C0NJ28QOdG2GmG+39YIa17VT0DnOrjZxQ9Qx04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727781854; c=relaxed/simple;
	bh=6ipXy5F3Xt07TiPDff/NelsF1XsktJ2UoUz9fgQ4rGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g563p4BRMqH+j5SmLogVNOMIYInKyBUUxkEl3HS2cf2712Ku2HkZ2364Y18Kb+Vhe8T3St521jAHKAgIjXtcwPmoBo2rrg5QZ0O13I6yUSxeo3muKbewH02SaRsJJS48sT31nTMOlICS4xGIG9xVNXbUlIiqH72oSn09SGqCL+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=59414 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1svaz1-009kOX-5n; Tue, 01 Oct 2024 13:24:02 +0200
Date: Tue, 1 Oct 2024 13:23:58 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] Partially revert "rule, set_elem: remove
 trailing \n in userdata snprintf"
Message-ID: <ZvvbzkNjJeEY25Fv@calendula>
References: <20241001112054.16616-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241001112054.16616-1-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

On Tue, Oct 01, 2024 at 01:20:54PM +0200, Phil Sutter wrote:
> This reverts the rule-facing part of commit
> c759027a526ac09ce413dc88c308a4ed98b33416.
> 
> It can't be right: Rules without userdata are printed with a trailing
> newline, so this commit made behaviour inconsistent.

Did you run tests/py with this? It is the primary user for this.

> Fixes: c759027a526ac ("rule, set_elem: remove trailing \n in userdata snprintf")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/rule.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/rule.c b/src/rule.c
> index 811d5a213f835..51d778d095317 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -601,7 +601,7 @@ static int nftnl_rule_snprintf_default(char *buf, size_t remain,
>  			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>  		}
>  
> -		ret = snprintf(buf + offset, remain, " }");
> +		ret = snprintf(buf + offset, remain, " }\n");
>  		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>  
>  	}
> -- 
> 2.43.0
> 
