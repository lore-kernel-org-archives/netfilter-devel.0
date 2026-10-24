Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792880600;
	b=0lqvCHm/NbbqxSShkpsAY4MnfGOvJzsWdlWA60gGxBpN18XrdiNk+tO5VgifW07emP5z
	 ITaV1LjpXq700dr90KjwImOcNAlnsFt4wK01v9SwTfvLp2L2q+LC4UzWcjxP4UAdKRdH4
	 Dk8XUYSyK0ifXea81ec/PpEpAdQFSWt5TfonLpki2vaHX9cCDU2RTKcrSOJWDLXG1rLaK
	 jylT5xTCKQUCdiN2SBgX8xm9JQLh/ubYqdqJnrG+JL/oBzht9cI9t3X/f4ynx+yMz8FNS
	 TveFxlVQm4kLSMXdZIjHiGX694RVjd2WE/GNZ0es4TOQeey1ELyY88N5yWq4OF0UgvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792880600;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=fEpek5FX8wNTYU//B1YNrG48vGFcw694wmGUQhenV1A=;
	b=z6ZU5PCK7iGCbKZlBRXljSt/K9UHGPPh/I2VQMb43UMwHsyaI9xqTYx2pcdrc6gT/dDh
	 2x7FkUeQI2aiUz0LEKNmdBZUnnSWb9NMxcXO32+gxI24EPjujL2fc1jne60Bpt3vlFlBf
	 H0Yoz1Ti/cHyrxgC0tQECmG5p1ItWrOAobkOKkR8W9qLItInynN4lw718+wI7RqJ0gP0X
	 qeo4FqiTq0xyrNJmHsxXrSHjbK1ebZpTLGqHDFbr56u8WZbKHa8tinEfhYB6VLwHivFAo
	 XjlE1fs7xSThObWggeF2dYA/PkYb+jUUp0ZgZ99rHyQ0z/yZJF6tKY5+LrSwtDAzTBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579F5606A31A;
	Sat, 24 Oct 2026 22:23:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 579F5606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1937360AF0; Sun, 25 Oct 2026 00:23:10 +0200 (CEST)
Date: Sun, 25 Oct 2026 00:23:09 +0200
From: Florian Westphal <fw@strlen.de>
To: Joas Antonio dos Santos <joasantonio108@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	Weiming Shi <bestswngs@gmail.com>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_set_pipapo: skip transaction elements
 during GC
Message-ID: <at0vzdlVTF8XAzHj@strlen.de>
References: <179287943591.17355.17353179557993329094@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179287943591.17355.17353179557993329094@gmail.com>

Joas Antonio dos Santos <joasantonio108@gmail.com> wrote:
> Since nft_set_commit_update() runs set commit callbacks before processing
> NEWSETELEM transactions, pipapo_gc_scan() can observe elements added by
> the transaction being committed: nft_pipapo_commit() calls
> pipapo_gc_scan() on the clone, which already holds the freshly inserted
> (not yet activated) elements.
> 
> pipapo_gc_scan() selects elements to collect using only
> __nft_set_elem_expired(), without checking the element's transaction
> state.  A new element that is already expired at commit time (for
> example a short expiration whose delta elapses during a large batch

Please ask your LLM to explain how a newly added element can be both new
and expired at the same time, then fix that.
