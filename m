From: Harald Welte <laforge@netfilter.org>
Subject: Re: Regarding LIBIPQ problem
Date: Wed, 5 Apr 2006 17:31:16 +0200
Message-ID: <20060405153116.GK20558@sunbeam.de.gnumonks.org>
References: <1411.10.12.25.5.1143825446.squirrel@gpo.iitb.ac.in>
	<859616420604010236j1048f16anbe3edaa8b6967244@mail.gmail.com>
	<4854.10.12.25.5.1143978508.squirrel@gpo.iitb.ac.in>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bg2esWel0ueIH/G/"
Cc: netfilter-devel@lists.netfilter.org, David Vogt <beunlovable@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Vasantha Kumar Puttappa <vasanthakumar@iitb.ac.in>
Content-Disposition: inline
In-Reply-To: <4854.10.12.25.5.1143978508.squirrel@gpo.iitb.ac.in>
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


--Bg2esWel0ueIH/G/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 02, 2006 at 05:18:28PM +0530, Vasantha Kumar Puttappa wrote:
> Hi David,
>   Thanx for your response.
>   Actually I did use "ntohs" in the actual code.
>   Anyhow I tested same code in kernel-2.6.11-6mdk and it's working fine,
> although i am receiving multiple copies at the receiver.
>=20
>   Do you have any idea of kernel version in which "libipq" works properly
> withoug any problem.

I'm not aware of any libipq/kernel versions that have problems.

Also, try using libnetfilter_queue / nf_queue for new code, rather than
ip_queue, which has already been in feature-removal-schedule for quite
some time.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Bg2esWel0ueIH/G/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFEM+LEXaXGVTD0i/8RAupNAJ0VhCiYCjLZU7IdN0PM+2VA5A5PmgCeNQ/9
t2B5MuV0kml/Dd1AtyVbiGo=
=aK2+
-----END PGP SIGNATURE-----

--Bg2esWel0ueIH/G/--
