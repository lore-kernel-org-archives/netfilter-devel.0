Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280F5335555
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Sep 2026 09:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788256388; cv=none; b=niIAvhuapOYe/EEjHSKMBINMSYdxo+p81bTUYA0Cjdq1Q+CPN+e2D8lNo7Tb19pqluUyl/TB7mwfKjGsDnEHly8tMLqhCe8Qho1S9hz/17k6myuSCrxQTOAvXwP+RTs7Z6D2hJim1yP60JZHyeEaj1uwU3Hh3rOVWp+83NT3SSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788256388; c=relaxed/simple;
	bh=sTEkv3TMgWeFpsXMIqILkqs4+HupYOD6HU+8AL/7O4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AAfuN3+0ADvmiMIyjyLERwnCYaYvA3AR+HbJHg2AaauzQ59qJBVepQ1j2zbIjb+iiF06izOj9U69MDHoqV96RFzSjPEQ3pn6pKunNKKEKkSt0B7Z42oGx0o0kKWnV4Lrjtt9btVtcFjzuFT+3umJfugF6m6m0ut6bLfDT6V51eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=DShgqHx3; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="DShgqHx3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9Gu/rf2SZLVxDjGBuBU9Ht7Yl3Sj29x0F7n9z7RGk8g=; b=DShgqHx3fwM3T/fd/wlT83VgyB
	rkRbQbGqZPEz7UPkFoZEONC7MKYpTVWupfo2OWWpMfe7r980bwwPesrTMi/ij7NRcKGhDdgRTgEEP
	ynwdrAydg0+ZdIwqFzLXNvaIg0DE/kUiWaVNsb+dQ2wvYJy5v+NJhi58rcYVzCR847B8g2nOjqBoZ
	9LMAOFvYX6SryuaT/KTlv9UZtDc4ZD/bx8vPGc3K/cEPHZJJ3iQi49/BFW1cFijBQcDFfNxZhvpjm
	zGCtIeBrAG16H7ZhuR2MWfNIwj9/uupQZ25yd2hABZ95Qy/5X3kVIFTFSda787+nV6lzM79v4NtNV
	2DAlmWiQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1x1LAt-00000000065-44S1;
	Tue, 01 Sep 2026 11:53:04 +0200
Date: Tue, 1 Sep 2026 11:53:03 +0200
From: Phil Sutter <phil@nwl.cc>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Test odd netdev hook updates
Message-ID: <apagf_aZh7-dre1O@orbyte.nwl.cc>
References: <20260827204255.274666-1-phil@nwl.cc>
 <2fa302ed-71bc-4136-8955-cddb234b5e24@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fa302ed-71bc-4136-8955-cddb234b5e24@suse.de>

On Tue, Sep 01, 2026 at 09:54:27AM +0200, Fernando Fernandez Mancera wrote:
> On 8/27/26 10:42 PM, Phil Sutter wrote:
> > These should cover what Fernando fixes in his kernel patch "netfilter:
> > nf_tables: fix device name and prefix match in hook lookup" as well as
> > some bonus cases I came up with.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Thanks Phil! These tests cover a lot of different cases.
> 
> Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks for your review, Fernando!

Pablo, I'll push this out now, which means we'll get two failing test
cases until kernel fixes are ready and deployed. Fine with you?

Cheers, Phil
