From: Sven-Haegar Koch <haegar@sdinet.de>
Subject: Re: Outgoing interface selection by source address
Date: Thu, 27 Nov 2003 16:27:58 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0311271626000.1890@mercury.sdinet.de>
References: <Pine.LNX.4.44.0311271618450.26423-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pawel Hadam <Pawel.Hadam@imag.fr>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0311271618450.26423-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 27 Nov 2003, Henrik Nordstrom wrote:

> On Thu, 27 Nov 2003, Pawel Hadam wrote:
> > connection (src0, dst) are routed via eth1. And I would like them to be
> > routed via interface eth0, as src0 is the address of eth0 not eth1.
>
> For this you need to use policy routing. I assume this exists in IPv6 as
> well as it does in IPv4. This question is not really iptables related.

nope, no policy-routing for ipv6 - this is one of the big area's where
linux ipv6-support is still way behind ipv4.

c'ya
sven

-- 

The Internet treats censorship as a routing problem, and routes around it.
(John Gilmore on http://www.cygnus.com/~gnu/)
