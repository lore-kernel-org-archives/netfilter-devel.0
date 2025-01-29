Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1434119DF60;
	Wed, 29 Jan 2025 11:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738149700; cv=none; b=qElDX28SKnBPrwlWqFVIh/bPTRQzxfGCUbqayoZWlUVwaT9eXARSukibNJzvvYZj+Uw+GVPeSNL3F9qW9Z7DKuWM6zZzRK1PyDLC50/rJFZeVgnzLwh5yyGcz4l4excD1d/jTf+OXtYxTp3boAgxxdUwGcCkrzgt/2TXQDRO5eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738149700; c=relaxed/simple;
	bh=Yo2JGBTqWbbzUfVP9ROVA88mkldkfbicwXk1ti04cBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rSWEFltvm0IBgMecvMkxH9LIckuQ/yVgK+tEu8+KR0Py+DD+QWvhcPvEUcCdr1gckO4Wm7OcOxX245+FRftJEMgPY+8LdDoNkjJCd/zvL0Wt1Tgy7pNAXpsxIwTFa+4Wx+AgpljGDaJvwc+jTCfy9o2LZiHwIzmOkI+/V4EdS78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ufJlJ0VM; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ufJlJ0VM; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ufJlJ0VM";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ufJlJ0VM"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A763260289; Wed, 29 Jan 2025 12:21:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738149688;
	bh=yXN7gG7HTCnYnv/kWEBn2kTauBvoczxhbEzerjXeLrY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ufJlJ0VMKP1e0GrA037hglJhKiCsWNpyh/foMvz9McMb0Zd034k0G/mZnPNPkwxGq
	 AJcCPsBW4kPp3nFqrxOB+cV/Zys+zMw2ybHFgpPaRDtY3lKripuQYLtwoCdsTbCmrf
	 OTkUXX9ocb9x12abHt98A+FqOvSwuOisXb/BhrSk69E7Cf9bjlzTXErZY8M29iL3a7
	 MWQPXY/p4FiCucdUgyeROIws0GyvnSEctfLHaXC0i63yHtT4n+Wr0xYxzh+mB3OhMb
	 fVdcEXP1PKlU1PNj3Yn9+FXPML4kJyX3vNw+C6sTa3o/X7eWVOky8KmMMqoZP9RL95
	 dIIn502i9ibRA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D4A1C6024E;
	Wed, 29 Jan 2025 12:21:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738149688;
	bh=yXN7gG7HTCnYnv/kWEBn2kTauBvoczxhbEzerjXeLrY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ufJlJ0VMKP1e0GrA037hglJhKiCsWNpyh/foMvz9McMb0Zd034k0G/mZnPNPkwxGq
	 AJcCPsBW4kPp3nFqrxOB+cV/Zys+zMw2ybHFgpPaRDtY3lKripuQYLtwoCdsTbCmrf
	 OTkUXX9ocb9x12abHt98A+FqOvSwuOisXb/BhrSk69E7Cf9bjlzTXErZY8M29iL3a7
	 MWQPXY/p4FiCucdUgyeROIws0GyvnSEctfLHaXC0i63yHtT4n+Wr0xYxzh+mB3OhMb
	 fVdcEXP1PKlU1PNj3Yn9+FXPML4kJyX3vNw+C6sTa3o/X7eWVOky8KmMMqoZP9RL95
	 dIIn502i9ibRA==
Date: Wed, 29 Jan 2025 12:21:24 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [TEST] nft-flowtable-sh flaking after pulling first chunk of the
 merge window
Message-ID: <Z5oPNA0IFd7-zBts@calendula>
References: <20250123080444.4d92030c@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250123080444.4d92030c@kernel.org>

Hi Jakub,

On Thu, Jan 23, 2025 at 08:04:44AM -0800, Jakub Kicinski wrote:
> Hi!
> 
> Could be very bad luck but after we fast forwarded net-next yesterday
> we have 3 failures in less than 24h in nft_flowtabl.sh:
> 
> https://netdev.bots.linux.dev/contest.html?test=nft-flowtable-sh
> 
> # FAIL: flow offload for ns1/ns2 with masquerade and pmtu discovery : original counter  2113852 exceeds expected value 2097152, reply counter  60
> https://netdev-3.bots.linux.dev/vmksft-nf/results/960740/11-nft-flowtable-sh/stdout
> 
> # FAIL: flow offload for ns1/ns2 with masquerade and pmtu discovery : original counter  3530493 exceeds expected value 3478585, reply counter  60
> https://netdev-3.bots.linux.dev/vmksft-nf/results/960022/10-nft-flowtable-sh/stdout

this is reporting a flow in forward chain going over the size of the
file, this is a flow that is not follow flowtable path.

> # FAIL: dscp counters do not match, expected dscp3 and dscp0 > 0 but got  1431 , 0 
> https://netdev-3.bots.linux.dev/vmksft-nf/results/960740/11-nft-flowtable-sh-retry/stdout

this is reporting that occasionally a flow does not follow flowtable
path, dscp3 gets bumped from the forward chain.

I can rarely see this last dscp tests FAIL when running this test in a
loop here.

Just a follow up, I am still diagnosing.
