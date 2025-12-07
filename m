Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D691B983F;
	Sun,  7 Dec 2025 10:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765104017; cv=none; b=ffZV1tewg1/tg4qS2yxrCeWOHOzFTWn0PuSZFSuwJT7nk8kT6DoYPObrwLNjdWvQjQbAHcLNX+RhnTYVgl7s4GfK0NWYrkeeSCKAAUkEfO2rK2eNRSt3s+AHWe2t+buLDg3Oap6KnzMlylfJnPPHKzhfLTuFc73HnihOcEFT3QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765104017; c=relaxed/simple;
	bh=vVox+hlO9MS5Tuex3cugUV3uHv0+plT/3A1osRrQcPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y1sxN2vY+AP48rhrzAi3Lpw373Nq7npjyIRkChE+RjzqgsHNk/v6iQPmsKlXjWCTuYhmV4iNtgzyT9b1YPAFviR5JgLSEkKelMgajfKX7jB1UqwNyDseSY78PLqJhC2WUfRLGKbWepNaT5LNROyjnk8FXaS7L1inQVhiMTw8u6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 78EDB6034B; Sun, 07 Dec 2025 11:40:13 +0100 (CET)
Date: Sun, 7 Dec 2025 11:40:12 +0100
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [TEST] conntrack_reverse_clash.sh flakes
Message-ID: <aTVZjCnkdQLKP9Mm@strlen.de>
References: <20251206175135.4a56591b@kernel.org>
 <20251206175647.5c32f419@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251206175647.5c32f419@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> Ah, one more, the non-reverse conntrack-clash is SKIPping, occasionally:
> https://netdev.bots.linux.dev/contest.html?pass=0&test=conntrack-clash-sh
> 
> If the event it's testing is probabilistic could we make it return XFAIL
> when it doesn't trigger? We try to reserve SKIP for tests skipped
> because tool is missing in env, something isn't built into the kernel
> etc.

Sure, I can switch this to xfail.  Its trying to trigger a conntrack
race but there is no way to force this and I did not want the script
to spin for long when trying to trigger the nat clash undo logic.
