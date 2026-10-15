Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E6A4BAA17;
	Thu, 15 Oct 2026 18:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792090279; cv=none; b=KUYwETGKSEMo+5csVJXZAO0fKdoMTWVYEydjLiwdKxRb0GV911AGXWDos0WLEOjiw1BQb6EiJzDh3cg3vLIYWH1H03k3+kpt0GvCuoWLWzUOKh8gKOAll9PWUKRN/0sC39zXis4RTjhvlXE7Xu4s8zz+4yc0N+6owRbxRsgcQjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792090279; c=relaxed/simple;
	bh=PdtEyOd+J/2fiZkaceo5cAeUkPy9uCTBZFkQzoFfpGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U5UsRAU4PnchvKk9hLXxkS3TMSEfs5mymWtCloSTaXZB9FSpKdRra3Riv/NnKx4Qw6eGit1+qMHcZRvZa3jE7fkJitf21S77f4JQcZhUac2fX1+9m1R5BBlpUaD6ybTuwnHhrxihT/pTGLFBXycCI+WjBJ2bXyIDESs2dMgJG3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ewf5R94e; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ewf5R94e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MJmX4b1u5tOTPARyB5qX60siGQ72Kn2GluhVs6oag6Q=; b=ewf5R94evg7Eyo9ZbrhlAriwdj
	izNfmTeT2CRvXyHnV5jp010NSVYHkz9GshTiBGI3ZASUnEV4rpaYhLrjF0c6m+tq1z1diuUDVSsUO
	1aSpqEVttvMZGhgkDemWFaDtwdyjK4egcDmhG56NcJOrklJ3eKyn2LPP1/a31oN3kcPKKR+TJAQTV
	KL8KQy0F6YUU6cFBduNNKS2OxXmXIrdLbGFM+/xPUFikskmY3Tn3Fr/lqWvsbYAagqrQjccnIw1VC
	uoHfyvflJSoIAljVumj8YThh/DhBh5B/DdxeMD+0aZn/cSuSuD81h1ovgCdrU/seA9iiJNbPRQXjp
	nFZFs1ZQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xHQXc-000000004CZ-3Ik4;
	Thu, 15 Oct 2026 20:51:00 +0200
Date: Thu, 15 Oct 2026 20:51:00 +0200
From: Phil Sutter <phil@nwl.cc>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowangio@gmail.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, virtualization@lists.linux.dev,
	Rusty Russell <rusty@rustcorp.com.au>,
	Max Krasnyansky <maxk@qualcomm.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>, Simon Horman <horms@kernel.org>,
	David Ahern <dsahern@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev
Subject: Re: [PATCH net-next v2 6/7] net: add ip4_parse()
Message-ID: <atEglBQ0B1jR5t7q@orbyte.nwl.cc>
References: <cover.1792067836.git.mst@redhat.com>
 <2645c102b2f73292d1973b82c95def24e48064e1.1792067836.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2645c102b2f73292d1973b82c95def24e48064e1.1792067836.git.mst@redhat.com>

Hi Michael,

On Thu, Oct 15, 2026 at 08:41:45AM -0400, Michael S. Tsirkin wrote:
> Multiple places in the net stack open-code the same minimal IPv4 header
> validation: pull the fixed header, check version 4 and IHL >= 5 (where 5
> is the fixed header size in 32-bit units) - and locate the transport
> header at IHL * 4 past the network header.
> 
> Add a helper for doing that: it returns the validated header and
> the transport header offset, or NULL if truncated or malformed.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: LLM

Reviewed-by: Phil Sutter <phil@nwl.cc>

Did you consider nft_inner_parse_l2l3 in net/netfilter/nft_inner.c and
ip_mc_check_iphdr in net/ipv4/igmp.c as well?

Cheers, Phil
