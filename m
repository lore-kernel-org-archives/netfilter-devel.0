Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD4E4534AD
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2026 11:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791372743; cv=none; b=nSvzH1WyX3NnxMOfeb2hlb6u+9/4lYJJmQbSJIVfurFU5V61gfisuu8FI5+e6OA6KSQ1tZuvFT0cwtT4R4EzQ23+zRBrGDt45AWlSkVblLykbYM3dS9kWq3q/vJZcQhmmvaAmJycMiBcBglmlcw1z6lHffAXfwrnTD8N+AzzBSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791372743; c=relaxed/simple;
	bh=7X59tkWE9zHxSzPUwyFk23l1YIbTBi6LPyQtnzE6hL4=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cbqJkEuksursGFQsmdoOZXGTsU6q/TUFEOARxyEmsnrON0cVzK8feUH+5i6Lzt+DuFNm4BM+ZJqguWZRZWpjWsXGwql6OrS34Mofg/xbbflO4p/AGrwmLU/pbF9TWtqZxcpQ10mjZgE4mxvfsUxl9ekgeI5TE2l4JHA0dLaSivg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D88B86038C; Wed, 07 Oct 2026 13:32:04 +0200 (CEST)
Date: Wed, 7 Oct 2026 13:32:04 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] selftests: netfilter: fix return value in zone
 subtest
Message-ID: <asYttCJ5ZNjCPm1b@strlen.de>
References: <20261006230459.2139-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006230459.2139-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> zone subtest prints FAIL, but did not set 'ret=1', so kselftest
> framework reports success.
> 
> While at it, also fail when "nft -f" returns an error.
> 
> Noticed thanks to a (broken) local patch that should have caused this
> selftest (resp. the kselftest framework) to report a failure.

https://sashiko.dev/#/patchset/20261006230459.2139-1-fw%40strlen.de

| Does this early return in test_masquerade_vrf() skip the qdisc cleanup?

Yes, but a great many other places don't clean up either.

Tests are supposed to pass, I don't think there is any point in
making scripts more complicated by cleaning up in FAIL cases too.

I don't plan to address this comment. LMK if you disagree.
