From: Harald Welte <laforge@netfilter.org>
Subject: Re: Bug (?) in ipt_reject doesn't follow policy routing (2.4.x)
Date: Tue, 15 Apr 2003 09:40:49 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030415074049.GX6866@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.21.0304141317090.763-100000@debian.besselink> <3E9B2398.8020109@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mln0rGgUGuXEqmuI"
Cc: leen@wirehub.nl, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3E9B2398.8020109@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--mln0rGgUGuXEqmuI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 14, 2003 at 11:09:44PM +0200, Patrick McHardy wrote:

> @netfilter-people: would something like this be acceptable ? REJECT and=
=20
> MIRROR (which looks broken wrt ip_route_output and dst handling) need
> something like this to work correctly with policy routing.

I don't see a problem with your patch.  Please note, however, that I am
not very familiar with the linux routing code - so I feel a bit unable
to make that decision.

We should talk to David Miller about this issue.  Could you please write
a short summary like 'old behaviour was X and we had Problem Y with it,
now we try to fix it with this patch doing Z'?  I would then put the
patch together with this summary (as .help file) in patch-o-matic
pending and discuss it with davem.

> Bye
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

--mln0rGgUGuXEqmuI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+m7eBXaXGVTD0i/8RAmFqAJ9byVL2mCkrwt8ZEeIbMtVILi5EvgCfejlg
xkkwpnqztUhlndUtiEtp27M=
=Rov7
-----END PGP SIGNATURE-----

--mln0rGgUGuXEqmuI--
