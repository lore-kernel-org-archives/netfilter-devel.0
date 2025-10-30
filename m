Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F162307AC4
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 10:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761821469; cv=none; b=HOPrzhhc5qmWOsqxCf3OXpQrvA1DAMzBBrK5xLwbOrCH65T04ipuSkGzOTvk5FnXzcLkG/W2Guxgzp8FYf46uRbGJKJSitNW30i5C0xsdFuBlfZXjIcWUNdbCLq79oCwBh25TeR8SyRvcmicNUXYHew2BW48shAsF5i8RCFctIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761821469; c=relaxed/simple;
	bh=SR9+S0ZkAekkBlgQlNPRWOPYTZDxGKM3ndCFHyZcZ+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lnsVOOOSigpGBETR31CfNkjHhbS29wOfr7L7SADxxKQd6XMAVRtgTe970ypYvEE838blFygAL9jCJtnDKUDqH9nB+gNmCpGnyVNDnHPPaJJMi3Cfz1ohCPsgTJgQGDLKxoE7j1Y6wwFJONPF2CyWMy78JbDiVV+8FBPZ5NuGhNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=FEYvYvpt; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FEYvYvpt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BQ+VdrFroYPsrHXEgEPNwrOu2d1F63o8dHr7F+4mfVA=; b=FEYvYvptncDrZkmjAeN082CfDk
	+npPJbWVWE20ESeCBj4vwFFZe8z9i9T1hRWrAhphDaZ8ap4I4559bZFRIaXf+ZIPyh5PASoKNcRtE
	g5LvVPj8X/jor1lBnDVuL15iCA8/1/7uu6mML0ua9VLEwE7RnJV6LHIjaHfQBJWFARet8i71oQ8Mo
	t1rOmj3WZLTRddcEDTTniZbjFDyGtElJcbCd8pi7L/WQA5XkPx8XoDAYub67XYSL+W+PYQ6eccE1h
	y7ACELrsO43M6/QE1snqu16rrzDh513ShBc1pw4+TRtIg2DA0nBbkhBZZ8BAflcHDFKDxx5iqD2qC
	FcA7wtYQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vEQFE-0000000037c-3I5Q;
	Thu, 30 Oct 2025 11:51:04 +0100
Date: Thu, 30 Oct 2025 11:51:04 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 28/28] Drop no longer needed newline in BUG() messages
Message-ID: <aQNDGKa0SSTL2Wv1@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20251023161417.13228-1-phil@nwl.cc>
 <20251023161417.13228-29-phil@nwl.cc>
 <aQJd4JIEv4uuXxiu@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQJd4JIEv4uuXxiu@calendula>

On Wed, Oct 29, 2025 at 07:33:04PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Oct 23, 2025 at 06:14:17PM +0200, Phil Sutter wrote:
> > Since BUG() now appends a newline itself, drop it from calls where
> > present.
> 
> I really think 27/28 and 28/28 belong to the same patch.

I'll fold them before pushing out as Florian suggested, OK?

Cheers, Phil
