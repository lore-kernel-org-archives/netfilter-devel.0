Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8166213A3EC
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Feb 2025 07:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739517510; cv=none; b=HADFfMkyFWbMJlhX1ETQETbA3pSciy0zCxzbNhfjpa+mXfblDrsc4jmcgacwq1Za/JsT6xOp5zLi5JqcStghc0DSAMx1gSqeBVuDRIPjPkOonrow1+UtlmjtPsTbim5EK6G1yzRbfMLWV9tJuTPSURbnCfhI4ybkmsGqrh75NQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739517510; c=relaxed/simple;
	bh=cOSn0a4Wtc21kbM0GETPTUeTbvBSm9oOBHstlm2Um4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CWCqIhigifLEUTKfqT7sSpRVe2SkgaMzwKVBLhewVeNP09WOTi13iScCIRQkm7UC5bdfiLTO9XvUPIqzCJGmi/PmjLCdbJiADzrCUOh4YcAueMJcIxjHaqKOXTOIyCZQXmgHBQuDz+U8qNAShwMxnQWZbyppIeDAlqyL9A8A3rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tipxo-0002ck-Qq; Fri, 14 Feb 2025 08:18:16 +0100
Date: Fri, 14 Feb 2025 08:18:16 +0100
From: Florian Westphal <fw@strlen.de>
To: Sunny73Cr <Sunny73Cr@protonmail.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: payload expressions, evaluate.c, expr_evaluate_bits
Message-ID: <20250214071816.GA9861@breakpoint.cc>
References: <pEHO7WvK0prMNgZ-F5ykdLmclh4sY_7_tM7aC-AkyCPTDU6izTFwHj0tJsLHGONPYZKM3zt7B2wVJihfd0Vdxv71PjrpxtuRKY1AlVmcyBc=@protonmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pEHO7WvK0prMNgZ-F5ykdLmclh4sY_7_tM7aC-AkyCPTDU6izTFwHj0tJsLHGONPYZKM3zt7B2wVJihfd0Vdxv71PjrpxtuRKY1AlVmcyBc=@protonmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sunny73Cr <Sunny73Cr@protonmail.com> wrote:
> contents of /etc/nftables.conf (run in dash shell Debian 12.9):
> -------------------------------
> #!/usr/sbin/nft -f
> flush ruleset
> table inet filter {
>  chain filter {
>   type filter hook output priority filter;
> 
>   @ih,0,129 == 0 \
>   accept;
>  }
> }
> -------------------------------
> 
> Output:
> 
> nft: evaluate.c:510: expr_evaluate_bits: Assertion `masklen <= NFT_REG_SIZE * BITS_PER_BYTE' failed.

Fixed last year:
https://git.netfilter.org/nftables/commit/?id=58904b8b55a2a7941287f0267601eb54c75432a0
