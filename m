From: Lennart Poettering <mz6e657466696c746572@itaparica.org>
Subject: Re: libipq + packet mangling + MTU
Date: Fri, 4 Oct 2002 21:01:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021004190107.GA24906@whiskey.dummy.lan>
References: <20021004153401.GA23867@whiskey.dummy.lan> <200210041749.g94HnvfZ006108@marajade.sandelman.ottawa.on.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Michael Richardson <mcr@sandelman.ottawa.on.ca>
Content-Disposition: inline
In-Reply-To: <200210041749.g94HnvfZ006108@marajade.sandelman.ottawa.on.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 04.10.02 13:49, Michael Richardson (mcr@sandelman.ottawa.on.ca) wro=
te:

>   Sane? No :-)
>=20
>   Seriously, see RFC2003 as well as the DF and PMTU sections of RFC2401
> for some thoughts. Are you adding a new IP header? Or is something else
> happening?

No, the IP header is not increased/decreased in size. Mainly, the
payload is modified.

>   You need to send an ICMP fragment needed to the sender of the
>   packet.

I did not know of "fragment needed" ICMP messages. That might be an idea.

>     Lennart> I would like to see a second MTU-value attached to each netw=
ork
>     Lennart> device which specifies a higher limit than the normal
>     Lennart> MTU. Packets which are larger than this second MTU get dropp=
ed,
>     Lennart> packets which are larger than the normal MTU but smaller than
>     Lennart> that special MTU are accepted. So that I would be able to set
>     Lennart> the normal mtu to 1480 and the effective MTU to 1500 and be
>     Lennart> happy this way. Is there anything like this available in the
>     Lennart> Linux kernel currently?
>=20
>   Yes, you can specify the MTU as part of a route, and as part of the=20
> neighbour cache. The later gets created automatically, so might take some
> code to do what you want.=20

I did not know of this feature either!

ip route change 10.0.0.0/8 dev eth0 mtu 1400

seems to do the job for me, is that right?

This seems to be the ideal solution! Thanks!

>=20
>     Lennart> Maybe there is a simple sysctl variable that may modify the
>     Lennart> packet size the kernel splits its TCP stream with?
>=20
>   If you are strictly dealing with locally generated packets, then it sho=
uld
> be easier. A virtual interface is one way to deal with this, but is has o=
ther
> less desireable effects as well.

I already thought of another, more pragmatic solution: The large
packages are mostly TCP. Thus it is enough to get TCP right. And this
is easy to do: the TCPMSS target is a simple solution to limit segment
size. It works quite fine. UDP packages will get fragmented and slowed
down. However: it won't break things, since no packets are lost.

Thank you very much for your help!

lp

--=20
name { Lennart Poettering } mail { lennart@poettering.de }
icq { 11060553 } www { http://www.poettering.de/lennart/ }
loc { hamburg, germany } pgp { 0x1A015CC4 } hack { .phi. }



--DocE+STaALJfprDB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.0 (GNU/Linux)

iD8DBQE9neVzMn8mlRoBXMQRAjuEAJ99MsNXrrTMI8R1vOjSQjIfOKtBMgCfSLp5
05vjdGNQQP1+emFOL178aG0=
=IzUH
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
