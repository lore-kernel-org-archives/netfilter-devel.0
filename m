From: Harald Welte <laforge@netfilter.org>
Subject: Re: GnomeMeeting STUN
Date: Fri, 26 Dec 2003 01:26:25 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031226002625.GA8401@obroa-skai.de.gnumonks.org>
References: <1072260947.722.25.camel@golgoth01> <20031224143851.GD941@obroa-skai.de.gnumonks.org> <1072370922.680.6.camel@golgoth01>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Damien Sandras <dsandras@seconix.com>
Content-Disposition: inline
In-Reply-To: <1072370922.680.6.camel@golgoth01>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 25, 2003 at 05:48:42PM +0100, Damien Sandras wrote:
> > NAT didn't change at all between 2.4.x and 2.6.x, so there is no change
> > related to gnomemeeting.
> >=20
> > I assume all we have to offer is ip_conntrack/nat_h323, which is in
> > patch-o-matic but has been reported not to work with gnomemeeting (but
> > with netmeeting) in the past ?  We'd be happy to receive any feedback
> > you would have regarding that subject.
> >=20
>=20
> I will do my best. I already had sent some information to Joszef a long
> time ago, but I think it was lost.=20

please retransmit, or even better: submit it to bugzilla.netfilter.org.
This way it is not that likely to get lost again.

> The problem with the conntrack approach is that we will also have to do
> the same kind of connection tracker for the SIP protocol :(

IIRC, SIP was the reason for MIDCOM (and FCP, ...).  A conntrack/nat
helper for SIP will only work in a very small subset of SIP (no
hostnames, only IP addresses, no encryption).  Despite that fact,
somebody is already working on such a helper.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/64AwXaXGVTD0i/8RAv3OAJ9VLIugzG29fb/9qs7UrZ8UwfphbgCfRIHJ
Vq2PuTPB8nE6DF8crViYLrY=
=L/Ni
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
