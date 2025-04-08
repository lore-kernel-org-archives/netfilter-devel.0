Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F609266B40
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Apr 2025 09:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744106115; cv=none; b=L4In5T65iCdjWi7Iyr2vmfrrrf1YuARagen0KI+1s05XuGdTytvBgnXzanRtMWyhPA/REq2TL6ZR9qLeFeXGmVY7CbXg/r4s1QIc7GU/oi6/rEYIt8QEBFP1i0tqePQrRlhwoyGSfTm/hCBWZdMLdlCdp5vMNc43Oqa2Vq9RDQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744106115; c=relaxed/simple;
	bh=/ZS7BugfvAYo65qIpwLxLz9/8oOhDnmO6Htdg91OBJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PMyLah0zDUA8xYhwE6vkWtlq08NYMkVxCqBDEhbLRXGsKbRm0tlGvbO77HO+huWV2zU4OCS2H8tnRWB9Uq9Utk/jxvf3JBrp15eA19HNO6eilz0VeK0T86yEMzYQIPNSnPzSaUPccbuNZ5RZXDampDyjA9yS7jF3piRvREa6vGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u25fg-0000D0-Pe; Tue, 08 Apr 2025 11:55:08 +0200
Date: Tue, 8 Apr 2025 11:55:08 +0200
From: Florian Westphal <fw@strlen.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3 nf 3/3] nft_set_pipapo: add avx register usage
 tracking for NET_DEBUG builds
Message-ID: <20250408095508.GA536@breakpoint.cc>
References: <20250407174048.21272-1-fw@strlen.de>
 <20250407174048.21272-4-fw@strlen.de>
 <20250408092949.1afdee61@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250408092949.1afdee61@elisabeth>
User-Agent: Mutt/1.10.1 (2018-07-13)

Stefano Brivio <sbrivio@redhat.com> wrote:
> I wonder, by the way, if 1/3 and 2/3 shouldn't be applied meanwhile
> (perhaps that was the reason for moving this at the end...?).

Yes, that was one of the reasons.

Pablo, I will resend this patch later, targeting nf-next.
I will not resend patches 1 and 2.

> Otherwise it's a bit difficult (for me at least) to understand how this
> macro should be used (without following the whole path). Alternatively,
> a comment could also fix that I guess.

I prefer better variable name to comments.

> Everything else looks good to me, thanks for all the improvements!

Thanks for reviewing.  I will wait for patches 1 and 2
to make it to nf, then for nf->nf-next resync and will
then resend this with all of your change requests included.
