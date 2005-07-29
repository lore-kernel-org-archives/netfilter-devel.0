From: Harald Welte <laforge@netfilter.org>
Subject: Re: Bug Report: IPtables 1.2.* segfaulted by iptables 1.3.*
Date: Fri, 29 Jul 2005 12:58:34 +0200
Message-ID: <20050729105834.GD7063@rama.de.gnumonks.org>
References: <9927912d05072704113d7e8707@mail.gmail.com>
	<e756d62eb5442015@mayday.cix.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xB0nW4MQa6jZONgY"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Robert de Bath <list-netfilter@debath.co.uk>
Content-Disposition: inline
In-Reply-To: <e756d62eb5442015@mayday.cix.co.uk>
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


--xB0nW4MQa6jZONgY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 28, 2005 at 11:53:49AM +0100, Robert de Bath wrote:
> Hi all,
> I've been mixing iptables 1.2.8/1.2.11 and 1.3.1/2 tools and unlike I wou=
ld=20
> expect I know that the tables created by 1.3.x tools will segfault any 1.=
2.x=20
> based tool that's later runon the table.

mh, mixing multiple versions of the tools is a bad idea anyway.  We have
other issues with this as well (one has been added to INCOMPATIBILITIES
recently).

> Is there any reason iptables-1.3 couldn't be changed so it doesn't crash=
=20
> version 1.2.x, I assume by putting the sort order back as it was ?

If the fix is non-intrusive and doesn't reaquire a lot of additional
computational complexity, I would accept such a patch.  Otherwise I
don't really think it's worth supporting such a setup.  Usually you have
one version of iptables installed, not multiple.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--xB0nW4MQa6jZONgY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC6gvaXaXGVTD0i/8RAnh3AKCl3/esWzPe6paSDluT1CK51mt4nACgnxmu
68NFL+Sw/3lAqSezm6TxIPw=
=C8pp
-----END PGP SIGNATURE-----

--xB0nW4MQa6jZONgY--
