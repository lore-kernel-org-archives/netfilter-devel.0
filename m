From: Oskar Andreasson <oan@frozentux.net>
Subject: --dport in uml crash
Date: Tue, 24 Oct 2006 01:03:45 +0200
Message-ID: <1161644625.8705.16.camel@LAPTOP4.MSHOME>
Reply-To: oan@frozentux.net
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-k38o8tWOt1rSf8cbYbfN"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--=-k38o8tWOt1rSf8cbYbfN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Using UML kernel 2.6.18 and iptables-1.3.6.=20
Specifying iptables -A INPUT -p tcp --dport 23 -j ACCEPT generates a
hard crash of the UML system.=20
-j ACCEPT on it's own works flawless and -p tcp also works flawless, so
i assume it's the --dport causing the crash for some reason.=20

I've been unable to get a look at the error messages since the xterm
closes down before I get a chance to read it (lots of something scrolls
by before closing however), any suggestions on how to get the errors are
welcome, or if anyone else can replicate them would also be welcome :).=20

Let me know if there is any more information that might be needed, or if
this is an UML related bug?


--=20
--
Oskar Andreasson
http://www.frozentux.net
mail/sip: oan@frozentux.net


--=-k38o8tWOt1rSf8cbYbfN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBFPUpQGadwPDPpB60RAv8YAKCz54D3Fqs2Dc/wU3ZAuWjXSnFDhQCgx/b+
/3XZXU8D2AcLwzZBHELTkDc=
=KaeQ
-----END PGP SIGNATURE-----

--=-k38o8tWOt1rSf8cbYbfN--
