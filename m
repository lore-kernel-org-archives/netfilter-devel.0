Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542C828689A
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Sep 2025 12:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758024489; cv=none; b=LyMyfVLUUG8m9bI/VOAAYEuKT1YrGQ27XikC9p2Oqh4ACCgMB57k/y2x6BESI0ubakxY2VfruwfjPayUffQzzoWVrLhRoezkNLelb/ygmuTyQ9Qj6xjciwKvVcWiFLoKX64ZZPP/yiWNDtrcp034cNWvJFvKXFWZkruVnmRIH+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758024489; c=relaxed/simple;
	bh=NiMPoLe6TdXjKRaVImMWth7M0n5+C5b7kQYyTukt+Sk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ASDHRGozFU74epDO0m6YeRod+gp9bHPgoqCLsVupLeEhk3OIiEALK/sJ6YWWsWolFfvAeOHs5RKIwYUzSuVVJD7l2Sv7+OqXIjWQbx3iioGlbi1RyCEuvLKcZsPYsDH5yKYk8U1uXOywvsEKQtE4iwW+GvxSH8ff9oQh+xsiLK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 11FE560308; Tue, 16 Sep 2025 14:08:04 +0200 (CEST)
Date: Tue, 16 Sep 2025 14:08:03 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl RFC] data_reg: Improve data reg value printing
Message-ID: <aMlTI4-QYkkwgTEX@strlen.de>
References: <20250911141503.17828-1-phil@nwl.cc>
 <aMiC3xCrX_8T8rxe@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMiC3xCrX_8T8rxe@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Phil,
> 
> On Thu, Sep 11, 2025 at 04:11:45PM +0200, Phil Sutter wrote:
> > The old code printing each field with data as u32 value is problematic
> > in two ways:
> > 
> > A) Field values are printed in host byte order which may not be correct
> >    and output for identical data will divert between machines of
> >    different Endianness.
> > 
> > B) The actual data length is not clearly readable from given output.
> > 
> > This patch won't entirely fix for (A) given that data may be in host
> > byte order but it solves for the common case of matching against packet
> > data.
> > 
> > Fixing for (B) is crucial to see what's happening beneath the bonnet.
> > The new output will show exactly what is used e.g. by a cmp expression.
> 
> Could you fix this from libnftables? ie. add print functions that have
> access to the byteorder, so print can do accordingly.

FWIW I prefer this patch.

While it would be possible to move all printing to libnftables (and
as you point out it has more information available wrt. to the data
types involved, esp. byteorder), I think that printing the data
byte-wise rather than per u32 word is sufficient for debugging a wide
range of bugs.  In particular it will expose the true size of the
immediate/rhs value.
