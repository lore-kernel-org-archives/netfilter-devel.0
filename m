Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9B249A3D6;
	Mon, 12 Oct 2026 16:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791821632; cv=none; b=jhPUJFnGYmzmjqOxC15/OL9uS4KZqBSS28yz0gN4TOwKQUgy6LHle2sHR4sDLULI28oWSSOv6a+fLQGV5GHR0S787jyXG8OiOSBtY5eiUtm2Znt21bQb7nF97A5GKVN9VEDbVYihgYdqWSWyt7s0jmxWfniIVJhmAlbIM48NdU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791821632; c=relaxed/simple;
	bh=UpTCKSzAb1uzcZnKeQMJ3Ny8uiDLbdNLjHKmwZ6y+U8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sMXq18HilGyP+snXZ3vml96X6yPfE4k1wtJWbAYwDNt0Vsnjkfg6xaG3mCPwDsC8o27TFpox9qxSfNStIvs1aj+O9N/JKVOaSzizyVkQykAkKA53m/GuZmTs9zqML62zK4jQMH8xkrv6C1qa6+XHYf2RmRoM1h7HvPUYCiaGc7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A8C9F60293; Mon, 12 Oct 2026 18:13:41 +0200 (CEST)
Date: Mon, 12 Oct 2026 18:13:38 +0200
From: Florian Westphal <fw@strlen.de>
To: Hari Chandrakanthan <hari.chandrakanthan@oss.qualcomm.com>
Cc: pablo@netfilter.org, phil@nwl.cc, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next] netfilter: nf_conntrack: add ct expression
 support for netdev egress chains
Message-ID: <as0HMjsgUvKd7dAo@strlen.de>
References: <20261006085844.2694120-1-hari.chandrakanthan@oss.qualcomm.com>
 <asTd69Buuk6PisMl@strlen.de>
 <fe6fe48c-df09-41be-acff-bbae33454bd9@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe6fe48c-df09-41be-acff-bbae33454bd9@oss.qualcomm.com>

Hari Chandrakanthan <hari.chandrakanthan@oss.qualcomm.com> wrote:
> I agree that enabling inet/bridge conntrack solely for netdev/egress 
> would be unnecessary overhead.

Not following.  What is 'netdev egress only'?
Where are the skbs coming from, i.e. though what pipeline?

Bridge?
Routing?

> To address this, as suggested by Pablo, we are considering enabling 
> conntrack lookup/creation at
> netdev/ingress. This would allow netdev chains to access conntrack state 
> without requiring conntrack
> to be enabled for the inet or bridge families, avoiding unnecessary 
> overhead for netdev-only use cases.

FWIW bridge conntrack is already problematic (see recent RFC patch
to refag in INPUT, conntrack is pretty much routing-only.

> Kindly share your thoughts on this approach.

I think you'd have to explain your use case.

I thought you only want

skb-> mark = ct->mark

from egress. That would imply something else already enabled conntrack
anyway, else you'd have no conntrack marks set that you could read.
