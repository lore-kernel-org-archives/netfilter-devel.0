Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36611DE3AA;
	Wed,  9 Apr 2025 09:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744190317; cv=none; b=XeqEcgfUd7TmDXnCeSOEKOl1sOudVADq4PBAcTyKMJ/+NwebjZhLLob5MiB98qfwBkJPX9KN6UQ0qShMN/NPFedmYFSJG6tbMNrvZ2yaWH29S+kVz6bpiz+WND4v/yOVCvx/qlrOsLRiylJFpLxU3LUxiJ1iVQ8ytCj6b+3vhDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744190317; c=relaxed/simple;
	bh=SvN3Gcf50djMUpmY0B1/0uK5pLnCZSO+X3P+SrDIIZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UXs28hxFtEpV5IoLWvP1OlH7PVxRxgxEY0BAlSsQRkyxASSQvrmHNdzvVYwH4Vsn4wgBLhCF2vEMSdpGVLgz3hMBnurR9Fdm5FQTjK2Ii5Sr7hjHaEgZw/eEmeBhFQrPGCaZPSXfky8mW3jxvb6jom9G75FlK6A/8HjAzSDVG4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u2RZd-0004ns-Qe; Wed, 09 Apr 2025 11:18:21 +0200
Date: Wed, 9 Apr 2025 11:18:21 +0200
From: Florian Westphal <fw@strlen.de>
To: Huajian Yang <huajianyang@asrmicro.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, razor@blackwall.org,
	idosch@nvidia.com, davem@davemloft.net, dsahern@kernel.org,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Expand headroom to send fragmented packets in
 bridge fragment forward
Message-ID: <20250409091821.GA17911@breakpoint.cc>
References: <20250409073336.31996-1-huajianyang@asrmicro.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409073336.31996-1-huajianyang@asrmicro.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Huajian Yang <huajianyang@asrmicro.com> wrote:
> The config NF_CONNTRACK_BRIDGE will change the way fragments are processed.
> Bridge does not know that it is a fragmented packet and forwards it
> directly, after NF_CONNTRACK_BRIDGE is enabled, function nf_br_ip_fragment
> will check and fraglist this packet.
> 
> Some network devices that would not able to ping large packet under bridge,
> but large packet ping is successful if not enable NF_CONNTRACK_BRIDGE.

Can you add a new test to tools/testing/selftests/net/netfilter/ that
demonstrates this problem?

> In function nf_br_ip_fragment, checking the headroom before sending is
> undoubted, but it is unreasonable to directly drop skb with insufficient
> headroom.

Are we talking about
if (first_len - hlen > mtu
  or
skb_headroom(skb) < ll_rs)

?

>  
>  		if (first_len - hlen > mtu ||
>  		    skb_headroom(skb) < ll_rs)
> -			goto blackhole;
> +			goto expand_headroom;

I guess this should be

if (first_len - hlen > mtu)
	goto blackhole;
if (skb_headroom(skb) < ll_rs)
	goto expand_headroom;

... but I'm not sure what the actual problem is.

> +expand_headroom:
> +	struct sk_buff *expand_skb;
> +
> +	expand_skb = skb_copy_expand(skb, ll_rs, skb_tailroom(skb), GFP_ATOMIC);
> +	if (unlikely(!expand_skb))
> +		goto blackhole;

Why does this need to make a full skb copy?
Should that be using skb_expand_head()?

>  slow_path:

Actually, can't you just (re)use the slowpath for the skb_headroom < ll_rs
case instead of adding headroom expansion?
