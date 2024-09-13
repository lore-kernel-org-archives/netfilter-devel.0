Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D844205D
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 20:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726259714; cv=none; b=L4vFOMVG7MHHYx3aiWICbgO63Q7AQJ4XpaagWB0cjnHZ9RTE0t5C0XQdQCa2d7f92fJNzs7begEcazctfozvgaGqFDVycd7gtYN4NlWC7GoD6LjLykELeOPbomqxP0zWfODxgcR8K5+BqeDyQ5oAVeyvjcB+WBZpZF9eh6NaTzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726259714; c=relaxed/simple;
	bh=g7QiCiF+RXxvBq5q1TkRZiGUZr5uG7e/dmQQRWqEamI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vDKPeFJZIFR/GUcHQiZOiOzW3Y48cNnuj+4DpjDTNBBn6UTZAvjqAUTN32/oS7vPp7KvRmdJBgNh3rh6+5ikpKaX47i/D8Ioq56o3OLFxok43Sj65ceBGIQ/dqvY2sDP1JZrs3l4Tg8si5GGZuNb5qn0as2immifqZ9YFJJxrVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=hT72vOn1; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="hT72vOn1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aOjLnizYsfQZN3KOGU6mTg2a5kH4yMqcBI/ccuy87/w=; b=hT72vOn1/dD+0oiRpMBmLHGY0F
	dx8T0PK5fqJZf3K4d/6gRv8I5JXgulTfD1KPF49/3Ig4kQhU9yrLr0NpWTDTNqDUTO6lmi4++teJW
	lL5n5IJTiq0/40TK/zhi4JxpxaTr2Z/R4BwWvzZHtiZ1IWEixbowLiHw17ZDZur8RDpZKf4Da+boR
	2efyfXN4V66xTTisoQm2rdDcAGXB/Y8JMFCAYGxdBb16ZETGFimISRugLUuNx1hmPDF61AGsD2RMI
	eieYQDifypRW2mi5bMRq1n5sojE5eVTCCyldlkL7BMGDRCpbdy8FpdQXJnnwrFh6BIW2QkcKvR+nY
	9+Z+npeQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1spD0W-000000001mx-2pxK;
	Fri, 13 Sep 2024 22:35:08 +0200
Date: Fri, 13 Sep 2024 22:35:08 +0200
From: Phil Sutter <phil@nwl.cc>
To: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_tproxy: make it terminal
Message-ID: <ZuSh_Io3Yt8LkyUh@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Antonio Ojea <antonio.ojea.garcia@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240913102347.GA15700@breakpoint.cc>
 <ZuQT60TznuVOHtZg@calendula>
 <20240913104101.GA16472@breakpoint.cc>
 <ZuQYPr3ugqG-Yz82@calendula>
 <CABhP=tZKgrWo2oH3h=cA8KreLZtYr1TZw7EfqgGwWitWZAPqyw@mail.gmail.com>
 <ZuQg6d9zGDZKbWBO@calendula>
 <ZuQpbnjAoutXEFUj@orbyte.nwl.cc>
 <ZuQx3_x6JJgzA0gS@calendula>
 <20240913141804.GA22091@breakpoint.cc>
 <CABhP=tYWf7-Ydi6HyOQ_syeS=k6Y9xPbSGYTSjOjhYpA=Jk-TQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABhP=tYWf7-Ydi6HyOQ_syeS=k6Y9xPbSGYTSjOjhYpA=Jk-TQ@mail.gmail.com>

Hi Antonio,

On Fri, Sep 13, 2024 at 05:38:21PM +0200, Antonio Ojea wrote:
> On Fri, 13 Sept 2024 at 16:18, Florian Westphal <fw@strlen.de> wrote:
> >
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > Hmm. Looking at nft_nat.c, 'accept' seems consistent with what nat
> > > > statements do implicitly.
> > >
> > > Yes, and xt_TPROXY does NF_ACCEPT.
> > >
> > > On the other hand, I can see it does NF_DROP it socket is not
> > > transparent, it does NFT_BREAK instead, so policy keeps evaluating the
> > > packet.
> >
> > Yes, this is more flexible since you can log+drop for instance in next
> > rule(s) to alert that proxy isn't running for example.
> >
> 
> This is super useful, in the scenario that the transparent proxy takes
> over the DNATed virtual IP, if the transparent proxy process is not
> running the packet goes to the DNATed virtual IP so the clients don't
> observe any disruption.

So here's a use-case for why non-terminal tproxy statement is superior
over terminal one. :)

> > > > > is this sufficient in your opinion? If so, I made this quick update
> > > > > for man nft(8).
> > > >
> > > > Acked-by: Phil Sutter <phil@nwl.cc>
> > > >
> > > > In addition to that, I will update tproxy_tg_xlate() in iptables.git to
> > > > emit a verdict, too.
> > >
> > > Thanks, this is very convenient.
> >
> > Agreed, it should append accept keyword in the translator.
> 
> I'm not completely following the technical details sorry.

In essence, tproxy statement does not set a verdict unless it fails to
find a suitable socket. A sample ruleset illustrating this is:

| table t {
| 	chain c {
| 		type filter hook prerouting priority 0
| 		tproxy to :1234 log "packet tproxied" accept
| 		log "no socket on port 1234 or not transparent?" drop
| 	}
| }

> With my current configuration I do set an accept action
> 
>    udp dport 53 tproxy ip to 127.0.0.1:46659 accept
> 
> and I have dnat statements after that action.

For the record, your ruleset looks like this (quoting from the kselftest
you sent me):

| table inet filter {
|        chain divert {
|                type filter hook prerouting priority -100; policy accept;
|                $ip_proto daddr $virtual_ip udp dport 8080 tproxy ip_proto to :12345 meta mark set 1 accept
|        }
|        # Removing this chain makes the first connection to succeed
|        chain PREROUTING {
|                type nat hook prerouting priority 1; policy accept;
|                $ip_proto daddr $virtual_ip udp dport 8080 dnat to umgen inc mod 2 map { 0 : $ns2_ip , 1: $ns3_ip }
|        }
| }

Foundational lecture: 'accept' verdict covers the current hook only. Like
with iptables, if you accept in e.g. PREROUTING, INPUT may still see the
packet. 'drop' verdict OTOH discards the packet, so no following hooks
will see it (obviously).

Your case is special because of the different types. If I interpret this
correctly, a new connection's packet will get tproxied by divert chain
and dnatted by PREROUTING chain (which sets up a conntrack entry). The
second packet will hit conntrack in prerouting hook at priority -200
(according to the big picture[1]) and your tproxy rule does not match
anymore. The nat type chain does not see the packet as it's not a new
connection. Maybe this explains the behaviour you're seeing.

In order to avoid the inadvertent dnat of tproxied packets, terminating
the divert chain's rule with 'drop' instead of 'accept' should do - if
tproxy fails, it set NFT_BREAK so the packet continues and hits
PREROUTING chain (if the connection is new).

Cheers, Phil

[1] https://people.netfilter.org/pablo/nf-hooks.png
