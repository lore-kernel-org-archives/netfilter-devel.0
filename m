From: Harald Welte <laforge@netfilter.org>
Subject: ipt_string / 2.6.x (smp_num_cpus)
Date: Sat, 14 Feb 2004 22:38:49 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040214213849.GD7756@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0402071412270.27286-100000@sparrow>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jn9znQ5OoOl0oegR"
Cc: Gianni Tedesco <gianni@ecsc.co.uk>,
	ML-netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Rusty Russell <rusty@rustcorp.com.au>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: William Stearns <wstearns@pobox.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0402071412270.27286-100000@sparrow>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--jn9znQ5OoOl0oegR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm Cc'ing Rusty, since he's the hotplug cpu expert=20

On Sat, Feb 07, 2004 at 02:19:14PM -0500, William Stearns wrote:
> 	ipt_string.c didn't compile correctly out of the box, because of a=20
> missing symbol smp_num_cpus.  I know there's a _correct_ fix for that=20
> (something like NR_CPUS?), but I couldn't find it.  Adding the line
>=20
> int smp_num_cpus =3D 1;

NR_CPUS is set to the maximum number of cpu's that particular kernel
image can support.  on x86, that's usually 32. =20

If I understood correctly, smp_num_cpus went away because there is no
longer a static number of cpus in a system.  Instead, there is now a
list of 'currently active' cpus and one of 'cpus that could possibly
run'.

There is only a macro for num_online_cpus().  We would need
num_possible_cpus() as replacement for smp_num_cpus.

#define num_possible_cpus()	cpus_weight(cpu_possible_map)
#define smp_num_cpus		num_possible_cpus()

should therefore be a working and semantically correct fix.

Rusty: Any comments?

> 	- Bill

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--jn9znQ5OoOl0oegR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFALpVpXaXGVTD0i/8RAnxAAJ9/v4YkTA492dSdCKj+i4j6iAP9sQCcDSrd
OMDUg3vVTut8K5sOw3IjpHI=
=SzwH
-----END PGP SIGNATURE-----

--jn9znQ5OoOl0oegR--
