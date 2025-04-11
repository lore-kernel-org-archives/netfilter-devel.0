Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C06D221274;
	Fri, 11 Apr 2025 10:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744368898; cv=none; b=RhumUt9gQW2gZJpLvmfPs8j4hGj2edmTILguGVfmhWAhKhKIsDk1cJHctY6ZIYSaOOmBBWl6NU4Z/eXHEu4HkMLlLN7JXiQ1/fciP+yMf4Cv8O2mEXMk3FosJBx7kg8Aepir7sjYiMh5JNX5HbqSKwfef17d+KlxL2DSRD14Cio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744368898; c=relaxed/simple;
	bh=Au2ajGDP8BCik6aLQ9DNWR0Zj+BLaAGtG+jKy8DHfeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cu1lb+7A0XV3FRx1qoCfRKfGdnIn7aiZPM1ZN/tROhTHhK/CtaLUAaKU4kzbhJJi97GV2/iKAms4JAJNBMz3GM+IA84UrfX/boesv5k+6yDmve4oSywx7/XGZhxinG47k72voKoK+TIigkW2T039tU8anUdc+Pr9U4k/JiXJLo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W0WXFHYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W0WXFHYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16AEC4CEE2;
	Fri, 11 Apr 2025 10:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744368895;
	bh=Au2ajGDP8BCik6aLQ9DNWR0Zj+BLaAGtG+jKy8DHfeo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W0WXFHYEdWRyqyQgVz1FrZcdccRqLEiRY6SpF+QjpDJ/f023m5lYoi8yN721fy8Wi
	 MBEqfFjo42AOe8GB6mUunyCf+IQh/VJxSgkoQKWBub5F/yf46V3GmAdog5lqt9/9Vj
	 /SFkEWYC7sca4jmh0GrMZFy/elFqf/IoPMUXYT+7stAKR1BNPUt5EXaWLLQN5joCVu
	 VwAjCypJtAbPrfRoUUQ3RFuF0Ny2PT+hqL52uiT6fQ26wR11G84hFMOa6fo2AxdPa9
	 tHEUX45uwLbYQNaJ5KiugV3zwobduNLPIKSUSGvvsE6EVOqP83dF2JE88b153u3TAS
	 UeOa/tHcgWVDA==
Date: Fri, 11 Apr 2025 11:54:50 +0100
From: Simon Horman <horms@kernel.org>
To: Huajian Yang <huajianyang@asrmicro.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, razor@blackwall.org,
	idosch@nvidia.com, davem@davemloft.net, dsahern@kernel.org,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Expand headroom to send fragmented packets in
 bridge fragment forward
Message-ID: <20250411105450.GA395307@horms.kernel.org>
References: <20250409074444.8213-1-huajianyang@asrmicro.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409074444.8213-1-huajianyang@asrmicro.com>

On Wed, Apr 09, 2025 at 03:44:44PM +0800, Huajian Yang wrote:
> The config NF_CONNTRACK_BRIDGE will change the way fragments are processed.
> Bridge does not know that it is a fragmented packet and forwards it
> directly, after NF_CONNTRACK_BRIDGE is enabled, function nf_br_ip_fragment
> will check and fraglist this packet.
> 
> Some network devices that would not able to ping large packet under bridge,
> but large packet ping is successful if not enable NF_CONNTRACK_BRIDGE.
> 
> In function nf_br_ip_fragment, checking the headroom before sending is
> undoubted, but it is unreasonable to directly drop skb with insufficient
> headroom.
> 
> Using skb_copy_expand to expand the headroom of skb instead of dropping
> it.
> 
> Signed-off-by: Huajian Yang <huajianyang@asrmicro.com>
> ---
>  net/bridge/netfilter/nf_conntrack_bridge.c | 14 ++++++++++++--
>  net/ipv6/netfilter.c                       | 14 ++++++++++++--
>  2 files changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
> index 816bb0fde718..b8fb81a49377 100644
> --- a/net/bridge/netfilter/nf_conntrack_bridge.c
> +++ b/net/bridge/netfilter/nf_conntrack_bridge.c

...

> @@ -97,6 +97,16 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
>  
>  		return err;
>  	}
> +
> +expand_headroom:
> +	struct sk_buff *expand_skb;

Please move this declaration to the top of the function.

Flagged by W=1 builds with gcc 14.2.0 and clang 20.1.2.

> +
> +	expand_skb = skb_copy_expand(skb, ll_rs, skb_tailroom(skb), GFP_ATOMIC);
> +	if (unlikely(!expand_skb))
> +		goto blackhole;
> +	kfree_skb(skb);
> +	skb = expand_skb;
> +
>  slow_path:
>  	/* This is a linearized skbuff, the original geometry is lost for us.
>  	 * This may also be a clone skbuff, we could preserve the geometry for

...
