Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB482356DD
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Apr 2025 10:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743591005; cv=none; b=SpU7NIVblsLqBq+RCaNKNzqSCz1bcBJtu+1MMyg/tCVqxWRt7kn9I75mnl1G+sKMXFHGk5J+POj5bCWHNRpXB4R0/I42SbJ7qu6Pf3GfoSV8/FOEi+m6KvwKasRHqzZp11oIBEEcBLIUvPS57z9iUqmyWetpOVTNrZCv5vwJjyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743591005; c=relaxed/simple;
	bh=NK/4ZMxKVooEusBOmZe3pJcim51k/LYI7P8Fsu3gmZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sJ1meVbh5C/ZfBNesNX2xsBIs71ojbtyJOJa4uXjWlups7gBYnuEoMWF8bC9kzcyQy+hRT8peDaGokOSEC/ytwVEAPPcGZ5X3gihB3Uw8cGvhvAY+LuOjMSpYhEtg2b3Xtddlgr2ghZM5cLzm0L4OBZ4rH8htLgXKjVuR36uYYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tzvfT-00016d-W5; Wed, 02 Apr 2025 12:50:00 +0200
Date: Wed, 2 Apr 2025 12:49:59 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot+53ed3a6440173ddbf499@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: don't unregister hook when
 table is dormant
Message-ID: <20250402104959.GA4219@breakpoint.cc>
References: <20250401123651.29379-1-fw@strlen.de>
 <Z-0THLCSy917XRq0@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-0THLCSy917XRq0@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I just made another pass today on this, I think this needs to be:
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index c2df81b7e950..a133e1c175ce 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -2839,11 +2839,11 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
>                         err = nft_netdev_register_hooks(ctx->net, &hook.list);
>                         if (err < 0)
>                                 goto err_hooks;
> +
> +                       unregister = true;
>                 }
>         }
>  
> -       unregister = true;
> -
>         if (nla[NFTA_CHAIN_COUNTERS]) {
>                 if (!nft_is_base_chain(chain)) {
>                         err = -EOPNOTSUPP;
> 
> This is the rationale:

[..]

I've marked the patch as rejected.  I'm not sure what the pre and
postconditions for non-netdev is in this function, so I won't send a v2.
