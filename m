Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BB49443
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2024 13:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729085621; cv=none; b=k3KJIMNGHKFvZ+cs29+W+ZPZD1De22f8+ydTd4DXXDf9ttL4Y8JDnLdysEVc3MUr2G+8fMTFcX7esCyKOer9Ac/M1cWKKohsIfcHGO1c9aQktKEnK4FUsiq9Fi6afNLFPhUEgKMh1eqF0DOHk3/9xOdh0yow6Hu4HFfbeFqgtgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729085621; c=relaxed/simple;
	bh=efj4DeFicn+pO06k4j7/dkYa/sXziRyDGHKXsekCKDs=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T5Ie0zcPDTv1M/XFnzfvtV5DYQSX+g8h0kHcBtgPIvJEhucMcok5bBB6VIr+lXFDNyQi5K6olw3lFDvBhiVlVIfuKFsqT2luPqGfBphaFkNvlqRo0j8+srs9HCuWSf8RM3u7kD2fuOrazTBhB3HgbGomojDfx7DcD6SrYk6nZps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=TZH2Yl3M; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="TZH2Yl3M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=80LhqMd2dZCYL6MLxkPfgQWUV5yMKboFevBLbh4Yj4Y=; b=TZH2Yl3MrOrboHVqWPHzZ7fbtM
	WXuUC6CVU8TAOpKcuITNVh7h2rwzJlYxHm4KF8J8VqOl0Tl9JmbR44fCTx/xGGTeIDVWR9ZZqFv/M
	W3RqVOnbnR4XQb2+8M4kfiYTG1re728qzJyAXjw9YuYvAruVwbEDHeB6RYHROMYLGJ1YvEjd1n2I1
	XLBqmxT+Cgq2JDQkTR5xRqj3dIoSUwfqn+KofTPGuhNjOIB6P/ePBPbqTi7PjmxHuR4iuKbyt0ot7
	2hvLBO5nGlVs5EdTN4ogvqZwZUTRXiukqm48i12A0ZZIGmodU3h+nsxry/Q1IsGqsJUK5J8kDfq8p
	HBkCM+vA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t149b-000000000uQ-0Yqo
	for netfilter-devel@vger.kernel.org;
	Wed, 16 Oct 2024 15:33:31 +0200
Date: Wed, 16 Oct 2024 15:33:31 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 0/5] Some minor fixes
Message-ID: <Zw_AqwFzcuFXHruM@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20241009105037.30114-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009105037.30114-1-phil@nwl.cc>

On Wed, Oct 09, 2024 at 12:50:32PM +0200, Phil Sutter wrote:
> Correct some things I noticed while working on something else. Nothing
> depends on those, so push them separately.
> 
> Phil Sutter (5):
>   tests: iptables-test: Append stderr output to log file
>   man: xtables-legacy.8: Join two paragraphs
>   man: ebtables-nft.8: Note that --concurrent is a NOP
>   gitignore: Ignore generated arptables-translate.8
>   xshared: iptables does not support '-b'

Series applied.
