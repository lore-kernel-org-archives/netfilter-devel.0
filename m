From: Harald Welte <laforge@netfilter.org>
Subject: Re: Feasability of Protocol Filtering
Date: Sun, 27 Apr 2003 15:09:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427130952.GJ990@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44+maildir.0304221620090.1447-100000@woozle.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zuGyJ7KNSMOGsxcs"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matt Skidmore <fox@woozle.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44+maildir.0304221620090.1447-100000@woozle.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--zuGyJ7KNSMOGsxcs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2003 at 04:25:11PM -0700, Matt Skidmore wrote:
>=20
> I have gained some interest in adding a new module to the netfilter code
> for filtering by protocol. However, I do not know how realistic this
> project would be. I have not found any projects similar to it as of yet.
> But, I would like to be able to REJECT, DENY, or REDIRECT packets based on
> the protocol of their connection.
>=20
> Examples:
> Identify and DENY SSH traffic regardless of port

You should have a look at libqsearch, which adds a fast pattern matching
library to the linux kernel.

> -Matt

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--zuGyJ7KNSMOGsxcs
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q9agXaXGVTD0i/8RAu9oAKCaC6dNzBr5oqoi9dQ5ZFDCS8rJPwCgr6at
2pJbc2C9dtshb/WqT9o44WY=
=OtTF
-----END PGP SIGNATURE-----

--zuGyJ7KNSMOGsxcs--
