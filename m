From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 2.6 IPSEC + SNAT
Date: Thu, 02 Oct 2003 19:42:45 +1000
Sender: linux-net-owner@vger.kernel.org
Message-ID: <E1A4zyv-0003or-00@gondolin.me.apana.org.au>
References: <1065012231.2121.37.camel@gardafou>
Return-path: <linux-net-owner@vger.kernel.org>
To: jef@linuxbe.org, linux-net@vger.kernel.org,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <1065012231.2121.37.camel@gardafou>
List-Id: netfilter-devel.vger.kernel.org

Jean-Francois Dive <jef@linuxbe.org> wrote:
> the problem is the order of operation, but both ways have their
> drawbacks:

The different orders do completely different things.  Both are valid
though.

> - NAT - IPSec: well Herbert's bug report get fixed, i even suppose you
> do some nat to get the traffic match the selectord, this is nice, but
> when the packet get detranslated, you then should check policy on
> denated packets, this mean that you may miss policy check failures: what

In my scenario, the policy check should be done on the packets before
they are unNATed since the IPSEC policy is setup with the SNATed address.

> and have firewall to feel good about it. For exemple in static nat
> entries, one could see a cleartext packet arrive with the NAT'ed
> addresses, pass the
> "receive_cleartext_packet_but_they_should_be_encrypted" test, get
> denated and pop in the inside network.

In my scenario such a packet will fail the policy check.

> - IPSec - NAT: well this make the attempt not working but you do enforce
> policy checks on packets before they get NAT worked on.

This order has nothing to do with my scenario.  This sequence of events
is what happens when you attempt IPSEC behind a NAT gateway.  NAT
traversal is needed in this case.

Cheers,
-- 
Debian GNU/Linux 3.0 is out! ( http://www.debian.org/ )
Email:  Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
