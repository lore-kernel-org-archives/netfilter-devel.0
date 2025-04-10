Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069E11EDA2A
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Apr 2025 16:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744303676; cv=none; b=pyw6pkVJSZKMrFFXGJcq/U2ham/gxchmS8ds8oL/OmmIgy/gcxguuVSE8z8YvPA9KOWffKuPeFTWwLdFctjeHVnHXCb6sqB2+aEL+WkBBjSIHEGQRiCvZiThAgdhNdX7PPcSOwYN7u913XOZVAj0g1ByDAvy7HlMufpxIFr4oLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744303676; c=relaxed/simple;
	bh=mHMuQ9EcWmzvTQtHLt5oaeWCNpnMofdRLtTWNi9ye0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BHdJ8FVljHTcG6XX0AB4m+t1d7mRmTDyaT1NfcP2xvhQbg/Xeu9E8Odb2Qh0MOZYUqCejb0ua632CNAljOxaz8uPpRgWENxcGAg6tBRAcSOSCN6f/XUXvCuD0lztXIVVsMEEczLoov9Rij8kkyBIiFeuCmoyvkhcgH4EgWuT+XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=F7toPNhT; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="F7toPNhT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tMyI+B13knlWD0DPxA5gXWPvbWgsdEH7JcvEAxyqeAk=; b=F7toPNhT65QAacC087hEiX8ywV
	GotQ13hu5TnAPrd3j8wIuUIF4ighaAwfbk7x3wnDL5WkPNFNorDD/CrwTOKop0FfREJ20nb6fo+kF
	OduvOnWMsJxl8QEpGbzsuLYjB2XkpK3qXlLDpYw0vVRR6rp1wKah0qdgknZ+m/JvWw/4GfajSp10G
	Q3+QWAfff7zKZbfQNnULJVjLM369/ZOKfthb5itlPYFKrGMfojVe+4JYXwHxIt/3IA1m2+wAP9/lH
	Ne/SSkhXLIZfwr+jPGzBg6d+SYa7kZRh5+HX9hsbEQTRcoXXe8UsaEYDbu6wDgFwfXwtj3V8krQzM
	fo/dB1Iw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1u2v44-000000001Ph-43FF;
	Thu, 10 Apr 2025 18:47:44 +0200
Date: Thu, 10 Apr 2025 18:47:44 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>
Subject: Re: [iptables PATCH v2 0/8] nft: Implement forward compat for future
 binaries
Message-ID: <Z_f2MOsvmG_eKF-S@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>
References: <20241009114819.15379-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009114819.15379-1-phil@nwl.cc>

On Wed, Oct 09, 2024 at 01:48:11PM +0200, Phil Sutter wrote:
> Changes since v1:
> - Split the parser into a separate patch for easier backporting by
>   distributions.
> - Make the writer opt-in, allow users to force the parser fallback at
>   run-time.
> - Document the feature in man pages.
> 
> Time to abandon earlier attempts at providing compatibility for old
> binaries, choose the next best option which is not relying upon any
> kernel changes.
> 
> Basically, all extensions replaced by native bytecode are appended to
> rule userdata so when nftnl rule parsing code fails, it may retry
> omitting all these expressions and restoring an extension from userdata
> instead.
> 
> The idea behind this is that extensions are stable which relieves native
> bytecode from being the same. With this series in place, one may
> (re-)start converting extensions into native nftables bytecode again.
> 
> Appending rule userdata upon creation is inactive by default and enabled
> via --compat option or XTABLES_COMPAT env variable. The parser will fall
> back to userdata automatically if present and parsing fails.
> 
> Patches 1-3 are preparation. Patches 4 and 5 implement the parser side,
> patches 6 and 7 implement the writer and patch 8 finally extends
> iptables-test.py to cover the new code.
> 
> Phil Sutter (8):
>   nft: Make add_log() static
>   nft: ruleparse: Introduce nft_parse_rule_expr()
>   nft: __add_{match,target}() can't fail
>   nft: Introduce UDATA_TYPE_COMPAT_EXT
>   nft-ruleparse: Fallback to compat expressions in userdata
>   nft: Pass nft_handle into add_{action,match}()
>   nft: Embed compat extensions in rule userdata
>   tests: iptables-test: Add nft-compat variant

Series applied.
