Received: from mx01.frank.fyi (mx01.frank.fyi [5.189.178.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0412D878D;
	Thu, 12 Jun 2025 20:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.189.178.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749759191; cv=none; b=XsyBIUJpuTjzVF6H51W/CZZHPYupeK9mMuNeL7swKZHwJ/+yu2CL6+70fcd2l5NPmGQAWD6dCXO0pZR7AbHhlRqrCcv5Ls4hUMvX9lCNhYN9F05BhMfEiVA1AyzRuy/7pNR+NN8ntpD5bZp2P01srfXoZLdnH2f1EAkxmn9aV0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749759191; c=relaxed/simple;
	bh=5AtADpZQklpovVZ+DTgV8PH6MVSn65vhBXtXjRzH4Do=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ajDTM0oeETEGcK+P5h3VnKI0HqJFonb4aeKg0aZ6ZinHhBRLpI6evWGSWiWwVotDL/ljYOR7XoiPgejKQPCDwk0T9z5ugDksRZl0alm7ZfGBLDlXZa4BzvfCOLOVYxZazls5ME26UcXiU+HExSgDVh4TTeuEuh2LZWGVlQoYH2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=frank.fyi; spf=pass smtp.mailfrom=frank.fyi; dkim=pass (2048-bit key) header.d=frank.fyi header.i=@frank.fyi header.b=Khy+U95T; arc=none smtp.client-ip=5.189.178.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=frank.fyi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=frank.fyi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=frank.fyi header.i=@frank.fyi header.b="Khy+U95T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=frank.fyi; s=mail;
	t=1749759182; bh=5AtADpZQklpovVZ+DTgV8PH6MVSn65vhBXtXjRzH4Do=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=Khy+U95TtI0DoWEA0BPAM2zehdAdBRUkv6IEDPOmJagNgpgHLLy6tI9+k1+mKhxOJ
	 u7zWXJPs0OS/3/x30lIMgamACrg3+a9GdtNNReZqsOSYDHJziYqKLOP9exT2RiLcgJ
	 kpB9nOHfVJf8XD/nLggcMHj628TlCsHf2+YY62kNTaQf/7FXbGLcVqMeUokCARQGxs
	 i3TqSTWdAWjXOKqvTRR2ayWkW1ywGlwKkDbOtuBENDfl8PcfcBblOZw5Q2yf2XkZF4
	 Hf6K4/3ChI8TdNJuE4UIpls/OY+BwctowkB+x7jYCJB4MpMdRXB8WHnbxCKUsVbk2X
	 NiEpeQbyJ7kHQ==
Received: by mx01.frank.fyi (Postfix, from userid 1001)
	id A18791120181; Thu, 12 Jun 2025 22:13:02 +0200 (CEST)
Date: Thu, 12 Jun 2025 20:13:02 +0000
From: Klaus Frank <vger.kernel.org@frank.fyi>
To: Phil Sutter <phil@nwl.cc>, 
	Antonio Ojea <antonio.ojea.garcia@gmail.com>, Klaus Frank <vger.kernel.org@frank.fyi>, 
	netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Lukas Wunner <lukas@wunner.de>, netfilter@vger.kernel.org, 
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>, netdev@vger.kernel.org
Subject: Re: Status of native NAT64/NAT46 in Netfilter?
Message-ID: <cqrontvwxblejbnnfwmvpodsymjez6h34wtqpze7t6zzbejmtk@vgjlloqq2rgc>
References: <w7bwjqyae36c6pqhqjmvjcrwtpny6jxjyvxzb2qzt7atjncxd2@gi4xhlyrz27b>
 <aEqka3uX7tuFced5@orbyte.nwl.cc>
 <CABhP=tZRP42Dgw9+_vyAx80uPg4V2YFLfbGhpA10WzM46JYTNg@mail.gmail.com>
 <aErch2cFAJK_yd6M@orbyte.nwl.cc>
 <CABhP=tbUuJKOq6gusxyfsP4H6b4WrajR_A1=7eFXxfbLg+4Q1w@mail.gmail.com>
 <aEsuPMEkWHnJvLU9@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEsuPMEkWHnJvLU9@orbyte.nwl.cc>

On Thu, Jun 12, 2025 at 09:45:00PM +0200, Phil Sutter wrote:
> On Thu, Jun 12, 2025 at 08:19:53PM +0200, Antonio Ojea wrote:
> > On Thu, 12 Jun 2025 at 15:56, Phil Sutter <phil@nwl.cc> wrote:
> > >
> > > Hi,
> > >
> > > On Thu, Jun 12, 2025 at 03:34:08PM +0200, Antonio Ojea wrote:
> > > > On Thu, 12 Jun 2025 at 11:57, Phil Sutter <phil@nwl.cc> wrote:
> > > > > On Sun, Jun 08, 2025 at 08:37:10PM +0000, Klaus Frank wrote:
> > > > > > I've been looking through the mailling list archives and couldn't find a clear anser.
> > > > > > So I wanted to ask here what the status of native NAT64/NAT46 support in netfilter is?
> > 
> > > > we ended doing some "smart hack" , well, really a combination of them
> > > > to provide a nat64 alternative for kubernetes
> > > > https://github.com/kubernetes-sigs/nat64:
> > > > - a virtual dummy interface to "attract" the nat64 traffic with the
> > > > well known prefix
> > > > - ebpf tc filters to do the family conversion using static nat for
> > > > simplicity on the dummy interface
> > > > - and reusing nftables masquerading to avoid to reimplement conntrack
> > >
> > > Oh, interesting! Would you benefit from a native implementation in
> > > nftables?
> > 
> > Indeed we'll benefit a lot, see what we have to do :)
> > 
> > > > you can play with it using namespaces (without kubernetes), see
> > > > https://github.com/kubernetes-sigs/nat64/blob/main/tests/integration/e2e.bats
> > > > for kind of selftest environment
> > >
> > > Refusing to look at the code: You didn't take care of the typical NAT
> > > helper users like FTP or SIP, did you?
> > 
> > The current approach does static NAT64 first, switching the IPv6 ips
> > to IPv4 and adapting the IPv4 packet, the "real nat" is done by
> > nftables on the ipv4 family after that, so ... it may work?
> 
> That was my approach as well: The incoming IPv6 packet was translated to
> IPv4 with an rfc1918 source address linked to the IPv6 source, then
> MASQUERADE would translate to the external IP.
> 
> In reverse direction, iptables would use the right IPv6 destination
> address from given rfc1918 destination address.
> 
> The above is a hack which limits the number of IPv6 clients to the size
> of that IPv4 transfer net. Fixing it properly would probably require
> conntrack integration, not sure if going that route is feasible (note
> that I have no clue about conntrack internals).

Well technically all that needs to be done is NAT66 instead of NAT44
within that hack and that limitation vanishes.
> 
> The actual issue though with protocols like FTP is that they embed IP
> addresses in their headers. Therefore it is not sufficient to swap the
> l3 header and recalculate the TCP checksum, you end up manipulating l7
> headers to keep things going. At least there's prior work in conntrack
> helpers, not sure if that code could be reused or not.

If nat64 functionality was added within conntrac itself then it would be
easy to reuse the l7 helpers. If it was anywhere else the l7 helpers
within conntrack would have to be re-implemented as conntrack wouldn't
know the mappings and therefor it probably would be quite hard to do the
rewrites.
Also in regards to FTP not just L7 headers but also payload needs to be
edited on the fly. As it often uses differnt commands for IPv4 and IPv6
(even though the IPv6 ones also support IPv4) and it embeds the IPs as
strings.

EPRT<space><d><net-prt><d><net-addr><d><tcp-port><d>

where "net-prt" is either 1 for IPv4 or 2 for IPv6. and net-addr is the
string representation.
However a client may send the "PORT" command instead...
Also RFC2428 may be helpful in this context.

I think if it was possible to get the nat64 into conntrack it should
also be possible to take care of this more easily as with external
"hacks".


Also in regards to the above code it looks like currently only tcp and
udp are supported. All other traffic appears to just dropped at the
moment instead of just passed through. Is there a particular reason for
this?

> 
> Cheers, Phil
