Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91861509B7;
	Fri,  3 May 2024 10:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714732916; cv=none; b=r7bxTJmRPO5YDTs95ciHv6/HgHcbIh+/eyeDAVnPsD4xkAZlSN+EGFSPb9tM92UvvpHScGLh7RzcNHcw0vsCzEnVZIXMBVwlcWz31VFv9+l2Gbz0BcWdCXILSHevHhuZEnB8Y7VJ1vAtUxlvnxGZ+c7XROQjVMLpYYFJBRro/Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714732916; c=relaxed/simple;
	bh=BeMHoJOu1sgwWKRFqAwYYsALNTVJWj+Tn/G61kiqAUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cVEJkxv7jLefLGZdkKqETtPQqRsfzhXzZm2qtxwnRCyBN95gAx/j2w+xtmBPMNuHCDTxUoPiEaPCQ6hePYwfFsqGv6gUKd1Wp4+wDVKpj51dgwZz96b6CGzrRrHUWz3DbpCqy3nvHIh2DNl/heDz1a2Tc0RXHw6FgtMkdiRZJIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1s2qMJ-0000Yk-Qq; Fri, 03 May 2024 12:41:43 +0200
Date: Fri, 3 May 2024 12:41:43 +0200
From: Florian Westphal <fw@strlen.de>
To: kernel test robot <lkp@intel.com>
Cc: Florian Westphal <fw@strlen.de>, oe-kbuild-all@lists.linux.dev,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [netfilter-nf:under-review 14/18]
 net/netfilter/nft_set_pipapo.c:2122: warning: expecting prototype for
 __nft_pipapo_walk(). Prototype was for nft_pipapo_do_walk() instead
Message-ID: <20240503104143.GA9734@breakpoint.cc>
References: <202405031522.nDHvTzEz-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202405031522.nDHvTzEz-lkp@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

kernel test robot <lkp@intel.com> wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git under-review
> head:   7ab960ad3bd958ddbeabe9ab2287ac5d0a673f23
> commit: cd491237776df450e99904b9408bfad35366a73f [14/18] netfilter: nft_set_pipapo: prepare walk function for on-demand clone
> config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20240503/202405031522.nDHvTzEz-lkp@intel.com/config)
> compiler: sh4-linux-gcc (GCC) 13.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240503/202405031522.nDHvTzEz-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202405031522.nDHvTzEz-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> net/netfilter/nft_set_pipapo.c:2122: warning: expecting prototype for __nft_pipapo_walk(). Prototype was for nft_pipapo_do_walk() instead

Sigh.  Pablo, can you squash this to
"netfilter: nft_set_pipapo: prepare walk function for on-demand clone"?

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index be5c554ca4d3..1a1dcb646af5 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2100,7 +2100,7 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
 }
 
 /**
- * __nft_pipapo_walk() - Walk over elements in m
+ * nft_pipapo_do_walk() - Walk over elements in m
  * @ctx:       nftables API context
  * @set:       nftables API set representation
  * @m:         matching data pointing to key mapping array

