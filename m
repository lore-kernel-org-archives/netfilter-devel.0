Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8722F1C1740
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Oct 2024 19:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727812147; cv=none; b=qL0XBkadbvrPnDP0mTdQYCM0OsbqzhFyofBf5asgFlnkTlsUCFw8pA67XCXMi8ggaCq2nuQkIEtIoHpol18OIA4Li65BGLiVBDUIVf94qJU5VVHvQmFKHyhiXzUutzyLZv/ucL6onyjFRywlVD3X3IGU//LpnFfag3UQEfPI6oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727812147; c=relaxed/simple;
	bh=jcULy+r0SLi+rGr+v9Nw3oDlLiGZpT1mTtl7mXdsYxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XLJEyQXyZsarEmS74CdImYzYFmghaw5KCsOyzSEgAXEshem231RxxSRRDzyCXCU7OxfnERuH+sVoajh2TmsYcmGt45ZlQdhoMnod1U8qRNBch0iqCCT1PiDMw0cC8lZ3m/LfZjwOLBMetxjOn0w/c0wVDDS0ev8gRN0gqtCNUGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=gvrlLH3V; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="gvrlLH3V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PSN+vGuoDjjq20RC+dsQaX/Z0H1DaxJBQRjhvc2TB28=; b=gvrlLH3VZFfJ/OFxBXZFxqZpeU
	hO7th44xuWM4w3Y+fpBMFNT0zWh+jDPvCGDTvXyUxObwFcV88gEmVDayQL/eQErAtJMgiTPlEf9WO
	KQiCi1sqhNdHBR9/knRfwWYcraPBGXdgFUMOYFWKZSAPA4sJQqsJWynsoh4ndiBm8c28nhFqkpsLh
	NFD7LOi6x/Fvyj5Zw1oWU+dnFaU1tdr58nDhbNmYzZffuLBckebHoHtv0bsZZWQgYBNtFYzvygCC0
	k8o7GadhzPS4XSESHlIsBWke4zM2+b4zCwna7fUoFl5WFpQ/W3xQg9tpTfyIsKLharwsGNtrmA+rd
	vccFXx9w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1svirn-0000000047J-2CNr;
	Tue, 01 Oct 2024 21:49:03 +0200
Date: Tue, 1 Oct 2024 21:49:03 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] rule: Don't append a newline when printing a
 rule
Message-ID: <ZvxSL02dM_VfAx8u@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20241001175034.14037-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241001175034.14037-1-phil@nwl.cc>

On Tue, Oct 01, 2024 at 07:45:22PM +0200, Phil Sutter wrote:
> Since commit c759027a526ac, printed rules may or may not end with a
> newline depending on whether userdata was present or not. Deal with this
> inconsistency by avoiding the trailing newline in all cases.
> 
> Fixes: c759027a526ac ("rule, set_elem: remove trailing \n in userdata snprintf")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
