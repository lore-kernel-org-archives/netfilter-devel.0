From: Pawel Hadam <Pawel.Hadam@imag.fr>
Subject: Re: Outgoing interface selection by source address
Date: Thu, 27 Nov 2003 16:33:21 +0100 (MET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.GSO.4.33.0311271631110.21455-100000@horus.imag.fr>
References: <Pine.LNX.4.58.0311271626000.1890@mercury.sdinet.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Sven-Haegar Koch <haegar@sdinet.de>
In-Reply-To: <Pine.LNX.4.58.0311271626000.1890@mercury.sdinet.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 27 Nov 2003, Sven-Haegar Koch wrote:

> > > connection (src0, dst) are routed via eth1. And I would like them to be
> > > routed via interface eth0, as src0 is the address of eth0 not eth1.
> >
> > For this you need to use policy routing. I assume this exists in IPv6 as
> > well as it does in IPv4. This question is not really iptables related.
>
> nope, no policy-routing for ipv6 - this is one of the big area's where
> linux ipv6-support is still way behind ipv4.

And that is what I was affraid of.

Maybe someone has any other idea how to route the IPv6 packet (with
fixed source address) via the proper interface, and not via the interface
chosen by destination address routing ???

Pawel
