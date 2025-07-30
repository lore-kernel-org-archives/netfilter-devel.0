Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC4C2DC339
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Jul 2025 16:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753893544; cv=none; b=jFnZ1WOcA+cx43dkejdo8aEmsufqN9vWeQ1p6pRYDhzT12YuQm1OPshr0gfCjWjCSq+5tm+TIFV4cAK36eOE/dbiTOWrH6ygmB3Ed8018hKxziBwfIcD0NX//zpTcsKpwd5NhffLlVYmq/2OUaOatA0PQZx11dJTYAAslq5Wstk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753893544; c=relaxed/simple;
	bh=UnBizYXCRauTuYc6BTFNs8W2U+/ys9UNeLu8yYXh/zc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=enfXY4kZrYBWmux7uueTb0k0N7PuXRDyg6+uOa0I4NsnEuLoPYVY/ZQViHzqJIaucFMo7dyHJLA4Ma+rZcGfOM8CmSbmkrbPcaXJxXpCwt1htXvgT9ahvXSjcHWGJR1JC012N78YFdvxwPgwefBQTGLpnIkcBWPrah68hI82DvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Bq7uh0+A; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=T58Ie79w; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Bq7uh0+A";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="T58Ie79w"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5FB5760255; Wed, 30 Jul 2025 18:38:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753893539;
	bh=UnBizYXCRauTuYc6BTFNs8W2U+/ys9UNeLu8yYXh/zc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bq7uh0+AIvQLixIE8ubBB/Fy2sEP0n2ikN7E9jkNLtdVPGbtaVxM43I7MRpjDacbm
	 aUJ/BH/x4XLuOi7j/8nJJQYegvd9vTwfaoTwCfTNmUKkmea+QnxzlEbS0tx5ycV7cv
	 ms4RLfAs4uXD4MSL8+v+3Axz4Rvl8XU2u1I8qtSW13HJR64d6TIb0ON221Mgm+18Od
	 t9zfzyi+zo9zIYfxD9gqt9kfRq63jaeJT4n/orORBaY2gOtyb/wU+pm34JjxSIJBoc
	 HJi5iBMWYK5LwWXC/EkcFskJcH/ZUPJzFU0yFdvaXeef4+UM+iTBiTCNXmiGLxl1Sx
	 DJJhRtIO0yjew==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9DDA060255;
	Wed, 30 Jul 2025 18:38:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753893538;
	bh=UnBizYXCRauTuYc6BTFNs8W2U+/ys9UNeLu8yYXh/zc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T58Ie79w20w4RV4G3fCO/myRLglvqQEKZfuWKYlZy+02RtgkfDRuTBP/UDdYLJCpd
	 ua6Hjd3noy09SSvmEik46tTuwg6bD9P3rIrpc5BRioAACre9b62jcMQB79JN8yAinN
	 AOL/0tAYyTjaRstIEUiwJ++rMNAom5Muhx1N+ug+t1ezBAcK6YOMVFnxbGs6reDTcD
	 y5/pKmrfL/Jx6pItPOd24UZLRlZGLG4XPjWlD3c+TuxR0Xsz0OerXKkAaWd2XOkMfq
	 CowIoEb3jM9XaCIJZ9ubtHvaw88YQkgpjG3G2JZ0j66FHodwsMNZAP1QSivIbH11cK
	 WX0JBY1VtkbBQ==
Date: Wed, 30 Jul 2025 18:38:54 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 0/3] evaluate: Fix for 'meta hour' ranges spanning
 date boundaries
Message-ID: <aIpKnp91SvTCTI30@calendula>
References: <20250729161832.6450-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250729161832.6450-1-phil@nwl.cc>

On Tue, Jul 29, 2025 at 06:18:29PM +0200, Phil Sutter wrote:
> Kernel's timezone is UTC, so 'meta hour' returns seconds since UTC start
> of day. To mach against this, user space has to convert the RHS value
> given in local timezone into UTC. With ranges (e.g. 9:00-17:00),
> depending on the local timezone, these may span midnight in UTC (e.g.
> 23:00-7:00) and thus need to be converted into a proper range again
> (e.g. 7:00-23:00, inverted). Since nftables commit 347039f64509e ("src:
> add symbol range expression to further compact intervals"), this
> conversion was broken.

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
