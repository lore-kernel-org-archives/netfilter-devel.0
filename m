Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F04119AD8C;
	Thu, 12 Jun 2025 21:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749765311; cv=none; b=gQYxblU8SNopHpz/zrsmdqLGXssQB2ppUdq2nx9ZzVCa7nq7JrIGa8YKmu99+zorNF8bLQTDOMcgbbaMXMl7E4CVwSDg1x0JrTySa71wkv8F/EsuQqg8uAcdeylsy8PnToCG/no7cDAQlLxE1BnmQlN0Swoib55Sg2vj8eei0Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749765311; c=relaxed/simple;
	bh=v0DXISM21CFJLwfDh6OfwaljM02dwnc9XkWcJR3V2+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EcKIQGHYvXKpu7/B7JGOonF+vz8p6woOuGwm+xducJzR9a8YK6Yen6K3fMh5RVmjgLKqrUspZOcGOAADMyCclObdjUedhSIFEUSB/NoDYeLy/KZjrdyiv3o1vSZ6HWhrsGyWut5M5XxQITVlqpr/XilfToP2ktvhJA7FHV3yn3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=lIDZPkAH; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="lIDZPkAH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=R2bboSf8u7dl0NbIg0T+ctZOIch+m0PyW+cFV/FzJ04=; b=lIDZPkAHbl8Q6UNr4W/Z8uIua0
	p9zdTabagfx03BsGquH1Qcw97ln/gHDy7IvlnHa9VCyNwHx/Vryx+jrXDq3tjRmPCZuzCmAt9KRxR
	E4yhKXaCXeAZO38sGIlYpm7b3bASycu5nvw2XeeFvNi6HpahF6vmQ0TegX7ML4XlliMNFJveCLqyy
	pxhKfAxpZrnU78vabLjhuvSppj/4NUTvDmjVrXtYMNvoSusKQopSGfe4mpfFG3H/OTJ06lamP/ILA
	zDKw0xGRcHJ4zOZ3sWccGVwTUX+IWl/SoDbpvqYyPSQdiy+mONajLpZHHZnJNbWjquED7TyeiBQ/I
	DRbrcS8A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPpt4-000000001yc-3T6l;
	Thu, 12 Jun 2025 23:55:06 +0200
Date: Thu, 12 Jun 2025 23:55:06 +0200
From: Phil Sutter <phil@nwl.cc>
To: Klaus Frank <vger.kernel.org@frank.fyi>
Cc: Antonio Ojea <antonio.ojea.garcia@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Lukas Wunner <lukas@wunner.de>,
	netfilter@vger.kernel.org,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	netdev@vger.kernel.org
Subject: Re: Status of native NAT64/NAT46 in Netfilter?
Message-ID: <aEtMuuN9c6RkWQFo@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Klaus Frank <vger.kernel.org@frank.fyi>,
	Antonio Ojea <antonio.ojea.garcia@gmail.com>,
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
 <aEsuPMEkWHnJvLU9@orbyte.nwl.cc>
 <cqrontvwxblejbnnfwmvpodsymjez6h34wtqpze7t6zzbejmtk@vgjlloqq2rgc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cqrontvwxblejbnnfwmvpodsymjez6h34wtqpze7t6zzbejmtk@vgjlloqq2rgc>

On Thu, Jun 12, 2025 at 08:13:02PM +0000, Klaus Frank wrote:
> On Thu, Jun 12, 2025 at 09:45:00PM +0200, Phil Sutter wrote:
> > On Thu, Jun 12, 2025 at 08:19:53PM +0200, Antonio Ojea wrote:
> > > On Thu, 12 Jun 2025 at 15:56, Phil Sutter <phil@nwl.cc> wrote:
> > > >
> > > > Hi,
> > > >
> > > > On Thu, Jun 12, 2025 at 03:34:08PM +0200, Antonio Ojea wrote:
> > > > > On Thu, 12 Jun 2025 at 11:57, Phil Sutter <phil@nwl.cc> wrote:
> > > > > > On Sun, Jun 08, 2025 at 08:37:10PM +0000, Klaus Frank wrote:
> > > > > > > I've been looking through the mailling list archives and couldn't find a clear anser.
> > > > > > > So I wanted to ask here what the status of native NAT64/NAT46 support in netfilter is?
> > > 
> > > > > we ended doing some "smart hack" , well, really a combination of them
> > > > > to provide a nat64 alternative for kubernetes
> > > > > https://github.com/kubernetes-sigs/nat64:
> > > > > - a virtual dummy interface to "attract" the nat64 traffic with the
> > > > > well known prefix
> > > > > - ebpf tc filters to do the family conversion using static nat for
> > > > > simplicity on the dummy interface
> > > > > - and reusing nftables masquerading to avoid to reimplement conntrack
> > > >
> > > > Oh, interesting! Would you benefit from a native implementation in
> > > > nftables?
> > > 
> > > Indeed we'll benefit a lot, see what we have to do :)
> > > 
> > > > > you can play with it using namespaces (without kubernetes), see
> > > > > https://github.com/kubernetes-sigs/nat64/blob/main/tests/integration/e2e.bats
> > > > > for kind of selftest environment
> > > >
> > > > Refusing to look at the code: You didn't take care of the typical NAT
> > > > helper users like FTP or SIP, did you?
> > > 
> > > The current approach does static NAT64 first, switching the IPv6 ips
> > > to IPv4 and adapting the IPv4 packet, the "real nat" is done by
> > > nftables on the ipv4 family after that, so ... it may work?
> > 
> > That was my approach as well: The incoming IPv6 packet was translated to
> > IPv4 with an rfc1918 source address linked to the IPv6 source, then
> > MASQUERADE would translate to the external IP.
> > 
> > In reverse direction, iptables would use the right IPv6 destination
> > address from given rfc1918 destination address.
> > 
> > The above is a hack which limits the number of IPv6 clients to the size
> > of that IPv4 transfer net. Fixing it properly would probably require
> > conntrack integration, not sure if going that route is feasible (note
> > that I have no clue about conntrack internals).
> 
> Well technically all that needs to be done is NAT66 instead of NAT44
> within that hack and that limitation vanishes.

I don't comprehend: I have to use an IPv4 transfer net because I need to
set a source address in the generated IPv4 header. The destination IPv4
address is extracted from the IPv6 destination address. Simple example:

IPv6-only internal:     fec0::/64
v6mapped:               cafe::/96
external IPv4:          1.2.3.4
internal transfer IPv4: 10.64.64.0/24

Client sends:       IPv6(fec0::1, cafe::8.8.8.8)
nat64 in fwd:       IPv4(10.64.64.1, 8.8.8.8)
nat in postrouting: IPv4(1.2.3.4, 8.8.8.8)

Google replies:     IPv4(8.8.8.8, 1.2.3.4)
nat in prerouting:  IPv4(8.8.8.8, 10.64.64.1)
nat64 in fwd:       IPv6(cafe::8.8.8.8, fec0::1)

> > The actual issue though with protocols like FTP is that they embed IP
> > addresses in their headers. Therefore it is not sufficient to swap the
> > l3 header and recalculate the TCP checksum, you end up manipulating l7
> > headers to keep things going. At least there's prior work in conntrack
> > helpers, not sure if that code could be reused or not.
> 
> If nat64 functionality was added within conntrac itself then it would be
> easy to reuse the l7 helpers. If it was anywhere else the l7 helpers
> within conntrack would have to be re-implemented as conntrack wouldn't
> know the mappings and therefor it probably would be quite hard to do the
> rewrites.
> Also in regards to FTP not just L7 headers but also payload needs to be
> edited on the fly. As it often uses differnt commands for IPv4 and IPv6
> (even though the IPv6 ones also support IPv4) and it embeds the IPs as
> strings.
> 
> EPRT<space><d><net-prt><d><net-addr><d><tcp-port><d>
> 
> where "net-prt" is either 1 for IPv4 or 2 for IPv6. and net-addr is the
> string representation.
> However a client may send the "PORT" command instead...
> Also RFC2428 may be helpful in this context.
> 
> I think if it was possible to get the nat64 into conntrack it should
> also be possible to take care of this more easily as with external
> "hacks".

I agree it would probably be the cleanest solution.

> Also in regards to the above code it looks like currently only tcp and
> udp are supported. All other traffic appears to just dropped at the
> moment instead of just passed through. Is there a particular reason for
> this?

I guess tcp and udp are simply sufficient in k8s.

Cheers, Phil
