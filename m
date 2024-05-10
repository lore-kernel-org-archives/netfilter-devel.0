Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F231607B9
	for <netfilter-devel@vger.kernel.org>; Fri, 10 May 2024 09:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715331994; cv=none; b=U1Ea2JIhZq3qXFLxJYUQt1YBczQsCEYNBSkyBJnCzw9mgvfcFLtx2X0YB+fMoGiGspfB1Lx9/NonLIwyoxJqkGu6rXu/vilvRq0uL1hJCpG+b+OOoG4eOJL346HCWd275o50V8Y8S9GmkoRNprcRRTQ5UByLaE0co2KKkCCHpFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715331994; c=relaxed/simple;
	bh=HqNh7pKUxjI7AR8E7dkOvCAYOdfmp5047k+aYveLtBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IU1unYq8lzg3UjUHXDruDprc3+vEhHFx8K/SO/TGpIveZCpdpxoiWeQoIbHKSaxMpnwYMRDlgz+7gIpgdJiPuLDjEd3+weUgueadBH4qHsJopRZ+CzZkmhOag787sNaL4iyn9an38ZA/Z75Ij2JzuKWy/nwHHaDB0JQzfo+RYEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1s5MCz-0005jy-Hk; Fri, 10 May 2024 11:06:29 +0200
Date: Fri, 10 May 2024 11:06:29 +0200
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: Sven Auhagen <sven.auhagen@voleatech.de>,
	netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: Could not process rule: Cannot allocate memory
Message-ID: <20240510090629.GD16079@breakpoint.cc>
References: <qfqcb3jgkeovcelauadxyxyg65ps32nndcdutwcjg55wpzywkr@vzgi3sh2izrw>
 <20240508140820.GB28190@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240508140820.GB28190@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Florian Westphal <fw@strlen.de> wrote:
> Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> > When the sets are larger I now always get an error:
> > ./main.nft:13:1-26: Error: Could not process rule: Cannot allocate memory
> > destroy table inet filter
> > ^^^^^^^^^^^^^^^^^^^^^^^^^^
> > along with the kernel message
> > percpu: allocation failed, size=16 align=8 atomic=1, atomic alloc failed, no space left
> 
> This specific pcpu allocation failure aside, I think we need to reduce
> memory waste with flush op.

Plan is:

1. Get rid of ->data[] in struct nft_trans.
   All nft_trans_xxx will add struct nft_trans as first
   member instead.

2. Add nft_trans_binding.  Move binding_list head from
   nft_trans to nft_trans_binding.
   nft_trans_set and nft_trans_chain use nft_trans_binding
   as first member.
   This gets rid of struct list_head for all other types.

3. Get rid of struct nft_ctx from nft_trans.
   As far as I can see a lot of data here is redundant,
   We can likely stash only struct net, u16 flags,
   bool report.
   nft_chain can be moved to the appropriate sub-trans type
   struct.
