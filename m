Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D3220298C;
	Mon,  1 Sep 2025 21:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756761193; cv=none; b=dnEpPwTBQzIRPsqQemTIVsqe4XfH8dMXgJbLRs+OUNUc1QyCS7YrmxWt0mEGClVA9AvxEqY5U541s2UYvvSaK+fjHqMG/x4Q+6sCwQ8GxrFUmb+Dqxl59YHtzXfavQleJDFIcC1P0ga+kjwN6nu56UKAJRoKjAHvVjRdiMs3QOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756761193; c=relaxed/simple;
	bh=oEw+zrac+iQ0J+PrVgl5wB4HwjYM8mFeh60RyTL2XJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C916c4QH6uSpRLNlc6T+pl/z5VVS6Wdyd1JsOGDaZnbNYKX4cUfr8b7vhdIgzI9cxUh5zfLtR1VwuVDnfmad9FwSYAyYQn5+78AWMYNV4rZhXnxYdX+VpQg2F7J0DHhbTcgcqcBH/LjBItKfXKiXCBO8NaOn8K3tUfs7D2U1bFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=K7N21hTN; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cbWSnqqq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="K7N21hTN";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cbWSnqqq"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A65686066E; Mon,  1 Sep 2025 23:13:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756761181;
	bh=v/QQl3O5Pn8vBOfIuPo0sChr3k27wmF9gySp7SvLdmI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K7N21hTNe7vY2EsF6XCBq6Girl/P7TN2IC6qWjlG3nNUvosxZyX0GxZGPkn632azT
	 ol2fSFM2u2GfRAXNmIOmZg4I0Hw6R+mQSLATtflfLXTa007hKDM1pSmfJ/2cy0wPTU
	 RFan9JE9hm7NPwljmhR4eUGUr4Ck4oV6WaqCM7ytL2InYtKYit4kuyIJeUaa2pFDFI
	 wfebZ6cDKayGU5nOpEr1Vd5yM6iaRzg9dymW+jsB+ThMcL0noCvzP8lf8PuMRxRHO/
	 YnquQFVr6thTYxdTQRWP1hFmTOcHSZHc6zNevSSELy/G/Nm0xqTDoBhhTPtZSourbN
	 YY3IPHduwLG1g==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E0C296066E;
	Mon,  1 Sep 2025 23:12:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756761180;
	bh=v/QQl3O5Pn8vBOfIuPo0sChr3k27wmF9gySp7SvLdmI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cbWSnqqq/Jz4NPzFZbHd5kl/VHJ2raaAToIXRjvnIRRHO7qYJJTb1qz19BtIBiz/W
	 74bnJnNj9BWbP0cOBqp9ZZRNoqruvrLTyv4bNupnvQxekPlcCKwOic6IejEYWKolEd
	 zcsUTbfTpPvJFyGd1szrfVl32bwWrvmg75WnAJHHm7Zlz18MyUiLktFso7dHYgQRhF
	 EdEH4rEFgPev/gtDW4ETbuJ9Fh8EyrQnRM226bQNt7zAgSS4RReSpfNHrvnLSucnQq
	 E415P6f/7uaGCwDx6np9UlTq97vghO3XbuTgYP5D0DPa4EG9NuKNNqaLFgg+hYlHch
	 NchaFmO+4mh4A==
Date: Mon, 1 Sep 2025 23:12:57 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 5/8] netfilter: nf_tables: Introduce
 NFTA_DEVICE_PREFIX
Message-ID: <aLYMWajRCGWVxAHk@calendula>
References: <20250901080843.1468-1-fw@strlen.de>
 <20250901080843.1468-6-fw@strlen.de>
 <20250901134602.53aaef6b@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250901134602.53aaef6b@kernel.org>

On Mon, Sep 01, 2025 at 01:46:02PM -0700, Jakub Kicinski wrote:
> On Mon,  1 Sep 2025 10:08:39 +0200 Florian Westphal wrote:
> > This new attribute is supposed to be used instead of NFTA_DEVICE_NAME
> > for simple wildcard interface specs. It holds a NUL-terminated string
> > representing an interface name prefix to match on.
> > 
> > While kernel code to distinguish full names from prefixes in
> > NFTA_DEVICE_NAME is simpler than this solution, reusing the existing
> > attribute with different semantics leads to confusion between different
> > versions of kernel and user space though:
> > 
> > * With old kernels, wildcards submitted by user space are accepted yet
> >   silently treated as regular names.
> > * With old user space, wildcards submitted by kernel may cause crashes
> >   since libnftnl expects NUL-termination when there is none.
> > 
> > Using a distinct attribute type sanitizes these situations as the
> > receiving part detects and rejects the unexpected attribute nested in
> > *_HOOK_DEVS attributes.
> > 
> > Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
> 
> Why is this not targeting net? The sooner we adjust the uAPI the better.

I think there were doubts that was possible at this stage.

But I agree, it is a bit late but better fix it there.

Florian?
