Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A372AEED;
	Thu, 12 Jun 2025 13:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749736587; cv=none; b=G8F0j9qhdKHNbQ1iStDF/1MvHqVrVIh6p4WmdlTe7Jv3Ik+sUNLVSKKL8oEYhDFgmiocANYXu28VHkL1iBGFHsPqwTryAtHk6DoUcP+xwv/akks8g97ToxHuorBaZZbMZzZqXRqV321D4RYSJun7M1xHEvmbx+0gY+uejj9rbZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749736587; c=relaxed/simple;
	bh=ZakZVVVODMWkRQI1SarGrMRR4T+9HnkmX9uWYkMY6Kw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iOF/WqnRwBirKESUFU0ajWaDW9meki0TDAjXC0AUyRhfAxJ/PKSV89i4zeiJUXNP/QnWXPcjVt5T9zJXeU/w3D3DnWqxcYi1tA96X2D6EFPrfviqPB2afBjJlaKdUcdKawuQFV0D1N1h81hf9s5VyTpOxQ4akZjSqrBaaVTtqJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=p1nG5TsN; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="p1nG5TsN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nfGNYS41loWokSWYVja8FxQdikyJFkobLWfrEG0QOog=; b=p1nG5TsNogHlS4OBheFLyDe+em
	inWzuUy01P7eKrmTb0boaStxfZbYqjwzwtRRagcKAvcnnxN7YC3jQOTX0w+tPyURu69EGI1mQk7Ah
	MAWy9oe8ALzM2LPxjEcwJxLRJwkg4+9fFEEUWBiUi4B86jjLHmNiYy8+oc+WOZgsUXXU/HopzfhzM
	TX3UD3RYaT1u8vkIHuLqcHo+3XmXBZ9I1k9tqLtQ3MVRjTdDR0zY4R8x/ur/dAu9/LfaxT0VPAjQo
	z/KDt0vq3GiShUpPpf7XMKMTzyrypV/QfD0oUlenNpeNCZNFMYrIW9CA/qK0lZbJE3UphwcS9JUjI
	fQPJQJxw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPiPn-000000001IM-0SWt;
	Thu, 12 Jun 2025 15:56:23 +0200
Date: Thu, 12 Jun 2025 15:56:23 +0200
From: Phil Sutter <phil@nwl.cc>
To: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Cc: Klaus Frank <vger.kernel.org@frank.fyi>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Lukas Wunner <lukas@wunner.de>,
	netfilter@vger.kernel.org,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	netdev@vger.kernel.org
Subject: Re: Status of native NAT64/NAT46 in Netfilter?
Message-ID: <aErch2cFAJK_yd6M@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Antonio Ojea <antonio.ojea.garcia@gmail.com>,
	Klaus Frank <vger.kernel.org@frank.fyi>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Lukas Wunner <lukas@wunner.de>,
	netfilter@vger.kernel.org,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	netdev@vger.kernel.org
References: <w7bwjqyae36c6pqhqjmvjcrwtpny6jxjyvxzb2qzt7atjncxd2@gi4xhlyrz27b>
 <aEqka3uX7tuFced5@orbyte.nwl.cc>
 <CABhP=tZRP42Dgw9+_vyAx80uPg4V2YFLfbGhpA10WzM46JYTNg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABhP=tZRP42Dgw9+_vyAx80uPg4V2YFLfbGhpA10WzM46JYTNg@mail.gmail.com>

Hi,

On Thu, Jun 12, 2025 at 03:34:08PM +0200, Antonio Ojea wrote:
> On Thu, 12 Jun 2025 at 11:57, Phil Sutter <phil@nwl.cc> wrote:
> > On Sun, Jun 08, 2025 at 08:37:10PM +0000, Klaus Frank wrote:
> > > I've been looking through the mailling list archives and couldn't find a clear anser.
> > > So I wanted to ask here what the status of native NAT64/NAT46 support in netfilter is?
> > >
> > > All I was able to find so far:
> > > * scanner patches related to "IPv4-Mapped IPv6" and "IPv4-compat IPv6"
> > > * multiple people asking about this without replies
> > > * "this is useful with DNS64/NAT64 networks for example" from 2023 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7b308feb4fd2d1c06919445c65c8fbf8e9fd1781
> > > * "in the future: in-kernel NAT64/NAT46 (Pablo)" from 2021 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=42df6e1d221dddc0f2acf2be37e68d553ad65f96
> > > * "This hook is also useful for NAT46/NAT64, tunneling and filtering of
> > > locally generated af_packet traffic such as dhclient." from 2020 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8537f78647c072bdb1a5dbe32e1c7e5b13ff1258
> > >
> > > It kinda looks like native NAT64/NAT46 was planned at some point in time but it just become quite silent afterwards.
> > >
> > > Was there some technical limitation/blocker or some consensus to not move forward with it?
> >
> > Not to my knowledge. I had an implementation once in iptables, but it
> > never made it past the PoC stage. Nowadays this would need to be
> > implemented in nf_tables at least.
> >
> > I'm not sure about some of the arguments you linked to above, my
> > implementation happily lived in forward hook for instance. It serves
> > well though in discovering the limitations of l3/l4 encapsulation, so
> > might turn into a can of worms. Implementing the icmp/icmpv6 translation
> > was fun, though!
> >
> > > I'm kinda looking forward to such a feature and therefore would really like to know more about the current state of things.
> >
> > AFAIK, this is currently not even planned to be implemented.
> >
> > Cheers, Phil
> >
> 
> we ended doing some "smart hack" , well, really a combination of them
> to provide a nat64 alternative for kubernetes
> https://github.com/kubernetes-sigs/nat64:
> - a virtual dummy interface to "attract" the nat64 traffic with the
> well known prefix
> - ebpf tc filters to do the family conversion using static nat for
> simplicity on the dummy interface
> - and reusing nftables masquerading to avoid to reimplement conntrack

Oh, interesting! Would you benefit from a native implementation in
nftables?

> you can play with it using namespaces (without kubernetes), see
> https://github.com/kubernetes-sigs/nat64/blob/main/tests/integration/e2e.bats
> for kind of selftest environment

Refusing to look at the code: You didn't take care of the typical NAT
helper users like FTP or SIP, did you?

I also recall some loose ends regarding MTU since the packet size
increases when translating from v4 to v6.

Anyway, funny to see there is a public DNS64 run by Google. I had used a
DNS proxy named totd (the trick-or-treat daemon), but can't even find it
in the web anymore.

> phil point about icmp is really accurate :)

That wasn't ironic! Compared to other problems, getting ICMP working was
easy. :)

Cheers, Phil
