Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FED18FDA5;
	Sun, 13 Apr 2025 09:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744535305; cv=none; b=COK3z91p8kqJaXpZyS/COheBnp8u7s1EXSFy7c9qIQrt82yhpiqXZ2hULLYnT3gDrkgtfg6DNg9ZHjJicka0XW2/2y3Ugqsx9XwApWdvOEaiDNpLM0C/KEfaV04cHhz0j8gOazWWCZLNEllr3u2rlgmppXpRgmVEZYwdypbiEk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744535305; c=relaxed/simple;
	bh=hY70RgUzIaYDB8r9oBPfUFVbPt7/tFSK8kAT5IQ5R2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UhnaLsnsWr3IPQ/duyzlHWj1TvSfdabNwQmP7F09I1nvEkyuldMjDlCaALW14l6z9VnHE5C5wDnNSBwILyripKHOscoWcons9IhKUcuOoH/vHJfdRE2Rj94MwlVEtU6341xvj937jcfaxEVL/GpiibGnrHRCArHA2GBCw11HEu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u3tJj-0001aS-JW; Sun, 13 Apr 2025 11:07:55 +0200
Date: Sun, 13 Apr 2025 11:07:55 +0200
From: Florian Westphal <fw@strlen.de>
To: lvxiafei <xiafei_xupt@163.com>
Cc: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
	horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org,
	linux-kernel@vger.kernel.org, lvxiafei@sensetime.com,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	pabeni@redhat.com, pablo@netfilter.org
Subject: Re: [PATCH V5] netfilter: netns nf_conntrack: per-netns
 net.netfilter.nf_conntrack_max sysctl
Message-ID: <20250413090755.GA5987@breakpoint.cc>
References: <20250407095052.49526-1-xiafei_xupt@163.com>
 <20250412172610.37844-1-xiafei_xupt@163.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250412172610.37844-1-xiafei_xupt@163.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

lvxiafei <xiafei_xupt@163.com> wrote:
> +    Maximum number of allowed connection tracking entries per netns. This value
> +    is set to nf_conntrack_buckets by default.
> +
> +    Note that connection tracking entries are added to the table twice -- once
> +    for the original direction and once for the reply direction (i.e., with
> +    the reversed address). This means that with default settings a maxed-out
> +    table will have a average hash chain length of 2, not 1.
> +
> +    The limit of other netns cannot be greater than init_net netns.
> +    +----------------+-------------+----------------+
> +    | init_net netns | other netns | limit behavior |
> +    +----------------+-------------+----------------+
> +    | 0              | 0           | unlimited      |
> +    +----------------+-------------+----------------+
> +    | 0              | not 0       | other          |
> +    +----------------+-------------+----------------+
> +    | not 0          | 0           | init_net       |
> +    +----------------+-------------+----------------+
> +    | not 0          | not 0       | min            |
> +    +----------------+-------------+----------------+
>  
>  nf_conntrack_tcp_be_liberal - BOOLEAN
>  	- 0 - disabled (default)
> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> index 3f02a45773e8..062e67b9a5d7 100644
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -320,7 +320,6 @@ int nf_conntrack_hash_resize(unsigned int hashsize);
>  extern struct hlist_nulls_head *nf_conntrack_hash;
>  extern unsigned int nf_conntrack_htable_size;
>  extern seqcount_spinlock_t nf_conntrack_generation;
> -extern unsigned int nf_conntrack_max;
>  
>  /* must be called with rcu read lock held */
>  static inline void
> @@ -360,6 +359,13 @@ static inline struct nf_conntrack_net *nf_ct_pernet(const struct net *net)
>  	return net_generic(net, nf_conntrack_net_id);
>  }
>  
> +static inline unsigned int nf_conntrack_max(const struct net *net)
> +{
> +	return likely(init_net.ct.sysctl_max && net->ct.sysctl_max) ?
> +	    min(init_net.ct.sysctl_max, net->ct.sysctl_max) :
> +	    max(init_net.ct.sysctl_max, net->ct.sysctl_max);
> +}

Is there a reason you did not follow my suggstion in
https://lore.kernel.org/netdev/20250410105352.GB6272@breakpoint.cc/

to disable net->ct.sysctl_max == 0 for non init netns?

You could then make this

   if (likely(init_net.ct.sysctl_max))
	return min(init_net.ct.sysctl_max, net->ct.sysctl_max);

   return net->ct.sysctl_max;

... or am i missing something?

Aside from that (and the needed #IS_ENABLED() guard) this change looks
good to me.
