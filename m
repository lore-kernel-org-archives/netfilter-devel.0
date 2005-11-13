From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Link netfilter before ipv4.
Date: Sun, 13 Nov 2005 10:59:23 +0100
Message-ID: <20051113095923.GF17476@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.64.0511120202080.26844@bizon.gios.gov.pl>
	<200511130810.jAD8AiE7003388@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XStn23h1fwudRqtG"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200511130810.jAD8AiE7003388@toshiba.co.jp>
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


--XStn23h1fwudRqtG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 13, 2005 at 05:10:43PM +0900, Yasuyuki KOZAKAI wrote:

> Good catch! But that patch seems not to able to apply current tree becaus=
e of
> Hunk. Harald, could you apply attached patch instead ?

Yes.  Please include a proper Signed-off-by: line from the original
author (if there was any), or at least mention him in the commit message
as the bug reporter.

I've fixed this up with this one, but please take care of this in future
patches.

Thanks!

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--XStn23h1fwudRqtG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDdw57XaXGVTD0i/8RAtMHAKCc+emxVgoEZDv7iWi8Wbm0gr0maACffYok
3zrNcMt9HzCCF/+YSiS1xQ4=
=bCQC
-----END PGP SIGNATURE-----

--XStn23h1fwudRqtG--
