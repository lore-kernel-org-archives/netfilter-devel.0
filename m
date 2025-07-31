Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619252BE634
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Jul 2025 13:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753966919; cv=none; b=estdZ/FMjYLYNY1cCzsp80ODEe7A+Cm1ufnu69GBdgNo+CZ+RlsOMaiJ7mim8Eeh3Ou5AeoIq/0F3cjSQ4UKtZQzD28bOFT7tIMkQbXJjrXAoAmFEdjwwkxshZkihPryMuSK1bLNn5NQat056l8gwuc7mkmiS3P1/gjOMGHL4eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753966919; c=relaxed/simple;
	bh=8opPrJYPWA00fP2UIyW7INpD61Wae0J+6nj5w8YHFP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YqJ4W5uRYi/oFIfwmMftt/2arPhjAAwaIBz04crt4xnwaB0kjOQJa5+4XRBT+8CEJtMoXgpldDEgdeoJ856hZt6WCUINXnj8C+Z4oBnRa9WoUI4RZ4yki2TDHrQfvnSvyQqHK3zCWj6rEBEZEDMsZpu44D0+XVQiYszr3o2oe+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ibu1PQMR; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ibu1PQMR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=iUMZdNYXjoxon4kb2VmSTyNyKHPZUmOE0pTZrkhH/rA=; b=ibu1PQMRM+ZwK2gy+lYIf2d0vu
	rM+55TiglIrL8wUz3HR79n+ZE9Udq0tVWwBMKC0hyVCFsH5AyjiINv0H5JFe6iqyAMKosAesK1zLb
	IFF7VKTDlbDP0Xy5OPc75Zcbjn4fyUb0bBBhvdOPe123pIct4+qZNOZbjof9Wu7fY/m5YlTIRCSDJ
	c2F/Aiwc7XMeh45GCdx4ORZTQdk+Ik1rd5lGrhRv4m0PPyzGeg+m8F6thM9wxfO5kJMcNiPfrDtv9
	U0idG8gOzaz30x2Cg6hGJgT0msYGNoLJIcY45McjdOkXxV0O6YJLaaPU7EpNHGhclt7yrBwAbhS0k
	b5iSYzkg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uhSuw-000000005FA-0gxH;
	Thu, 31 Jul 2025 15:01:54 +0200
Date: Thu, 31 Jul 2025 15:01:54 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v3 0/3] evaluate: Fix for 'meta hour' ranges spanning
 date boundaries
Message-ID: <aItpQjx4_AAOAzAW@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250730222536.786-1-phil@nwl.cc>
 <aItRJdZK_t9e_oVO@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aItRJdZK_t9e_oVO@calendula>

On Thu, Jul 31, 2025 at 01:19:01PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jul 31, 2025 at 12:25:33AM +0200, Phil Sutter wrote:
> > Kernel's timezone is UTC, so 'meta hour' returns seconds since UTC start
> > of day. To mach against this, user space has to convert the RHS value
> > given in local timezone into UTC. With ranges (e.g. 9:00-17:00),
> > depending on the local timezone, these may span midnight in UTC (e.g.
> > 23:00-7:00) and thus need to be converted into a proper range again
> > (e.g. 7:00-23:00, inverted). Since nftables commit 347039f64509e ("src:
> > add symbol range expression to further compact intervals"), this
> > conversion was broken.
> 
> Thanks for fixing my bugs.

Thanks for your review!

> Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Patches applied.
