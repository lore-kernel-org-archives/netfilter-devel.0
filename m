From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] LOCAL_IN support for owner match
Date: Thu, 27 Mar 2003 14:12:41 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030327131241.GF25471@sunbeam.de.gnumonks.org>
References: <3E81B60F.1000609@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UFHRwCdBEJvubb2X"
Cc: marc@mbsi.ca,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3E81B60F.1000609@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--UFHRwCdBEJvubb2X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 26, 2003 at 03:15:43PM +0100, Patrick McHardy wrote:
> Hi Marc,
>=20
> this patch adds LOCAL_IN support to the owner match.

makes sense.

> My previous patches which i sent to netfilter-devel had
> problems, namely they didn't knew about tcp sockets
> in TIME_WAIT state so the crashed. This one is tested
> on several computers for some time and seems to work well.

After a quick read through the code, it seems like your implementation
works only for udp and tcp sockets.

In this case, you should make sure that the owner match in INPUT can
only be used if the match did contain '-p udp' or '-p tcp'.

To see example code on how to do so: ECN/DSCP target.

> Regards,
> Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--UFHRwCdBEJvubb2X
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+gvjJXaXGVTD0i/8RAje1AJ9dOoytmmzz4XzbUp7mA8Rf/OYkFgCfU61L
gCaMaHlZpBxlrXo/QIg+ssE=
=osq4
-----END PGP SIGNATURE-----

--UFHRwCdBEJvubb2X--
