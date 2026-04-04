Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1145B40DFD5
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Apr 2026 09:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775295182; cv=none; b=mGw6LLvxaLyHwrfyF0BCHKeQgo6+4YZ8ffG7nIxvUL6TOy1MOC+Z2NKzIBWCGmF9qqxe3oCUpIqjLvV5O9aFHR1nq7lvE3nOKU5rxj/KzoEvMs79vrthETZOTQAz3xWFMH6xJLLgj+3ODuQtQmmYuUlLHPmVc6oYAE/nl37MBSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775295182; c=relaxed/simple;
	bh=bHECIzgkNhNMz7HdHTgCNdPZmIDWnNNYtXYVNiv9+BM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lkz4LhETd29Sw2OuYVLQinIEfF1/SzQbYrAH5ZylsGEDz9Hk9EMS0jn/0so/1uhBe9p/jQ+6vpLZBx37DzCtMSWsW8BK8W9+sr80LnWUNpXHcu+XSlLg/tdgEyy8Z3gkIhJCX54eIkaLopmWSHZCju6GS7GacslWCoUnRvjaKTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=kVuax+VV; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="kVuax+VV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IeW8Wv9tLSB5ZsRVTcsOEdeeSV1L+3sEnyw/I94XyOA=; b=kVuax+VVlRCdSTBfJjoev16Va+
	bq99+iVQfoM9VckptUzO3odL4XJbrcL+UjIVDEinGRb8kJCa2DpWdHbRmN0KIn2NcaWDIdSyiLEFf
	mkEZ6+0aAkpKuidD4pKFsZctlCceJXMIpre1wm07TU3I3KwTIMP035hzaO+TWzfB46/YIkKeLBf3q
	6vEnCAbAhdkbqtIqAaP85lCeUySrUi81TArzpHq9L5GgDbkCOw6Ili33hTeYHZvWwF1nioPEk8MOd
	r/vYQH/wjhMOgJciObilv7O3R/bD5/KSujITv1wdXj6xUA878J7nyrH2OLzeiR1I47szONwy4gmeD
	FT+RqdKg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w8xN5-000000000g1-2Dw6;
	Sat, 04 Apr 2026 11:32:51 +0200
Date: Sat, 4 Apr 2026 11:32:51 +0200
From: Phil Sutter <phil@nwl.cc>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/2] A bit of non-constant binop follow-up
Message-ID: <adDaw2nCXsDPHHyE@orbyte.nwl.cc>
References: <20260402184320.14862-1-phil@nwl.cc>
 <20260403155314.GC5449@celephais.dreamlands>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403155314.GC5449@celephais.dreamlands>

On Fri, Apr 03, 2026 at 04:53:14PM +0100, Jeremy Sowden wrote:
> On 2026-04-02, at 20:43:18 +0200, Phil Sutter wrote:
> > When asked about how to translate ebtables' --arp-gratuitous match, I
> > noticed that basically everything is there already but the parser
> > rejects it.
> > 
> > While we can't do a simple 'arp saddr ip == arp daddr ip' because cmp
> > expression requires for one side of the equation to be constant, using
> > XOR on LHS we can work around this limitation:
> > 
> > arp saddr ip ^ arp daddr ip == 0.0.0.0
> > 
> > Thanks to Jeremy's work on bitwise expression (which one might want to
> > repeat for cmp),
> 
> I'll take a look. :)

Cool, thanks! The ability for cmp to operate on two registers instead of
one register and payload ("data reg") would allow user space to
implement the above as 'arp saddr ip == arp daddr ip' (without the need
for an internal conversion into XOR). It is not a short-term solution
though due to the needed kernel support.

Cheers, Phil
