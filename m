Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1352A1F4607
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Jul 2025 15:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753976997; cv=none; b=H/168LrKI1gqoz+ZbnHqS9fkX2gHe4yu62R68DyW8FNda+bNaeygmhvOynbxl9HB1XVXg4dQsEdWiQ9reoqq6BOngYJd4CleSF+/Rkj0xvDojJ7hspL2P8/ASZhGmt3RbOumeO8lobRx4of+7YQcFkP2MSH5SSFKDxfJjRlw2GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753976997; c=relaxed/simple;
	bh=znFyPAU7Hq8pYZAUoUKUz0gFjNIF11k3vt+fbO6Kysw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wuu/QWgqhxJwbea2hrfC1ROz6HhNEACVeX+cB2xelFT8CRxHFTqUgb1EmzgnT0BCgK2g8fra9vvQFgImjo0k2C/sJ035XewEehrv1awcGjHsVfp6nzxeb2W8n9kn7bXc8qdRwESCj7zunx+QgFXSPDoLfWx5OTuJFpU9hihm43g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2DED2603FF; Thu, 31 Jul 2025 17:49:53 +0200 (CEST)
Date: Thu, 31 Jul 2025 17:49:53 +0200
From: Florian Westphal <fw@strlen.de>
To: Dan Moulding <dan@danm.net>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	regressions@lists.linux.dev
Subject: Re: [REGRESSION] v6.16 system hangs (bisected to nf_conntrack fix)
Message-ID: <aIuQoUQQnFMyvJJs@strlen.de>
References: <aIgMKCuhag2snagZ@strlen.de>
 <20250729170228.7286-1-dan@danm.net>
 <aIkHAZjudod05WaR@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIkHAZjudod05WaR@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Dan Moulding <dan@danm.net> wrote:
> > Ok. I just tried reverting only the changes to nf_conntrack_core.c and
> > the hang no longer occurs. This is on top of 6.16.
> 
> Strange.  Can you completely revert 2d72afb340657f03f7261e9243b44457a9228ac7
> and then apply this patch instead?

Any news?  If you don't have the time to test, could you please share
kernel config or at least some details like CONFIG_PREEMPT settings, if
this uses kasan, kcsan etc.?

I'm asking because I still cannot reproduce any hangs, so I assume that
there is some significant difference between our setups.
While I could ask for a blank revert, that would get back the bug I
was trying to fix and I dislike doing so without understanding the cause
of the new bug first.

Are you using anything more excotic, say, conntrackd, conntrack
helpers, synproxy, or anything like that?

I was able to produce a memory leak by running conntrack_resize.sh
selftest in a loop, but its unrelated bug in ctnetlink.

I will submit a patch later after some more testing.
