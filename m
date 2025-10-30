Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB67335567;
	Thu, 30 Oct 2025 23:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761866068; cv=none; b=hM+feAaDGBXXKWAluV6JQqk7MTOVQ6oBTWlrLCjj1gXsG8blHSC5sd6GOF+kAcivhakqXHfe/xwe4Fv+JZdoFUqsv/4vqfWn0hRszUYUv0Rvt+aHbAM3/awS7l1/oKQpRKZIPBMUtjyFapFUh8skE+jmSiNjdAiYcQ+GSKfm26g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761866068; c=relaxed/simple;
	bh=QcTh+OhegINb346RF9hW5buznZQ8lVHOlDIAsAyCX9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UmO6waj8ZIbK10oM6vsCb4/7j5sGgKIhEd/BYWYwfA0ZGcffhh38KW68XzdSyXXgKwLTzQ4IKsC9f89dpEvGSDpk02VETUlaz8QZWO4okODw2w3MMdHInWr7E20xdE2aibBEQrzW03+1Nji+K2RUjW2AFU/XKzvgA00rH6w2Ows=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A8F9760203; Fri, 31 Oct 2025 00:14:24 +0100 (CET)
Date: Fri, 31 Oct 2025 00:14:24 +0100
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, bridge@lists.linux.dev
Subject: Re: [PATCH v15 nf-next 3/3] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
Message-ID: <aQPxULsaFi0uIV8u@strlen.de>
References: <20250925183043.114660-1-ericwouds@gmail.com>
 <20250925183043.114660-4-ericwouds@gmail.com>
 <aN425i3sBuYiC5D5@strlen.de>
 <a4a3dce4-0f2c-4153-abbe-81e5d2715bbe@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4a3dce4-0f2c-4153-abbe-81e5d2715bbe@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> > I also vaguely remember I commented that this changes (breaks?) existing
> > behaviour for a rule like "tcp dport 22 accept" which may now match e.g.
> > a PPPoE packet.
> > 
> > Pablo, whats your take on this?  Do we need a new NFPROTO_BRIDGE
> > expression that can munge (populate) nft_pktinfo with the l4 data?
> > 
> > That would move this off to user policy (config) land.
> > 
> > (or extend nft_meta_bridge, doesn't absolutely require a brand new expression).
> > 
> Did you get any answer on this somewhere? I think that answer may affect
> this commit, so I'll wait before sending the next version for now.

Sorry for dropping the ball on this.  No, I did not.

First step is to write up a summary of the current behaviour,
then decide on a how-do-we-want-this-to-work and then on
an how-to-get-there.

I think for the second part (how-do-we-want-this-to-work)
the 'greedy' approach proposed by Antoine (ip saddr 1.2.3.4
matches regardless of l2 encap) makes sense but it will be hard
to get there.

I will try to cook up a proposal/rfc sometime next week.
