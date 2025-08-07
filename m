Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7F125A2AE
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Aug 2025 10:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754563907; cv=none; b=mE4YG2olkRPIoKGKPggJ4IBuTCjFcY0AROIcDHfFpap18XYJCRwQrmf1ysxAr4qG7hpaDV/Ad59KwoJgcl0vmjP8TjaQlpQ/sbI4VjFsMqkz1FJnY31JSJQV22J/lwVqPJF9GClNPClZk9/XhW5NpYHrscdLenis5Yz2V8UUsbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754563907; c=relaxed/simple;
	bh=f9hcYkPvEhdVuAZVVC2J087YjujL90s7Vsdz+8V4LMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p+CWJQKiqFZUyIbWmio4mYAOofhUd1ytk+ufY7xvXvjsZvWSB9wBPhUFxK851CmYEis/jijrt3e0CiDIQOspQY7szQxMR88TDEeie3NHY5pR2vFzbQwu3nGeEbG9vfNxOUSIBB8bC81Zfg50TWLO6s/2Q1iGN9n1/Ls7fzWkPc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Nc9KpB/h; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Nc9KpB/h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vg7Cs9zlHYwRYgHnVb8Z93u135vrYPhPkjuydbijs/g=; b=Nc9KpB/hFHGkhw+b5B9UkxDI8V
	Jw7K9dnVOQSzRk9e9j5dDgfey9pR1K7LS0/3H19BwUcOUcwt1rADPgVl41k9i6Jn4uDyvUqbStGIg
	hST327u3hlCPJ/g4fu45v61iZOcaf+Qs5oh+yBRkWfHNprYX2LBWaJxqt+S0RCEqyy5f+D7fG+5hc
	GLUJo4qXSDKmW3a1BC/XfQ6rruvXcFikt1BSLVm+pokLfOBP4XIg+Mg0NfNHYbjbXJXK0qAysUKAe
	NTQUtQizyGG1bYxQVeWg9164xbqaLDAjQlEj7zbqvVMgfabWvOBBK2exF8NNPHgsduQ7CZxX3iGJJ
	LXtjCwtg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ujyDl-000000003Av-1jnO;
	Thu, 07 Aug 2025 12:51:41 +0200
Date: Thu, 7 Aug 2025 12:51:41 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Yi Chen <yiche@redhat.com>
Subject: Re: [nft PATCH] tests: shell: Fix packetpath/rate_limit for old socat
Message-ID: <aJSFPWo9dS30np-7@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Yi Chen <yiche@redhat.com>
References: <20250806143814.4003-1-phil@nwl.cc>
 <aJSCM58M4KUlq0vc@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJSCM58M4KUlq0vc@strlen.de>

On Thu, Aug 07, 2025 at 12:38:43PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > The test would spuriously fail on RHEL9 due to the penultimate socat
> > call exiting 0 despite the connection being expected to fail. Florian
> > writes:
> 
> Thanks for sending a patch.  Please push it out.

You're welcome, thanks for your analysis!

Patch applied.
