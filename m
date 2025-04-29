Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465C81FBEB9;
	Tue, 29 Apr 2025 13:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745933374; cv=none; b=W/kZYpPXO3vBfFZLDVgcasCLaB5CoMjpIVqyPwSdPEmuxZlQYqlfePCwW1D0deLaXlRT6Y+ilqJLqrLa9wqKxvWc+lSkXOII6KM+gx2Y3fZTqj5i/9pfb1EftlsvfI7KZEO9rACuHq71bV2XUmGh8uJZW+utZr1kkz9Hbi/vAT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745933374; c=relaxed/simple;
	bh=YwN4EMaAALUmRHq3OHZLExjO0utT8ZCGsFKX/ieuAps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aF5LxWTydc3c2zza41YLXXqSECBlcQAUWO/QHeK2M+fuytOXhTG12VYzW93bnXlrRfPpb6KndQJawpIZ83j4dFnJt85oOU0ux1a4tuQ0DNMVzrtLGajWUy44sAFMnWQnJa+OBIVHcqCXa8OBm9DRZIVou/CmtOtwHyltQ9457ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u9l1V-0001Fg-Om; Tue, 29 Apr 2025 15:29:21 +0200
Date: Tue, 29 Apr 2025 15:29:21 +0200
From: Florian Westphal <fw@strlen.de>
To: avimalin@gmail.com
Cc: vimal.agrawal@sophos.com, linux-kernel@vger.kernel.org,
	pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de,
	anirudh.gupta@sophos.com
Subject: Re: [PATCH v1] nf_conntrack: sysctl: expose gc worker scan interval
 via sysctl
Message-ID: <20250429132921.GA4721@breakpoint.cc>
References: <20250429130940.74538-1-vimal.agrawal@sophos.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250429130940.74538-1-vimal.agrawal@sophos.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

avimalin@gmail.com <avimalin@gmail.com> wrote:
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index 2f666751c7e7..480ff9a6f185 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -559,6 +559,7 @@ enum nf_ct_sysctl_index {
>  #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
>  	NF_SYSCTL_CT_TIMESTAMP,
>  #endif
> +	NF_SYSCTL_CT_GC_SCAN_INTERVAL_INIT,
>  	NF_SYSCTL_CT_PROTO_TIMEOUT_GENERIC,
>  	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_SYN_SENT,
>  	NF_SYSCTL_CT_PROTO_TIMEOUT_TCP_SYN_RECV,
> @@ -691,6 +692,13 @@ static struct ctl_table nf_ct_sysctl_table[] = {
>  		.extra2 	= SYSCTL_ONE,
>  	},
>  #endif
> +	[NF_SYSCTL_CT_GC_SCAN_INTERVAL_INIT] = {
> +		.procname	= "nf_conntrack_gc_scan_interval_init",
> +		.data		= &nf_conntrack_gc_scan_interval_init,
> +		.maxlen		= sizeof(unsigned int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_jiffies,
> +	},
>  	[NF_SYSCTL_CT_PROTO_TIMEOUT_GENERIC] = {
>  		.procname	= "nf_conntrack_generic_timeout",
>  		.maxlen		= sizeof(unsigned int),

I think you'll need to add NF_SYSCTL_CT_GC_SCAN_INTERVAL_INIT to
the

 /* Don't allow non-init_net ns to alter global sysctls */
 if (!net_eq(&init_net, net)) {

branch in nf_conntrack_standalone_init_sysctl().
