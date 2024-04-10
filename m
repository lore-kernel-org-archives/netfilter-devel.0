Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AAD015444A;
	Wed, 10 Apr 2024 09:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712741030; cv=none; b=sWTSACDONhJ4PvCTQw4kFjUsqezjHonkLnyc/PfiWD4dNimfHM0N4dBPK9mcabrbOS2IxITd3aQPdDTvqS5xv2hVqegs+JKoo0dN4bF8+2bnX7hA07ZxblObvnDpTunc4ev/dvDG82d5rGqlL3ssi2sGYnZISSNoPwdwB9H/SNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712741030; c=relaxed/simple;
	bh=DhyQeHjydszLKnOgjgYXyohLr75mbDAOWJKZ2AQnIwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WNf4PGbj26fEHsGfLn9u5EV4tnLyhCo297vYJpcIvz35R+j7obtMsvW8Ey6luAgVIry9Z6SyJ5KV2qXhsOgCqGmywgor1shuA4Opc62XXXL8fRxPAKthK3sOn5gBWTZ9OidTeGFXgKOcGbRtr6QYh+bSq1cFOVz1g4AlI5+qOhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Wed, 10 Apr 2024 11:23:42 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] netfilter: complete validation of user input
Message-ID: <ZhZanswJEPkqrlZE@calendula>
References: <20240409120741.3538135-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240409120741.3538135-1-edumazet@google.com>

On Tue, Apr 09, 2024 at 12:07:41PM +0000, Eric Dumazet wrote:
> In my recent commit, I missed that do_replace() handlers
> use copy_from_sockptr() (which I fixed), followed
> by unsafe copy_from_sockptr_offset() calls.

I forgot too to git grep away from net/netfilter/ folder for some
reason.

> In all functions, we can perform the @optlen validation
> before even calling xt_alloc_table_info() with the following
> check:
> 
> if ((u64)optlen < (u64)tmp.size + sizeof(tmp))
>         return -EINVAL;

Thanks for this fix.

> Fixes: 0c83842df40f ("netfilter: validate user input for expected length")
> Reported-by: syzbot <syzkaller@googlegroups.com>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/ipv4/netfilter/arp_tables.c | 4 ++++
>  net/ipv4/netfilter/ip_tables.c  | 4 ++++
>  net/ipv6/netfilter/ip6_tables.c | 4 ++++
>  3 files changed, 12 insertions(+)
> 
> diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
> index b150c9929b12e86219a55c77da480e0c538b3449..14365b20f1c5c09964dd7024060116737f22cb63 100644
> --- a/net/ipv4/netfilter/arp_tables.c
> +++ b/net/ipv4/netfilter/arp_tables.c
> @@ -966,6 +966,8 @@ static int do_replace(struct net *net, sockptr_t arg, unsigned int len)
>  		return -ENOMEM;
>  	if (tmp.num_counters == 0)
>  		return -EINVAL;
> +	if ((u64)len < (u64)tmp.size + sizeof(tmp))
> +		return -EINVAL;
>  
>  	tmp.name[sizeof(tmp.name)-1] = 0;
>  
> @@ -1266,6 +1268,8 @@ static int compat_do_replace(struct net *net, sockptr_t arg, unsigned int len)
>  		return -ENOMEM;
>  	if (tmp.num_counters == 0)
>  		return -EINVAL;
> +	if ((u64)len < (u64)tmp.size + sizeof(tmp))
> +		return -EINVAL;
>  
>  	tmp.name[sizeof(tmp.name)-1] = 0;
>  
> diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
> index 487670759578168c5ff53bce6642898fc41936b3..fe89a056eb06c43743b2d7449e59f4e9360ba223 100644
> --- a/net/ipv4/netfilter/ip_tables.c
> +++ b/net/ipv4/netfilter/ip_tables.c
> @@ -1118,6 +1118,8 @@ do_replace(struct net *net, sockptr_t arg, unsigned int len)
>  		return -ENOMEM;
>  	if (tmp.num_counters == 0)
>  		return -EINVAL;
> +	if ((u64)len < (u64)tmp.size + sizeof(tmp))
> +		return -EINVAL;
>  
>  	tmp.name[sizeof(tmp.name)-1] = 0;
>  
> @@ -1504,6 +1506,8 @@ compat_do_replace(struct net *net, sockptr_t arg, unsigned int len)
>  		return -ENOMEM;
>  	if (tmp.num_counters == 0)
>  		return -EINVAL;
> +	if ((u64)len < (u64)tmp.size + sizeof(tmp))
> +		return -EINVAL;
>  
>  	tmp.name[sizeof(tmp.name)-1] = 0;
>  
> diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
> index 636b360311c5365fba2330f6ca2f7f1b6dd1363e..131f7bb2110d3a08244c6da40ff9be45a2be711b 100644
> --- a/net/ipv6/netfilter/ip6_tables.c
> +++ b/net/ipv6/netfilter/ip6_tables.c
> @@ -1135,6 +1135,8 @@ do_replace(struct net *net, sockptr_t arg, unsigned int len)
>  		return -ENOMEM;
>  	if (tmp.num_counters == 0)
>  		return -EINVAL;
> +	if ((u64)len < (u64)tmp.size + sizeof(tmp))
> +		return -EINVAL;
>  
>  	tmp.name[sizeof(tmp.name)-1] = 0;
>  
> @@ -1513,6 +1515,8 @@ compat_do_replace(struct net *net, sockptr_t arg, unsigned int len)
>  		return -ENOMEM;
>  	if (tmp.num_counters == 0)
>  		return -EINVAL;
> +	if ((u64)len < (u64)tmp.size + sizeof(tmp))
> +		return -EINVAL;
>  
>  	tmp.name[sizeof(tmp.name)-1] = 0;
>  
> -- 
> 2.44.0.478.gd926399ef9-goog
> 
