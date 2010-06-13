From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH xt-addons] xt_geoip: fix possible out-of-bounds access
Date: Sun, 13 Jun 2010 10:38:27 +0200
Message-ID: <20100613083827.GA11457@Chamillionaire.breakpoint.cc>
References: <1275382302-8857-1-git-send-email-fwestphal@astaro.com>
 <alpine.LSU.2.01.1006121037230.29158@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:45361 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753140Ab0FMIia (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Jun 2010 04:38:30 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1006121037230.29158@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@medozas.de> wrote:
> On Tuesday 2010-06-01 10:51, Florian Westphal wrote:
> 
> >It is possible for geoip_bsearch() to pick mid == sizeof(subnets).
> >
> >Consider a set with a single entry and a "address to test"
> >higher than the range:
> >
> >1st call: lo = 0, hi = 1 -> mid will be 0
> >2nd call: lo = 1, hi = 1 -> mid will be 1
> >
> >On the 2nd call, we'll examine random data.
> 
> Isn't this simpler?

Guess that is a matter of taste :-)
To me, lo and hi are indexes into range[] and thus should not
exceed sizeof(range). This is what my patch fixes.

> diff --git a/extensions/xt_geoip.c b/extensions/xt_geoip.c
> index 4c6b29f..44e489d 100644
> --- a/extensions/xt_geoip.c
> +++ b/extensions/xt_geoip.c
> @@ -126,13 +126,13 @@ static bool geoip_bsearch(const struct geoip_subnet *range,
>  {
>  	int mid;
>  
> -	if (hi < lo)
> +	if (hi <= lo)
>  		return false;
>  	mid = (lo + hi) / 2;
>  	if (range[mid].begin <= addr && addr <= range[mid].end)
>  		return true;
>  	if (range[mid].begin > addr)
> -		return geoip_bsearch(range, addr, lo, mid - 1);
> +		return geoip_bsearch(range, addr, lo, mid);
>  	else if (range[mid].end < addr)
>  		return geoip_bsearch(range, addr, mid + 1, hi);
>  
> Seems to work on paper.

Yes, this works as well.

I do not have a strong preference on how this is fixed; if you
consider your patch to be the better choice then please, by all means,
apply it :-)

Thanks,
Florian
