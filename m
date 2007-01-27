From: =?windows-1252?q?R=E9mi_Denis-Courmont?= <rdenis@simphalempin.com>
Subject: Re: [NETFILTER]: ip6_tables: Support MH match.
Date: Sat, 27 Jan 2007 17:34:42 +0200
Message-ID: <200701271734.46876@auguste.remlab.net>
References: <200701260953.l0Q9rvv9022736@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4218675.MdaPK2Gyvh";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200701260953.l0Q9rvv9022736@toshiba.co.jp>
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

--nextPart4218675.MdaPK2Gyvh
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

	Hello,

Le vendredi 26 janvier 2007 11:53, Yasuyuki KOZAKAI a =E9crit :
> MH is defined as extention header in RFC3775, but this patch handles
> it as layer 4 protocol header like ICMPv6 header.
>
> The reasons are
> - The reason why it's defined as extentin header is mainly for
>   'piggy back'. But that feature was not specified in RFC3775 after
> all. - No header follow MH. RFC3775 says
> 	Implementations conforming to this specification SHOULD set
> 	the payload protocol type to IPPROTO_NONE (59 decimal).

What happens if a node (including a non-Linux one) receives a MH packet=20
with a non-none next protocol? I might be wrong, but I would assume it=20
parses it, at least in some cases.

If this is trye, this patch might introduce a trivial way to evade=20
firewall rules, as firewall admins will assume the next protocol is=20
none, while it might not be.

Of course, I could be plain wrong, since I do not know MH.

> - Many parts in RFCs assume that it's like layer 4 protocol header.
> - Actually Linux IPv6 stack, XFRM, setkey, iproute2... handle it as
> if it's layer4 protocol.

Slightly off-topic, but anyway, what about socket() syscall - can you=20
create a IPPROTO_MH raw socket with it?

=2D-=20
R=E9mi Denis-Courmont
http://www.remlab.net/

--nextPart4218675.MdaPK2Gyvh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEYEABECAAYFAkW7cRYACgkQw+xtvt1tEr0aVgCcCnk7CCPwJ8/LchIvLmKcvDeK
n5UAn3j5J5HpzB7yrOu7iG/Ih3OCFj+a
=JqPD
-----END PGP SIGNATURE-----

--nextPart4218675.MdaPK2Gyvh--
