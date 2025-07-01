Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E554726463B
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Jul 2025 10:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751366904; cv=none; b=GBm9ALhY1hzRHh171g/cjlNw5oqFKnP10BsQyu4ssj6lXGNip7IPg1NXhbB+6/CrVHRdaw/3Fi/ejIaz4gqnFilh4lxFD/mll8TUW3GmFXRklqUSt3T/s3R5i4p00sWGWub8CTIfa+KOHCGnMYChxhQ85ez0CVn6mxyfJwQE1rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751366904; c=relaxed/simple;
	bh=RV0avjVS5rdKLQCTKz0i3PXuLZWTWw3ns3zlPoSE78I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e3vQ5bH+BSeCpswZTDcO3sl/7wV4lX1MlBPUOi//DmeJeQnVzyzC6qkB9cg4Q9V4Qq/gv43lDhx93N+IzHGoKCTPNGy6hp4k/cATUiGgdKBBOfI7TDP0Se4X6EtPR6P23D5tFYFw0JErWZyMC85H1FjbJgcvekDWu1s0TmCHqU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1F242602AC; Tue,  1 Jul 2025 12:48:21 +0200 (CEST)
Date: Tue, 1 Jul 2025 12:48:20 +0200
From: Florian Westphal <fw@strlen.de>
To: Sven Auhagen <Sven.Auhagen@belden.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Cannot allocate memory delete table inet filter
Message-ID: <aGO89KaXVNuToRJg@strlen.de>
References: <BY1PR18MB5874110CAFF1ED098D0BC4E7E07BA@BY1PR18MB5874.namprd18.prod.outlook.com>
 <aFwHuT7m7GHtmtSm@strlen.de>
 <BY1PR18MB58746445C00F31B0BAF392ACE07BA@BY1PR18MB5874.namprd18.prod.outlook.com>
 <BY1PR18MB587473C6870ED217731B73F7E041A@BY1PR18MB5874.namprd18.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY1PR18MB587473C6870ED217731B73F7E041A@BY1PR18MB5874.namprd18.prod.outlook.com>

Sven Auhagen <Sven.Auhagen@belden.com> wrote:
> One question regarding option 2.
> Don't I need to rcu read lock the nft_set_flush now because when I preallocate the transaction I need to make sure that the nelems do not change before doing the walk?

rcu read lock won't make nelems stable either.

The preallocation can fall short (nelems increased) or
it can have leftover elements (if elements timed out or
were deleted) after the walk.

So, no, you don't need to hold the rcu read lock, but
you can't rely on nelems remaining stable.
