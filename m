From: Harald Welte <laforge@netfilter.org>
Subject: Re: iptables/extensions/libipt_time.c missing include
Date: Tue, 27 Jan 2004 11:57:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040127105745.GG11761@sunbeam.de.gnumonks.org>
References: <wazza.877jzj8ll6.fsf@message.id> <20040123095234.GA4595@wavehammer.waldi.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lQSB8Tqijvu1+4Ba"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20040123095234.GA4595@wavehammer.waldi.eu.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--lQSB8Tqijvu1+4Ba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 23, 2004 at 10:52:34AM +0100, Bastian Blank wrote:
> On Fri, Jan 23, 2004 at 03:06:45AM +0100, laurent.ml@linuxfr.org wrote:
> > Tell me if I'm wrong, it seems an include is missing in
> > extensions/libipt_time.c from iptables cvs.
> > (line 302 : offsetof)
>=20
> You should use <stddef.h> instead of <linux/stddef.h>.

At least on my debian machines /usr/include/stddef.h doesn't exist.

Thus, I'm accepting the patch.

> Bastian

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--lQSB8Tqijvu1+4Ba
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAFkQpXaXGVTD0i/8RAhZrAKCNrI8jHSYySN8lthaw7CwrU4LTBQCdHJ9R
khAYgndUgibstgoXW2b53SI=
=Nciv
-----END PGP SIGNATURE-----

--lQSB8Tqijvu1+4Ba--
