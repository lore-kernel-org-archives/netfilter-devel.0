From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Critical bug fix in ROUTE target
Date: Sun, 2 Mar 2003 11:08:14 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030302100814.GD2296@naboo.clug.de>
References: <1046425749.28135.56.camel@descartes.info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="at6+YcpfzWZg/htY"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Cedric de Launois <delaunois@info.ucl.ac.be>
Content-Disposition: inline
In-Reply-To: <1046425749.28135.56.camel@descartes.info.ucl.ac.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--at6+YcpfzWZg/htY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 28, 2003 at 10:49:10AM +0100, Cedric de Launois wrote:
> Here is a patch fixing a critical bug in the ROUTE target, in
> the --gw option. A packet was released twice when the target
> failed to route it.
>=20
> Patch against the current cvs tree.

thanks, patch applied.

> Question for Harald : when do you intend to release a new version
> of iptables ? Because iptables-1.2.7a does not support the ROUTE
> target contained in the latest pom, and people are complaining to
> me :( , and the daily snapshot for iptables is not working for several
> month now...

I know, I know.  I've been planning to release 1.2.8 for about a month
now.  There are a couple of issues (see CURRENT_ISSUES) which have to be
resolved before I can make the feature freeze and finally release it.

I've been busy with other work during the last couple of weeks,
includign several kernel-space bugfixes (see my recent patch submissions
to david miller, bugzilla activity, patch-o-matic changes).

> C=E9dric

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--at6+YcpfzWZg/htY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+YdgOXaXGVTD0i/8RAtERAKCx+bv+FfXS8pKxFJT5cNF0Wh/udQCfa6Mx
Te797BNg4kpHwlDlXJUinlE=
=+2/o
-----END PGP SIGNATURE-----

--at6+YcpfzWZg/htY--
