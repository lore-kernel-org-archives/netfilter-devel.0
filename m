From: Harald Welte <laforge@netfilter.org>
Subject: Re: I see wrong ip on icmp_need_fragment. MASQUERADE+less_than_1500_MTU_link+nfs
Date: Sat, 23 Aug 2003 23:07:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030823210759.GD6750@sunbeam.de.gnumonks.org>
References: <200308141317.h7EDHad01974@Port.imtp.ilyichevsk.odessa.ua>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VMt1DrMGOVs3KQwf"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Denis Vlasenko <vda@port.imtp.ilyichevsk.odessa.ua>
Content-Disposition: inline
In-Reply-To: <200308141317.h7EDHad01974@Port.imtp.ilyichevsk.odessa.ua>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--VMt1DrMGOVs3KQwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 14, 2003 at 04:17:35PM +0300, Denis Vlasenko wrote:
> Hi folks,
>=20
> Please CC me, I'm not on the list.
>=20
> I think I see a bug.

Unfortunately you didn't tell us which exact kernel version you were
using while experiencing the described behaviour.

Could you please file a bug about this to bugzilla.netfilter.org with
the kernel version and all details?  thanks.

> Is this a known problem?

we've had this bug in the past - but it's assumed to be fixed since
quite some time (2.4.19 or 2.4.20, I think).

> vda

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--VMt1DrMGOVs3KQwf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/R9evXaXGVTD0i/8RAvTpAJ9sChYtt2ZTZmjW/5YGLgX9PQbZUQCaA6GS
5CwMM0TogGKrZkHP9jINgc0=
=XQyP
-----END PGP SIGNATURE-----

--VMt1DrMGOVs3KQwf--
