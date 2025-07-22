Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C851927EC78
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Jul 2025 20:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753216581; cv=none; b=YTFsJkcjRVLTDB6w4/mhVTYk6xObJZmnhTEm1RHR0LTdD9Xz2eV6vvEDtP4GCVHKq7HGZt97p3LTey7jGKtxak5XLyqrJt1//el2SNlYZPfrxUVTXVayEiSadDikgdUuhrwNvbLTy9nZcVqqJLJGJKmAuqBZZAruRLvvuXVbA68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753216581; c=relaxed/simple;
	bh=9uCW3JZb932tjLXx26rqU3E6MjNtlaLX9N7WNP4wtCY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mHBQSncZ9gcMEXaT8R76/YlNU5MDudWSIvSAFCnfAlvfygaUGTcyT2mlY4VZ9mw1K1C3+a9cq2JyNwmq4f6YXlcpRvYJf/4zZrUllWAwAEKgNLIW0/yaWaNq1clfFzkKQ1OY9HnG3y+F/R6e8nHlL2O79m93WYpweJdfNBvcLsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Zda6Pult; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Zda6Pult"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SwfAKPdzCny+nP5f/UJTYQ7A263DLOaiFeW6U9hy26M=; b=Zda6Pult9OxzcggR4Cmk2ZBsZ+
	D0Cxl5DaeHaaztFRkytEOn2xlgf8IOnQLqHrRx6D3NEfng5FKTgsxYQ5Xkpf5T9ZVCHBNIbmzznkw
	YFvwhAAvoU1FWczlOIu8MOqlC3qf7dxOq8KkUFZ1Ga1WcegLMojxvUOcQk54Pg6TW5josW0E/T9CR
	b0PUQUCvWFdhdCiAal/O3UUod68wNFzJL73v0xqbD4fi39qDHIl9M8QSnQsAbGmzRi2CHQ27NRZdV
	ocrv7ePIF/NfSgYQ/cXayCEcUwRf9X4FCmpMIYzoq9aTevwDry6aA13yEvgeLPxaaNCHkjwPh/+YJ
	DaeIaaCw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ueJii-0000000014M-3IJI
	for netfilter-devel@vger.kernel.org;
	Tue, 22 Jul 2025 22:36:16 +0200
Date: Tue, 22 Jul 2025 22:36:16 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/2] Revert "libxtables: Promote
 xtopt_esize_by_type() as xtopt_psize getter"
Message-ID: <aH_2QECLlK1lm5lA@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20250722144853.21022-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722144853.21022-1-phil@nwl.cc>

On Tue, Jul 22, 2025 at 04:48:52PM +0200, Phil Sutter wrote:
> This reverts commit 786b75f7c9b9feaa294da097c2e9727747162c79.
> 
> The internal routine xtopt_esize_by_type() is *not* just a fancy wrapper
> around direct xtop_psize array access, as clearly indicated by the
> comment right above it: It will return the single field size for
> range-value types (XTTYPE_UINT*RC).
> 
> Using it in xtables_option_metavalidate() leads to spurious "memory
> block of wrong size" complaints.
> 
> Fixes: 786b75f7c9b9f ("libxtables: Promote xtopt_esize_by_type() as xtopt_psize getter")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Series applied.
