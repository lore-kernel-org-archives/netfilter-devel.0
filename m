Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58AF54774
	for <netfilter-devel@vger.kernel.org>; Sat,  3 Oct 2026 11:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791025862; cv=none; b=tn6ybJFWrwy1DOO23+V105u2DzN4lQ47MRv9QUkSFHn0hBKFlkKMjmwAI1nIP3WM/dLlEyvQcFvXL5UwDFB6uX8/xdRg5NWiKYwDnYZevMSXmVSov5W0KjINFKP3P9nE6wSEHQV5S1hkLJ++joYeK+RCVHKZ6IvH2AtHJ9seL9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791025862; c=relaxed/simple;
	bh=FXOa9RaoYzoV/Q5rTLTdhQxRNTfpYaPLqH5NfnHx4Bs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K1WTkaQUksSp7BWmbu9o3T0NuZaIhUI5HAi/QayskAbVGC51kV7DcE1Opa+xCH/h8Y5zYEbLbaMvCXLhsgbSig0rdF02ReZt+j1DE3O6znClWi0R9xbWKuVVCgDNidJsYqsy3as/A4RfR5thZNC4wyh2BXkyQZ6r4PhB5obUgos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=BddluGwg; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="BddluGwg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oSWIOWDg/3Fu/9ih/iuCCz8xaNN8M9UQNT4kfZkpS+A=; b=BddluGwgG1qp26Mo65Th+6DgqF
	xckVjx0JS6BU0mvhokRcyiUJ2KGueHWlnds9a9xjqUZ+tPTgkivw1KhoXMY5Hwnw5tmpSUFnm72vo
	wNt7tbWsB/0VUG+yuxKrlzgji/l7/0mz9mUk764V8ZiYtecvd9aG712DjndfU3NPGIb7nhmIJzwIf
	ojKNTFngjGX4Jbf7ji5hWs89PAc5M8wV+DIr3yc6URZxrb4WFhPpvaMf6NQ3P2ix0aGiBIS6olSX1
	xwMziyz2qmKt7F2zJYPuPh+tZZJB25OiHF8g6nvRzecl0qwtKFDC10/K0ywXffPkP4CONYhxHO0rw
	1TIRU9fg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xCxdp-000000005Se-0F5A;
	Sat, 03 Oct 2026 13:10:57 +0200
Date: Sat, 3 Oct 2026 13:10:57 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 2/2] doc: nft.8: Document caveats when mixing clients
Message-ID: <asDiwbE0Cmyl5bFs@orbyte.nwl.cc>
References: <20260917173159.2077268-1-phil@nwl.cc>
 <20260917173159.2077268-2-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917173159.2077268-2-phil@nwl.cc>

On Thu, Sep 17, 2026 at 07:31:59PM +0200, Phil Sutter wrote:
> The "do not touch" warning message nft emits for tables with rules using
> compat expressions has been complained about for being confusing.
> Replace it with a reference to nft.8 and describe the implications there.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

This required adjustment in parsing/compat_xlate shell test case.

Both patches applied.
