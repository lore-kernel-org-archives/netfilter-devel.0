Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4920E451984;
	Wed,  7 Oct 2026 11:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791372410; cv=none; b=DGWxOc5hFtREUYRVlu7IOdp+yZJ1rWKeeRj6tKI+1Zg5kupX7TKv5yu57KrW9XI6qDvK55A5FUTG8BvK87xK8HfefF5Gl8GWI35/8S775o2JELYCaUJ1dKVV9/sgkC+KgrXrZYLahR44ymThkIgqKmvkTFHYKuJaYY8/Q9bVKb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791372410; c=relaxed/simple;
	bh=nNz+2pukxDgm4VGMq38mx9djubvzUb0FJlvPkBsqTEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t29EAtNEp4UVGMn5JXlu8pekQE5NwCxMMqfP2tkVXiXBtapjk1zUi5oVO1zL2fItcjZQkqZNBfGZa7O83YUB5u5xD2Td05q3VkW8eeISgHw190eNy2NqKwnWvVh8AD3EM2vrGV56EDnETAAwaO4mIqUvxQlx+cQ0H30SKv0QISo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AA3136038C; Wed, 07 Oct 2026 13:26:32 +0200 (CEST)
Date: Wed, 7 Oct 2026 13:26:27 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Daehyeon Ko <4ncienth@gmail.com>, phil@nwl.cc,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net v3] netfilter: conntrack: avoid recursive master
 destruction
Message-ID: <asYsY-yLXNVFc_Rv@strlen.de>
References: <20261007014802.2615503-1-4ncienth@gmail.com>
 <asYHaUFdxo0flpAe@strlen.de>
 <asYf2b03D78kWdkZ@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asYf2b03D78kWdkZ@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > That said, ignoring the source of the problem is not good.
> > 
> > I see no point whatsoever for a expected connection to have a
> > non-control connection as its master.
> 
> I would prefer if chain length is limited too, ie. tighten this
> interface based on the LLM feedback.

Thanks, working on this now.  Tentative plan:

#define NF_CT_MAX_EXPECT_CHAIN_LEN     4

static inline bool nf_ct_master_acceptable(const struct nf_conn *m)
{
       unsigned int depth = 0;

       while (m->master) {
               if (++depth > NF_CT_MAX_EXPECT_CHAIN_LEN)
                       return false;
               m = m->master;
       }

       return true;
}

 struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 {
        struct nf_conntrack_expect *new;
 
+       if (!nf_ct_master_acceptable(me))
+               return NULL;
+

I'll make an independent submission for this.
