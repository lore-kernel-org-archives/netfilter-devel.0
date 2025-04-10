Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8451E1E00;
	Thu, 10 Apr 2025 10:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744280326; cv=none; b=IqSk3hkcAD6T7GdO4/3GAhOlaLg5gwKp0nG3Fw0dv9LZlWRW6kSsWKz+c0RGbaWu7QSr1auTIpbHHS5WkLb3ZOEdb2LetstkuJgs2MLk7Wt4MrRNeeR494XCWm9LfU+Mt9Xg+A1o4WYKC+Yk7cNHSxK1R1LL9FxfB6crnYtVWvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744280326; c=relaxed/simple;
	bh=nwMLMAJqqi9VxNEBcuYkup3huS4Cx7nmzuBOt+KRy0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ciYqW9S41XfZR3E/EfkzmkCFyMbXoGdg7WuBq5vJ5COZdyotO0mIJUS2tY1Gj11jblIVNnSlIkqmvMMlAaw/rang8ZMzuWLzxH9tGOOl+S3zJtd6siQgU3b0Ib3SehJUMlzpoTuW/4J3+erM8gEasFWCxPJtLdRbTyAiYMxcmec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u2ozI-0002u7-Ct; Thu, 10 Apr 2025 12:18:24 +0200
Date: Thu, 10 Apr 2025 12:18:24 +0200
From: Florian Westphal <fw@strlen.de>
To: Huajian Yang <huajianyang@asrmicro.com>
Cc: pablo@netfilter.org, fw@strlen.de, kadlec@netfilter.org,
	razor@blackwall.org, idosch@nvidia.com, davem@davemloft.net,
	dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Move specific fragmented packet to slow_path
 instead of dropping it
Message-ID: <20250410101824.GA6272@breakpoint.cc>
References: <20250410075726.8599-1-huajianyang@asrmicro.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410075726.8599-1-huajianyang@asrmicro.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Huajian Yang <huajianyang@asrmicro.com> wrote:
> --- a/net/bridge/netfilter/nf_conntrack_bridge.c
> +++ b/net/bridge/netfilter/nf_conntrack_bridge.c
> @@ -61,18 +61,14 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
>  		struct sk_buff *frag;
>  
>  		if (first_len - hlen > mtu ||
> -		    skb_headroom(skb) < ll_rs)
> -			goto blackhole;

I would prefer to keep blackhole logic for the mtu tests,
i.e.
  if (first_len - hlen > mtu)
      goto blackhole;

same for the frag->len test in the skb_walk_frags loop.
From what I understood the problem is only because of
the lower devices' headroom requirement.
