Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86E03655F1
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 08:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779955300; cv=none; b=mTdvzcwP1gsmOO0F4w2YG2SgR+sI5Qk50NXR2FWYJVG361/OF+3DbKLA3Gz+JH1zQQiW1CyfGBi4b3UgNuxPDRqFqm+kTy6seVZUUjs0/lJizmnwQ2FG6NgY3yRH9z7t7eXYX34e7Vvmir1adbtl3AHJOdSO/m2sB+Rhfyr/pdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779955300; c=relaxed/simple;
	bh=sfcPjCfe3f8Q/p6c9vKTUwhptulcgx7TKoqT78i46NY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CJnRUnBfEej8mvtRyWYdd6OtXvhUnNstC9qMpLN7inCWlM9Xn3w6XDgLBgh/pbrd6ZdLxPaVglHmWz8fTNiQnuc2GG+5xESSJxewpL91CssfWBOYGbHRB/r+RQzuKjIysjE2xZaOIDxImP9zqSlXAYicSZl9mziCSaJNwrBkwWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6515660138; Thu, 28 May 2026 10:01:32 +0200 (CEST)
Date: Thu, 28 May 2026 10:01:32 +0200
From: Florian Westphal <fw@strlen.de>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_ct: fix OOB in NFT_CT_SRC/DST eval
Message-ID: <ahf2XAmRnsjK0krp@strlen.de>
References: <20260528042620.263828-1-jiayuan.chen@linux.dev>
 <ahfQGCNs8hl6FlHL@strlen.de>
 <ahfV6K6KrG0akLUZ@strlen.de>
 <88abc4d7-8316-4c9e-aca0-351fe0ecb2b0@linux.dev>
 <ahfqfM6xQKZr_xbA@strlen.de>
 <58fc5150-76e7-46e5-a72f-41133c408109@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58fc5150-76e7-46e5-a72f-41133c408109@linux.dev>

Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> > > > nf_ct_l3num(ct) == NFPROTO_IPV6 ? 16 : 4);
> > > As defense-in-depth, IIUC?
> > Yes, alternatively merge your v1 with the template check. I don't see how
> > we can ever have nf_ct_l3num(ct) != nft_pf(pkt) outside of the template
> > bug.
> I think the template check plus the family check (nf_ct_l3num(ct) !=
> nft_pf(pkt)) is enough as defense-in-depth.

Actually, I think we need to fix this to copy priv->len unconditionally.
Or, alternatively, add a memcpy wrapper that zero-pads the remainder of
the registers.

https://sashiko.dev/#/patchset/20260528042620.263828-1-jiayuan.chen%40linux.dev

"This is a pre-existing issue, but does copying only addr_len bytes when
priv->len is larger leave the remainder of the register uninitialized?
In nft_do_chain(), the register array is allocated on the kernel stack
without zero-initialization. If priv->len is 16 and addr_len is 4, only
the first 4 bytes are written."
