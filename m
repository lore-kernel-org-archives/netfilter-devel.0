Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ADE56FCB
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2024 16:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712681361; cv=none; b=kRnkc7NfwowLwKorP6ulwzI3EXHf36SFA6kB7+rhLUf1p8r4Aih8DZgKiHHxup+XVTI80T2EuQGjrzold+kVv4FSg90m3WVVgtwMYpzPO5mPZyA7SoDWsKlO1nbS+ZWWeh2aSDq4G0qbgFsisS73LnrlPBPTkGXjPvoelLji+pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712681361; c=relaxed/simple;
	bh=qpMrJbQ3paQ4TFiBd4/isONXtG9C4QwkwAch7MMtu8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hLpQLRPnUQFAj4UsrUnthYmNcmPgZHGCgqkdF10MrjYAQW/f7DR3XVj4HJK14ZrYjWs0aOQMBU5cJk6oCh+pCbPBRO+wnp8EjgXKQtmvINB3lfaHEA/onZEkIEDqXOCEWZLSt4KKEgm0cls2F+I13nI64nfwYf1g8uhpKPtcsBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vmicros1.altlinux.org (Postfix) with ESMTP id 16B8C72C8F5;
	Tue,  9 Apr 2024 19:49:11 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
	by imap.altlinux.org (Postfix) with ESMTPSA id 0E41536D016C;
	Tue,  9 Apr 2024 19:49:11 +0300 (MSK)
Date: Tue, 9 Apr 2024 19:49:10 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] libxtables: Attenuate effects of functions'
 internal static buffers
Message-ID: <20240409164910.5x6l35anvc36juca@altlinux.org>
References: <20240409151404.30835-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20240409151404.30835-1-phil@nwl.cc>

Phil,

On Tue, Apr 09, 2024 at 05:14:04PM +0200, Phil Sutter wrote:
> While functions returning pointers to internal static buffers have
> obvious limitations, users are likely unaware how they call each other
> internally and thus won't notice unsafe use. One such case is calling
> both xtables_ipaddr_to_numeric() and xtables_ipmask_to_numeric() as
> parameters for a single printf() call.
> 
> Defuse this trap by avoiding the internal calls to
> xtables_ip{,6}addr_to_numeric() which is easily doable since callers
> keep their own static buffers already.
> 
> While being at it, make use of inet_ntop() everywhere and also use
> INET_ADDRSTRLEN/INET6_ADDRSTRLEN defines for correct (and annotated)
> static buffer sizes.
> 
> Reported-by: Vitaly Chikunov <vt@altlinux.org>
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Reviewed-by: Vitaly Chikunov <vt@altlinux.org>

Also, I tested in our build env and it's worked good.

Thanks,

> ---
>  libxtables/xtables.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/libxtables/xtables.c b/libxtables/xtables.c
> index f2fcc5c22fb61..7b370d486f888 100644
> --- a/libxtables/xtables.c
> +++ b/libxtables/xtables.c
> @@ -1513,11 +1513,9 @@ void xtables_param_act(unsigned int status, const char *p1, ...)
>  
>  const char *xtables_ipaddr_to_numeric(const struct in_addr *addrp)
>  {
> -	static char buf[16];
> -	const unsigned char *bytep = (const void *)&addrp->s_addr;
> +	static char buf[INET_ADDRSTRLEN];
>  
> -	sprintf(buf, "%u.%u.%u.%u", bytep[0], bytep[1], bytep[2], bytep[3]);
> -	return buf;
> +	return inet_ntop(AF_INET, addrp, buf, sizeof(buf));
>  }
>  
>  static const char *ipaddr_to_host(const struct in_addr *addr)
> @@ -1577,13 +1575,14 @@ int xtables_ipmask_to_cidr(const struct in_addr *mask)
>  
>  const char *xtables_ipmask_to_numeric(const struct in_addr *mask)
>  {
> -	static char buf[20];
> +	static char buf[INET_ADDRSTRLEN + 1];
>  	uint32_t cidr;
>  
>  	cidr = xtables_ipmask_to_cidr(mask);
>  	if (cidr == (unsigned int)-1) {
>  		/* mask was not a decent combination of 1's and 0's */
> -		sprintf(buf, "/%s", xtables_ipaddr_to_numeric(mask));
> +		buf[0] = '/';
> +		inet_ntop(AF_INET, mask, buf + 1, sizeof(buf) - 1);
>  		return buf;
>  	} else if (cidr == 32) {
>  		/* we don't want to see "/32" */
> @@ -1863,9 +1862,8 @@ void xtables_ipparse_any(const char *name, struct in_addr **addrpp,
>  
>  const char *xtables_ip6addr_to_numeric(const struct in6_addr *addrp)
>  {
> -	/* 0000:0000:0000:0000:0000:0000:000.000.000.000
> -	 * 0000:0000:0000:0000:0000:0000:0000:0000 */
> -	static char buf[50+1];
> +	static char buf[INET6_ADDRSTRLEN];
> +
>  	return inet_ntop(AF_INET6, addrp, buf, sizeof(buf));
>  }
>  
> @@ -1923,12 +1921,12 @@ int xtables_ip6mask_to_cidr(const struct in6_addr *k)
>  
>  const char *xtables_ip6mask_to_numeric(const struct in6_addr *addrp)
>  {
> -	static char buf[50+2];
> +	static char buf[INET6_ADDRSTRLEN + 1];
>  	int l = xtables_ip6mask_to_cidr(addrp);
>  
>  	if (l == -1) {
>  		strcpy(buf, "/");
> -		strcat(buf, xtables_ip6addr_to_numeric(addrp));
> +		inet_ntop(AF_INET6, addrp, buf + 1, sizeof(buf) - 1);
>  		return buf;
>  	}
>  	/* we don't want to see "/128" */
> -- 
> 2.43.0
