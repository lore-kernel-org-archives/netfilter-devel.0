From: Harald Welte <laforge@netfilter.org>
Subject: Re: Introducing iptables-snmp...
Date: Wed, 26 Mar 2003 15:59:10 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030326145910.GW21953@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0303191155100.24978-100000@peter.stamf.pr.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lt3WynA+XK9Fj6D4"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Peter Stamfest <peter@stamfest.at>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0303191155100.24978-100000@peter.stamf.pr.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--lt3WynA+XK9Fj6D4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 19, 2003 at 12:02:27PM +0100, Peter Stamfest wrote:
> It also requires iptables-1.2.7a (+a small patch to introduce=20
> "iptc_free" - I would suggest to actually apply this patch to the=20
> iptables-distribution) - it uses the libiptc.a library.

please post this patch here, I would like to include it.=20

if you consider fixing the memory holes, please also post the fixes
here.  thanks.

> peter

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--lt3WynA+XK9Fj6D4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+gcA+XaXGVTD0i/8RAo8RAKCYeTOVeZDfqfMe/RRjMm7XjgFVGQCfc4et
FnaMJk5fXOMR5aVwPQVN26w=
=dyV5
-----END PGP SIGNATURE-----

--lt3WynA+XK9Fj6D4--
