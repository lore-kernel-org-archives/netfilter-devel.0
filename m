Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6915225765
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Aug 2025 14:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755268134; cv=none; b=nXBVJc3JJmm/2iwjohSrUjU5UgHZYcDQIK/jsbuoG86eNfyseoxCK/pPx+QsHIltYWcAnWTjMeqUAU07asfH8nc0isLUZ/N8LA//GBsfawXgj628kPGjsCwn6zM3yF+PmvNzMu7Vd0ylXVYitH8UDLqMBCKW4JL1WqebqhlESYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755268134; c=relaxed/simple;
	bh=sUy2OoE/006InquQ87AII5TlBuH9M+Hl8KwG9RPScD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VlCVlu1vb0L8bLmymnJbAsaDYJb/ZY8ozzMvOfIy05ve+5b5jDDQmLeRTbpJXqIOLFxhjYzYJYbvlhQg482LWK7QFEW5F9QCWFke0rD3XCu6f60vyNc1JaT1BRcZfL1oouKzmNKvs18xmqqW1OhVfbgnkv+eY4B9UShcXbpLk+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qkzwZ2nB; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qkzwZ2nB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IHX3Xy3rg48KEmX22n/8EfvHNrg81bt9b7d0poSwIOU=; b=qkzwZ2nBAonuuU2Khb2zOYqLBf
	WVc9R6xFxICSuL2hVwvM2TtbHu6klf6NwpOcxzcedvvbJ2gAJ+pmkER6qrkgHESz7VJjj4bmZmAVU
	PpTmUScUY7ynKO5Ls8yuyWDKCdrzGXgjE+BnxM4eFgrXw0zMpDYHvglLmG0K/PjeJWnpLJeAAYcd3
	FHYYZu00Vit1XIPFmGnp4UoBCORZDs5BqrRRZHQo9c8WaD0Y4EP8fvPRDd8om9boxT/6Shrm4sti9
	OyKYGw/0gTZjXqxC8yADbqRo0D1N0tVKYgp0pUsWWuvwdTHupGAnfheubWEW38LkOXfOkIcShNPNX
	T6Oruv6g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umvQI-000000005cr-40uZ;
	Fri, 15 Aug 2025 16:28:50 +0200
Date: Fri, 15 Aug 2025 16:28:50 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 01/12] segtree: incorrect type when aggregating
 concatenated set ranges
Message-ID: <aJ9EIiEiBsCO1gZf@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250813141144.333784-1-pablo@netfilter.org>
 <20250813141144.333784-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813141144.333784-2-pablo@netfilter.org>

On Wed, Aug 13, 2025 at 04:11:33PM +0200, Pablo Neira Ayuso wrote:
> Uncovered by the compound_expr_remove() replacement by type safe function
> coming after this patch.
> 
> Add expression to the concatenation which is reachable via expr_value().
> 
> This bug is subtle, I could not spot any reproducible buggy behaviour
> when using the wrong type when running the existing tests.

So assuming start->etype is EXPR_SET_ELEM and start->key->etype is
EXPR_CONCAT, then the wrong call will change start->expiration instead
of start->key->expr_concat.size. Since this is immediately followed by a
call to 'expr_free(start)', the bogus value in start->expiration has no
effect and since compound_expr_destroy() does not care about the value
in 'size', its wrong value has no effect either. Correct? :)

Cheers, Phil
