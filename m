Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0293133F385
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 10:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761821601; cv=none; b=d2mNAOCQwnvyKywI1DwIM7id3cRSlAeakqOTlUBkkknu8cfBDfbHy2f5h8C1dv6rbXXrB3bD862GoVwXJcl9ZFWP+plvgI2bni9AHFw9ptIcg7gQcfQ3CCnBvdqzkHWa7FP1MiQcs+T2vHi7pHLN3NFmGKfGuO/nO7cpai7UffQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761821601; c=relaxed/simple;
	bh=d6V1sK4JIsxNV8kCNcDtkBqa83KZUYDN5HjZH8SNgr8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VVxBdcLYd/JGc5Q7Xqv9lSXmGplwr5wLux0CkLq/tGgQzYswFTEXx9IFox8jpnrlbMtxEAAn71JPfmxX04Pj8/pQbp6lTZcrMydMIJh3VNcGbLpZi/Q7rYY1d79zoSgl5aTnszcpK2Gyq3RuEVQ5XbyqQoCiej72EvUbZzbhcmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZovzWMFm; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZovzWMFm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZJ3cNssME6q4qAfCxDe3fACc4elEyVwuq41XsMwKMwM=; b=ZovzWMFmh2NG0HTeL9Ff2copcB
	AR3Vx/rIC46vb+3Em6nzGwhp/3sbakrymcxlo/HLR9U5bnoRDqoHopY+7McSaYuKW87nKUV/2SGr7
	aYRPltC3+1+qPbadk/uH7kVmsPW175cehVgYmSlNXEQu0jPupOgKFH98tixPLjqk0S/YfV8sFRIwv
	GlpCS3hZRdapA5hWaIXcpqTkaxJRTiFvCmGGc/WbM60ThA+ukB13RdSVvURFDUiz/0lZJ0xpsoWUw
	M8E8DgID9i+ATO7AnB2craB5Z7g4A4Nu50z4kZMd4QJabHX7sovi6cd4jxp4Zq/HY/M4XOUCYhXDO
	NR1/CDug==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vEQHN-000000003At-2tsC;
	Thu, 30 Oct 2025 11:53:17 +0100
Date: Thu, 30 Oct 2025 11:53:17 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 20/28] netlink: Introduce struct
 nft_data_linearize::sizes
Message-ID: <aQNDnS6ibANsLEWV@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20251023161417.13228-1-phil@nwl.cc>
 <20251023161417.13228-21-phil@nwl.cc>
 <aQJeONBDnSzvjDq3@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQJeONBDnSzvjDq3@calendula>

On Wed, Oct 29, 2025 at 07:34:32PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Oct 23, 2025 at 06:14:09PM +0200, Phil Sutter wrote:
> > This array holds each concat component's actual length in bytes. It is
> > crucial because component data is padded to match register lengths and
> > if libnftnl has to print data "in reverse" (to print Little Endian
> > values byte-by-byte), it will print extra leading zeroes with odd data
> > lengths and thus indicate number of printed bytes does no longer
> > correctly reflect actual data length.
> 
> What patch is the first client for this new field?

The next one, patch 21. It changes nftables to call the new _set_imm()
libnftnl functions which accept byteorder and sizes as parameters.

Cheers, Phil
