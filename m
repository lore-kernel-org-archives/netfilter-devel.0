Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E41282F3A
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Aug 2026 14:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786284867; cv=none; b=jc0JPTu68EKT8aneCIHjbgJv5Z3ibiToLMp9wFzmKQNfQ/4f1gMa4OHef+u4Lvbp/tYjCLZ7iV3ln4eSISL9YiWV/5nttstZ8NKec0h2rFlyrLbBgrDs7pOfSVxOVBp+TSzZ+HBCdJVJQEko0xhu8C+jN4sGlDNbtahwJ7wFIz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786284867; c=relaxed/simple;
	bh=Bb975jW0UqbGiq4IXt2CHDtyQlpBNEjCvPDZeDCTBZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eBNh8Jrwz6lZkuANCilZVWSV7Lj+AAtYmJUUo9JO4i/8YZ2rIbLDaefWJWy4olpHBz+nBFwj4mV8oBUF+wkl3LKGfNZkcMxhJaHL0N96MW0qAKecRXoZdM8I1Ks6aTd8TAzFkWXrdTMPmkRgi5uzB06ri97w0hbfzBy01pqb5AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A40806051B; Sun, 09 Aug 2026 16:14:16 +0200 (CEST)
Date: Sun, 9 Aug 2026 16:14:16 +0200
From: Florian Westphal <fw@strlen.de>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 1/7] netfilter: ipset: remove need to allocate memory
 on delete operations
Message-ID: <aniLOIEhZS19xOuG@strlen.de>
References: <20260806101947.2802-1-fw@strlen.de>
 <20260806101947.2802-2-fw@strlen.de>
 <d65061dc-1142-de3f-349d-c77647d5e15e@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d65061dc-1142-de3f-349d-c77647d5e15e@netfilter.org>

Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> Sigh. It's getting more and more complicated to maintain a fairly simple 
> data structure.

Yup.  Would be very simple for SMP=n :-)

> What do you think which is better for the test (match) case (not 
> add/del), performance-wise:
> 
> - seqcount and retry
> - holes left [and INIT_CIDR() converted to a function to skip the holes
>   and find the first entry for add/del]

Depends on how likely a constant pingpong between 1 / 0 count is.  Given
data (packet) path can't insert a new netmask, I would guess its very
very unlikely, so the seqcount / retry loop is not used at all.
