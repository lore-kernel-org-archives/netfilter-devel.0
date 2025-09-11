Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB021A2387
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Sep 2025 12:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757592163; cv=none; b=um4ulzooyAkPl4e6vVVRjacDtqa7BhVQcM6k7Lp8GvbwdBd48qOC/IlmwQx7mkpjZe/my6wq9VkEwbTRd05yV5loHkHPMKCgJjVXTEWoGtnGlRgrjBrGZkcqWNrNxSoRTOZeQYnhW4a8vlsB8Mtqmix8CSNhlsmngjSE8EvTEIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757592163; c=relaxed/simple;
	bh=Duq1DIkQe3qX02VhEACFxMjz5x0DTGePsn8XjL4BWNA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BikNy34BKujGEQzYDtGIkSoJTzGgua+I0hYFtiXNBISwQezK/z28OwAPZz0t9zhmfF8uhhOspk/MD6rwjWpl0mPv/CL1beok0bkwN6wNIOmrHNmwheTrK3L9tNfr4CL9osPqtIKKlGUPo2iCJ7DAPtHtfRHIX80lMeVdD/7sc/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=l13xXDJk; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="l13xXDJk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uPXeuTqLB86o/5Bfy+yT/ohqpmKde9SouYyOrXOKtb4=; b=l13xXDJk+nED9cE9AjMgSolDC6
	BxmwQjJ1CfOz294CINdUNB6E7+pCF5nuHFkzrF4y/wERHltI5PB8msxRBIwSNZbxWZutXGC8cUwnf
	twRmlwRDrlxWWuYt8kRN3Uil3ncn7XMbJGVquxaw88JTGvLdkH/XiQPmnsOuReuDb1/7/YKqCWzK0
	/Oq2lfMEPuUsm6thiCr4CNTj0m0C+HQ0OWzlLcCz3CKlUaVgpBUGhnpzKXcXJJOHD4ZL/qewZaOSO
	+Vau9+JmslZZ6WtcNXDnp8NZrmawFuRSUm4eYQb7BaWH1aZ2Adm4mH+//HLSh3uwmgO8Dz9/cN+qF
	HHZB7AXA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uwg0b-000000001qp-2LaC;
	Thu, 11 Sep 2025 14:02:37 +0200
Date: Thu, 11 Sep 2025 14:02:37 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v3 11/11] Makefile: Enable support for 'make check'
Message-ID: <aMK6XUffoFcnzkXM@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250903172259.26266-1-phil@nwl.cc>
 <20250903172259.26266-12-phil@nwl.cc>
 <aLmvS0buvv-vFyPx@calendula>
 <aLm8pkZu0r1hrlUf@orbyte.nwl.cc>
 <aLnFEDmuqOckePL8@calendula>
 <aLnc7AidZLW9dCbY@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLnc7AidZLW9dCbY@orbyte.nwl.cc>

Hi Pablo,

On Thu, Sep 04, 2025 at 08:39:40PM +0200, Phil Sutter wrote:
> On Thu, Sep 04, 2025 at 06:57:52PM +0200, Pablo Neira Ayuso wrote:
[...]
> > distcheck-hook: could set a env var so test just print a [SKIP].
> > 
> > Similar to your previous approach with the env var, but logic reversed.
> 
> I don't think the 'make distcheck-hook' call is able to inject variables
> into the following 'make check' call's environment. It could create a
> special file though which all test suites recognize and exit 77
> immediately.

What are your thoughts about this? IMO, the special configure option is
much cleaner than creating a special file and patching all test runners
to check for it. It should be doable though, so if you prefer this I
don't mind.

Thanks, Phil
