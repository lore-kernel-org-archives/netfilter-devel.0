Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A1A33EC;
	Wed,  1 Jan 2025 23:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735773816; cv=none; b=PCEUThV/LAP7IPtB+pmWKvLX+gLrkOmi/9epnNbT7kNXRrx796g9fMiSvnRdpW0Zmf8gvib30cBmENjK4qLCO7hA56qiBJHxnY8jjlkP96PCQ3TufdSC4+4krLnn97l+cWFdm+rVWXtbYEMpGuVIro+mG7/K243ee3P9w8WBqJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735773816; c=relaxed/simple;
	bh=t8peOcUTt1t64vQ5QjfLS8Amc4fSVcyMSsOha6Q0qPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aeYgR5oeq9GV8audd2mHIIFI0JlLLlgDmbOxe+BqXF091Bf7Y5HnwWIGfLMcuq7JMOnM25lGWxdkCId0yvDBh8vQw9jgVHLm3fBB/2UzIgYIHSo/x49+4hjxynbPkMu+W/QfmdHtKxU9Iw7lfmuprvFolX1bhTz29nM6D0Y1Ckk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tT7UC-00056t-V1; Wed, 01 Jan 2025 23:46:44 +0100
Date: Wed, 1 Jan 2025 23:46:44 +0100
From: Florian Westphal <fw@strlen.de>
To: egyszeregy@freemail.hu
Cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org,
	daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com,
	kadlec@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: uapi: Merge xt_*.h/c and ipt_*.h which has
 same name.
Message-ID: <20250101224644.GA18527@breakpoint.cc>
References: <20250101192015.1577-1-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250101192015.1577-1-egyszeregy@freemail.hu>
User-Agent: Mutt/1.10.1 (2018-07-13)

egyszeregy@freemail.hu <egyszeregy@freemail.hu> wrote:
>  /* match info */
> -struct xt_dscp_info {
> +struct xt_dscp_match_info {

To add to what Jan already pointed out, such renames
break UAPI, please don't do this.

It could be done with compat ifdef'ry but I think its rather ugly,
better to keep all uapi structure names as-is.

>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
> -MODULE_DESCRIPTION("Xtables: TCP MSS match");
> +MODULE_DESCRIPTION("Xtables: TCP Maximum Segment Size (MSS) adjustment/match");
>  MODULE_ALIAS("ipt_tcpmss");
>  MODULE_ALIAS("ip6t_tcpmss");
> +MODULE_ALIAS("ipt_TCPMSS");
> +MODULE_ALIAS("ip6t_TCPMSS");

I think you should add MODULE_ALIAS("xt_TCPMSS") just in case, same
for all other merged (== 'removed') module names, to the respective
match (preserved) modules.
