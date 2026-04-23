Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6591A23A4
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2026 12:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776947260; cv=none; b=gv7/wmHpGAnyOVa/yh+aOd/q0Jo1zP7Q1Zc93PXXh0g8Du+UKG5Is6McIhF1srT1VNW/ZJpkwCLZjjg6ppLZOenON2LCsidjoVlFrb9Vtgf0yRE23Z/dbv/mGgLRQGhOZq+Xu4Pg9Zr5wZVoWcs6XB1E4L72Y2BK8yt+4nl0uiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776947260; c=relaxed/simple;
	bh=VUIBBddILe2htJTgfhm2ie76bfWTDQLyIwyUKld1tDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SEBW5EJlTzgR4JAWh6nfrQv1VX9Bg8mp+TrJh+AEQwgwA3sqyBxBzDUnB1kZ7k+zZS9G9qEBGli3a2WPclJ5KFE8hLHlxC9VPaxGRqe+9SP2zNfUSveBjUEq+1IWD6VHrwhsfLftG7BprjBgJlTFjSKybdMrHaYC4pnDPu+VfJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DF3A460425; Thu, 23 Apr 2026 14:27:35 +0200 (CEST)
Date: Thu, 23 Apr 2026 14:27:35 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	jeremy@azazel.net, phil@nwl.cc, pablo@netfilter.org
Subject: Re: [PATCH nf v2] netfilter: nft_bitwise: fix dst corruption in same
 register shifts
Message-ID: <aeoQMCJ7x0tGoUFC@strlen.de>
References: <20260423120538.3704-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423120538.3704-1-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> In nft_bitwise_eval_lshift() and nft_bitwise_eval_rshift(), shift
> operations are performed in a loop over 32-bit words. The loop
> calculates the shifted value, writes it to dst, and calculates the carry
> from src for the next iteration.
> 
> If the source and destination registers overlap either exactly (sreg ==
> dreg) or partially (e.g., dreg is offset from sreg by 4 bytes) the loop
> overwrites src data before it can be read by subsequent iterations. This
> causes the carry or the shifted data itself to be incorrectly calculated
> using the newly modified dst value instead of the original src payload.

We should support overlaps (src == dst).  But partial overlaps?
Does nft generate such byte code?

I think we should reject it.  Either userspace has no more use
for src (and can clobber it with the shifted result), or it has
to keep it for later reuse.  But in what case is a partially clobbered
register useful?
