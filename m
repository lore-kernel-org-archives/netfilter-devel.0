Received: from mx01.frank.fyi (mx01.frank.fyi [5.189.178.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4124B522F;
	Thu, 12 Jun 2025 22:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.189.178.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749766790; cv=none; b=l/c0Hj5D4uk36evZhppk+iIZD04roo7GXpKlOrTRgztQxSh9gggaJw2AH+nFrrszjfggzOmBSvJlX6hydFyv73HIcm1aJkhANEJeTF8TL1KudiJn3W0Ce2hyaJ4+74DnaMXla8ea0+0+VX5DY9P1hMWDVPy1M1aBttIuGhinsRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749766790; c=relaxed/simple;
	bh=UFEPYcgVTl7eCWfgckiypm0T0RMjyCjz8dzBImUdhvY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gtgdEs9HfNkC+MMSbZ6kkcHo/LwR5BPaTgyKHd5Si3klRmMiBBxz3Ou8hn7JHXeaa4YSieBglXQi/ILyTg0wCoB+5i0GSozUp+6JQE/1vkcvsSbmKYWCLAxJuEDqYMUPaLobS5gfQ7WFxlLU8UCBaIHjLZl6IzTD+sHwDwv8zik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=agowa338.de; spf=pass smtp.mailfrom=agowa338.de; dkim=pass (2048-bit key) header.d=agowa338.de header.i=@agowa338.de header.b=eZP3Wcpd; arc=none smtp.client-ip=5.189.178.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=agowa338.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=agowa338.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=agowa338.de header.i=@agowa338.de header.b="eZP3Wcpd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=agowa338.de; s=mail;
	t=1749766786; bh=UFEPYcgVTl7eCWfgckiypm0T0RMjyCjz8dzBImUdhvY=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=eZP3WcpdFwMHIcANpE9x2r9NM3FHumqM9tBDBr764SMhnpLGzvGDUd6MIlX/3B5UX
	 XpCFcJVjDCfHYedhqI0EjFHzCxkV+e6cSIxVmaUpqyUvc50D5RFMiKTKUpDVklkCAY
	 6jvNbG6saT67XdFxJ9HqmTdnzHL+2TjMrNwD8dpNWyfVizGb7MF6ktavjZzsFgNXub
	 fb/8OlgzJ64s8hcSud3vEGNFa3GHyRD6UFLTHScud3DkNhIHAsRujKA0PUJUpL1TLE
	 /sHY/9LG3R2/nXjJsu6lChYBiEcuEFFPLLh6ZwALytk/IIYnC24LLhLUj8Sx30klqt
	 Lrjualbp5yLlg==
Received: by mx01.frank.fyi (Postfix, from userid 1001)
	id 278821120185; Fri, 13 Jun 2025 00:19:46 +0200 (CEST)
Date: Thu, 12 Jun 2025 22:19:46 +0000
From: webmaster@agowa338.de
To: Phil Sutter <phil@nwl.cc>, Klaus Frank <vger.kernel.org@frank.fyi>, 
	Antonio Ojea <antonio.ojea.garcia@gmail.com>, netfilter-devel@vger.kernel.org, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Lukas Wunner <lukas@wunner.de>, 
	netfilter@vger.kernel.org, Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>, 
	netdev@vger.kernel.org
Subject: Re: Status of native NAT64/NAT46 in Netfilter?
Message-ID: <s4ffjiihvgv6glpvd3rbqr3cedprmgqijxiz2dh6v5lq4doabd@gpis5xfdyea5>
References: <w7bwjqyae36c6pqhqjmvjcrwtpny6jxjyvxzb2qzt7atjncxd2@gi4xhlyrz27b>
 <aEqka3uX7tuFced5@orbyte.nwl.cc>
 <CABhP=tZRP42Dgw9+_vyAx80uPg4V2YFLfbGhpA10WzM46JYTNg@mail.gmail.com>
 <aErch2cFAJK_yd6M@orbyte.nwl.cc>
 <CABhP=tbUuJKOq6gusxyfsP4H6b4WrajR_A1=7eFXxfbLg+4Q1w@mail.gmail.com>
 <aEsuPMEkWHnJvLU9@orbyte.nwl.cc>
 <cqrontvwxblejbnnfwmvpodsymjez6h34wtqpze7t6zzbejmtk@vgjlloqq2rgc>
 <aEtMuuN9c6RkWQFo@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEtMuuN9c6RkWQFo@orbyte.nwl.cc>

On Thu, Jun 12, 2025 at 11:55:06PM +0200, Phil Sutter wrote:
> On Thu, Jun 12, 2025 at 08:13:02PM +0000, Klaus Frank wrote:
> > On Thu, Jun 12, 2025 at 09:45:00PM +0200, Phil Sutter wrote:
> > > On Thu, Jun 12, 2025 at 08:19:53PM +0200, Antonio Ojea wrote:
> > > > On Thu, 12 Jun 2025 at 15:56, Phil Sutter <phil@nwl.cc> wrote:
> > > > >
> > > > > Hi,
> > > > >
> > > > > On Thu, Jun 12, 2025 at 03:34:08PM +0200, Antonio Ojea wrote:
> > > > > > On Thu, 12 Jun 2025 at 11:57, Phil Sutter <phil@nwl.cc> wrote:
> > > > > > > On Sun, Jun 08, 2025 at 08:37:10PM +0000, Klaus Frank wrote:
> > > > > > > > I've been looking through the mailling list archives and couldn't find a clear anser.
> > > > > > > > So I wanted to ask here what the status of native NAT64/NAT46 support in netfilter is?
> > > > 
> > > > > > we ended doing some "smart hack" , well, really a combination of them
> > > > > > to provide a nat64 alternative for kubernetes
> > > > > > https://github.com/kubernetes-sigs/nat64:
> > > > > > - a virtual dummy interface to "attract" the nat64 traffic with the
> > > > > > well known prefix
> > > > > > - ebpf tc filters to do the family conversion using static nat for
> > > > > > simplicity on the dummy interface
> > > > > > - and reusing nftables masquerading to avoid to reimplement conntrack
> > > > >
> > > > > Oh, interesting! Would you benefit from a native implementation in
> > > > > nftables?
> > > > 
> > > > Indeed we'll benefit a lot, see what we have to do :)
> > > > 
> > > > > > you can play with it using namespaces (without kubernetes), see
> > > > > > https://github.com/kubernetes-sigs/nat64/blob/main/tests/integration/e2e.bats
> > > > > > for kind of selftest environment
> > > > >
> > > > > Refusing to look at the code: You didn't take care of the typical NAT
> > > > > helper users like FTP or SIP, did you?
> > > > 
> > > > The current approach does static NAT64 first, switching the IPv6 ips
> > > > to IPv4 and adapting the IPv4 packet, the "real nat" is done by
> > > > nftables on the ipv4 family after that, so ... it may work?
> > > 
> > > That was my approach as well: The incoming IPv6 packet was translated to
> > > IPv4 with an rfc1918 source address linked to the IPv6 source, then
> > > MASQUERADE would translate to the external IP.
> > > 
> > > In reverse direction, iptables would use the right IPv6 destination
> > > address from given rfc1918 destination address.
> > > 
> > > The above is a hack which limits the number of IPv6 clients to the size
> > > of that IPv4 transfer net. Fixing it properly would probably require
> > > conntrack integration, not sure if going that route is feasible (note
> > > that I have no clue about conntrack internals).
> > 
> > Well technically all that needs to be done is NAT66 instead of NAT44
> > within that hack and that limitation vanishes.
> 
> I don't comprehend: I have to use an IPv4 transfer net because I need to
> set a source address in the generated IPv4 header. The destination IPv4
> address is extracted from the IPv6 destination address. Simple example:
> 
> IPv6-only internal:     fec0::/64
> v6mapped:               cafe::/96
> external IPv4:          1.2.3.4
> internal transfer IPv4: 10.64.64.0/24
> 
> Client sends:       IPv6(fec0::1, cafe::8.8.8.8)
> nat64 in fwd:       IPv4(10.64.64.1, 8.8.8.8)
> nat in postrouting: IPv4(1.2.3.4, 8.8.8.8)
> 
> Google replies:     IPv4(8.8.8.8, 1.2.3.4)
> nat in prerouting:  IPv4(8.8.8.8, 10.64.64.1)
> nat64 in fwd:       IPv6(cafe::8.8.8.8, fec0::1)

The IPv6 subnet has more IPs than the internal transfer IPv4 network.
Therefore doing a NAT66 to condense all of them into one IPv6 address
means you only need 1 IPv4 in the internal transfer net. Therefore the
limitation stated above no longer applies. Admittedly if you do the
nat44 within a dedicated network namespace while sharing an IPv4 with
the host you'd still need to do NAT44 too.

> 
> > > The actual issue though with protocols like FTP is that they embed IP
> > > addresses in their headers. Therefore it is not sufficient to swap the
> > > l3 header and recalculate the TCP checksum, you end up manipulating l7
> > > headers to keep things going. At least there's prior work in conntrack
> > > helpers, not sure if that code could be reused or not.
> > 
> > If nat64 functionality was added within conntrac itself then it would be
> > easy to reuse the l7 helpers. If it was anywhere else the l7 helpers
> > within conntrack would have to be re-implemented as conntrack wouldn't
> > know the mappings and therefor it probably would be quite hard to do the
> > rewrites.
> > Also in regards to FTP not just L7 headers but also payload needs to be
> > edited on the fly. As it often uses differnt commands for IPv4 and IPv6
> > (even though the IPv6 ones also support IPv4) and it embeds the IPs as
> > strings.
> > 
> > EPRT<space><d><net-prt><d><net-addr><d><tcp-port><d>
> > 
> > where "net-prt" is either 1 for IPv4 or 2 for IPv6. and net-addr is the
> > string representation.
> > However a client may send the "PORT" command instead...
> > Also RFC2428 may be helpful in this context.
> > 
> > I think if it was possible to get the nat64 into conntrack it should
> > also be possible to take care of this more easily as with external
> > "hacks".
> 
> I agree it would probably be the cleanest solution.
> 
> > Also in regards to the above code it looks like currently only tcp and
> > udp are supported. All other traffic appears to just dropped at the
> > moment instead of just passed through. Is there a particular reason for
> > this?
> 
> I guess tcp and udp are simply sufficient in k8s.

doesn't k8s also support sctp? Also still no need to just drop
everything else, would have expected to just pass through it without
special handling...

> 
> Cheers, Phil
