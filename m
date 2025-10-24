Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA82C314A83
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 11:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761305505; cv=none; b=C6dfKeurRv+nAhTxVu0F7cyXsmWxZlx1zTRc/O9Yhcx4ELshm6FVqCCxpUQeeIYPKiSCQZGggxAatcW3R7bC35zNC0DutdD+eMINBZntI2Hv34SVykv3ueV7l4uoUoXvWLwsCjXTrvjvymes5ZRLTtxA0yAS7SZgw5H/dGfxUIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761305505; c=relaxed/simple;
	bh=RUZpNCYeSPllW3JE1/ALinzQOiyUWEHHuZeQ8ON1CO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uz5b7l9MFHGEeziutCAidUJ1PyJY78Zvktue+YqJjbzcAz+58tJnGz7W1YfVljO4ILyeYT5JSfUNn8IzR2QSM78l43xgaCnWicOkPM+08FEHRecUtW7vsBJIUUzFZ3zopIPyH2UY7rQiJdCDy1sMYBySklkHiQ1Trq/20GrJokw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 994A1602CC; Fri, 24 Oct 2025 13:31:40 +0200 (CEST)
Date: Fri, 24 Oct 2025 13:31:40 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	louis.t42@caramail.com
Subject: Re: [PATCH nf] netfilter: nft_connlimit: fix stale read of
 connection count
Message-ID: <aPtjnNZncIqh19Jl@strlen.de>
References: <20251023232037.3777-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251023232037.3777-1-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> nft_connlimit_eval() reads priv->list->count to check if the connection
> limit has been exceeded. This value can be cached by the CPU while it
> can be decremented by a different CPU when a connection is closed. This
> causes a data race as the value cached might be outdated.
> 
> When a new connection is established and evaluated by the connlimit
> expression, priv->list->count is incremented by nf_conncount_add(),
> triggering the CPU's cache coherency protocol and therefore refreshing
> the cached value before updating it.
> 
> Solve this situation by reading the value using READ_ONCE().

Hmm, I am not sure about this.

Patch looks correct (we read without holding a lock),
but I don't see how compiler would emit different code here.

This patch makes no difference on my end, same code is emitted.

Can you show code before and after this patch on your side?
