Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B382620FAAB;
	Wed,  5 Feb 2025 23:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738797635; cv=none; b=H3rMAjkRIfqpPomXuo4eT6Odalfh8A0NUGX1typTEM6dCelkHCUstDnEXHChtk8CbWG7ALWHRTqTMNcaNrD6Do1YG5uDtKAx78iiGuzClfO3ENuzSDz7iKocKbmIIiCDqjExXJ190Yv935o6yq0SdkDNNU+SoCfF/ixyQc3lW60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738797635; c=relaxed/simple;
	bh=BUFcGGRSqmwYfrikidL9Zc0eHOmPWJoEksPbnFGP154=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fThf2GjsFtskBviCrF/NwQr2GKi0IgMl114fEvyksYVwgOqz3L28LMwktMVDGBZGv0p6Pw2Y8lU0HIqL7ryHfz+qYqdpRflf0O+txoxoo9lwTnAzX3KANL700anjJcntsjMEvHeRA/RFN3CVK5vdq2LRwPzdxl46ASO1WsLMCwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cnpAuzZo; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cnpAuzZo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cnpAuzZo";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cnpAuzZo"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E32E96035D; Thu,  6 Feb 2025 00:20:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738797623;
	bh=gV9Rtnv4tFpOv868mMJ1Ge/6sJai5+qF7cjBnltrVSw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cnpAuzZoS8sTa42TWZEENtKSFjUC/kDniQQ0ALEQQvMeUtEQQDRdoA4GXEb3OCskD
	 wLPumOrClYD6GLLml5BPkIAbEqyznCr33+crjmDNEX1SDZ2APmjSn2dGWfRmUJn4qJ
	 vY1kkPyo/B2nzF4FWZk6IaN1KZBC7wFkiGW+ks1IrDGtSGQG3bomGzDaIxBxVv5NPt
	 kJZJsvTtwBGi3dr2Y/0bev1ZtOZ1BJ1DRI4kU2Ht4U96KQqWBv8Siwrj0/lzPYd+hC
	 qR7tT0uEYJulOIXvdPWekdTdQIC4rLz+9CqpC6mxspGMUpgTCnXbjeswRRPblTuPJ2
	 9t8lLXHc5Lkxg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EBA0F602EE;
	Thu,  6 Feb 2025 00:20:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738797623;
	bh=gV9Rtnv4tFpOv868mMJ1Ge/6sJai5+qF7cjBnltrVSw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cnpAuzZoS8sTa42TWZEENtKSFjUC/kDniQQ0ALEQQvMeUtEQQDRdoA4GXEb3OCskD
	 wLPumOrClYD6GLLml5BPkIAbEqyznCr33+crjmDNEX1SDZ2APmjSn2dGWfRmUJn4qJ
	 vY1kkPyo/B2nzF4FWZk6IaN1KZBC7wFkiGW+ks1IrDGtSGQG3bomGzDaIxBxVv5NPt
	 kJZJsvTtwBGi3dr2Y/0bev1ZtOZ1BJ1DRI4kU2Ht4U96KQqWBv8Siwrj0/lzPYd+hC
	 qR7tT0uEYJulOIXvdPWekdTdQIC4rLz+9CqpC6mxspGMUpgTCnXbjeswRRPblTuPJ2
	 9t8lLXHc5Lkxg==
Date: Thu, 6 Feb 2025 00:20:19 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [TEST] nft-flowtable-sh flaking after pulling first chunk of the
 merge window
Message-ID: <Z6PyM5OBTRzgWRDT@calendula>
References: <20250123080444.4d92030c@kernel.org>
 <Z5oPNA0IFd7-zBts@calendula>
 <20250129170057.77738677@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250129170057.77738677@kernel.org>

Hi Jakub,

On Wed, Jan 29, 2025 at 05:00:57PM -0800, Jakub Kicinski wrote:
> On Wed, 29 Jan 2025 12:21:24 +0100 Pablo Neira Ayuso wrote:
> > > Could be very bad luck but after we fast forwarded net-next yesterday
> > > we have 3 failures in less than 24h in nft_flowtabl.sh:
> > > 
> > > https://netdev.bots.linux.dev/contest.html?test=nft-flowtable-sh
> > > 
> > > # FAIL: flow offload for ns1/ns2 with masquerade and pmtu discovery : original counter  2113852 exceeds expected value 2097152, reply counter  60
> > > https://netdev-3.bots.linux.dev/vmksft-nf/results/960740/11-nft-flowtable-sh/stdout
> > > 
> > > # FAIL: flow offload for ns1/ns2 with masquerade and pmtu discovery : original counter  3530493 exceeds expected value 3478585, reply counter  60
> > > https://netdev-3.bots.linux.dev/vmksft-nf/results/960022/10-nft-flowtable-sh/stdout  
> > 
> > this is reporting a flow in forward chain going over the size of the
> > file, this is a flow that is not follow flowtable path.
> > 
> > > # FAIL: dscp counters do not match, expected dscp3 and dscp0 > 0 but got  1431 , 0 
> > > https://netdev-3.bots.linux.dev/vmksft-nf/results/960740/11-nft-flowtable-sh-retry/stdout  
> > 
> > this is reporting that occasionally a flow does not follow flowtable
> > path, dscp3 gets bumped from the forward chain.
> > 
> > I can rarely see this last dscp tests FAIL when running this test in a
> > loop here.
> > 
> > Just a follow up, I am still diagnosing.
> 
> Thanks for the update!
> 
> FWIW we hit 4 more flakes since I reported it to you last week
> (first link from previous message will take you to them).
> All four in dscp_fwd

Just another follow up on this. I am testing here a revert of:

  b8baac3b9c5c ("netfilter: flowtable: teardown flow if cached mtu is stale")

nft_flowtable.sh shows too frequent re-offloads (create/teardown
cycles) with fragments that can lead no packets following the
flowtable path as dscp_fwd reports.

Let me give it more testing then, if results are positive, I will
formally propose this revert.

Thanks.
