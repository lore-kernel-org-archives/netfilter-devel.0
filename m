Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279D43BAD96
	for <netfilter-devel@vger.kernel.org>; Fri, 22 May 2026 10:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779445663; cv=none; b=drkyNXKlDqNgVz/pOLo81H5epWBd1E5KW1Yysek8OkvsUzj1pVctx+JNaMffG2x51ra/xofJqFI7YnI5N+u0MKxym0bFBKPdBg0Ktsl5ZiyaSeplendAhlFV44Cn07yQIsF0LjEkLlUFKYl4YumkYwBQ0MNcYDigd/gx1GPEcXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779445663; c=relaxed/simple;
	bh=tizpuggaC7SNn18Xo8wrXSdO/82Aqv1LiLMb5N9HUNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k1s6j7Sl/Padu2YB90zuiLvsGhU2n2j5eTlzXfLwv+Pf1IJ24ADAMactCl3KfHykgoPGcO6L60JHBV4sWpbE1X7n1n4nzthmFMj+tqbROHS8S02of9P0LISNLuPwN0ZvhuNCOI67E+zhhDXGD/O+VFC4z2yFv3FPuVWKHcuU7vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B61FC60345; Fri, 22 May 2026 12:27:18 +0200 (CEST)
Date: Fri, 22 May 2026 12:27:16 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org,
	syzbot+690d3e3ffa7335ac10eb@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: xt_cpu: prefer raw_smp_processor_id
Message-ID: <ahAvhJpc8RLhXEzV@strlen.de>
References: <20260519183430.20726-1-fw@strlen.de>
 <35756825-5349-468c-881f-e88b80f0729b@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35756825-5349-468c-881f-e88b80f0729b@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> I see I can use the compat layer to configure NFQUEUE target see:
> 
> # Warning: table ip filter is managed by iptables-nft, do not touch!
> table ip filter {
> 	chain FORWARD {
> 		type filter hook forward priority filter; policy accept;
> 		tcp dport 80 counter packets 0 bytes 0 xt target "NFQUEUE"
> 	}

Please send a patch.
