Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C17E2FB612;
	Tue,  3 Feb 2026 15:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770131043; cv=none; b=ZO5IjxXSGR7dZh4FxRcngAh8pTyFut834Qep4Gd14E4ognt9wPE49ry5DFHBHn3cb3bC3SDibr+/SyDW77iqRj8WcZ3kp/oGNi8z7ac6JOke0nPWXSbdgUVwSlJShqwmD0/4tbmX6uDYSiumLZB8RtBzsqtC2wEUkECNxTKOm04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770131043; c=relaxed/simple;
	bh=najQtQrVjuFmTk+wdSsh/0gRiVydvigfoZIUvEw3NEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EiYYfLrMQlOR9hZh5TuPqLt2TwAkr8hCh2kcIFXNYw0+mcfll6H59RbBTglRSghORiIu62Ld650HBa++KqLSGDGcssYFxcqhDNCXe3mW7DciTEYn7QBfJICKwJEBjXoHDEPlVUDkq0eNoA5EHK7bkVKz7UfMWWIJogrhid7/8/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2399360242; Tue, 03 Feb 2026 16:03:59 +0100 (CET)
Date: Tue, 3 Feb 2026 16:03:58 +0100
From: Florian Westphal <fw@strlen.de>
To: Sun Jian <sun.jian.kdev@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: amanda: fix RCU pointer typing for
 nf_nat_amanda_hook
Message-ID: <aYIOXk55_DRFKCqo@strlen.de>
References: <20260203080109.2682183-1-sun.jian.kdev@gmail.com>
 <20260203145511.164485-1-sun.jian.kdev@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203145511.164485-1-sun.jian.kdev@gmail.com>

Sun Jian <sun.jian.kdev@gmail.com> wrote:
>  enum amanda_strings {
> @@ -98,7 +98,12 @@ static int amanda_help(struct sk_buff *skb,
>  	u_int16_t len;
>  	__be16 port;
>  	int ret = NF_ACCEPT;
> -	typeof(nf_nat_amanda_hook) nf_nat_amanda;
> +	unsigned int (*nf_nat_amanda)(struct sk_buff *skb,
> +				      enum ip_conntrack_info ctinfo,
> +				      unsigned int protoff,
> +				      unsigned int matchoff,
> +				      unsigned int matchlen,
> +				      struct nf_conntrack_expect *exp);

Why is that needed?
