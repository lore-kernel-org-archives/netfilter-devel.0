Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3388202963
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Jan 2026 16:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769790154; cv=none; b=dOk0784zjJ8fkaDk4xwhJodae14Dy+RSjBvSxTAGFtpusrB5aP+pz7lz0e6HEP/gMZcuUeshqziqD+VQa4lwYkVLp1hFl6xwQVlEXzNJpWRApTBISkwGQZHen52BzAp+rhXeKtmZM1wZvufyKm6q7fv5XOtMPbRWe6CBlJ78Y5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769790154; c=relaxed/simple;
	bh=4+jwPV9YjcCuUB7IhFCgJO/GFvV/cxcdpAz/mRTtX/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PFTUJaT1m9X0qzBLho19VzfnNdyUhRtS3cOwA04UgsvWJJAbNEHdT+HAs98Ty43NRWN/VVDGfD34TmPYjQppddSUG42tw50SdrRS4pMXALg0IxYM1LLF0zl+IYYu5OYBr10FwX6owIgJFYTx1oFyaEMmCvP6xo/urWsMeyLUY7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=GCiaQiea; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GCiaQiea"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fZ8KP30DvTpUtmeTjZMnGufkyq2RRkSNlPg0NcTWadw=; b=GCiaQieabPUNx7+6zP/Xhwjuqe
	1gBjpDreuSSt3szeS3vQ1GmLXPzUv0x5y2VkwhlZLcVbCiM9fKIUi7eJyjH71BNhjz7Kk2g7Qdb29
	yqLGFJUdd3hB6cfLBT9yfFJ3mC5aHJE9btQzWSIpbbSg2nZt2ItWPJQaU6/KEdigVzD4wkn86+qZ/
	TLHjTT2q4e89DnlO5rheemQSavdRD2mIp+h5/Svdi/0mDhjMbvyhISRNyWaESZOO023oUIAlDrGP+
	A0Pm8XRrID7g/hE1GEHEOA7ZYDEFpfpgLHkqUrficy8Lm7dLVMQCP+sufeo83404M5DpuGUi2ztdO
	j7h0T8GA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vlrGQ-000000001mD-2wGu;
	Fri, 30 Jan 2026 17:22:30 +0100
Date: Fri, 30 Jan 2026 17:22:30 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH v2] ruleparse: arp: Fix for all-zero mask on Big
 Endian
Message-ID: <aXzaxpX59E4QsWYF@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20260129195700.13553-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129195700.13553-1-phil@nwl.cc>

On Thu, Jan 29, 2026 at 08:56:38PM +0100, Phil Sutter wrote:
> With 16bit mask values, the first two bytes of bitwise.mask in struct
> nft_xt_ctx_reg are significant. Reading the first 32bit-sized field
> works only on Little Endian, on Big Endian the mask appears in the upper
> two bytes which are discarded when assigning to a 16bit variable.
> 
> Fixes: ab2d5f8c7bbee ("nft-arp: add missing mask support")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v1:
> - Use memcpy() to avoid gcc's -Wstrict-aliasing warning

Patch applied.
