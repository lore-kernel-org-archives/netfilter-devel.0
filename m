Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0FD37648F;
	Fri,  3 Apr 2026 19:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775245620; cv=none; b=iEnCtkIBxEEHWh5vZBLWNJa7bZ4ueFoqMIHP6XjgbJNYkOTuaviirvvLtgV8mOEV5Iej7MAnQsmtiZhAGYVjjUwhO6H35WpyCIO51Gce7gmDI9HJmCrV9mwjFdyPkFL5y56osfEz6jE95gusUi0jVuHCu+seUWs+EmZ+XRK5hf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775245620; c=relaxed/simple;
	bh=GXYIOxBHh3VhjgTQVlbh4Z9tVxd5Y6Y7wE0hEfUydcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QJLOzsyojzPjXGn2aQP+K/j6MKfgBaIRYK57Q7IL0gpXqzvrQ05v5MLCz3LEWi35Ow/uRuYFC6WHA6BIul+BI2J9YIQ4iuMz+BNpJDo0pBwnpEEON+cvTeCnyzkmRh0q6BAVCTnSx69F9j0jzCPFB6JYotYBuXx3mv3fhO0N9tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id ADEB460913; Fri, 03 Apr 2026 21:46:56 +0200 (CEST)
Date: Fri, 3 Apr 2026 21:46:56 +0200
From: Florian Westphal <fw@strlen.de>
To: Marino Dzalto <marino.dzalto@gmail.com>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: xt_HL: add pr_fmt, default case and NULL
 checks
Message-ID: <adAZME8XxeUNgEt-@strlen.de>
References: <20260403193929.89449-1-marino.dzalto@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403193929.89449-1-marino.dzalto@gmail.com>

Marino Dzalto <marino.dzalto@gmail.com> wrote:
> Signed-off-by: Marino Dzalto <marino.dzalto@gmail.com>
> ---
>  net/netfilter/xt_hl.c | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/net/netfilter/xt_hl.c b/net/netfilter/xt_hl.c
> index c1a70f8f0..9434d5ca8 100644
> --- a/net/netfilter/xt_hl.c
> +++ b/net/netfilter/xt_hl.c
> @@ -6,6 +6,7 @@
>   * Hop Limit matching module
>   * (C) 2001-2002 Maciej Soltysiak <solt@dns.toxicfilms.tv>
>   */
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
>  #include <linux/ip.h>
>  #include <linux/ipv6.h>
> @@ -25,7 +26,12 @@ MODULE_ALIAS("ip6t_hl");
>  static bool ttl_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  {
>  	const struct ipt_ttl_info *info = par->matchinfo;
> -	const u8 ttl = ip_hdr(skb)->ttl;
> +	const u8 ttl;
> +
> +	if (!skb)
> +		return false;

If this was NULL we'd have crashed already.

>  	case IPT_TTL_GT:
>  		return ttl > info->ttl;
> +	default:
> +		pr_warn("Unknown TTL match mode: %d\n", info->mode);
> +		return false;

Please add a .checkentry function and reject this from there.
