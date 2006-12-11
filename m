From: Tom Eastep <teastep@shorewall.net>
Subject: Re: iptables extension removal
Date: Mon, 11 Dec 2006 11:29:10 -0800
Message-ID: <457DB186.4040006@shorewall.net>
References: <457DAF95.2050203@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig92ECC47202E6F830DCC88134"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <457DAF95.2050203@trash.net>
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

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig92ECC47202E6F830DCC88134
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Patrick McHardy wrote:
> We have decided to remove extension for obsolete/out-of-tree
> patches from iptables, moving the extensions for patches
> maintained in pom or external repositories to the individual
> patchlets and deleting the rest.
=2E..
> libipt_iprange.c		move to pom

Patrick,

Is ipt_range.c also moving from the main kernel tree to POM?

-Tom
--=20
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key


--------------enig92ECC47202E6F830DCC88134
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFfbGMO/MAbZfjDLIRAjHHAKCaXSYgT04VODvKsbQX4rEtJdUQmQCfQ5L7
L+zOBs6hX3WU3m55QilpFMs=
=jfqx
-----END PGP SIGNATURE-----

--------------enig92ECC47202E6F830DCC88134--
