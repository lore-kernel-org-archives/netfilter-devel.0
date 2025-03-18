Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779ED211A20;
	Tue, 18 Mar 2025 20:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742328824; cv=none; b=qKW6Y+bBMukdQHLgagwtSLdBkv8pEh7WifLAslv3RSoRdBlDDJXidI7eqQOUZgAEC/YTCHNEcmE1MvmzIMf05WjfMP1/2dbKPXud7PduxTEuYD2e0CGGJXw7keMorZWJ5vOldzmmJaYnYgiCTfX5stsGgsY9ValkL3+ZupNyOT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742328824; c=relaxed/simple;
	bh=0fV/fURLzzI0eOghLnL11fyUlbfyd6zVcgnelYOafkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DYrKbRa4gHTp2XttYNY3YJZPHuoWCURL+kJ+tFwx09isddmGdNsQoFHKJ2ncHzckCIArratt8S+c0+xGVtHRvwlv+4ouA1sWDvbSlb8NfgI9guPuUXz+Ag0bGAio7MKzdykwUD0Af9/iNqDTh2pNbWV2ZlqGd/4j0Qv1oteILyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tudJT-0000cB-Gq; Tue, 18 Mar 2025 21:13:23 +0100
Date: Tue, 18 Mar 2025 21:13:23 +0100
From: Florian Westphal <fw@strlen.de>
To: Maxim Mikityanskiy <maxtram95@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Patrick McHardy <kaber@trash.net>,
	KOVACS Krisztian <hidden@balabit.hu>,
	Balazs Scheidler <bazsi@balabit.hu>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, Maxim Mikityanskiy <maxim@isovalent.com>
Subject: Re: [PATCH net] netfilter: socket: Lookup orig tuple for IPv6 SNAT
Message-ID: <20250318201323.GB840@breakpoint.cc>
References: <20250318161516.3791383-1-maxim@isovalent.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318161516.3791383-1-maxim@isovalent.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Maxim Mikityanskiy <maxtram95@gmail.com> wrote:
> nf_sk_lookup_slow_v4 does the conntrack lookup for IPv4 packets to
> restore the original 5-tuple in case of SNAT, to be able to find the
> right socket (if any). Then socket_match() can correctly check whether
> the socket was transparent.
> 
> However, the IPv6 counterpart (nf_sk_lookup_slow_v6) lacks this
> conntrack lookup, making xt_socket fail to match on the socket when the
> packet was SNATed. Add the same logic to nf_sk_lookup_slow_v6.
> 
> IPv6 SNAT is used in Kubernetes clusters for pod-to-world packets, as
> pods' addresses are in the fd00::/8 ULA subnet and need to be replaced
> with the node's external address. Cilium leverages Envoy to enforce L7
> policies, and Envoy uses transparent sockets. Cilium inserts an iptables
> prerouting rule that matches on `-m socket --transparent` and redirects
> the packets to localhost, but it fails to match SNATed IPv6 packets due
> to that missing conntrack lookup.
> 
> Closes: https://github.com/cilium/cilium/issues/37932
> Fixes: b64c9256a9b7 ("tproxy: added IPv6 support to the socket match")

Note that this commit predates IPv6 NAT support in netfilter.
No need to send a v2, just saying.

Reviewed-by: Florian Westphal <fw@strlen.de>
