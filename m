Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55B1199D9
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jan 2024 13:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706103998; cv=none; b=sK1ftQoy0olEd8Sf2Bz4wqemW1XMsoAmIrZgZn4Ybf+Tl2WX71ro8kFSKhBxJZAWrQLSlZ01HnqS+Ft+nR1HM+2Wgmqa1hthj2f/WGfBoymwqZ9X0LhopV/MRIG0vBi7VPAMc65odZ/mjOw132Z85eX+sg3RMskJg2yL9K3f5Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706103998; c=relaxed/simple;
	bh=ZP5+WWboxAB5q+oqYRtkPVg7fAv4+zhfHGC19cA0+50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tt+w2Vdjg4Spy8LJZma9EFHFZ1/+NskcnlEiF4MOIc1SpGLb1kLi3bt981slvrtUYWW4jJAZcUfCGFgw0VLHwreXJhZ37cdt2OKY4RWW/Oxgz6EfzUFSM8SouOMlHmKTUuZIfj5mHJFPydY3aSUWwjXtce1pkry+TqheYVyhZDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=a7RQrHCR; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="a7RQrHCR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zZ2OHqraHWJbvWDFEvHhRr63lHGccyjf5//i8uw2YDE=; b=a7RQrHCRlKvnJjaSEI7Xj4eNIo
	Oz/+6nVp5pCCDTNVE0pJBBLWaxfAcCb6LUT8vVvYVe82q1DNz3gGNsn3Rls/j2xH5J5tOWZJNfJkR
	X0U6X78H9w4glZ8czLvleDgHOKOQheLxbVZSxSdDMO/pbpa+T+1t6i2v7Sp2kLL7BMihgn3Lr5Ffa
	iEZU+RKmVIN8SVeRcidUsaiaE5OOeA5tzVdBdznSjnFA+SZsEwwTwdriYuJow6+wBLualRab5PGQp
	56fxLZqlvM9WCjPfyotZOqJamJBQd9JQp5ZGbkOh0FTlCHFawYybTRuq1YgBUb/lqS4QVhf7HVwQ6
	QmzFUfUg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rSdaF-000000001rL-3h4X;
	Wed, 24 Jan 2024 14:46:27 +0100
Date: Wed, 24 Jan 2024 14:46:27 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: arptables: allow arptables-nft only
 builds
Message-ID: <ZbEUsy9h4DNJxpFt@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20240123154252.12834-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240123154252.12834-1-fw@strlen.de>

On Tue, Jan 23, 2024 at 04:42:48PM +0100, Florian Westphal wrote:
> Allows to build kernel that supports the arptables mangle target
> via nftables' compat infra but without the arptables get/setsockopt
> interface or the old arptables filter interpreter.
> 
> IOW, setting IP_NF_ARPFILTER=n will break arptables-legacy, but
> arptables-nft will continue to work as long as nftables compat
> support is enabled.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Phil Sutter <phil@nwl.cc>
