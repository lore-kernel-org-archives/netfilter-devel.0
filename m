Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF8838A714
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Jun 2026 19:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780426961; cv=none; b=S5iaFtSs0M5RdiUry3J1yOSxuQTrhe1GtSzplbKtIB+rlv1Sj5yXZ9Ofc8UpkUJRRuRVrEmWpEIYyKPYnFdIie5XsR+eqC11/RLRGuEUYcCgdhxLCO1oZjQ6UC2bD6xmQZswaUUlIUXqqYVwnJ5hG+06KQPDkrIbqnO7Ra2irD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780426961; c=relaxed/simple;
	bh=zRWO3lDjuoOzzsPNSGwHCpuV9ffmZ2m/AHaCaP0KNr8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u0oTK1M3SJhFJqwVgXGTI3fM1Ge4S92zx0FC8nLVcDp1sCYKbA3QswKNzzW7X4A6NNj24dwmj2gdCHSKXgAzMlA2OQ7aXqUwzxlE0PFRVqXOovneprgZ8D1YOlEqQMC7nl0rqBo3QEkjQXdHIWTI/3qil/PQ+08+3wDFjI5DhOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=mBEol8qI; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="mBEol8qI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+yeSY5P5ynJO6eGXQ2Kh3Hya0FwHXUc6a9QRu05ykW0=; b=mBEol8qIor0txMi1j0RmlnhJcO
	3Nr408BXw5iPZ2CFLufVbVrk4SKHJyDPx7QL4vJsDecCo1JIw6+ZwknBO7Yojs95a+mls8yAxYMVj
	8yLJGSqSO0Q4vR26Chrp2VbA5vD8PqgSlyI5t/cKER+YHXQP5KtVbskcJKFoeYhsP9sZsFWtr9ELH
	NR/kGhbcv6p1cbmm/v9xYOUIZOZDuA02OYLCJlQMKMBQZsi/8t1cF2tusAt5lnfyT7DzBbkKoLUTx
	s3m2uv+EcesWeMC4oyOwzZh80sR5DTM3+tw+BldaSVhxd8O3LaQ8flKlv3CBc6I/O65S7ob5SRnJU
	OPQ9XZ8Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wUUNp-0000000061F-1fVG;
	Tue, 02 Jun 2026 21:02:37 +0200
Date: Tue, 2 Jun 2026 21:02:37 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: packetpath/ct_count: Add missing socat
 feature test
Message-ID: <ah8ozdhOrSlSj7uh@orbyte.nwl.cc>
References: <20260602130715.727246-1-phil@nwl.cc>
 <ah7etAsr7mvjXKk1@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah7etAsr7mvjXKk1@strlen.de>

On Tue, Jun 02, 2026 at 03:46:28PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Skip the test on systems which don't have socat installed.
> 
> Ah, thanks. Please apply.

Done already, sorry for not sending an "applied" message.
