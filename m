From: Harald Welte <laforge@netfilter.org>
Subject: Re: Basic API Question
Date: Thu, 26 Jun 2003 12:16:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030626101606.GM2645@sunbeam.de.gnumonks.org>
References: <1056613186.8171.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5AMDinkw1evBROKu"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Paul J. Caritj" <pcaritj@riovia.net>
Content-Disposition: inline
In-Reply-To: <1056613186.8171.11.camel@localhost.localdomain>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--5AMDinkw1evBROKu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 26, 2003 at 03:39:46AM -0400, Paul J. Caritj wrote:
> Geetings,
> I am trying to accomplish a very simple task: the addition, removal, etc
> of iptables rules through C.=20

unfortunately due to the current iptables architecture this is not an
easy task :(

> I have found ample documentation on developing modules, etc, but
> nothing to answer this basic question.=20
>=20
> Does such an interface exist or will I basically have to pipe out shell
> commands (eew)?

no, unfortunately not. You will have to execute shell commands.  If you
have lots of changes, you might want to try piping into stdin of
'iptables-restore --noflush'

> Thanks all,
> Paul

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--5AMDinkw1evBROKu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++sfmXaXGVTD0i/8RAnfaAJ93LJJXaeYxR64+A3hQEFshhSGk3QCfQcin
wIll3UiY7cX61QJ0/svlu0Y=
=5IaH
-----END PGP SIGNATURE-----

--5AMDinkw1evBROKu--
