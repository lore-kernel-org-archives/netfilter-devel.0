From: Harald Welte <laforge@netfilter.org>
Subject: Re: Netfilter on an IXDP-2400/2800
Date: Sun, 21 Sep 2003 16:12:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030921141244.GC20986@sunbeam.de.gnumonks.org>
References: <20030915140411.GA3166@mandark.chaos.lab>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Cc: netfilter-devel@lists.netfilter.org, hadi@cyberus.ca
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Frank Meerkoetter <meerkoetter@stud.fbi.fh-darmstadt.de>
Content-Disposition: inline
In-Reply-To: <20030915140411.GA3166@mandark.chaos.lab>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 15, 2003 at 04:04:11PM +0200, Frank Meerkoetter wrote:

> during the next 6 month i've maybe the possibility to play around with an=
=20
> intel network processor board [1].
>=20
> The IXP-2400 is a processor based on the xscale architecture, running at=
=20
> 600Mhz [2]. It contains among other things 8 io-processors, called=20
> microengines which are optimized for packet-processing. The setup will=20
> most probably have a quad gigabit ethernet card.
>=20
> A first idea for a project was to modify the netfilter framework to make =
use
> of the special hardware features of this platform.
>=20
> Could someone please comment on the usefullness/feasibility of such a=20
> modification?

Please contact Jamal (hadi@cyberus.ca), he has way more understanding
about such systems than I have [and is  believed to have done quite some wo=
rk
in the direction you are heading].

> sincerely=20
>   Frank Meerkoetter

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/bbHcXaXGVTD0i/8RAqZbAJ91gjBeQoM6CTUeoqJsF04Za0rlUQCfQSKO
NRSlNQyorhKNeapnG/xNB2M=
=vZjB
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--
