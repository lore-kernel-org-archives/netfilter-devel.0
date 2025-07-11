Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58D621CC5D;
	Fri, 11 Jul 2025 14:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752243301; cv=none; b=K46CAssK8OfP3wkaObNr1CUhQytkMeuhsgkKWhdV7K++qouJHQyaVXYJYL88KrbAq2kG5ph6d/2TegbH/BhKb2NPu1yxfeeIJsbmy3F7O81yxH8RhbCQqRmSRhf15GDJowFco41a+IZaG4J42S8NA/KnP6gKrfo4zxk0ARBF7jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752243301; c=relaxed/simple;
	bh=J4zwpd/8rB1eaPcaJ7oYgBhhKfRnc+cZeXtOOWcnmJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cpcZrAUd9ByUdpvk8yG5Mji/m0bUuR8qo7v1edzckOdLCDChJcNbnaGEGqzNlDiaCMzzVX75SmnwPaolNykolXQFitxQI6iUqbSbeeu0OU8P0CU1YeZnPM6d6Y9dPLi2GJu9KdqjCdm0M2n8EEtLzUclrQbSv2WWDGDiS7ZWHeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E03F96057E; Fri, 11 Jul 2025 16:14:57 +0200 (CEST)
Date: Fri, 11 Jul 2025 16:14:57 +0200
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
Message-ID: <aHEcYTQ2hK1GWlpG@strlen.de>
References: <20250708151209.2006140-1-ericwouds@gmail.com>
 <20250708151209.2006140-4-ericwouds@gmail.com>
 <aG2Vfqd779sIK1eL@strlen.de>
 <6e12178f-e5f8-4202-948b-bdc421d5a361@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e12178f-e5f8-4202-948b-bdc421d5a361@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:

[ skb->protocl munging ]

> But in nft_do_chain_bridge() it is needed in the case of matching 'ip
> saddr', 'ip daddr', 'ip6 saddr' or 'ip6 daddr'. I suspect all ip/ip6
> matches are suffering.

Thats because of implicit dependency insertion on userspace side:
# ip saddr 1.2.3.4 counter ip daddr 3.4.5.6
bridge test-bridge input
  [ meta load protocol => reg 1 ]
  [ cmp eq reg 1 0x00000008 ]
  [ payload load 4b @ network header + 12 => reg 1 ]
  ...

So, if userspace would NOT do that it would 'just work'.

Pablo, whats your take on this?
We currently don't have a 'nhproto' field in nft_pktinfo
and there is no space to add one.

We could say that things work as expected, and that
 ip saddr 1.2.3.4

should not magically match packets in e.g. pppoe encap.
I suspect it will start to work if you force it to match in pppoe, e.g.
ether type 0x8864 ip saddr ...

so nft won't silently add the skb->protocol dependency.

Its not a technical issue but about how matching is supposed to work
in a bridge.

If its supposed to work automatically we need to either:
1. munge skb->protocol in kernel, even tough its wrong (we don't strip
   the l2 headers).
2. record the real l3 protocol somewhere and make it accessible, then
   fix the dependency generation in userspace to use the 'new way' (meta
   l3proto)?
3. change the dependency generation to something else.
   But what? 'ether type ip' won't work either for 8021ad etc.
   'ip version' can't be used for arp.

> I haven't found where yet, but It seems nft is checking skb->protocol,
> before it tries to match the ip(6) saddr/daddr.

Yes, userspace inserts this, see 'nft --debug=netlink add rule bridge ..'
