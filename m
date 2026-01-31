Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CE9320A00
	for <netfilter-devel@vger.kernel.org>; Sat, 31 Jan 2026 21:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769895279; cv=none; b=cwlU17W5H96nz5SUb52V+JYl39/VcqsuwJTeJmr4laGW2gc54UFJ31qS5kO2GTCvKjSbqZyZK0ABFar9uIORAnRhulg1x6CuOZ603lyByDKwSgSo8YTDaOyCXKdInlZZkyMp2aRZ8ZzKAllzyCoUTnk6/BIGItiDpoCs+9KiCrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769895279; c=relaxed/simple;
	bh=21C1wAJ5Bg1fzIyHSXENaC92H+Vs4dCG9bhBTPG0Oz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SBccTvyUT399uIfnijbs5752hE5uU2KKWoAlNa1VfAwLR6NVvqK7FpNvSsZyXCc2KOBf1eJRkZMi1t3zuVwKanyDUK2k1UaeE862EH5p1krkADWyXbSBvHH8DdTGZFfrXapSkP3dXWD1DzfwUHsebXbyoo8uL/UqURLrSaB/iXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 056B160189; Sat, 31 Jan 2026 22:34:34 +0100 (CET)
Date: Sat, 31 Jan 2026 22:34:34 +0100
From: Florian Westphal <fw@strlen.de>
To: Ingyu Jang <ingyujang25@korea.ac.kr>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc
Subject: Re: [Question] Dead code in xt_register_matches/targets()?
Message-ID: <aX51asLGZ8ojgrrW@strlen.de>
References: <20260131145516.3289625-1-ingyujang25@korea.ac.kr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260131145516.3289625-1-ingyujang25@korea.ac.kr>

Ingyu Jang <ingyujang25@korea.ac.kr> wrote:
> I noticed that in net/netfilter/x_tables.c, the functions
> xt_register_match() and xt_register_target() always return 0.
> 
> Both functions simply perform:
>   - mutex_lock()
>   - list_add()
>   - mutex_unlock()
>   - return 0
> 
> However, xt_register_matches() and xt_register_targets() check
> the return values and have error handling paths:
> 
>   for (i = 0; i < n; i++) {
>       err = xt_register_match(&match[i]);
>       if (err)
>           goto err;
>   }
> 
> Since xt_register_match/target() never fail, these error checks
> appear to be dead code.
> 
> I found multiple callers that check these return values:
>   - net/netfilter/xt_set.c
>   - net/netfilter/xt_MASQUERADE.c
>   - and others
> 
> Is this intentional defensive coding for potential future changes,

No, leftover.  It could be cleaned up but I would prefer to keep it
as-is, x_tables is in maintenance mode.
