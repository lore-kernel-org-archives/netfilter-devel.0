From: Harald Welte <laforge@netfilter.org>
Subject: Re: License of libiptc
Date: Thu, 19 Aug 2004 13:08:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040819110805.GK3921@sunbeam.de.gnumonks.org>
References: <05FEBCD8-ED29-11D8-9EB5-000A95678CE8@norad.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Iy2CUD6FdotTkhwY"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stefan Arentz <stefan.arentz@norad.org>
Content-Disposition: inline
In-Reply-To: <05FEBCD8-ED29-11D8-9EB5-000A95678CE8@norad.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Iy2CUD6FdotTkhwY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 13, 2004 at 03:02:25PM +0200, Stefan Arentz wrote:

> We are currently using libiptc in our (not yet released) product to=20
> access functionality that is not accessible through the iptables=20
> command. During a license/code review I noticed that the license of=20
> libiptc is GPL instead of LGPL. As we are not yet in the position to=20
> release our code this is a problem for us.

No, you shouldn't have started proprietary development on top of libiptc
in the first place.

The library is intentional licensed under the GPL and not LGPL.

>  S.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Iy2CUD6FdotTkhwY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBJIoVXaXGVTD0i/8RAoaIAKCe7fFN6RMM6tvFy0WizOkFKFdnvACdFO9I
r9FLg9E8FtTNo9sn7POiBUY=
=bCcx
-----END PGP SIGNATURE-----

--Iy2CUD6FdotTkhwY--
