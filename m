From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] h323 module unloading fix
Date: Tue, 8 Feb 2005 16:52:39 +0100
Message-ID: <20050208155238.GT6878@sunbeam.de.gnumonks.org>
References: <20050208145908.GS6878@sunbeam.de.gnumonks.org>
	<20050208152620.GA30780@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XFkHhpX+zY/pUGhI"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Max Kellermann <max@duempel.org>
Content-Disposition: inline
In-Reply-To: <20050208152620.GA30780@roonstrasse.net>
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


--XFkHhpX+zY/pUGhI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 08, 2005 at 04:26:20PM +0100, Max Kellermann wrote:

> I think your patch regarding ip_conntrack_core.c is a workaround, that
> does not look clean to me. I prefer to make H.323 register the H.245
> helper with a disabled mask (only to be activated internally by
> H.225), and then unregister it cleanly.

Yes, but every additional entry in the list of helpers is matched
against every packet...  and I don't want to waste performance just for
being a bit more clean.

But maybe we could add a flag to the helper like F_DISABLED which would
disable matching for that particular helper.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--XFkHhpX+zY/pUGhI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCCOBGXaXGVTD0i/8RAmb3AKCKIHF7LNhO3sntVTLrQk9NNqOOpgCgj3jn
uFJZEZ+8//x9E3DM6mort0Y=
=1tmm
-----END PGP SIGNATURE-----

--XFkHhpX+zY/pUGhI--
