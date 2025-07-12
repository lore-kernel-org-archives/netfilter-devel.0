Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D12218ADE;
	Sat, 12 Jul 2025 10:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752317448; cv=none; b=IKwt9P3fiYgLwJWi/Bf0g7h9QAYBJ/nYgojKNNWU4Ap1i+TqwhbSPdxbY9g6ySwpaaRaapMgkZwxkIsmSmMPv3yEj373yww7RdOVuQe1Y03VBvBinXDW+4sxKHnqteD/C7Vn9wQe6vtSg2MK7QDOKUwN6H0mr6q+6g7J36aAif0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752317448; c=relaxed/simple;
	bh=hrAKwujbigYwJ+sW8NwXDZpwkG2euTmoPVacdcvsw9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QBeMauHLVc6rd7EQ2rQMdDwVcULgw12jbjoI+FI3XRp24D7DbLULiYGBGww8k9dNuKPezNO4yfRfxcOyVvTqjCEbvR60PuSuXAGlbPQvJMHicW7viz2TuvUGyQUZFwtZRYyt1PEaZeuS8SNyVNIYS6vvi1+T+KU9U8cq4atDiHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AD198604C6; Sat, 12 Jul 2025 12:50:38 +0200 (CEST)
Date: Sat, 12 Jul 2025 12:50:23 +0200
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH v14 nf-next 3/3] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
Message-ID: <aHI970UQsS-c1vEH@strlen.de>
References: <20250708151209.2006140-1-ericwouds@gmail.com>
 <20250708151209.2006140-4-ericwouds@gmail.com>
 <aG2Vfqd779sIK1eL@strlen.de>
 <6e12178f-e5f8-4202-948b-bdc421d5a361@gmail.com>
 <aHEcYTQ2hK1GWlpG@strlen.de>
 <5db98a41-37b5-41f9-8a57-f143cc0eb39b@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5db98a41-37b5-41f9-8a57-f143cc0eb39b@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> Is using 'meta nfproto ipv4' instead an option? This looks at
> pkt->state->pf, which holds the correct value, not at skb->protcol.

pf is NFPROTO_BRIDGE.
