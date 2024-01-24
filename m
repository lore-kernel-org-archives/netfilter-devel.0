Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE2A604B2
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jan 2024 14:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706104850; cv=none; b=OLWftKfKxnJbR3r4Qqpkw7E2mZ1tB07JfyzI5Z8O2uQ3ESrcTMMVn2lEvH9kHf8uDYRHDLXUNuK8HmD9/k+LtsadGLj84N8pOx5iMx2zDiN9b0ypErk5mHNT1jIsDyd8tj5k7m4eoXMKuvyz0JAFyrcaatFr2FmdArN5QXakdp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706104850; c=relaxed/simple;
	bh=aC3M8fIAlxvtv7Icno9ZBB2G5w66/3PDA3aTiqTBV64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YotNPHsl6JxMVFnnXEBI9PqR+RJ1H5bO8DGBv21Jk7V9uEIjXPHUbPQthoXRFhXbLYbV3rCOFHpk5u3OTbMMYCDhtS/h+UkfY+CGPtYNxdb+kDSnSFuOgSQcAzP8OqbopsQ/miSua9jg/Cbu5sP856CVy0qhjBKPasQKtDVnNrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZZBJ8+qK; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZZBJ8+qK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qjr7Q7E2/jR890r3TUKG4HmLrest3P5SsXK8j1/a15g=; b=ZZBJ8+qKfp+9B9+9lB3yYVbuGm
	zE6ZIitZMhKe7zfElr7hEPIhU/g4tMaJHRpmQNc5MqwXebpl7kQACsm2FJyW08bCqGAp3B7ozEY8r
	H8zNQW6CN6PeQQeffPYcu9bhwu3tkQezLvGBIUSE7uo999erGx91mS8rDwjJ+/WT4J9CulNJsELSN
	EoRE/2BsUNcLAARtHLWmdg6WPy6axdy8CI+FFFVmFNLIphg1rhuCmSZl3Suss6ahMWI7W/wgpGqZZ
	LFEyL92bO38+4mtUMkQkGKt6Gn7GpgKw5DmK3vve0aqqrVtArc3w8TmaD+oXVKjzhXH9RmYN9vkB5
	uDV7VLcw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rSdo6-0000000022m-2A9E;
	Wed, 24 Jan 2024 15:00:46 +0100
Date: Wed, 24 Jan 2024 15:00:46 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables] extensions: libebt_stp: fix range checking
Message-ID: <ZbEYDliDhUrO73eu@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20240123164936.14403-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240123164936.14403-1-fw@strlen.de>

Hi Florian,

On Tue, Jan 23, 2024 at 05:49:33PM +0100, Florian Westphal wrote:
> This has to either consider ->nvals > 1 or check the values
> post-no-range-fixup:
> 
> ./iptables-test.py  extensions/libebt_stp.t
> extensions/libebt_stp.t: ERROR: line 12 (cannot load: ebtables -A INPUT --stp-root-cost 1)
> 
> (it tests 0 < 1 and fails, but test should be 1 < 1).
> 
> Fixes: dc6efcfeac38 ("extensions: libebt_stp: Use guided option parser")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  extensions/libebt_stp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/extensions/libebt_stp.c b/extensions/libebt_stp.c
> index 81054b26c1f0..371fa04c870f 100644
> --- a/extensions/libebt_stp.c
> +++ b/extensions/libebt_stp.c
> @@ -142,7 +142,7 @@ static void brstp_parse(struct xt_option_call *cb)
>  #define RANGE_ASSIGN(name, fname, val) {				    \
>  		stpinfo->config.fname##l = val[0];			    \
>  		stpinfo->config.fname##u = cb->nvals > 1 ? val[1] : val[0]; \
> -		if (val[1] < val[0])					    \
> +		if (stpinfo->config.fname##u < stpinfo->config.fname##l)    \
>  			xtables_error(PARAMETER_PROBLEM,		    \
>  				      "Bad --stp-" name " range");	    \
>  }

This is odd: xtopt_parse_mint() assigns UINT32_MAX to val[1] for
XTTYPE_UINT32RC if no upper end is given. Also, extensions/libebt_stp.t
passes for me. What's missing on my end?

Cheers, Phil
