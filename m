From: Harald Welte <laforge@netfilter.org>
Subject: Re: Bug #2
Date: Wed, 26 Feb 2003 19:18:46 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030226181846.GR8883@sunbeam.de.gnumonks.org>
References: <20030219235024.GA1228@tekilla.homeip.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QLVwfW7TUsi22t4P"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030219235024.GA1228@tekilla.homeip.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--QLVwfW7TUsi22t4P
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 20, 2003 at 12:50:24AM +0100, Willi Dyck wrote:
>   "locally-generated icmp-frag-needed not correctly NATed when mtu
>    transition happens on nat box"
>=20
> I see in the Bugzilla system that there is a fix available but not yet
> tested enough to be implemented.
> Could someone please send me this fix (patch). I'd like to test it
> because today I've discovered that problem too and would like to help if
> possible. Many thanks in advance.

See patch-o-matic: pending/11_inner-icmp-translation-fix.patch=20

I am planning to have this in 2.4.21.

> Gru=DF/Regards
> Willi

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--QLVwfW7TUsi22t4P
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+XQUGXaXGVTD0i/8RAg11AJ4ngWCduvEvdqQb/gyLEcIIQBYpZQCfZyjc
3eoSzIUagFi8r2RgGA+MZTk=
=eYLM
-----END PGP SIGNATURE-----

--QLVwfW7TUsi22t4P--
