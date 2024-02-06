Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6810C1C69D
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Feb 2024 23:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707261330; cv=none; b=MuxCZz3AkR2JeWtHr3UEXFCXjdQQcDf1s2n9c8MgNFMknrkX3NOPJnNzmfHeJFlLIrdDlX4xrSPbqkx/gdGyLwVMPew/+Diz9wq8mZSZOzFSI6a3V47n00q+/2vvbsOImgnuoyIzsdMpPo4wBo/tMDsVfbBg0ZiR0wz09Ra+QzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707261330; c=relaxed/simple;
	bh=YUbFixOwtsrykK0ArOhXQVh1GXWK5312birx7O/rimc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mM/CVOCWdvXSW4UQgmQLIZIzOT3UWiZinoWCJQzAOrKb/37F7t+ptD4tRQeSGEgQBVIHu/RKnTZp3+hWS1E+PWqxzy6wl0V5A2U2R/7qR3TB8bNLMDUqSWoysJOOJuyEfwqmKN40ySmzvybZ6kSvVDNI+No1/znhNK1lvXLuGg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aO4tDXpr; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aO4tDXpr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LObT9fX88OWJZDfDvyc7uEwTqufg7NGIfFiDr3OzTqo=; b=aO4tDXpriXddr4/56hQe7WSsXD
	GE1OWycsZcbKUwyW9nUjdMkvXWCxK0WSr1nH/hEJbXmcWj02VK8XS5S9Gs4BYvY1/4vOYIh3aDpEA
	PQqTgW+1m+l8rjsTMnHNdylP2hVPrzZ1QGi41enRCRE1REImZwoV4vpaYifYLrygLudK60LlKD445
	2j9/fckD90fXunRBaKmIvyrnwz2YT3aDXZz/J+vpJ/nF+E9CJYnU7UvtiZNNAF3aKhANhWxdM0Mg/
	uIwV+oW4qAwo62iLSff12VTQFcqrb4sRRSYGDgyx7RO971mYBd8F869Tng4n1gGRwExQVwVDQIP7d
	WEIZ6IPQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rXUey-00000000485-1V13;
	Wed, 07 Feb 2024 00:15:24 +0100
Date: Wed, 7 Feb 2024 00:15:24 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH 00/12] Range value related fixes/improvements
Message-ID: <ZcK9jDqrGRO8piyc@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20240202135307.25331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240202135307.25331-1-phil@nwl.cc>

On Fri, Feb 02, 2024 at 02:52:55PM +0100, Phil Sutter wrote:
> Discussion of commit ee87ad419e9a0 ("extensions: libebt_stp: fix range
> checking") motivated me to check parser behaviour with ranges, including
> some corner cases:
> 
> * Negative ranges (e.g. 4:3) are supposed to be rejected
> * Ranges may be (half) open, e.g. ":10", "5:" or just ":"
> * Ranges may be single element size (e.g. "4:4")
> * Full ranges are NOPs aside from the constraints implied by invoking
>   the match itself
> * Inverted full ranges never match and therefore must at least remain in
>   place (code sometimes treated them like non-inverted ones)
> 
> First patch in this series bulk-adds test cases to record the status
> quo, following patches fix behaviour either by implementing checks into
> libxtables (in patches 2, 3 and 12) or fixing up extensions. Patch 10 is
> an exception, it fixes for inverted full ranges when generating native
> payload matches for tcp/udp extensions.
> 
> Phil Sutter (12):
>   extensions: *.t/*.txlate: Test range corner-cases
>   libxtables: xtoptions: Assert ranges are monotonic increasing
>   libxtables: Reject negative port ranges
>   extensions: ah: Save/xlate inverted full ranges
>   extensions: frag: Save/xlate inverted full ranges
>   extensions: mh: Save/xlate inverted full ranges
>   extensions: rt: Save/xlate inverted full ranges
>   extensions: esp: Save/xlate inverted full ranges
>   extensions: ipcomp: Save inverted full ranges
>   nft: Do not omit full ranges if inverted
>   extensions: tcp/udp: Save/xlate inverted full ranges
>   libxtables: xtoptions: Respect min/max values when completing ranges

Series applied.
