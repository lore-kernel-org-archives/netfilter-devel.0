From: Harald Welte <laforge@netfilter.org>
Subject: Re: conntrack and kernel log
Date: Wed, 7 May 2003 17:00:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030507150044.GN6702@sunbeam.de.gnumonks.org>
References: <3EB91241.8070209@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pN9MePJoZbRKbUk1"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Eicke Friedrich <tady@gmx.net>
Content-Disposition: inline
In-Reply-To: <3EB91241.8070209@gmx.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--pN9MePJoZbRKbUk1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 07, 2003 at 04:03:45PM +0200, Eicke Friedrich wrote:

> How comes that the size per conntrack is at the first box smaller even=20
> though CONNMARK is installed? I mean it uses some bytes more per entry=20
> for the mark=3D field? Is it due to two CPU's? Sorry for this newbie=20
> question but googlin' did not gave me an answer.

It's because of the connection tracking helpers or nat helpers you have
or have not patched into your kernel.  (it also makes a difference
whether or not NAT is disabled or not.

> Thanks for any comments,
> Eicke.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--pN9MePJoZbRKbUk1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+uR+cXaXGVTD0i/8RAudWAKCkeAED2UgO8YdmC81znFyOsqjL4ACdG8Y/
C+8aR6YFDhdAg079noMUv/I=
=fT+y
-----END PGP SIGNATURE-----

--pN9MePJoZbRKbUk1--
