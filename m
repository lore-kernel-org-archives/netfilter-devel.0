Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9BC34BA4D;
	Fri, 26 Sep 2025 14:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758895860; cv=none; b=tfMkwFv4XCi19D2UaTj5/g/u8egavGyBwOLmFX8PMl8l6SZ2Qy1JC14H2xC4ME+T+ninAu/coervf7uhVZVFm8yTzvBjNkrxpEPgoySLSg5OHf03FbQXmq8oOAe52LMt2M0UCzO5es8QDAmyiEWi3C0FFhrOuV531n0VzBvDQu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758895860; c=relaxed/simple;
	bh=tPXxWUzqAXT/v2Bx4FpElEm4GBLSXhYT9oLPp9XysIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DFcJSyXJkZXyoJZgMjpJvXHO0isnUBl6MfotKIRrUASUE7bKZaQ/g1o8ayrIe1U5/RJkcIsteOsEwi8sgZ1BHx2JCkpOxQXXc3j59jdv1PbLwaJ6HcqGDfuUhFgWzJtNlrLWW9pp/DoiwUgSs0z/M4qR1P/Daf1Mj5WDCz6igiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+51qNCB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+51qNCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E12AC4CEF4;
	Fri, 26 Sep 2025 14:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758895860;
	bh=tPXxWUzqAXT/v2Bx4FpElEm4GBLSXhYT9oLPp9XysIY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a+51qNCBGAl/M5OpdyQ3t75NZR9wS42ZIShVl9p0hiDKvUwsb33lvMafn5PKqCAP+
	 xuJtk0BNxHKgW+0kc/rMTwCnG1IKjz3t3Os8Uffmt8UJ6MbhiIpYTBylOB40y4bCWo
	 FgCReEFziE6IDgH1m63T3AIlqfcVYrExToFp735qqRrTXIMB7m+WZjIpE/WrrV1B0s
	 hWR5WyoeTnhV2y4CGSQ/cGgSuI8b+pd15d71FhgaFYfzFc4XdS2+SYWiSKwD0ZY0Uq
	 prm17VPrZExs0aH96PsbpWlRFlHdPAsgnTMY48dOx2Wm2oPWZqYX25L8AN4FxE0Lnn
	 J/cDeZ38ws1jg==
Date: Fri, 26 Sep 2025 15:10:55 +0100
From: Simon Horman <horms@kernel.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, bridge@lists.linux.dev
Subject: Re: [PATCH v15 nf-next 2/3] netfilter: bridge: Add conntrack double
 vlan and pppoe
Message-ID: <aNae74-LXysIK9-h@horms.kernel.org>
References: <20250925183043.114660-1-ericwouds@gmail.com>
 <20250925183043.114660-3-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250925183043.114660-3-ericwouds@gmail.com>

On Thu, Sep 25, 2025 at 08:30:42PM +0200, Eric Woudstra wrote:
> This adds the capability to conntrack 802.1ad, QinQ, PPPoE and PPPoE-in-Q
> packets that are passing a bridge, only when a conntrack zone is set.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  net/bridge/netfilter/nf_conntrack_bridge.c | 97 ++++++++++++++++++----
>  1 file changed, 80 insertions(+), 17 deletions(-)
> 
> diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
> index 6482de4d8750..d3745af60f3a 100644
> --- a/net/bridge/netfilter/nf_conntrack_bridge.c
> +++ b/net/bridge/netfilter/nf_conntrack_bridge.c
> @@ -237,58 +237,121 @@ static int nf_ct_br_ipv6_check(const struct sk_buff *skb)
>  	return 0;
>  }
>  
> +/**
> + * nf_ct_bridge_pre_inner - advances network_header to the header that follows
> + * the pppoe- or vlan-header.
> + */

Hi Eric,

This is a Kernel doc. So please also document the function parameters.
And the return value using "Return: " or "Returns: ".

Likewise in patch 3/3.

Flagged by ./scripts/kernel-doc -none -Wall

Thanks!

> +
> +static int nf_ct_bridge_pre_inner(struct sk_buff *skb, __be16 *proto, u32 *len)

...
