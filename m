Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA21A11183
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Feb 2024 08:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707986302; cv=none; b=YBFtnCg66jTpdE7qDHCl6WCW1SEMJQb2l/WZVY5cwvZW8WadxVY6dPXj3p+GQhbocNLeuQuRm+yDB8aIeFs8Znu0zwUHvdztTePLlGz7f/BRlvC0YMDukP7yCsm6Co9LE32u22qgT38T2Ew0AFwPjO34NIqKNVUOTEMGe8rHer0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707986302; c=relaxed/simple;
	bh=M7X6YK6X2E92H99JZPezWnY/1U5rh5yIgh70AyOycIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gi/JWFXrRwr9ho/AqnRAM/c4Wzy9TOwkEXQplIjwbTKUBpAo+jdk5May1JpSMgS0j+k22GN6GF5nHvUL3HfEE6gi3uTsEf0egNy/Rq45wS1ZNpn9Hlva5LKuthrXrfROHy9q0eyxRt6xvoDQ1zns9Xi6/Xk7G9y+dqBl6y+1G/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1raXG6-0006sx-Hm; Thu, 15 Feb 2024 09:38:18 +0100
Date: Thu, 15 Feb 2024 09:38:18 +0100
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, sbrivio@redhat.com
Subject: Re: [PATCH v2 nf-next 2/4] netfilter: nft_set_pipapo: do not rely on
 ZERO_SIZE_PTR
Message-ID: <20240215083818.GA25716@breakpoint.cc>
References: <20240213152345.10590-1-fw@strlen.de>
 <20240213152345.10590-3-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240213152345.10590-3-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Florian Westphal <fw@strlen.de> wrote:
> pipapo relies on kmalloc(0) returning ZERO_SIZE_PTR (i.e., not NULL
> but pointer is invalid).
> 
> Rework this to not call slab allocator when we'd request a 0-byte
> allocation.
> 
> While at it, also use GFP_KERNEL allocations here, this is only called
> from control plane.

For the record, Pablo points out this is incorrect, as "nft get element"
holds rcu read lock and not the transaction mutex.

Existing nftables shell tests trigger sleeping-while-atomic splat here.

> -	res_map = kmalloc_array(m->bsize_max, sizeof(*res_map), GFP_ATOMIC);
> +	res_map = kmalloc_array(m->bsize_max, sizeof(*res_map), GFP_KERNEL);

I've applied the patch without the GFP_KERNEL replacement, no other
changes, shell tests pass after this.
