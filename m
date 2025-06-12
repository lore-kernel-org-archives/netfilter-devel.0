Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E312D1936;
	Thu, 12 Jun 2025 19:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749757507; cv=none; b=pnKVdvZDdsjBk6mtKvvEDYnD7wBiWntr8efv/F/w0zn4mnaRiNtt6pirr1cO/USG79shqClcQgcxIplGq7MnXOi75B4CtXHRfyd8TMcBtV26Q0XMxCpUYfTWXmXmfCcT5CL00qZLifraL0Bk6RJKMBTATY+IdkMqXusfCudBKZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749757507; c=relaxed/simple;
	bh=ZSyFaHs9qAWu5Z65auxBkBVdkKqMd/prx/jlW0lYhyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U6It3MazTy9bahnG16lfPP4Sz2jaVCTk89CLR9bd+qVHQWaGwErn2zESBtAnoQOTWrRnVcj1qJ/ss+jDXM8emmBlqyfQK5CwP0Chf/wTO4DfhMeRsDH4zOuf/cn+SOgIte7WEz41ozCNhfX3BSWRSrJ1rYlRj/CXMPgnjb/v+IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=I4sQMHxb; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="I4sQMHxb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=U3iLMIAGg43rdvlU52GFdCY8BaRXiWxZEruT4WgMndQ=; b=I4sQMHxbuRZIO9W/+k4nWZJ5/P
	s/wXQrjrgaFyFrMVGZvlJpK/8PycTZ4o5tzqJxktZuuzD5VohPlKPZQhKlUXxB/lhprwq5QYwYUnH
	s/BlyBTcI07vfY9rV3JxZWC8GdlY1HMIuvb9mRQjE1w1zL1WQrukTYpLW9UuJ7HK8xnNClnXHwlUm
	ujfBg9DZ39HzyaymCq3RCancwy7lplDKCZJn9EIVZFeCBFGFkvCeXyWyMTil/EjyRKrqSNnfD0yOj
	9GBG+puqXt0K/B+ZLidI5Rk177AWEZBmUm3AP8hsfO3hQckiEogXrzVo+l91Ro+4UMeTMdlznmRk2
	XSbHUQfw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPnrB-000000007zd-09cV;
	Thu, 12 Jun 2025 21:45:01 +0200
Date: Thu, 12 Jun 2025 21:45:00 +0200
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
Message-ID: <aEsuPMEkWHnJvLU9@orbyte.nwl.cc>
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
 <aErch2cFAJK_yd6M@orbyte.nwl.cc>
 <CABhP=tbUuJKOq6gusxyfsP4H6b4WrajR_A1=7eFXxfbLg+4Q1w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABhP=tbUuJKOq6gusxyfsP4H6b4WrajR_A1=7eFXxfbLg+4Q1w@mail.gmail.com>

On Thu, Jun 12, 2025 at 08:19:53PM +0200, Antonio Ojea wrote:
> On Thu, 12 Jun 2025 at 15:56, Phil Sutter <phil@nwl.cc> wrote:
> >
> > Hi,
> >
> > On Thu, Jun 12, 2025 at 03:34:08PM +0200, Antonio Ojea wrote:
> > > On Thu, 12 Jun 2025 at 11:57, Phil Sutter <phil@nwl.cc> wrote:
> > > > On Sun, Jun 08, 2025 at 08:37:10PM +0000, Klaus Frank wrote:
> > > > > I've been looking through the mailling list archives and couldn't find a clear anser.
> > > > > So I wanted to ask here what the status of native NAT64/NAT46 support in netfilter is?
> 
> > > we ended doing some "smart hack" , well, really a combination of them
> > > to provide a nat64 alternative for kubernetes
> > > https://github.com/kubernetes-sigs/nat64:
> > > - a virtual dummy interface to "attract" the nat64 traffic with the
> > > well known prefix
> > > - ebpf tc filters to do the family conversion using static nat for
> > > simplicity on the dummy interface
> > > - and reusing nftables masquerading to avoid to reimplement conntrack
> >
> > Oh, interesting! Would you benefit from a native implementation in
> > nftables?
> 
> Indeed we'll benefit a lot, see what we have to do :)
> 
> > > you can play with it using namespaces (without kubernetes), see
> > > https://github.com/kubernetes-sigs/nat64/blob/main/tests/integration/e2e.bats
> > > for kind of selftest environment
> >
> > Refusing to look at the code: You didn't take care of the typical NAT
> > helper users like FTP or SIP, did you?
> 
> The current approach does static NAT64 first, switching the IPv6 ips
> to IPv4 and adapting the IPv4 packet, the "real nat" is done by
> nftables on the ipv4 family after that, so ... it may work?

That was my approach as well: The incoming IPv6 packet was translated to
IPv4 with an rfc1918 source address linked to the IPv6 source, then
MASQUERADE would translate to the external IP.

In reverse direction, iptables would use the right IPv6 destination
address from given rfc1918 destination address.

The above is a hack which limits the number of IPv6 clients to the size
of that IPv4 transfer net. Fixing it properly would probably require
conntrack integration, not sure if going that route is feasible (note
that I have no clue about conntrack internals).

The actual issue though with protocols like FTP is that they embed IP
addresses in their headers. Therefore it is not sufficient to swap the
l3 header and recalculate the TCP checksum, you end up manipulating l7
headers to keep things going. At least there's prior work in conntrack
helpers, not sure if that code could be reused or not.

Cheers, Phil
