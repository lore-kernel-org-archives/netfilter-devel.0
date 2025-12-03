Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A776736D4E2;
	Wed,  3 Dec 2025 13:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764769237; cv=none; b=t1zOEpEKKhB7pTWeG/wDlAI8AG4E42ys8UUDK31FylNGHmcst71i0QAIjAGAZBgJ/keHxc4gL++TWtZrsRPdju3IK3Jm4DE4L9agsW0IAdK1t0oI3Pn0gcz3u/7+zqJlQJCGiUcde5h/WwuE5KR/Sbqfkax0wtUwvX90QMzb250=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764769237; c=relaxed/simple;
	bh=51qF0axHPXjm/0LgCS9Lcv3DcnCyoG5lvC9duxY87K0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DKrVlXGYbDugL7TyXchJg+jPIyuZ1EikcL0gLQJ5fKViPKcsOnP3C2W9QE6xWZNGxitAeuA9iRtuxG/IKL6vEaRcyM84Hhbneantv/ntfZzy7PGh5ugRvr7LyWDYmst3x+AXTn3CFMEvmZijFJphsHRXK70S8ABgJ6og3I60JgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 76ACA605DD; Wed, 03 Dec 2025 14:40:32 +0100 (CET)
Date: Wed, 3 Dec 2025 14:40:27 +0100
From: Florian Westphal <fw@strlen.de>
To: Melbin K Mathew <mlbnkm1@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, phil@nwl.cc,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_set_hash: fix potential NULL deref in
 nft_rhash_deactivate
Message-ID: <aTA9y3iH1JjMPwQ1@strlen.de>
References: <20251203132044.57242-1-mlbnkm1@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251203132044.57242-1-mlbnkm1@gmail.com>

Melbin K Mathew <mlbnkm1@gmail.com> wrote:
> In nft_rhash_deactivate(), rhashtable_lookup() may return NULL when the
> set element is not found, but the function unconditionally returns
> &he->priv.

Which is equal to 'return NULL' in that case.

> Dereferencing a member of a NULL pointer is undefined behavior in C.

&he->priv doesn't dereference he, it returns the address of the member.

> Although the current struct layout places 'priv' at offset 0 (making
> this behave like returning NULL), this is fragile and relies on
> implementation details.

Its not fragile, this file has:

        BUILD_BUG_ON(offsetof(struct nft_rhash_elem, priv) != 0);

to ensure 'priv is first member' requirement.
