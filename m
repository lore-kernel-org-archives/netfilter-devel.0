From: Harald Welte <laforge@netfilter.org>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Mon, 27 Sep 2004 15:39:05 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040927133904.GP3236@sunbeam.de.gnumonks.org>
References: <1092407190.2402.120.camel@nienna.balabit>
	<1095993739.1044.9.camel@jzny.localdomain>
	<20040925075253.GQ3236@sunbeam.de.gnumonks.org>
	<1096290473.1075.64.camel@jzny.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="axAiL0GWw9slBjba"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: jamal <hadi@cyberus.ca>
Content-Disposition: inline
In-Reply-To: <1096290473.1075.64.camel@jzny.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--axAiL0GWw9slBjba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 27, 2004 at 09:07:53AM -0400, jamal wrote:
> I think it would be better to separate the election process (who is
> master) from the syncing code. For some reason i thought this separation
> was there (and that all you had to do was bag some /proc entry).=20
> i.e if VRRP is the code that makes the decision that it wants you to be
> the master, thats how you become master. If someothericandohabetter (eg
> forCES) protocol wants you to be the master, thats how you become the
> master. There is no point in inventing a new HA scheme.
> And if you do it should probably be in user space (there is no
> perfomance issues with it) i.e its such a protocol (in user space) that=
=20
> should tell your syncing code to send syncs or not.
> Unless i missed something fundamental.

I totally agree with you, jamal.  And in fact this is exactly what we
have.  You tell one box it is master, and it becomes master.   You tell
a box it is slave, and it becomes slave.

There is just a minor addition in one case, where we want to safeguard
against a (currently) invalid mode of operation.  As soon as ct_sync
supports multiple master, this safeguard will certainly be removed.

But for the current code, unless somebody shows to me that it severely
limits some use of ct_sync, or it causes practical problems, I don't see
why we should remove this safeguard.

> cheers,
> jamal

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--axAiL0GWw9slBjba
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBWBf4XaXGVTD0i/8RAv1JAJ42JSws2ff0CGY+a1FoBRtrR39kswCgmdhu
YOv2FkAZx+up3AjZ0fWL8To=
=67Bp
-----END PGP SIGNATURE-----

--axAiL0GWw9slBjba--
