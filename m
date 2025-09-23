Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C662D239F
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2025 17:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758650342; cv=none; b=pUGqOJYKByN8FNNJ6h3w7GID1hY9G8jVwhKPfkzzF36Ftio2ItjNq6bzu2nUJhyFhfGKGBgd1HiN/5+NPAtTaofiQLnJ9I5YuDZVYma5ve8pJJULChB4SMWIXvOb0b4sCIZYfzhYkfFvgjIG/lyYyMrnj12YlmaBHXMttXR7GsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758650342; c=relaxed/simple;
	bh=r599UsrGZtUI3RfbBkI8HQTg8tPmVjv9G2ecu7Yt0hU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gEUx6SA/Zuk3Ccgxc1LOZa2AzSiEWTEOQQJeY+taHwccxw7vF8Q9eO+ZSQd+uYJ0elu+Jk5kqcmk+ysjQ14zIUj+9Jk3OzEFprirjWdCcwPZQFQCm3zeLowRNuKZVtUGteLjL9kJHB92+KuzxSmvZPxU7vfBeeaLn2Q/zBKqRSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A31B761935; Tue, 23 Sep 2025 19:58:57 +0200 (CEST)
Date: Tue, 23 Sep 2025 19:58:57 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org
Subject: Re: [PATCH RFC nf-next] netfilter: nf_tables: add math expression
 support
Message-ID: <aNLf4Uj9Faye2fTu@strlen.de>
References: <20250923152452.3618-1-fmancera@suse.de>
 <aNLMF2CdcCKWi4cI@strlen.de>
 <19498e76-bd17-4e63-9144-8cff9874d3da@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19498e76-bd17-4e63-9144-8cff9874d3da@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> > Why?  Any particular reason for this?
> > 
> 
> It is for simplicity reasons. Just to avoid a big payload with byteorder 
> conversions per math expression.

Not sold yet. I'd like to hear Pablos opinion.

> > Should it set NFT_BREAK?
> > 
> I don't think so. If the user wants to increase or decrease a field but 
> it already reached the limit IMO it shouldn't do anything but continue 
> with the next expression instead of setting NFT_BREAK. Anyway, not a 
> deal breaker for me..

I was just curious.  No objections from me.

> > I assume this says 'host' because its limited to 8 bits?
> 
> Yes, well it says "host" because I used NFT_MATH_BYTEORDER_HOST to 
> generate it, anyway it doesn't matter as it is 8 bits. Would it be 
> better to hide byteorder if it doesn't matter?

No, I would prefer simpler code, no need to special case this IMO.

> > AFAICS you need to add support for a displacement
> > offset inside the register to support this (or I should write:
> > work-around-align-fetch-mangling ...)

[..]

> What would be the best way to implement this? A pure bit offset 
> (NFT_MATH_OFFSET) or a bitmask (NFT_MATH_BITMASK)?

Bitmask would allow to remove MATH_LEN, correct?

Users that want pure U8 increment can do 0xff000000
resp.  0x000000ff.

Same for U16.  So I'd say a mask would be better.

> > Can you make it NLA_U32?  NLA_U8 doesn't buy anything except
> > limiting us to 255 supported options (i don't see a use case
> > for ever having so many, but if we ever have we don't need new OP32
> > attribute).
> 
> Sure, no problems about that. Also NFTA_MATH_LEN? I do not see a U32 
> bits operation happening in the future tho.

Yes, good question.  Due to netlink padding neither u8 nor u16 saves
space in the message encoding.  I'll leave it up to you, I don't see
2**32 math len making any sense.

> By default I thought that a module made sense.. but it is true it is 
> "general" purpose code and small. I don't really mind.
> 
> > I would also be open to just extending bitwise expression with this
> > inc/dec, both bitwise & math expr do register manipulations.
> 
> While both do register manipulation, I do not think they fit together 
> from a user perspective. Especially if we extend the number of math 
> operations in the future.

Users don't interact with the expressions directly.
But I understand your point.

Pablo, whats your take?
