Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A631C231C9F
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Apr 2026 12:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775909689; cv=none; b=deKZ9SfWBO4kXvz5URqz8mQN5By4EdemIXvrS9LJDaDtJ+8vHflSRCqJOLjIQ1MEW3Ha9xXOm2vxSFAsuC9kptXv9fMpeoURFJU1WYjLSVQqv1CKqQkrx5eKYyYbDpS0Dfpa7Zzadt+lGa4xbpFaZVl6OhWY6zC/hdANlH9Yri4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775909689; c=relaxed/simple;
	bh=VxA1SEJo/Rwb1hbW8w2OllWKpnNYNr6y5mJHEhv3dsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OL4YvzDa4JEvZD/AAVQFrt3gkHrMJ/ESPcfGTxa1/p3gxUjldhOC8gSgVl5EaiYIL7FdtZiRNBXpAwMfReQHW8u8Az42mn8A9uOg2HeAX4vyCX8dAc54fkJoxK86FLIbg7XRvhaMOCSNMa8qGC3AiXB8tlu9rrhWXX8F9X8hSZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8EFB060491; Sat, 11 Apr 2026 14:14:45 +0200 (CEST)
Date: Sat, 11 Apr 2026 14:14:45 +0200
From: Florian Westphal <fw@strlen.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nft_set_pipapo_avx2: restore
 performance optimization
Message-ID: <ado7NVm_yFVwASx-@strlen.de>
References: <20260401110230.19226-1-fw@strlen.de>
 <20260411123015.4a78f491@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260411123015.4a78f491@elisabeth>

Stefano Brivio <sbrivio@redhat.com> wrote:
> ...right, I'm not exactly proud of it, but if we don't hide that stuff
> the amount of visual noise explodes. I couldn't think of any better
> solution.

It's fine as-is, I just missed that "ret" thing in the first place.

> I really couldn't understand how turning those into "else if" would have
> anything to do with the scope "ret"... until I realised and actually
> read your reference. Oops.

I've sent a v2 that moves the LLM report ahead.
I hope its a bit better this way.  Actual patch is not changed so I
copied your RvB tag.

> intermediate matching bitmap (between fields) with a lot of leading
> zeroes.

Right.  Thanks for reviewing!
