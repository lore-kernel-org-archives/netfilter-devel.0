From: Harald Welte <laforge@netfilter.org>
Subject: Re: NAT/MASQUERADING conntrack problem
Date: Wed, 26 Mar 2003 16:31:53 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030326153153.GZ21953@sunbeam.de.gnumonks.org>
References: <200303242138.33213.kimj@dawn.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VvnGyWaJ9JuxX38U"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kim Jensen <kimj@dawn.dk>
Content-Disposition: inline
In-Reply-To: <200303242138.33213.kimj@dawn.dk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--VvnGyWaJ9JuxX38U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 24, 2003 at 09:38:33PM +0100, Kim Jensen wrote:
=20
> My problem is that in my setup I keep loosing control over packets from=
=20
> external origin to my internal servers, it seems like they are getting lo=
st=20
> in the connection tracking part. so my question is - is there a problem i=
n=20
> combining MASQUERADING & [S,D]NAT rules with iptables?

no, not that we are aware of.  your setup should perfectly work.

> Regards
> Kim
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--VvnGyWaJ9JuxX38U
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+gcfpXaXGVTD0i/8RAt07AKCdBxppJuhOptCpDwwEbK0GVih6cgCcC9dK
WACJzNAnccnk7m/TChLo+Xs=
=AfsG
-----END PGP SIGNATURE-----

--VvnGyWaJ9JuxX38U--
