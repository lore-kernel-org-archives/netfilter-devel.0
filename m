Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251FE335089
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 19:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769629101; cv=none; b=nSpgXXcpUODEmXTFHzh/U8lh/gx4W3NeutvMhjfT/213zPQRoYW9NEtekcrjZrMoXZ/4zPtHj1tsAPWPnS0b2moW6bF3TI7OGli9iaUjpPe8SQlWB79boyLjerHR9fhKeyYmGJYt7mKfELfBEDJ+SgYcMzQyB5amrQFvL5fwyp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769629101; c=relaxed/simple;
	bh=4vyUGnQ5ia3Jyti/p4hXW9ep4gTIvFaSMW42s/0ZVWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A9yyKvPF9DRg1eq+PoqqEA19mQ4Znu6VFSbnqCtlcWxYfqjAQfiiT0C8Uk/dFvEudySTHtz1h0+ZJ5j8cm6SeItj0N4Wq+JKwgPITbmEghNq8JCxaIZI6Vt6m1M1rRM2tXKR6ynfhjlZDWDoonnaEqBPungTmBujdaJ+b+jor4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=H/A0qmpT; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="H/A0qmpT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gV4/+Qyfdq1f9ceRA+w0Xt167wcn8S9tdPPQ0l+3jf4=; b=H/A0qmpTFdMZLFshoaqLb/pD1r
	93y5qve6GKcG82Z++yC+pHqGX8coMBsaCDx4vdCj7nvPQE84QvW7l4c0Ad4TuOHgo8Iy6EsRVkvd9
	w1Z6Si4HNCHhM6f5VR8htHUJAP03S80BCr49FWMRGA9hnERcVvAwVQFztSirwG6tds+bx/4jmSTIp
	GZAZ69HX0pkkGPBOK3pKZyeDAPt64p8Y+i71ea+Rq+eCg/HOjsVRKuRESNKPguuRgfodmYB4Dvrst
	TPjPXWj/j200iFyx4f5d8DtDpeT4te39ZVHH8Mtsld+L0Yd2Rtrh9nY9SDnMhmZMWJnILmJy+uhOr
	zFlGolAQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vlBMn-000000003fA-0e0k;
	Wed, 28 Jan 2026 20:38:17 +0100
Date: Wed, 28 Jan 2026 20:38:17 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/3] build: simplify the instantation of nftversion.h
Message-ID: <aXplqYgvvbO26cIj@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jeremy Sowden <jeremy@azazel.net>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>
References: <20260128183107.215838-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128183107.215838-1-jeremy@azazel.net>

On Wed, Jan 28, 2026 at 06:31:05PM +0000, Jeremy Sowden wrote:
> Add an nftversion.h.in autoconf input file which configure uses to instantiate
> nftversion.h in the usual way.
> 
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>

Series applied, thanks!
