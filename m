Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E86817920A
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 16:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724085217; cv=none; b=mJn2Ru1w+OtG8ZqX1zFKZvBE/8l01u3KDY0S7mZZ/D21CcyM7i9JyQAVCJ6O8tF3k1o4vK6Cc1bsPf8PP/CoMruXn6JmYQpH8w6XqAENd7r6bsS6HCGuUF4P/hSj3/QWogMNbIHfgGZgOq9QP7LeJWzXjZ1Fj5rGJhBR79n4apw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724085217; c=relaxed/simple;
	bh=H7bhSBXB9ycphpLVRFp5tvMFEc4VthbeQzxoFV8Zoe8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dUjZkvE/+SdzQJCtl63CgMKJDljkeVWZuvsMww9rsFsRnR/yXBp79W3utMNBKWnQ/zNjKr2LYZfUyCEO2Gb8KZiiKGZSg9ls1/o2IjIKmnkbuXfpB8hwPxs4sMWuWE9hcc6wK+PDILjwVCXyov/Su5edHE4VXrwljdmzqDG9aTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=34262 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sg5Jz-005Zoj-27; Mon, 19 Aug 2024 18:33:33 +0200
Date: Mon, 19 Aug 2024 18:33:30 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Nadia Pinaeva <n.m.pinaeva@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: store new sets in
 dedicated list
Message-ID: <ZsNz2lTEqLsiIn6R@calendula>
References: <20240710085835.1957-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240710085835.1957-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

On Wed, Jul 10, 2024 at 10:58:29AM +0200, Florian Westphal wrote:
> nft_set_lookup_byid() is very slow when transaction becomes large, due to
> walk of the transaction list.
> 
> Add a dedicated list that contains only the new sets.
> 
> Before: nft -f ruleset 0.07s user 0.00s system 0% cpu 1:04.84 total
> After: nft -f ruleset 0.07s user 0.00s system 0% cpu 30.115 total
> 
> .. where ruleset contains ~10 sets with ~100k elements.
> The above number is for a combined flush+reload of the ruleset.
> 
> With previous flush, even the first NEWELEM has to walk through a few
> hundred thousands of DELSET(ELEM) transactions before the first NEWSET
> object. To cope with random-order-newset-newsetelem we'd need to replace
> commit_set_list with a hashtable.
> 
> Expectation is that a NEWELEM operation refers to the most recently added
> set, so last entry of the dedicated list should be the set we want.
> 
> NB: This is not a bug fix per se (functionality is fine), but with
> larger transaction batches list search takes forever, so it would be
> nice to speed this up for -stable too, hence adding a "fixes" tag.

applied to nf-next, thanks
