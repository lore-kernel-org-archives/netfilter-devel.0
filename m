Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA222184
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2025 00:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736382714; cv=none; b=HXIVFHrcHT4PxDUClPrAcVQVg9Wvwqliq71KFKYdEujhZo71Pkz7RBzei7pJJsywBECS5Ogk1QFf3J3tsvoMdLzbyeu+7DRi9vaMiiuM3KR1nBNd0I1hzwL59rLZEO6Ti/2v7Je74LERGNLorDg9O27AO+Rq2Sg7Rpsbd9Q9u+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736382714; c=relaxed/simple;
	bh=/9xI9cP7yIerkBUuRePb84iXxJYkVQXBWB1B54r9lXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d4ZIs7ZclF2TY8HlVQGUa/n827/KV8gH8eGfQpP8p7VkmJcGrsdboWCfVKl2GX7A9MpXeL5S+tSnBMZoqF2Ezg4jhkstI8OZURfT+opKOoCSSaepOoTxorcK2e9WDQVw2h1fwJPTc99mTe6UiEpaES6fh/7oJ5JcZaBlTM5jBRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tVgSb-00011T-P9; Thu, 09 Jan 2025 01:31:41 +0100
Date: Thu, 9 Jan 2025 01:31:41 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Nadia Pinaeva <n.m.pinaeva@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: conntrack: add conntrack event
 timestamp
Message-ID: <20250109003141.GA3912@breakpoint.cc>
References: <20241115134612.1333-1-fw@strlen.de>
 <Z31OB1LLNA5AEDn1@strlen.de>
 <Z38O3LCrBRUDwUMR@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z38O3LCrBRUDwUMR@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >  
> > Ping, should I resend this patch?
> 
> For some reason I considered this was waiting for Nadia's feedback and
> I don't remember to have see an acknowledgment on this. I assume then
> this is good enough for the measurements that are needed.

I see, I did not know it was waiting on such feedback.

AFAIK the patch is ok and works as expected.

> Will you follow up with userspace updates for this new code?

Yes, I will get started right away.
