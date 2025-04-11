Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FE727604F
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Apr 2025 20:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744401988; cv=none; b=govhWwu4SrVo8xuvsnGtO/CyDlFTglwfELmkoAxMaf29sI3NGEluNsnH6p1lbeHMQk/ZzIaCW/DpZxoT8lRHNNtE2bisLanxCP7pwcwmscawV7tU9W6Bu+2N6ioLGZUMknmYseLXPIIa/grUeONnL+vLb21gzGgPGyJJ0OBhNwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744401988; c=relaxed/simple;
	bh=VuPg1l+TIa2/AqRcoeZCnj1cGXwlRAzHcd66jCuQXWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CfeFp750zISgeY1/1idAedW5DjEsfOSKa24Hxk84qDVczcmR74nJCBJ7Rj4/Ay81RYJudIEeE4PxG2RqmH//LvyO5Hopo3pAKfeb6EN54Xe+BJtKskL4ylSs+jU3MT9e2NQsHpDAh717BPkZPhMO4Dxv29EyAoBRqKHKcyDIfps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u3Kdm-0004R4-48; Fri, 11 Apr 2025 22:06:18 +0200
Date: Fri, 11 Apr 2025 22:06:18 +0200
From: Florian Westphal <fw@strlen.de>
To: Corubba Smith <corubba@gmx.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd2,v2 1/4] ulogd: add linux namespace helper
Message-ID: <20250411200618.GA17027@breakpoint.cc>
References: <c5cd1c3a-3875-4352-8181-5081103f96f6@gmx.de>
 <20250326192343.GA2205@breakpoint.cc>
 <92773ecf-bfbd-45b5-a83e-72efe26aba0b@gmx.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92773ecf-bfbd-45b5-a83e-72efe26aba0b@gmx.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Corubba Smith <corubba@gmx.de> wrote:
> On 3/26/25 20:23, Florian Westphal wrote:
> > Corubba Smith <corubba@gmx.de> wrote:
> >> The new namespace helper provides an internal stable interface for
> >> plugins to use for switching various linux namespaces. Currently only
> >> network namespaces are supported/implemented, but can easily be extended
> >> if needed. autoconf will enable it automatically if the required symbols
> >> are available. If ulogd is compiled without namespace support, the
> >> functions will simply return an error, there is no need for conditional
> >> compilation or special handling in plugin code.
> >>
> >> Signed-off-by: Corubba Smith <corubba@gmx.de>
> >
> > Looks good to me, I intend to apply this later this week unless
> > there are objections.
> 
> If I may be so bold: Friendly reminder that this patchset is not yet
> applied, and in the meantime I also sent a v3 [0] incorporating your
> feedback.

I know, the patches are deferred until after next ulogd2 release which
should happen next week.
