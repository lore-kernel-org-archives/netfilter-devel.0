From: "Harald Welte" <laforge@netfilter.org>
Subject: Re: [Bug 1764] New: conntrack oops while reading /proc/net/ip_conntrack
Date: Mon, 29 Mar 2004 16:42:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <01db01c415a4$7620d6e0$d100000a@sbs2003.local>
References: <11020000.1072813876@[10.10.2.4]> <20040103152921.76d4362e.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed;
	micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="GLp9dJVi+aaipsRk"
Content-Transfer-Encoding: 7bit
Cc: "Martin J. Bligh" <mbligh@aracnet.com>,
	<linux-kernel@vger.kernel.org>,
	<christophe@saout.de>,
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <Administrator>
Content-Class: urn:content-classes:message
Content-Disposition: inline
In-Reply-To: <20040103152921.76d4362e.rusty@rustcorp.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

--GLp9dJVi+aaipsRk
Content-Type: text/plain;
	charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 03, 2004 at 03:29:21PM +1100, Rusty Russell wrote:
> Um, Harald, other developers,
>=20
> 	Shouldn't list_conntracks do
> READ_LOCK(&ip_conntrack_expect_tuple_lock) before walking the
> expect list?

Thanks Rusty, indeed it should.

> Here's a patch.  Does it do anything?

To the bug reporter(s): Please give feedback on that patch.

> Rusty.
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--GLp9dJVi+aaipsRk
Content-Transfer-Encoding: 7bit
Content-Type: application/pgp-signature;
	name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/+AYIXaXGVTD0i/8RAnY0AJ0SCJ1aoZmzACMgRKkvheAaziMFIQCbBu/P
q1syJbvMF8fC9yX+/tUjax8=
=8qri
-----END PGP SIGNATURE-----

--GLp9dJVi+aaipsRk--
