From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Any known issues with iptables-1.3.0 from cvs/svn ?
Date: Mon, 10 Jan 2005 19:04:14 +0100
Message-ID: <1105380254.4514.38.camel@tux.rsn.bth.se>
References: <699F7BBB368A10479166148511F524177A0598@gn-ex01.Go80211.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-4pt5hh9igMyb7iFPWNHH"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>, pablo@eurodev.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Robert Iakobashvili <roberti@GoNetworks.com>
In-Reply-To: <699F7BBB368A10479166148511F524177A0598@gn-ex01.Go80211.com>
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


--=-4pt5hh9igMyb7iFPWNHH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2005-01-10 at 18:23 +0200, Robert Iakobashvili wrote:
> Dear Pablo , Russell,
>=20
> delete-by-specifying-the-complete-rule doesn't work

This has been fixed in svn. Current svn should really work.
A lot of the testcases in nfsim-testsuite uses this and it works fine,
and I just tested it with a fresh compile:

# iptables -A OUTPUT -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 111 --dport 222 -=
j ACCEPT
# iptables -D OUTPUT -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 111 --dport 222 -=
j ACCEPT
#

Works just fine.

--=20
/Martin

--=-4pt5hh9igMyb7iFPWNHH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBB4sOeWm2vlfa207ERAlo5AJ9pq/1t4x70m2Hba81IRySh+yaPaQCggfz9
QJcEcunRkmlTEMnmDL0hkkc=
=Zi49
-----END PGP SIGNATURE-----

--=-4pt5hh9igMyb7iFPWNHH--
