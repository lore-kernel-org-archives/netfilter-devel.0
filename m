Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 956BDD515
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Mar 2024 09:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711185444; cv=none; b=pWDeyNDIn4eb/LgVeGDtAfEoGzs7QDQmISXM1PJ/URCbwOyPUYHvCXvBM6yOvI/1E/XzHjRV6PuAzW+2zofGQiPLUhFSYfhClZmr+cNI9aKeoEvsg36mhGOrYYTpYMu2gSkk6Vx36ZxYxpOOmFw61RTPwy2XbmXSCQzG6Fd3Q40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711185444; c=relaxed/simple;
	bh=2xtk6ubKQn8qLQPm7btJe2wgoXwbcKMhjUWzlCyvz2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nQF/eB8FDBiEuz+1xoBGOLK85Mg0FvRpOG/RShRSTY04ddkgYFhDigV36L/ck5uaLiUPkpwCqE0pCWjPjj6k8aO7jpKFvBnqpw1mmWKoqukuRfrVM5vjgDIy78ZiwEF9b2JxvFciBXc7ss+LS2hMGr6eicDk00HvR5bYCK+LCpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vmicros1.altlinux.org (Postfix) with ESMTP id D0BAF72C8CC;
	Sat, 23 Mar 2024 12:17:17 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
	by imap.altlinux.org (Postfix) with ESMTPSA id C561536D071C;
	Sat, 23 Mar 2024 12:17:17 +0300 (MSK)
Date: Sat, 23 Mar 2024 12:17:17 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc: Jan Engelhardt <jengelh@inai.de>,
	Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
Subject: Re: [PATCH iptables] libxtables: Fix xtables_ipaddr_to_numeric calls
 with xtables_ipmask_to_numeric
Message-ID: <20240323091717.dtsioyvjnhl5dtyv@altlinux.org>
References: <20240323030641.988354-1-vt@altlinux.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20240323030641.988354-1-vt@altlinux.org>

On Sat, Mar 23, 2024 at 06:06:41AM +0300, Vitaly Chikunov wrote:
> Frequently when addr/mask is printed xtables_ipaddr_to_numeric and
> xtables_ipmask_to_numeric are called together in one printf call but
> xtables_ipmask_to_numeric internally calls xtables_ipaddr_to_numeric
> which prints into the same static buffer causing buffer to be
> overwritten and addr/mask incorrectly printed in such call scenarios.
> 
> Make xtables_ipaddr_to_numeric to use two static buffers rotating their
> use. This simplistic approach will leave ABI not changed and cover all
> such use cases.

Additional thoughts are: the call order of these two function is
important in will it override buf or not. Order of evaluation of
function arguments is unspecified[1] and compile time dependent. It
seems that on non-x86 architectures, sometime it could be different from
left-to-right. That's why this bug was unnoticed for so much time.

[1] https://en.cppreference.com/w/c/language/eval_order

Thanks,

> 
> Interestingly, testing stumbled over this only on non-x86 architectures.
> Error message:
> 
>   extensions/libebt_arp.t: ERROR: line 11 (cannot find: ebtables -I INPUT -p ARP --arp-ip-src ! 1.2.3.4/255.0.255.255)
> 
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> Cc: Jan Engelhardt <jengelh@inai.de>
> Cc: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
> ---
>  libxtables/xtables.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/libxtables/xtables.c b/libxtables/xtables.c
> index 748a50fc..16a0640d 100644
> --- a/libxtables/xtables.c
> +++ b/libxtables/xtables.c
> @@ -1505,7 +1505,9 @@ void xtables_param_act(unsigned int status, const char *p1, ...)
>  
>  const char *xtables_ipaddr_to_numeric(const struct in_addr *addrp)
>  {
> -	static char buf[16];
> +	static char abuf[2][16];
> +	static int bufnum = 0;
> +	char *buf = abuf[++bufnum & 1];
>  	const unsigned char *bytep = (const void *)&addrp->s_addr;
>  
>  	sprintf(buf, "%u.%u.%u.%u", bytep[0], bytep[1], bytep[2], bytep[3]);
> -- 
> 2.42.1
