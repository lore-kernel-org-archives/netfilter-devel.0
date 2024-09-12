Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F26F1A4E80
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 12:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726145807; cv=none; b=vFUTkHXo8FD7HIXVXt3j4cmPl9DY2j7Abej3MNFdy/7+HfjFgt14EaGp8zs8JWnGxYpMXF+1yiTb9Qn+lqSbMAs75otLUQKkEdxTHtl89sBKYMrM1pktRSrBgSj9yGK82Ktyrh0t8gHjvx1K92AZJj4SksrJHaX8ylJmGpTk+YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726145807; c=relaxed/simple;
	bh=VV2Jo3tGkQlgKSPbStAgNIlL2kFLzvuYGuomn0xDS2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K2v8FFVl2+hbCDn+SgYvEZvLPb24LywTbfvHbx/EqgcjJCM/klRtlgyaDaPs1Y8zpGB1Ds1RsXrygg8wYOUq6+RAZw3wr6eTGJxOooVB9BFQ9F1A/eypGtraO0WLl+kl7Q7wdfcUCBZ9eLNXkKQojq8T8XXHvmET4SDJ5R6VM0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sojNJ-00016p-KZ; Thu, 12 Sep 2024 14:56:41 +0200
Date: Thu, 12 Sep 2024 14:56:41 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v3 03/16] netfilter: nf_tables: Store
 user-defined hook ifname
Message-ID: <20240912125641.GA2892@breakpoint.cc>
References: <20240912122148.12159-1-phil@nwl.cc>
 <20240912122148.12159-4-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240912122148.12159-4-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> Prepare for hooks with NULL ops.dev pointer (due to non-existent device)
> and store the interface name and length as specified by the user upon
> creation. No functional change intended.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/net/netfilter/nf_tables.h | 2 ++
>  net/netfilter/nf_tables_api.c     | 6 +++---
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index c302b396e1a7..efd6b55b4914 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -1191,6 +1191,8 @@ struct nft_hook {
>  	struct list_head	list;
>  	struct nf_hook_ops	ops;
>  	struct rcu_head		rcu;
> +	char			ifname[IFNAMSIZ];
> +	u8			ifnamelen;
>  };
>  
>  /**
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 3ffb728309af..f1710aab5188 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -2173,7 +2173,6 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
>  					      const struct nlattr *attr)
>  {
>  	struct net_device *dev;
> -	char ifname[IFNAMSIZ];
>  	struct nft_hook *hook;
>  	int err;
>  
> @@ -2183,12 +2182,13 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
>  		goto err_hook_alloc;
>  	}
>  
> -	nla_strscpy(ifname, attr, IFNAMSIZ);
> +	nla_strscpy(hook->ifname, attr, IFNAMSIZ);
> +	hook->ifnamelen = nla_len(attr);


Hmm. nft_netdev_hook_alloc has no netlink attribute policy validation
:-/

Can you add another patch that fixes this up?


I'd suggest to move the if (nla_type(tmp) != NFTA_DEVICE_NAME)
test from nf_tables_parse_netdev_hooks() into nft_netdev_hook_alloc
so nft_chain_parse_netdev() also has this test.

Then,
> -     nla_strscpy(ifname, attr, IFNAMSIZ);

Into:

	err = nla_strscpy(ifname, attr, IFNAMSIZ)
	if (err < 0)
		goto err_hook_dev;

so we validate that
a) attr is NFTA_DEVICE_NAME
b) length doesn't exceed IFNAMSIZ.

ATM this check is implicit because nla_strscpy() always
null-terminates and the next line will check that the
device with this name actually exists.

But that check is removed later.
This patch can then set

 hook->ifnamelen = err

without risk that nla_len() returns 0xfff0 or some other bogus
value.
