Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E84350A05
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 22:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787609899; cv=none; b=X8/hb46MmhCHZWcdD9J2fW5oYgPHnAVYuwNvEWT8uj8+OG44/Eq/t1o6OR3XcyvWmzBCK/4/A/o27uU4uJBle32W6rsNvDs7tfSuB/m6TDG+CVkr8j1zbn48L2LMFdxPTspHbhg35PW3wkTyhWPIYxz+PfhRFJmzQLmvHM2gHzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787609899; c=relaxed/simple;
	bh=2sBkomBPzWMZyohPLYzS/fskVUzQUQSkE6mtKXMeTdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q0wWonDcJZ19eipOGsFM0E5JtG+e5Q2E+BDr0Tcq7597JsaXTp6d3y+XoYSMm7TgHIX72/p6b0qspMUu30eVlpfznApWyZujraTr3XuREmI+jeUB40Y9EfNqRR9UYpkdD6FFrdodCpaKoDT0PHsuNg2h1yjy0HwIHNm1+HlM0EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 136B960388; Tue, 25 Aug 2026 00:18:14 +0200 (CEST)
Date: Tue, 25 Aug 2026 00:18:12 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Zhiling Zou <zhilinz@nebusec.ai>
Subject: Re: [PATCH nf-next] netfilter: x_tables: reject missing '-p' flag
 and check for INV flag
Message-ID: <aozDJO7EMyfuupGq@strlen.de>
References: <20260821134136.18191-1-fw@strlen.de>
 <aohabszy_Ac23p7x@chamomile>
 <aolaWzC1PI7zeYRN@strlen.de>
 <aoy8kFZkXMNOHUcR@chamomile>
 <aoy977yxzSEsViun@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoy977yxzSEsViun@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> > Userspace always provides a zeroed e->ipv6.proto when unused, correct?
> 
> Yes, ip6tables raises it when it parses '-p' option.
> 
> > If so, LGTM.
> 
> Alright, I will respin tomorrow, thanks.
> 
> Do you want me to include the TPROXY fix too?

Actually nft_compat.c already does:

 if (proto)
   entry->e6.ipv6.flags |= IP6T_F_PROTO;

so the only other necessary fix is the check for 'INV' in xt_l2tp.c.
