Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF152E7F2C
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 20:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779222197; cv=none; b=j/QZbVkdHueTCTvty/8yMq19bHZCkpvb53DM2xLsXc47rV93KKEHCj4xDewS7Cxfbtfg+MnNKyShpaLjv+nMI/r/Py6SEUXDilRhxRGBAhXTKpHWo1yT4ap9IQvfVotjC6oDpGimKrUIG5bkRQnZYgCsT7R8Mpdj0s6sg4J7pcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779222197; c=relaxed/simple;
	bh=+aL2DimomLB2cj+NryjDRPjJeD6zzlNX6i39DuBGIJM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bdb18JFF0nbF/kZ3UGW9jtS5jwfCgaqX2or7pxBMllGOjHKicC0q3Sp9Vj3oo9O3o696KgTnt3mzAC65BLzWpNAaYPJLqsh+f4oxvIYeiyjiiTxQF/dQ2FqTmHb7hSRkiClRLDk1yAg1oXd2biTadz2oJI5MxWEPMdo7CxcGUgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 95D36607BD; Tue, 19 May 2026 22:23:13 +0200 (CEST)
Date: Tue, 19 May 2026 22:23:13 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, phil@nwl.cc,
	pablo@netfilter.org,
	Alejandro Olivan Alvarez <alejandro.olivan.alvarez@gmail.com>
Subject: Re: [PATCH nf v2] netfilter: nf_conncount: prevent connlimit drops
 for early confirmed ct
Message-ID: <agzGsaehgIuc0vIT@strlen.de>
References: <20260514141628.4636-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514141628.4636-1-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> Commit 69894e5b4c5e ("netfilter: nft_connlimit: update the count if add
> was skipped") introduced a regression where packets for valid
> connections are dropped when using connlimit for soft-limiting
> scenarios.
> 
> The issue occurs when a new connection reuses a socket currently in
> the TIME_WAIT state. In this scenario, the connection tracking entry
> is evaluated as already confirmed. Previously, __nf_conncount_add()
> assumed that if a connection was confirmed and did not originate from
> the loopback interface, it should skip the addition and return -EEXIST.
> 
> Skipping the addition triggers a garbage collection run that cleans up
> the TIME_WAIT connection. Consequently, the active connection count
> drops to 0, which xt_connlimit mishandles, leading to the false rejection
> of the perfectly valid new connection.

What do you make of https://sashiko.dev/#/patchset/20260514141628.4636-1-fmancera%40suse.de

Is there a way to handle this with a different solution?
I don't see a good solution.   What about making
__nf_conncount_gc_list() return the number of removed elements and allow
a single re-add attempt if we released some entries?

(Note that I don't think that conncount with unidirectional traffic
 is a sensible thing to configure, but I can't say "not supported"
 either...)
