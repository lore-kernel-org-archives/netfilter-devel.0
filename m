Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E0D146A71
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Jun 2024 14:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718289676; cv=none; b=V/9nkOnnDBIN9AphlomeaUZ2TrgCtVixfViZmaHqaLn5IGCWPikOj7WefvVtcG/rruOTty8HzWsU3EKhtO4FquAnp74fAgJPsnuMSspKeOJaR5HnFPDu+eQi6Bux1lFFcfF5NwUFgclAWA0fli1rG7kvMH/gXB4K6CVCKDnheJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718289676; c=relaxed/simple;
	bh=JOo9t4t2mFWdhsltVxljVPtCvcXLfoxmPq1BsymKP5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MptjFiC0Sg6f8HxOyDSqF10bObWcdKaZnvcqGXlvf3J4KXHKen2SedMBbXzEB7lYm02PPwu4mDZ8iy8KgnFEQFIrRQZ5V/7kwmH3ikuYEC6oHi5k3LdiWTAMpX4hSFsFEhjbfdfS8bAAKzZ4LwSKOiTWBM4jjGo/fMrV4kEXH8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sHldR-0007eq-HR; Thu, 13 Jun 2024 16:41:05 +0200
Date: Thu, 13 Jun 2024 16:41:05 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Fabio <pedretti.fabio@gmail.com>
Subject: Re: [nf-next PATCH 2/2] netfilter: xt_recent: Largely lift
 restrictions on max hitcount value
Message-ID: <20240613144105.GA27366@breakpoint.cc>
References: <20240613143254.26622-1-phil@nwl.cc>
 <20240613143254.26622-3-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613143254.26622-3-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> Support tracking of up to 2^32-1 packets per table. Since users provide
> the hitcount value in a __u32 variable, they can't exceed the max value
> anymore.
> 
> Requested-by: Fabio <pedretti.fabio@gmail.com>
> Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1745
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  net/netfilter/xt_recent.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
> index 60259280b2d5..77ac4964e2dc 100644
> --- a/net/netfilter/xt_recent.c
> +++ b/net/netfilter/xt_recent.c
> @@ -59,9 +59,9 @@ MODULE_PARM_DESC(ip_list_gid, "default owning group of /proc/net/xt_recent/* fil
>  /* retained for backwards compatibility */
>  static unsigned int ip_pkt_list_tot __read_mostly;
>  module_param(ip_pkt_list_tot, uint, 0400);
> -MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP address to remember (max. 255)");
> +MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP address to remember (max. 2^32 - 1)");
>  
> -#define XT_RECENT_MAX_NSTAMPS	256
> +#define XT_RECENT_MAX_NSTAMPS	(1ULL << 32)

Won't that allow massive mem hog?

Actually I think this is already a mem hog, unbounded
allocations from time where we had no untrusted netns :-(
