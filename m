From: Harald Welte <laforge@netfilter.org>
Subject: Re: NAT Server Performance, SMP box or Single CPU box?
Date: Tue, 4 Jan 2005 12:05:31 +0100
Message-ID: <20050104110531.GW11370@sunbeam.de.gnumonks.org>
References: <41D00A42.5080305@itcsoluciones.com>
	<41D2ADE9.4050104@itcsoluciones.com>
Reply-To: netfilter@lists.netfilter.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OKFp/nMBquCu/qa9"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Donato Diaz <donatodd@itcsoluciones.com>
Content-Disposition: inline
In-Reply-To: <41D2ADE9.4050104@itcsoluciones.com>
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


--OKFp/nMBquCu/qa9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 29, 2004 at 10:15:21AM -0300, Donato Diaz wrote:
> Hello,
> I have read in different lists that some people are having problem doing=
=20
> NAT with SMP Servers, due to the way the kernel manage conntrack with=20
> both CPUs.

this isn't a development question. Please follow-up to
netfilter@lists.netfilter.org

> NAT runs slower on Server SMP with two CPUs?

no, but the gain is not something like 'twice the performance'. =20

with networking, your i/o subsystem (64bit, pci-x, fast RAM, ...) is way
more important than cpu speed.

> Thanks all,
> Donato.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--OKFp/nMBquCu/qa9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB2nh7XaXGVTD0i/8RAg5uAKCJZA05nLiN89kI6uSyR6bnCzsX8gCgqf3k
F9Y6Dhnl9Wx6xD0Slo7vHeM=
=gn+2
-----END PGP SIGNATURE-----

--OKFp/nMBquCu/qa9--
