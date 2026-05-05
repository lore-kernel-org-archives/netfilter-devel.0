Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4BF19AD5C;
	Tue,  5 May 2026 22:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778020404; cv=none; b=dsrNlol3HKpe7xbbU6mJ/K2lCY/0SBeZi2xxeE+Nptx72x6yag8UXgInafWhPNC7Rw1DULZ2CY6qedEUEjQOVOCZ32E1SIulbAuD/uQ5VdVrxbiNw+47up2f2XYVfWf2Z7nAlI5plGFCQygS4Jtb70uXtwW0voWotPbPJlRL/eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778020404; c=relaxed/simple;
	bh=j4sDSN+KNZuaBrisARehsrIZ3WKlTfOs4pLJchcU2Jk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RbQB03oLOpgIy+nTcS1TyBRsFGA//ApUxnJBWjVj4cognIWUHGv2vvPD9luB4eifrJTcNEmgMVXVaqrW/yt/+OFg8ZpFEM8cxqJ6tmKT7hZdRIIlG0oTEUdDr6b3z8hHQ2IIpib80hhjHvUCiYBr55pdnoxjcxy0vnotpVcx3M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lK09AYOu; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lK09AYOu"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C8B6860177;
	Wed,  6 May 2026 00:33:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778020399;
	bh=9UhTEXeeMTMGh20cbiK9clTDZ68s2NM9Y9cYAypGj0Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lK09AYOuQMgEf7WssbiCi8+I6K7eQVKsjOhqnFO4nz479V/y/MBrpoVlNEZciE9aE
	 jjItsUs9rQ9AHRPfzQAu2cZ7vpiinBFOUelyFSJz2iV7y7ENzv3KwwkX1Hv3mvnuOH
	 ZQyjl3RlbDDhWcxwfNl42JbWCZTZ4+aXwkSU08g+tPAqrBrESTGDGuwv8PJzZh/dGs
	 I+kfGMcqiKKqRI+wDwJubHNysupT7BHswKMBmNS/flWELVYMDFjoLqRl1GYfaYfWUa
	 /NalzpQfU27SC8gpH3HW+l2NynqkrVQ7n12AmQQzf1l9hlsLpfeTO03Q8N8Qi+JHIv
	 dGfJdQPB/ccNw==
Date: Wed, 6 May 2026 00:33:17 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: HACKE-RC <rc@rexion.ai>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/4] netfilter: conntrack: add shared port
 and uint parsers for helpers
Message-ID: <afpwLbN-W2Sur5Qu@chamomile>
References: <afSBzDE-caw3Dsr1@orbyte.nwl.cc>
 <20260503083220.630655-1-rc@rexion.ai>
 <20260503083220.630655-2-rc@rexion.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260503083220.630655-2-rc@rexion.ai>

On Sun, May 03, 2026 at 02:02:17PM +0530, HACKE-RC wrote:
> Add nf_ct_helper_parse_uint() for bounded unsigned integer parsing
> from an unterminated buffer, and nf_ct_helper_parse_port() which calls
> it with max=65535 and rejects port zero.  Both helpers are exported so
> conntrack protocol helpers can replace ad-hoc simple_strtoul() usage.
> 
> Signed-off-by: HACKE-RC <rc@rexion.ai>

You will need a "real name" here.

> ---
>  include/net/netfilter/nf_conntrack_helper.h |  5 +++
>  net/netfilter/nf_conntrack_helper.c         | 39 +++++++++++++++++++++
>  2 files changed, 44 insertions(+)
> 
> diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
> index de2f956ab..ab145fcd9 100644
> --- a/include/net/netfilter/nf_conntrack_helper.h
> +++ b/include/net/netfilter/nf_conntrack_helper.h
> @@ -160,6 +160,11 @@ nf_ct_helper_expectfn_find_by_name(const char *name);
>  struct nf_ct_helper_expectfn *
>  nf_ct_helper_expectfn_find_by_symbol(const void *symbol);
>  
> +int nf_ct_helper_parse_uint(const char *cp, unsigned int len,
> +			    unsigned long max, unsigned long *val, char **endp);
> +int nf_ct_helper_parse_port(const char *cp, unsigned int len,
> +			    u16 *port, char **endp);
> +
>  extern struct hlist_head *nf_ct_helper_hash;
>  extern unsigned int nf_ct_helper_hsize;
>  
> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> index a715304a5..f6229957c 100644
> --- a/net/netfilter/nf_conntrack_helper.c
> +++ b/net/netfilter/nf_conntrack_helper.c
> @@ -499,6 +499,45 @@ void nf_nat_helper_unregister(struct nf_conntrack_nat_helper *nat)
>  }
>  EXPORT_SYMBOL_GPL(nf_nat_helper_unregister);
>  
> +int nf_ct_helper_parse_uint(const char *cp, unsigned int len,
> +			    unsigned long max, unsigned long *val, char **endp)

In nf.git, there is a new function sip_strtouint() that can possibly
be moved to nf_conntrack_helper.c.

Thanks.
