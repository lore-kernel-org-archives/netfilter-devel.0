From: Christian Hentschel <chentschel@arnet.com.ar>
Subject: Help with ip_nat_mangle..
Date: Thu, 28 Apr 2005 23:01:47 -0300
Message-ID: <1114740108.1940.15.camel@www.l-chr.com.ar>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-v1yvrwuSq8Wj+6QsG1tR"
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


--=-v1yvrwuSq8Wj+6QsG1tR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,
	I'm writing a SIP conntrack/nat helper for 2.6.11 (almost done), but as
i need to mangle skbuff several times, i need some help/info about it.=20
Can please someone explain skbuff mangle. I see that it does not mangle
skbuff immediately.
My problem is after mangling skbuff data, i need to search a string
again in it, and as  skbuff is not mangled as i thought i get the wrong
offset of the string in the buffer.

Thanks in advance.!.=20


--=20
Christian Hentschel <chentschel@arnet.com.ar>

--=-v1yvrwuSq8Wj+6QsG1tR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBCcZWL/jxG54BC3LgRAkNxAKCejprZ3iXWom9UGRxLzmArzscYdACfSm7u
hKDxwdmTJFloJvnI1ZTug1s=
=Nu56
-----END PGP SIGNATURE-----

--=-v1yvrwuSq8Wj+6QsG1tR--
