From: Harald Welte <laforge@netfilter.org>
Subject: Re: logging suggestion
Date: Sun, 27 Apr 2003 14:49:49 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427124949.GB990@sunbeam.de.gnumonks.org>
References: <3EA2DAFF.6010801@linux.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYtRAvLPyLojxZ7Y"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "N.Kursu" <kursu@linux.se>
Content-Disposition: inline
In-Reply-To: <3EA2DAFF.6010801@linux.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--zYtRAvLPyLojxZ7Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 20, 2003 at 07:38:07PM +0200, N.Kursu wrote:
> Hi ppls!
>=20
> Why not let iptables/netfilter specify where it should put the logging=20
> output. Now it defaults to syslog, but in the end... the logs get really=
=20
> really huge if you log many things with iptables.

this is why the ULOG target and ulogd were invented more than two years
ago.

see http://gnumonks.org/projects/ulogd


> Niklas Kursu
> kursu@linux.se

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--zYtRAvLPyLojxZ7Y
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q9HtXaXGVTD0i/8RAoo/AJ984qDgGTUeEXiNkrYYiy2bEOjN3gCcC+79
A1ZtRopkXcQDgoWL99nLzZE=
=vNCU
-----END PGP SIGNATURE-----

--zYtRAvLPyLojxZ7Y--
