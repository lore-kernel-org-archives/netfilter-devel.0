Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46E61F3B9C;
	Wed, 26 Mar 2025 17:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743008964; cv=none; b=WfVPShh7+VjjiPRWSPRVcen5092qxDKT81RWYtB52fBZxduc/+vXb8Mtlo1DDzII1ezj3Ka0zNM2TJTEsewMOf5ZMxrZNCgsUPTjJC4rTukIa8ledOJmv09W3j1OQIknD9lxjpE5pzlT6qanJIOyICXuRrLEt08/ujTf3WokqAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743008964; c=relaxed/simple;
	bh=wUXj29rFrogavQzzw57+plrIdWYU5RC72jMj9igXWtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rkdmnbFyUZNzGaTlnwYKkg0cBPMgXpL6krE3qtM/xsKJGuTUdiM6OrBdxv5RWS8QWqcxttmszVOLVxrHiU0g53LrUvzvLlSCT0XVNomUFpQCCZVDYZgr6b50tYSFmrKtGhrtEcb06HEq0mc0hGYPhbZs9k0bgqdybPD6mzgRe7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=U/9+V+NH; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="U/9+V+NH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kqretPaCy5wxL59lttuMQtiSH+q945MvgVttv/8DtUo=; b=U/9+V+NHga2TJvDwxBX9Li6yxp
	UfeFkK7r/8Gy3VisQT1r4f06zbu3sxJLI9faC62IcAYYaBueiwa8RwyTJIbDXff4Et48vcsU36TOy
	Xunpc2RALvQ4VnMXAMgUtrKEhscSDn3RsEFggA47WuPCxz4C/K8SgzSwAEFx6EFw/tRn08H5vNvkE
	ypENeP66pyb5FjkNtlWmN6LjZ7HxGD9osTh0xBzEQak9nVFBc9IDRSO4xPEnAYldK9/qy+fYXVbNe
	CVWiKmY0tJ7s3TcAOrvBWrsG7tYHtuOlVZyBJWTkoe5110SSvCMfUbv78ROIftYNegu71UI2bLeXX
	sEO6HpXA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1txUFi-000000004yC-3nFa;
	Wed, 26 Mar 2025 18:09:18 +0100
Date: Wed, 26 Mar 2025 18:09:18 +0100
From: Phil Sutter <phil@nwl.cc>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [net-next v3 1/3] netfilter: replace select by depends on for
 IP{6}_NF_IPTABLES_LEGACY
Message-ID: <Z-Q0vi3r5aHxY8Pv@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20250325165832.3110004-1-bigeasy@linutronix.de>
 <20250325165832.3110004-2-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250325165832.3110004-2-bigeasy@linutronix.de>

Hi Bigeasy!

On Tue, Mar 25, 2025 at 05:58:30PM +0100, Sebastian Andrzej Siewior wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Relax dependencies on iptables legacy, replace select by depends on,
> this should cause no harm to existing kernel configs and users can still
> toggle IP{6}_NF_IPTABLES_LEGACY in any case.
> 
> [fw: Replace depends on BRIDGE_NF_EBTABLES_LEGACY with select]

I don't get this remark: The three chunks dealing with that symbol do
the opposite, namely replacing 'select ...' with 'depends on ...'. Do I
miss the point or is this a leftover?

> diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
> index f16bbbbb94817..a6770845d3aba 100644
> --- a/net/bridge/netfilter/Kconfig
> +++ b/net/bridge/netfilter/Kconfig
> @@ -65,7 +65,7 @@ if BRIDGE_NF_EBTABLES
>  #
>  config BRIDGE_EBT_BROUTE
>  	tristate "ebt: broute table support"
> -	select BRIDGE_NF_EBTABLES_LEGACY
> +	depends on BRIDGE_NF_EBTABLES_LEGACY
>  	help
>  	  The ebtables broute table is used to define rules that decide between
>  	  bridging and routing frames, giving Linux the functionality of a
> @@ -76,7 +76,7 @@ config BRIDGE_EBT_BROUTE
>  
>  config BRIDGE_EBT_T_FILTER
>  	tristate "ebt: filter table support"
> -	select BRIDGE_NF_EBTABLES_LEGACY
> +	depends on BRIDGE_NF_EBTABLES_LEGACY
>  	help
>  	  The ebtables filter table is used to define frame filtering rules at
>  	  local input, forwarding and local output. See the man page for
> @@ -86,7 +86,7 @@ config BRIDGE_EBT_T_FILTER
>  
>  config BRIDGE_EBT_T_NAT
>  	tristate "ebt: nat table support"
> -	select BRIDGE_NF_EBTABLES_LEGACY
> +	depends on BRIDGE_NF_EBTABLES_LEGACY
>  	help
>  	  The ebtables nat table is used to define rules that alter the MAC
>  	  source address (MAC SNAT) or the MAC destination address (MAC DNAT).

Cheers, Phil
