From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: can netfilter capture internal network packet?
Date: Thu, 12 Jun 2003 22:29:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200306122229.17392.bdschuym@pandora.be>
References: <001101c32cd0$14bdf940$010aa8c0@toowoomba> <20030611120439.GJ32593@sunbeam.de.gnumonks.org> <1055388262.3967.84.camel@matthewn1.sw.moreton.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matthew Natalier <matthewn@snapgear.com>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <1055388262.3967.84.camel@matthewn1.sw.moreton.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thursday 12 June 2003 05:24, Matthew Natalier wrote:
> Calvin,
>
> The ebtables project might interest you.
>
> http://ebtables.sourceforge.net/
>
> You can intercept packets by putting a bridge between A and B.

> > My setup is
> >
> > A      B
> >  \       /
> >   \     /
> >   HUB
> >
> >      | (eth0)
> >
> >    GW
> >
> >      |(eth1)
> >
> >  is that possible to: when A send a message to B port 1700 (for examp=
le)
> > , the iptales in GW can grep the packet and put into queue for proces=
sing
> > and put it back to the line?

You'll need to use iptables on the bridge if you want to queue the packet=
 to=20
userspace, though. Just replace the hub by a Linux bridge and use iptable=
s on=20
it...

cheers,
Bart
