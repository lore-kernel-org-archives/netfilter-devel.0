From: Harald Welte <laforge@gnumonks.org>
Subject: Re: GnomeMeeting STUN
Date: Wed, 24 Dec 2003 15:38:51 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031224143851.GD941@obroa-skai.de.gnumonks.org>
References: <1072260947.722.25.camel@golgoth01>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DrWhICOqskFTAXiy"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Damien Sandras <dsandras@seconix.com>
Content-Disposition: inline
In-Reply-To: <1072260947.722.25.camel@golgoth01>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--DrWhICOqskFTAXiy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 24, 2003 at 11:16:14AM +0100, Damien Sandras wrote:
> Hello Harald,

Hi Damien.  I'm Cc'ing your email to netfilter-devel, since there might
be other developers interested in a discussion about STUN.

> I hope you are going well and I already wish you a merry christmas and a
> happy new year :-)

thanks a lot.  My best wishes for christmas and happy new year in
return.

> I have a few questions for you if you don't mind. You probably guess
> that getting gnomemeeting (and voip apps in general) behind a NAT
> gateway is hard for average users for which even port forwarding is
> hard.

yes, unfortunately those protocols are not very NAT friendly.

> Cisco has come up with a solution called STUN, I suppose you know what
> it is. GnomeMeeting could get STUN support soon, but Linux Nat appears
> as being of type "Blocked" (RFC3489).=20

The Linux >=3D 2.4.x implementation of NA(P)T is what the IETF tends to
call 'fully symmetric NAPT', i.e. the most sophisticated version of
network and port address translation. =20

With old, 'more stupid' NA(P)T implementations in ipfwadm and ipchains,
you would be able to do STUN.

So it seems like linux is too advanced for the tricks that STUN tries to
do. =20

netfilter/iptables would AFAICT interoperate quite well with what the
ITEF MIDCOM people are designing, though.

> So my question is: is there a way to make Linux NAT gateways work with
> STUN?

No, I honestly don't see any way. =20
The fundamental principles behind the iptables NAT design are:

1) try to change as little information as possible
	i.e. we only do NAT as long as it is possible. port numbers
	 are only changed if absolutely necessarry.  Also, as opposed
	 to ipchains, you cannot tell that NAT is used just by looking
	 at the source port numbers.

2) try to use as little resources as possible
	this especially means that any given (srcport,srcip) tuple
	at the NAT gateway can be used for many different connections,
	as long as the (dstip,dstport) tuple differs

3) provide as much 'security' as possible
	we get this for free if we do '2)'.  This means we don't accept
	any incoming reply packets from a differnet srcip/srcport than
	the original request was sent to.

> Have things changed with 2.6 in terms of the way NAT works and that
> could influence gnomemeeting's behavior?

NAT didn't change at all between 2.4.x and 2.6.x, so there is no change
related to gnomemeeting.

I assume all we have to offer is ip_conntrack/nat_h323, which is in
patch-o-matic but has been reported not to work with gnomemeeting (but
with netmeeting) in the past ?  We'd be happy to receive any feedback
you would have regarding that subject.

> Thank you,
>  _      Damien Sandras

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--DrWhICOqskFTAXiy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/6aT6XaXGVTD0i/8RAntnAKCwCH0eIGv2CKughlEsXds3TqgiVgCfe/fM
//SsdoyASQbGEdcivsZIbfI=
=hKzH
-----END PGP SIGNATURE-----

--DrWhICOqskFTAXiy--
