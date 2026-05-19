Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620FD36DA1B
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 18:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779216836; cv=none; b=ByCyMVO3jEqsiVIH//JT8XOaTDl7zmjfGaUBja5rmP8J/wHnGhVCR9V6HUyl5iBWfnKfoMU0xknl9LjKoSLVFMMOMjE+eqymOQoYUnMs78nctxrJaMjHx2aCnZXFB17rUObBwjj6s2bB/AjLpOAcYZkJyf7sOGii76Te8D7aYTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779216836; c=relaxed/simple;
	bh=SHkUq6U6jnQa24R9Zb8uYApjMeJrUxEvzdlllP919eE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c9c9wjIlkGANmrg/EWN1PjZR6Tr7bWfNlpRUcQ8lfkfqFhKcmeFGkhgFMp+kdPubqH2kCKIxuGENe0Eb0SSyC7gncS9hSEIWQVrfyU9HYS52d6U8mnLSS0XHluS7Wf/5gJ3nExVLgpjZSaK0pDRf57G9k49gwa//1iW5INWW4Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CCC76607BD; Tue, 19 May 2026 20:53:51 +0200 (CEST)
Date: Tue, 19 May 2026 20:53:51 +0200
From: Florian Westphal <fw@strlen.de>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
	coreteam@netfilter.org
Subject: Re: [PATCH nf 2/2] selftests: netfilter: add nft_fib_nexthop test
Message-ID: <agyxv8capFWhPo5I@strlen.de>
References: <20260519041431.396218-1-jiayuan.chen@linux.dev>
 <20260519041431.396218-2-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519041431.396218-2-jiayuan.chen@linux.dev>

Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> Cover nft_fib6_eval() over three route shapes and reproduce the OOB
> caused by the blind &rt->fib6_siblings walk:
> 
>   1) single external nexthop (nhid)
>   2) external nexthop group (nhid -> group)
>   3) old-style multipath (nexthop ... nexthop ...)

https://sashiko.dev/#/patchset/20260519041431.396218-1-jiayuan.chen%40linux.dev

Specifially: 'Does the test need to verify the datapath actually
evaluated correctly?' and
'It looks like the test also sets up an nftables counter rule but doesn't
verify if the rule actually matched any packets.'

I prefer functionality test over 'bug trap' tests.
