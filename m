Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C312931F5
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 19:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787601411; cv=none; b=PpDboCZRfel+gYTFsoHbCaTu96lZREO+t2UW6t7mXKn+etAnoYj82YWlKoxykF2vMtaj/VQZ0scamNSZtdleXol33PGcUBNvZ0DBqT8a4mR8UiaZUh9dZ6Baa2tNF7BHRfpFZsKwtC5KzV1JELou/l144KekOQwbVX9bnNuRbPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787601411; c=relaxed/simple;
	bh=d/sexpj4nf8NbLIPRBTxnG1vmqg/YyjiaM1wKDEZ1Fk=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NABogRSL1MmWazDzWP1A0M4dg0d7S5SA8kvKU8eXGOLFJ3Exg48GvTwYqsXeIZYSFE+mxABY3Zzxx8X5Xv+tYFkgaCfJH3antQxUmQriGZWIphBCcQawsZDrM3mQ/ssbtqXqH95/rXUutVHR4We+AIG6ya5c/1EQUy3PziK5iwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A439360388; Mon, 24 Aug 2026 21:56:47 +0200 (CEST)
Date: Mon, 24 Aug 2026 21:56:46 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_payload: restrict checksum offsets to
 known values
Message-ID: <aoyh_i2BhyOiMTpk@strlen.de>
References: <20260824192843.28439-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824192843.28439-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> We need to prevent userspace from corrupting e.g. tcp->doff, because
> many locations in conntrack and conntrack helpers rely on
> nf_conntrack_in() having validated the packet headers.
> nft_payload allows to alter headers later which invalidates this
> assumption.

https://sashiko.dev/#/patchset/20260824192843.28439-1-fw%40strlen.de

Can't make sense of it, afaics this patch is fine.
