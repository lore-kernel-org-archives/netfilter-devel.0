Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0FA183CDD
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2024 12:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723724721; cv=none; b=dyMohHWdCJtd/FXXvuD01VuW7m3c17woykm9mtJJlZI9gip8r26nHRfdtrYAcmXd8fvN6NMEhznIaSInyk5eH+LcOTWGY2XdDunnp8zIuAGQGq6gchvFv8sUK6NBPDSkAtAmFqsucNWk42kLpUaYNSrmX04PqXBZ18IVp9Wo254=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723724721; c=relaxed/simple;
	bh=CE9x7BZ47wP34E9l7g+ufus0KimDagpPFAMmmhL2U9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NZydFj/aC36FozHNZ7RTzm5b9wEFlhLSkMH5hegnrSOvUbDPOIcd4VlOeoBwVBP3FkITmkGWjCu1g46s+/FwXSXtvZXoJX9Zn4+Kv21SRp93ApyjYb4L7dxXyV3VyRgBRwOdU13Lhr8usDzQvZXltwbkrinqDQR2jCrMfb8057w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=YjhIRDdP; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="YjhIRDdP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Dh7J7mYaWvwvQvCEGAD3zjMeSjTDT8du3MbJryYUZ4I=; b=YjhIRDdPG5rd5gxvUzR4095eo3
	FnHxV6w9jAsQ7wRo2g1P9z5rBxaH/hluCOOXBRp8K5DL+IObANHcsGARDocXBARHnH7rgFoAHIkg6
	kzmq0fRcZmwjsyjghZUfIrsNmr42TnYcR7JcTeTluxmim9Ep9JKXkgaB6B2YM8OCHs7JJ4CZEzS5E
	xAWW4NZ8kbPrCy0Xm+1ElYV1YNS+j4ICtdR6AGTRdYv+UgDuuIB3XBvegZVvP1MLEI9vvVICGEUnK
	1O4AEetrsr9N+A1FkLOlS10rdEonFRCxnTaxGake6Q9ErAuPm00MiN5r4GpqAjc29K/zLiMKXHjNt
	mc9GNr0g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1seZXX-000000000ZG-0aYX;
	Thu, 15 Aug 2024 14:25:15 +0200
Date: Thu, 15 Aug 2024 14:25:15 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, nhofmeyr@sysmocom.de, eric@garver.life,
	fw@strlen.de
Subject: Re: [PATCH nft 0/5] relax cache requirements, speed up incremental
 updates
Message-ID: <Zr3zq62D7-aS6WQe@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, nhofmeyr@sysmocom.de,
	eric@garver.life, fw@strlen.de
References: <20240815113712.1266545-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240815113712.1266545-1-pablo@netfilter.org>

On Thu, Aug 15, 2024 at 01:37:07PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> The following patchset relaxes cache requirements, this is based on the
> observation that objects are fetched to report errors and provide hints.

This is nice as it applies to error path only, though the second cache
fetch is prone to race conditions. Did you consider retrying the whole
transaction with beefed-up cache in error case? I was about to mention
how it nicely integrates with transaction refresh in ERESTART case, but
then realized this is iptables code and nft doesn't retry in that case?!

Cheers, Phil
