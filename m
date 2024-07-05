Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B382F32
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2024 16:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720197796; cv=none; b=IjRyQikQqwM82muT7tOOXTYzlhksd4p5mf8RR0PnjXOc5rUFJYb0WfWxVDSXoU0WOmj5vmEHSKhk4V5l8AkiQPKcUXJZLjEpXM15BgjyIe+lal6spkNTVFtsRlP42qNBxQOPlKMtUIPDnWiCbYvYv4AJX+213TAVtkgP5R+n5L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720197796; c=relaxed/simple;
	bh=GhpBAr2VbvYqjaTk5vFOwcqD8djTV0tgPqp091bxYdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yss2Un6GZUCo3b18N50e8xFxWCPeitI2nlQO5tvfgkru7PkpuEm0CYdZTyM1MIXUCqkTpIn4MmeVhZCYIFM96tBNttaklSBIFQQgKJfsG4u6o+MqrXR6h/yF+pU92rIh2Svri4KclTALfJhQcpJWmu7YKHrm2uMzisBRayJTdA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Q+e29SFZ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Q+e29SFZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ljiBc9xODbQp6Hra2bsF7ZQsqdS5bkDS3mEBkaSWw0I=; b=Q+e29SFZn5CUGRJ5B50AcRFfM6
	zwKckKoXTStmwTXrLmHwonphUdR7RXdZcZBBJMrLEwBCA+98X6lMX0znfPOAyOIx9FE4N5vZxyUC0
	oyLGkeouhv22UKUKhceDRxKxbzp+ek7UacgY5r+6dX3/fmSXDdf8inuKEsDrwNZG2xg24+6HOwQrQ
	NCFEZQeyRI8029gx16Sn91dCX1EHMKYx/AthT/VmeVw0PV10NuAFSHXwCRQ11v8jBDURGLUP72GmC
	AE97UGiZ8iv5VgytVu539N6dnAAzFkI4JE07zQ+ceMnKEib78lEaO8DHhS+vSXlmpx3tkdBZ6T9Iz
	iyzng/lg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sPm1f-000000002Vk-1tmN;
	Fri, 05 Jul 2024 18:43:11 +0200
Date: Fri, 5 Jul 2024 18:43:11 +0200
From: Phil Sutter <phil@nwl.cc>
To: josh lant <joshualant@googlemail.com>
Cc: netfilter-devel@vger.kernel.org, josh lant <joshualant@gmail.com>
Subject: Re: iptables- accessing unallocated memory
Message-ID: <Zoginy1sxVHnhbNy@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	josh lant <joshualant@googlemail.com>,
	netfilter-devel@vger.kernel.org, josh lant <joshualant@gmail.com>
References: <CAMQRqNLQvfETbB6rpAP+QabsVGdwDmA0_7bxhK2jm0gcFQYm9g@mail.gmail.com>
 <ZogRDinLhQeOhY6O@orbyte.nwl.cc>
 <CAMQRqN+S6487boLi98hGSe-X9-8aM1XkNS+BRb+dMS+4hGiBhA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMQRqN+S6487boLi98hGSe-X9-8aM1XkNS+BRb+dMS+4hGiBhA@mail.gmail.com>

On Fri, Jul 05, 2024 at 04:56:28PM +0100, josh lant wrote:
> > Could you please try with current HEAD of iptables? I think the bug you
> > see was fixed by commit 2026b08bce7fe ("nft: ruleparse: Add missing
> > braces around ternary"). At least I don't see a problem in
> > testcases/iptables/0002-verbose-output_0 when testing with either
> > valgrind or ASAN.
> >
> 
> I was unable to build from master due to some other issue, but I
> applied this patch to 1.8.10 and now all the tests that were failing
> with segfaults are working...
> 
> Many thanks for your quick response. Have a nice weekend!

You're welcome! Glad the blind squirrel found another nut. ;)

Cheers, Phil
