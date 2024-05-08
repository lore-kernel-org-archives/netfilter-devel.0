Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7829B5228
	for <netfilter-devel@vger.kernel.org>; Wed,  8 May 2024 14:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715177305; cv=none; b=CtSVQED3Ot2Wfp/U0GjTBHw92O9JmIKr9Prk+kn892KJo5VemZ09d+2YR35ZdcoIB+uX0z4OmwylJZ8WxfBKhmTjJV9NxZiPlVp9EEgEO7Cq8t4vKpeVcelYLMLi39/4DPoouqA0HMjSK1j9OCr5mfzVQy77GjR03GYDgIV2XQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715177305; c=relaxed/simple;
	bh=XBVKn1+/ui9HIq6ED+WTWu4SRcKY2YpK35ERnVHQb+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rjTXWM6SSOreY5l7yYZdlwD9Yr4T673/mN2yCoqSGi7uf1HYh6L2YYzv3cHqAQtX5lrRVWeHx8VufZGDNITrB4OrwtxmR/fN5YCsNBc5IvXX2a9EuCaBIP/EutE08vOZvlX3Fu1VkX27YYFuASL3NATTW9mREEbZA0ZmhUKkLtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1s4hy0-00056b-80; Wed, 08 May 2024 16:08:20 +0200
Date: Wed, 8 May 2024 16:08:20 +0200
From: Florian Westphal <fw@strlen.de>
To: Sven Auhagen <sven.auhagen@voleatech.de>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, pablo@netfilter.org
Subject: Re: Could not process rule: Cannot allocate memory
Message-ID: <20240508140820.GB28190@breakpoint.cc>
References: <qfqcb3jgkeovcelauadxyxyg65ps32nndcdutwcjg55wpzywkr@vzgi3sh2izrw>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qfqcb3jgkeovcelauadxyxyg65ps32nndcdutwcjg55wpzywkr@vzgi3sh2izrw>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> When the sets are larger I now always get an error:
> ./main.nft:13:1-26: Error: Could not process rule: Cannot allocate memory
> destroy table inet filter
> ^^^^^^^^^^^^^^^^^^^^^^^^^^
> along with the kernel message
> percpu: allocation failed, size=16 align=8 atomic=1, atomic alloc failed, no space left

This specific pcpu allocation failure aside, I think we need to reduce
memory waste with flush op.

Flushing a set with 1m elements will need >100Mbyte worth of memory for
the delsetelem transactional log.

The ratio of preamble to set_elem isn't great, we need 88 bytes for the
nft_trans struct and 24 bytes to store one set elem, i.e. 112 bytes per
to-be-deleted element.

I'd say we should look into adding a del_setelem_many struct that stores
e.g. up to 20 elem_priv pointers.  With such a ratio we could probably
get memory waste down to ~20 Mbytes for 1m element sets.
