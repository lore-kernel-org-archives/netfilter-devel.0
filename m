From: Harald Welte <laforge@netfilter.org>
Subject: Re: remaining libnetfilter_conntrack issues
Date: Fri, 28 Oct 2005 23:08:58 +0200
Message-ID: <20051028210857.GB10568@rama.de.gnumonks.org>
References: <20051028205955.GA10568@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oC1+HKm2/end4ao3"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20051028205955.GA10568@rama.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--oC1+HKm2/end4ao3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 28, 2005 at 10:59:55PM +0200, Harald Welte wrote:
> Hi Pablo!
>=20
> I've started to write a new ulogd2 plugin against the new
> libnetfilter_conntrack, and found a number of issues, mostly related to
> header files:

Another comment:

7) we put the definition of the 'nfct_handle' into a private header
   file. this is good practise for encapsulation, since it prevents the
   application from making any assumptions about its size and/or
   contents.

Thanks for your consideration,
	Harald
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--oC1+HKm2/end4ao3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDYpNpXaXGVTD0i/8RAliKAJ93PIMf8q2AObgPpBiJmR7KsX1jhgCfUJ3+
P66W6c2JGpLFXQivAZ5ykfg=
=lHEV
-----END PGP SIGNATURE-----

--oC1+HKm2/end4ao3--
