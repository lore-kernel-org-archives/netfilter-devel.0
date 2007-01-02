From: Tom Eastep <teastep@shorewall.net>
Subject: Re: MARK targets all non-terminating
Date: Tue, 02 Jan 2007 10:25:54 -0800
Message-ID: <459AA3B2.4010008@shorewall.net>
References: <Pine.LNX.4.61.0701021838580.4001@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig1EAAF24C81794248C687A441"
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0701021838580.4001@yvahk01.tjqt.qr>
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
--------------enig1EAAF24C81794248C687A441
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Jan Engelhardt wrote:

>=20
> This non-terminating behavior of [file list] is _NOT_ documented in the=
=20
> iptables manpage. Is it even intended at all?
>=20

A couple of observations:

a) This non-terminating behavior has been around since the MARK targets f=
irst
   appeared so existing tools and scripts depend on it. As an example, if=

   "-j MARK" were suddenly terminating, most current uses of
   "-j CONNMARK --save-mark" would cease working since they typically
   follow matching "-j MARK" rules.
  =20
c) ebtables provides a nice solution which allows "-j mark" to be either
   terminating (the default), or non-terminating depending on the
   inclusion of a "--mark-target" phrase. That would be a nice addition
   to the iptables MARK targets, so long as the default was CONTINUE
   rather than ACCEPT.

-Tom=20
--=20
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key


--------------enig1EAAF24C81794248C687A441
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFmqOyO/MAbZfjDLIRAjz8AJ93Ynd8nGxjy4yUMM38+WX733VlpwCeKnL+
9dsol4UZzkdbcVvVw+TafkQ=
=1CMg
-----END PGP SIGNATURE-----

--------------enig1EAAF24C81794248C687A441--
