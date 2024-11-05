Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A3D1D63FB
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 13:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730813728; cv=none; b=G+2eIMmCDRWdp4y4zggSoer9WwLBHp8CjDu3aZ4D9k8Sxwe5vo4LPHNQAJ8lDvqlFzUWA+4Yl7ZmBd21UWZKF8qDBfcv257jzvU0F0sfp11u+QAweVJZPndrmFB6hG81Yl8LSBfQLOvmh3DGKtz5yZWYzTSr40MNQXsW6opVzz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730813728; c=relaxed/simple;
	bh=JYm+3OEoolEjK6xfRf6X3ET7qLWJR6ME/sLFhFl1zIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d5f1pDDt1P6pTaLQPAJmFSTgWnTKJusEmlEdx4GbxUzG+tsPi9q9PEAjpGr7B8oal3gI8JCc2ZRc7qNuVHdUKTaYQyHA/3fPLxDBVTZSMD0IeU3zfLn27NWGal5uC4/CWjSDctHXCwVR3aY9sIOBg+reY3qQCqtE8IkepnSQfHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=F3uzWN/x; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="F3uzWN/x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=m+9MIzzU/v2n+ITgCzmvyMvj1AVOmjFnS74N4XBF/ZQ=; b=F3uzWN/xEPQSue2vTs+vLi5J8c
	cy6UHYyMlsJtsKUQxkgM/PuBJbGzkTTW7UnoW1eDWAUlt+zcrvZso3c2bJ2VpavKFY8CRfjziT0U9
	kAmp0Hhee+lGa1Lm9k6C9knGyihAe8CDLW003vANpJVGpqUKlRWvW6nYJA5QsccYt5SsPzn+T4Zjl
	Gv7ekqjboRGU7z4MUac6J2n4ijd4KyVvd6Hvw2jz2AQdhuBKmzYQ9sbiMmVCrx6EgS060HUq/7qFp
	CBnXazwukLGTbew1GMMZ93OnBm9AfCGN+LVvLdrWlXwXbqEs4y9UHbY7YMDaAgHiqteVgtXTCye0Z
	Pl6+qXTg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8JiG-000000003Nr-3y7Q;
	Tue, 05 Nov 2024 14:35:16 +0100
Date: Tue, 5 Nov 2024 14:35:16 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, eric@garver.life
Subject: Re: [PATCH nft] json: collapse set element commands from parser
Message-ID: <ZyofFLveeueZuJPH@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, eric@garver.life
References: <20241031220411.165942-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031220411.165942-1-pablo@netfilter.org>

On Thu, Oct 31, 2024 at 11:04:11PM +0100, Pablo Neira Ayuso wrote:
> Update json parser to collapse {add,create} element commands to reduce
> memory consumption in the case of large sets defined by one element per
> command:
> 
> {"nftables": [{"add": {"element": {"family": "ip", "table": "x", "name":
> "y", "elem": [{"set": ["1.1.0.0"]}]}}},...]}

Thanks for the fix!

> Add CTX_F_COLLAPSED flag to report that command has been collapsed.

I had come up with a similar solution (but did not find time to submit
it last week). My solution to the "what to return" problem was to
introduce a 'static struct cmd cmd_nop' and return its address. Your
flag way is fine, too from my PoV.

> This patch reduces memory consumption by ~32% this case.
> 
> Fixes: 20f1c60ac8c8 ("src: collapse set element commands from parser")
> Reported-by: Eric Garver <eric@garver.life>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Side note: While profiling, I can still see lots json objects, this
> results in memory consumption that is 5 times than native
> representation. Error reporting is also lagging behind, it should be
> possible to add a json_t pointer to struct location to relate
> expressions and json objects.

I can have a look at mem use if I find spare time (TM).

We already record links between struct cmd and json_t objects for echo
mode (and only then). The problem with error reporting in my opinion is
the lack of location data in json_t. You might remember, I tried to
extend libjansson to our needs but my MR[1] is being ignored for more
than a year now. Should we just ship an extended copy in nftables?

Cheers, Phil
