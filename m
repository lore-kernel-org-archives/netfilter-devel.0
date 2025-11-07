Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1667404E
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Nov 2025 10:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762509697; cv=none; b=ZM5xSdAWDCj+M4EFvP/GnLq4Q2BacrXIoQuE7DYjDG2CZ8DcI0Q7qYWPLWkin/DqGmFpRayL1TEhWSh+Tn1hOsAObm9KWk4zyidzeKvYbMDmCZLkfJpNjF07wy9wOlxVctqu8EWq7b3SGWtwdB0xF3xuWrXNL3HLB0kIZZ/5NSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762509697; c=relaxed/simple;
	bh=onsZkeahqDOk6Nls9G20BBF2XrPwjOj3x6C9NlvGZPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ivYMpF+MxrhQY8jGy3hbioagFq/zhGSUv9e5Px5XT58mv3d0KyI2hGzRQi/qdHLF1B+jhCC/Oxsy3/n5aeLtjjXXBugvZjDhxBHhNGKuFB/MuvdeIfOaPujXSlJZxtkXKMcWJO7pTuVhi6jvCjU+5tdzM7ZGeUbxS6yD/ED0wTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=EubbgA+H; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="EubbgA+H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=q5T0Rcb6Nq4ShWkKNJPi2Ist0/rCaPjwUBcyT+DftGI=; b=EubbgA+Hi1i2Kf4nnEYFKQkAi3
	/zzWh+U8o2RGCxypt+y9rGcaFd80AKG6/MQ8cWwGBh9VYmJ2xjRtXFQJp2vl6xLxqkEnYwtMVfF8j
	+Ow9Z5yEP7ctnFnk9gmGLL65GN2pxI0LXHIa9pVp6HG0uBnfrTaUXmB1AbHlaoFvCglGuQT7JHZ3b
	j1XALP3eaXzT0f+95gjUOzzuRL6Xs4pAAbLU0twHcWcmRZtiiMrnNHG+9CXsmZn5oO6gK+Ipr+tFN
	pg/6TMXTFxh46mb5QSlsk+hgy49SQfbEx9mqZS0bKV6Kx/byaSZ+MkF9c6ZO0kMZ0KmG0ot5Xdi/m
	six2ZFPA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vHJHY-000000008BM-2sbM;
	Fri, 07 Nov 2025 11:01:24 +0100
Date: Fri, 7 Nov 2025 11:01:24 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] doc: libnftables-json: Describe RULESET object
Message-ID: <aQ3DdD5zUcFxGxhj@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20251106111717.9609-1-phil@nwl.cc>
 <aQ0s80YeCLRZnmsB@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQ0s80YeCLRZnmsB@strlen.de>

On Fri, Nov 07, 2025 at 12:19:15AM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Document the syntax of this meta-object used by "list" and "flush"
> > commands only.
>  
> > 872f373dc50f7 ("doc: Add JSON schema documentation")
> 
> Why is that here?  Should this have been 'Fixes: '?

Oops, yes.

> Aside from that, just apply this, thanks.

Patch applied, thanks!
