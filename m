Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1E016C866
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Aug 2024 14:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724855723; cv=none; b=P/xceBZPPsXeHqjEVY8qHo+GlDkbuTR8ikQw3q++lqwiITinfVasxzVI6IR/TEWnyDseI4WQ/fM+N/LGmchw5wWlvtdOxdkO9eVgUSnYj7zhYmfpK2lnj3jh954tWH3UFSN7AiUObOVDiVTzxoHPZ6d9/vBTtfluiGIMlWTGvpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724855723; c=relaxed/simple;
	bh=sd3/S/4ZAZ9ktwladzvyVB2kJht+cRCaBr97ZDXwN9Q=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eNpneDcNgFcVt1OyR2LkkP2sAQhHis+hRN+HrKKplKXf3sB4/jEMbEPHkIKnXmRykKubjsBecAL5SSV7GLlEvxi6xrYbO2FCmLi5ewhwG2lK37Pbx6ePcVS3eluVmSewLtLIhhJ8CKw6l37+ygiRP+gErVNUXDoYPPILz8kjPhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=55214 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sjJlT-001b6P-63; Wed, 28 Aug 2024 16:35:17 +0200
Date: Wed, 28 Aug 2024 16:35:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Garver <eric@garver.life>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2 0/7] cache updates
Message-ID: <Zs81ovsmFztVOutq@calendula>
References: <20240826085455.163392-1-pablo@netfilter.org>
 <ZsyfUE24_cmTtLiL@egarver-mac>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZsyfUE24_cmTtLiL@egarver-mac>
X-Spam-Score: -1.9 (-)

On Mon, Aug 26, 2024 at 11:29:20AM -0400, Eric Garver wrote:
> On Mon, Aug 26, 2024 at 10:54:48AM +0200, Pablo Neira Ayuso wrote:
> > Hi,
> > 
> > The following patchset contains cache updates for nft:
> > 
> > Patch #1 resets filtering for each new command
> > 
> > Patch #2 accumulates cache flags for each command, recent patches are
> > 	 relaxing cache requirements which could uncover bugs.
> > 
> > Patch #3 updates objects to use the netlink dump filtering infrastructure
> > 	 to build the cache (
> > 
> > Patch #4 only dumps rules for the given table
> > 
> > Patch #5 updates reset commands to use the cache infrastructure
> > 
> > Patch #6 and #7 extend tests coverage for reset commands.
[...]
> I ran this against the firewalld testsuite; lgtm. It does not cover
> "reset" commands.
> 
> Tested-by: Eric Garver <eric@garver.life>

Pushed out, thanks for testing.

I have one more series cooking for cache refining, I will get on Cc.
