Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6E436998F
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 05:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777269402; cv=none; b=l1mHVs+TRiE0ue9c/g5aoFSw21ewdM2Gm+5MSWy45T7XT/yAPgKy07Z1qUhwRReJi4T7+JbLjIZUZbWufb3TVUNAX4LgqL0tREBeI+ELqS/lGoqVbsP6pto5Xzoq9VRysVj8O+j6B7immSjZgLD2CPg8BKGWouttP469HTiaa7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777269402; c=relaxed/simple;
	bh=PIG9bW07NR3ONaKyaZFCOHDv3oEp2APTvF/He80COsU=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H1iDmpveJVKrQ8VH4axqePsWa2euXerjuGj5VFgkmPOF/0UsMcYF7jEICG0Pk7elylPolSz4AikGqR3TXsEluZ+qV2AVNdwRdmwy3s7I09MMvcn3dtdZq8tynVWrUKOuOnkTwZAQh3MGz4gA2DZ4/e4u/CrLkFc+N0y2sa5d/jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 05F3060640; Mon, 27 Apr 2026 07:56:37 +0200 (CEST)
Date: Mon, 27 Apr 2026 07:56:37 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: add test case for netdev + dormant
 table
Message-ID: <ae76lUWtvOUDuOCz@strlen.de>
References: <20260426144456.146241-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260426144456.146241-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> both commit update and abort path need to release memory associated with
> netdev hooks.  kfree gets skipped because it mixes registration and
> allocation.

I have a kernel fix for this bug but I am waiting for the pending PR to
get merged before sending it, the fix depends on the new unlink+free
helper and doesn't apply to main branch.
