Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC331DDC1A
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Jun 2025 18:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748976151; cv=none; b=YZuGPHI19yR08JqTHlsQeAwJZXaAiC1LgsiCXubhyzyqMC7N1rks98wihaw7aF9oJzXMMnBpGfPsJozJnPTfzCye7GUDjNf6HODHE7DL4VznqQjFlrKwLJNwLXormT9fTpiYy+Nd3oKD/CMJ40iM45JCjVLOdoz4FtcAnZlYNak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748976151; c=relaxed/simple;
	bh=1NyU5nYflaMMh3hSzNChQx6NLvct2ke0oXzBgWeXpls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PiB7tnEhyDuYxYUrQu/Ooqo1WMeBr9Usro6YUd4ejGBNo9rWrgJ+VxUErkJ/Ag3jHkgUHgUxrFRGNKaNxS5DTDDn0/KeiIDQrEANZRWLKHwM2ypk1KQtuBVmt96CwAXTArZpfdrxYCov3o+A7LvM4tltLhQVjIYLuqbNzwbsCMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bE829Wem; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bE829Wem"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sw2PG3Y+aTeo7r00p2aTwZ1ay9Tzn4vqcRgPEsh3w0g=; b=bE829WemFrBK6uZfcOJ2IeokTb
	tHxQSxADdMDa0fSc9J8w9FyQn68AiHQhuiP1rM/P0mrQqjpu69ntDgrXEvtSJNo61Ls4JnofZ1jHy
	hu33CILIO2IGrVbH0BrpWT3v32ASNp0pvSrGY4MZBKQld2yN0Vn2dZ5mT3g6m3uwsCyElTid9fzIT
	upWgrvgvuOJmblaHOG8NzruHtgQ9cJtguc3Coj8xDNLrB7HTR1RKJ44pIs1Y5Nl4HBhBDBGFGdrj2
	QyQe0Je5piO0q3eT6lfP2nVMzop0ddLm3jG0f7hKbTZeNOGvqvt7fecyf95JhBWAS61tKtvr8VBUj
	HwwFoSyg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uMWah-000000007jj-2O4g;
	Tue, 03 Jun 2025 20:42:27 +0200
Date: Tue, 3 Jun 2025 20:42:27 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: py: fix json single-flag output for fib &
 synproxy
Message-ID: <aD9CEwQCNWNfXTTM@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20250602121219.3392-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250602121219.3392-1-fw@strlen.de>

On Mon, Jun 02, 2025 at 02:12:16PM +0200, Florian Westphal wrote:
> Blamed commits change output format but did not adjust existing tests:
>   inet/fib.t: WARNING: line 16: '{"nftables": ..
> 
> Fixes: 38f99ee84fe6 ("json: Print single synproxy flags as non-array")
> Fixes: dbe5c44f2b89 ("json: Print single fib flag as non-array")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Phil Sutter <phil@nwl.cc>

Thanks, Phil
