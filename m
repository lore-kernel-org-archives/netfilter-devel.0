Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9431F22652D;
	Sun, 15 Mar 2026 08:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773562820; cv=none; b=IDlu30ArlzN4ILPia1MFgxnzNnKXTVHak918q8KOxe+YD0J8t19U+s1SKuyfLS5dMwsYjMlrgkmmnMVkrLNpnAoFCYrwmop03WC91VbiriF+DwmcXBmZ1TxbuyT+mkj7570eQzXkM2FNMQgSDPOa5ZKXX88N1kTpARiWkP5qaGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773562820; c=relaxed/simple;
	bh=wKJ2a74Vt6GGdFlV0Wh3HdWPKCqDswuFVSPRk5nbI/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UQQN2uYHUGbugqiYjPh0P5IUC1qHbwBPs7zBvdaLcwgx0jfGK6fidy9DieTJJznZDZzpHLORroi/Mrwr2Is6Rn3lVc6OW1UySAiZLwmKBz2+g3amk5CECs0mTgRBzcCZVXvCVlZeIopqEPoTaUfsBmW6tIRn41QeXIbRgir/wAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5D9046080C; Sun, 15 Mar 2026 09:20:16 +0100 (CET)
Date: Sun, 15 Mar 2026 09:20:15 +0100
From: Florian Westphal <fw@strlen.de>
To: Aaryan Bansal <aaryan.bansal.dev@gmail.com>
Cc: kadlec@netfilter.org, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hash: add fast paths for common key sizes and new fast
 hash functions
Message-ID: <abZrvwZYRTjCpFKj@strlen.de>
References: <20260311160904.192965-1-aaryan.bansal.dev@gmail.com>
 <20260315074432.444966-1-aaryan.bansal.dev@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260315074432.444966-1-aaryan.bansal.dev@gmail.com>

Aaryan Bansal <aaryan.bansal.dev@gmail.com> wrote:
> Add optimized fast paths to jhash() and jhash2() for common key sizes
> (4, 8, 12 bytes) to bypass switch statement overhead. These fast paths
> use direct word reads instead of byte-by-byte processing.
> 
> Also add new specialized hash functions for integer keys:
> - jhash_int(): Fast hash for single 32-bit integers (~3x faster)
> - jhash_int_2words(): Fast hash for two 32-bit integers
> - jhash_int_3words(): Fast hash for three 32-bit integers (e.g., IPv3 tuples)
> - jhash_mix32(): Ultra-fast hash for single integers
> - jhash_mix32_fast(): Minimal hash for extreme speed
> 
> These are useful for in-kernel hash tables where maximum performance
> is critical and reduced hash quality is acceptable.
> 
> Measured speedup on typical workloads:
> - jhash 4-byte keys: ~1.1x
> - jhash 8-byte keys: ~1.4x
> - jhash 12-byte keys: ~1.4x
> - jhash_int for single integers: ~3x

I won't merge a patch that adds functionality with no users.

Also, there already are helpers that do this
(jhash_1word, jhash_2words, jhash_3words).
