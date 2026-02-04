Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB1B2D061B
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Feb 2026 16:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770222812; cv=none; b=ealaGA84WPJ2ArokA+8esj6B7bcaWe+Iut4fcMw+6Npu0BBcMPJJkeEYChtQE+SUqjFTscXPB80Y+lNoxbgvpdVxqHC6TRxd56p+jr8fj/QPOV1HCurKxXJYuNVdTeyvlC/jtzcnL/VSxGMiYzK6qWxFF0giBiHfhChtZYLZdio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770222812; c=relaxed/simple;
	bh=lV2p0he1duPuaWPSOo9zbEiFgA+bT2nkuJ/kAGCjhxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e0PIRkoCKKJ6uF8+Af5iUmpGe3OuuNd6z8D3+k2pY9NPY6XgL+A5Hxky6A2lal1r6TMFv6ZMAJbeVq9BbYuo4g3dGYA0Gut/tvyStRlYhaISuzIH6Wv79sks6V1CBu95sfLE6H/Xz5F4z14KvZYC8jAhhv0zt5s/rPsSYtYCIYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 637C96033F; Wed, 04 Feb 2026 17:33:30 +0100 (CET)
Date: Wed, 4 Feb 2026 17:33:30 +0100
From: Florian Westphal <fw@strlen.de>
To: Nikolaos Gkarlis <nickgarlis@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fmancera@suse.de
Subject: Re: [PATCH v3] selftests: netfilter: add nfnetlink ACK handling tests
Message-ID: <aYN02tfKPpTxBZDW@strlen.de>
References: <aOJZn0TLARyv5Ocj@strlen.de>
 <20251005125439.827945-1-nickgarlis@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251005125439.827945-1-nickgarlis@gmail.com>

Nikolaos Gkarlis <nickgarlis@gmail.com> wrote:
> Add nfnetlink selftests to validate the ACKs sent after a batch
> message. These tests verify that:
> 
>   - ACKs are always received in order.
>   - Module loading does not affect the responses.
>   - The number of ACKs matches the number of requests, unless a
>     fatal error occurs.

I'm marking this as 'changes requested' in patchwork.

As far as I can see this test also needs to be updated to not
expect an ACK on the 'end batch'.

The consensus in the other thread appears to be that userspace
cannot rely on a given number of acks being present, as the receive
buffer might not be large enough to hold all of them.
