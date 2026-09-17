Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C415037C934;
	Thu, 17 Sep 2026 01:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789610102; cv=none; b=QzJUEBnGR4JwPjEUdgmQUeWLBZykyATBc0BFcKtfdiDGZUpCvIRt2w9dkbMzTmZ1nLON7PVHVwGpZUrN+8cFvr2qDQUvtu+5/6IHt4wSVR6gk93XpfDloRCLgtTNNa+zZ4BJdYUxD7FJVjlLioEBEua9GcWIzln8wEoHv6Jn+qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789610102; c=relaxed/simple;
	bh=2RJBx2RXmlO46GbKTUWo9mRYxlCy9WbMUTYFRRqKNQk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UTlj8UKYpfRoRkmUhnU1FacfaVb8U9sXXCZiz6D5tTCQDY3aCX8ursuwT37TuRBIjMIIhN0KkATQse/8qOuYU+nA081LbgGkk3EIV/xfIs5th1Fe6IbhleWt7MEgubdACD35ONifZh6pyoCl9UYJumJVKHVe5fiqLpRVSguX+s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hS77RQRK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hS77RQRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95471F000FF;
	Thu, 17 Sep 2026 01:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789610101;
	bh=AeRGnSVo/pZSPEvEnD0WVt6yfxZXDWoj6fvjGiYK9Fs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hS77RQRKPAPLL2kh/QY/7xBRrQA6JqaP6YPFbl9l8kOx6IbmmJXE8OBduRqruJJlf
	 pJPA3T3XOt8sfkYdcNVnIn/214eTYsHwcwDr4ZZtTFLuKIrrPDu5Cgp4mvSPY5S1BT
	 ZfJgzWhucsJQOXYnoEnCpIMg7mrcrGlhE5I0qXhTROR3kiH1IV3XTsjK99G8eCwfs6
	 Z+BfWu0bV4GzVl0eQQOsqE+Ldov4VLfC3aM3Y3ulReYyCbBNPrVzPtoq5hA1+pPo/l
	 vjjTdBvukQVM1X95Oady4tAIzEYGy2LEcrTV41wi4Og2BcidJZHYhmSDOFR/8Gt8JF
	 f8WcNbm2HDdOg==
Date: Wed, 16 Sep 2026 18:55:00 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, falemi@asu.edu,
 Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Xuanqiang Luo <xuanqiang.luo@linux.dev>, netfilter-devel@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: remove WARN_ON_ONCE() from the
 dev_fill_forward_path() loop check
Message-ID: <20260916185500.1cfbf67e@kernel.org>
In-Reply-To: <CA+0ovCgKDOk+Bg6Gh5Lwx94u_jJjQ30-vY1JcY2BYfhnWJJbPA@mail.gmail.com>
References: <CA+0ovCgKDOk+Bg6Gh5Lwx94u_jJjQ30-vY1JcY2BYfhnWJJbPA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 12 Sep 2026 07:40:09 +0000 Farhad Alemi wrote:
> ipip_fill_forward_path() and ip6_tnl_fill_forward_path() look up the
> route to the tunnel's remote endpoint and set ctx->dev to its device,
> which is the tunnel itself when that route resolves back to the tunnel.
> dev_fill_forward_path() then makes no progress and trips
> WARN_ON_ONCE(last_dev == ctx->dev) as soon as a flowtable tries to
> offload a flow through the tunnel. That routing loop is a configuration
> any CAP_NET_ADMIN user can set up, and ip_tunnel_xmit() and
> ip6_tnl_xmit() already treat it as a tx error, so remove the warning and
> just fail the walk, as commit 008e7a7c293b ("net: remove WARN_ON_ONCE
> when accessing forward path array") did for the path stack overflow.
> 
> Fixes: ab427db17885 ("netfilter: flowtable: Add IPIP rx sw acceleration")
> Fixes: d98103575dcd ("netfilter: flowtable: Add IP6IP6 rx sw acceleration")
> Closes: https://lore.kernel.org/all/CA+0ovCgaRvbd0Udj70b2xxG8Cx3CaCpNhnf1V4RWQuDveZYZhA@mail.gmail.com/
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Assisted-by: Claude:claude-opus-5 syzkaller
> Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>

Applied as 150dba2c69e933 in net, thanks
-- 
pw-bot: accept
