Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6162447811;
	Tue,  4 Aug 2026 10:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785838874; cv=none; b=ajzDF7eOnbxLvIt0s6nmNIBH934x/dPsE9dVarCxHDNvhOijDZ1kPTilPTy4wmkpJ95WGiTUT2wkkl82JbKJRRrHhIiS+5nEVf9IJ7VSeH0+Nfg+umo+k15HGpEHOaUnL5vN+LBQ8sxJOzRTsFARx53YbB0YIrejZxS7YQvMJHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785838874; c=relaxed/simple;
	bh=lPva83HVz2NbONGwMFVtBI3RPeXCK18J1LtgRRm9hUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C8w8fpRUpJE1dgUjvUxFeHh7xKwd8s1SPJNNL5pb5pQNRwYvK079/R4e3oYc4EAqhG7gDSn3lcZ8gaF1hJ2YN2j1I87w9FSLQTPm5B/fvGS95ENqhE2vv7huy5abLo4ef0MLvEon2yMgYV+sjVDkbshNx1dRFobsLfS+LW8ManU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 08979602B9; Tue, 04 Aug 2026 12:21:04 +0200 (CEST)
Date: Tue, 4 Aug 2026 12:21:03 +0200
From: Florian Westphal <fw@strlen.de>
To: David Lee <david.lee@trailofbits.com>
Cc: pablo@netfilter.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, Kyle Zeng <kylebot@openai.com>,
	Dominik 'Disconnect3d' Czarnota <dominik.czarnota@trailofbits.com>,
	phil@nwl.cc, horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_reject_ipv4: initialize IPCB at inet
 ingress
Message-ID: <anG9D4P33SG9uubK@strlen.de>
References: <20260804095105.715387-1-david.lee@trailofbits.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804095105.715387-1-david.lee@trailofbits.com>

David Lee <david.lee@trailofbits.com> wrote:
> From: Kyle Zeng <kylebot@openai.com>
> 
> The inet ingress hook runs before ip_rcv_core(), so IPCB has not been
> initialized when nft_reject_inet passes an IPv4 packet to
> nf_send_unreach(). skb->cb can therefore retain data from an earlier
> protocol layer.
> 
> icmp_send() treats IPCB(skb)->opt as parsed IPv4 options. Stale option
> offsets can make __ip_options_echo() copy an attacker-controlled length
> into its 40-byte reply option buffer and overflow the stack.
> 
> Clear IPCB for NF_INET_INGRESS and restore its input interface, matching
> the initialization normally performed by ip_rcv_core().

Will you also send a patch for net/ipv6/netfilter/nf_reject_ipv6.c ?

Or: send a v2 that also fixes this up,
Or: send a v2 that mentions why net/ipv6/netfilter/nf_reject_ipv6.c is
fine (I doubt it).
