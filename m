Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584931EFFA8;
	Tue, 18 Mar 2025 22:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742337244; cv=none; b=G2QPgNay7ufivjF1NmTSTAgoMXWRrMrPD7Z8xrBtT5gFnTBrl66SWVhH7Eq+fpFdeQ+SVcahdUabHL1bfpW4wzDBeuBYuMfmgL0RVxl5DZQJf4LPkNdl41dzXu20w54AO81dlF7tiRg5wizIMBy8wGAw7XNzm4Yibc6KRiZrAIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742337244; c=relaxed/simple;
	bh=1olzgF2iXunO8XWm2rJrE5cDHxmpjh9voIqEqYTKp8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oMBVbPlX5f70tTQjWTmG7YCM8diMceqCLWr4u5fnNIvbOrMv/oXKojh2CGODEtaQgelojOD1qQOeZADGA6qSm5TrScK2hy8El7fpCow9VGb6kRot6UX93GquNu+H8RKfsQ+GJREugzyQUZIaN6ap3VxRbyz/VYn3rpeJG0nJd8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QU7OdvnO; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XApgvuGn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QU7OdvnO";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XApgvuGn"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C835F605A7; Tue, 18 Mar 2025 23:33:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742337239;
	bh=eW+ffQWCXuRgCSjw8N8pUZJFjNamrbXWHtYt9wjRti8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QU7OdvnOJTxCemhOT2xGnjAYyK8LNaGPFKuQG9Kyn7cLNVWPX25rQTW27TuGjKkar
	 1khAb+WlSVZ/raNepTCosKjcUnE4eaHJqfWtrXEO7B56FJUm0+zJd7TXzc3Bpqi+/s
	 uqUFUCi4a7b6/hJxsTLI0GPBMtu4yIfWRP3L49YyTj5jGwxBam+qLjB9vboQG0gCNg
	 JbKDDjUjZjrAcv0vjmCIwd9JPk7XHqnHl/hcRkCXrhpWWLWJpDhppySpKX1FFTQPcK
	 tt/vyqXoEXnNjs8J8jNrUtCB25bCo0h2ASgNY6jHapelP4ebB95gbWXMY6PkHFnim2
	 Xh45JTuNeDenQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6C9C960581;
	Tue, 18 Mar 2025 23:33:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742337236;
	bh=eW+ffQWCXuRgCSjw8N8pUZJFjNamrbXWHtYt9wjRti8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XApgvuGnE0mBwwZRmZzs5sTqXDEI4qOj/sH4PsnuQjBoZs5TGERlYjKGXuOc5gXuV
	 OrBSy1f7neTKIfgoKQjvlBunV3PfYSMMjINss1weIbOmNzObteI+h5pCD5hU17vA9N
	 6eiH64Ufae67M7m4PD/NMnwSJD4cJDfUx5G748HFlwCzEfJ9soAbn7X5iDg0ygFcgp
	 E8kukFJqcmnf+PtKu2E300jm8weW5EaJOcVsYi9nayZq24C5Fon83JyNotmgss52BC
	 rw5rDCYbq66NoX8x8np+QzI0Gt/Xk/wpedhzYmN5gx0zyklLGR48+T7rdF1/ppg+fd
	 lFV2jIrTFBxYA==
Date: Tue, 18 Mar 2025 23:33:53 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>,
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
Message-ID: <Z9n00dy18IJHXdkK@calendula>
References: <20250318161516.3791383-1-maxim@isovalent.com>
 <20250318201323.GB840@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250318201323.GB840@breakpoint.cc>

On Tue, Mar 18, 2025 at 09:13:23PM +0100, Florian Westphal wrote:
> Maxim Mikityanskiy <maxtram95@gmail.com> wrote:
> > nf_sk_lookup_slow_v4 does the conntrack lookup for IPv4 packets to
> > restore the original 5-tuple in case of SNAT, to be able to find the
> > right socket (if any). Then socket_match() can correctly check whether
> > the socket was transparent.
> > 
> > However, the IPv6 counterpart (nf_sk_lookup_slow_v6) lacks this
> > conntrack lookup, making xt_socket fail to match on the socket when the
> > packet was SNATed. Add the same logic to nf_sk_lookup_slow_v6.
> > 
> > IPv6 SNAT is used in Kubernetes clusters for pod-to-world packets, as
> > pods' addresses are in the fd00::/8 ULA subnet and need to be replaced
> > with the node's external address. Cilium leverages Envoy to enforce L7
> > policies, and Envoy uses transparent sockets. Cilium inserts an iptables
> > prerouting rule that matches on `-m socket --transparent` and redirects
> > the packets to localhost, but it fails to match SNATed IPv6 packets due
> > to that missing conntrack lookup.
> > 
> > Closes: https://github.com/cilium/cilium/issues/37932
> > Fixes: b64c9256a9b7 ("tproxy: added IPv6 support to the socket match")
> 
> Note that this commit predates IPv6 NAT support in netfilter.

Right. I am inclined to put this into nf-next.

> No need to send a v2, just saying.
> 
> Reviewed-by: Florian Westphal <fw@strlen.de>

Thanks.
