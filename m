Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247501AD9E8
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2024 10:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723629764; cv=none; b=eBIPmMGxWAN+e0VWnELwl7VdaeL4z5oc6VOFIGZPI/w0YgoV4ocxeirqy3yF+gslETGXvunnZ5GGKE7MipNy8m9WCIZC4sQ5dQJlh9m8JbMycSPkcna6CXFrEyiPoziiTwqLhVv5sJsz4gaUCxAZ/7RPeUfTmjnw668JujL40HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723629764; c=relaxed/simple;
	bh=oPa5JaqI4zTMYozJr3wMMWEtY9g8/x2RSrzNg/UxdKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d+87MQlawmrj0ICVNLwd5kmjrmjYUMLFv1EKMop+eq/6GGEboCcaKzyxtqx33peGPovh7gUyax0CrXmimUZ50/5I5og5jTUmoPbjIIm5wjMQ0pAF/kEnDAjBrGKKghutDh0CiSw8lAFTjYW/VDutk8fy3E7lozUDlCNbLscYWPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aoGdx+aJ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aoGdx+aJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lRfragdNowafW3lJTdLjZYuaYxZLzrUPY4ZCdpRedgQ=; b=aoGdx+aJwuA0CHRt0aIj3TkZ6r
	lobpqcNGN+lGMT1/TZkEx+nkty2SxNWpi7BwQ2bppVFE207KTfZP30Ke3zzXPUZO6OrnBHM9LxM1V
	9CjvHwUi3Yu/hRX7Rpwjp/ivxhsR1G6RCvPQ5EF4UiSthgARsfcGKIM3+qFwWjNkCDPVhMj+B1Pcl
	ual1UemLcDIWhuVnoP4V5lDfuXuKR++JvCEOEWt/zVvRL0wRCeYtpHXWmJRf/Qdhmev8oNjP1yDhu
	vNPFiZ0louH+xOO8KUXoa7awyeoZL+2qT1hTtktDTlYhAQV84HEJY1xmJ2dmTpWvdeWoLDPb5fsGX
	1p0nwT4g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1seApz-0000000070Y-1mnC;
	Wed, 14 Aug 2024 12:02:39 +0200
Date: Wed, 14 Aug 2024 12:02:39 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH] tests: shell: Extend table persist flag test a bit
Message-ID: <ZryAv_79gk9otlP8@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20240813193611.14529-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813193611.14529-1-phil@nwl.cc>

On Tue, Aug 13, 2024 at 09:36:11PM +0200, Phil Sutter wrote:
> Using a co-process, assert owner flag is effective.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
