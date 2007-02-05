From: Eric Leblond <eric@inl.fr>
Subject: Re: Resend [patch 2/2] iptables: add random option to SNAT
Date: Mon, 05 Feb 2007 16:55:33 +0100
Message-ID: <1170690933.5631.11.camel@localhost.localdomain>
References: <1170681950.5631.4.camel@localhost.localdomain>
	<45C747D9.102@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-8arhKg79Gl8j06k+17m5"
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45C747D9.102@trash.net>
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


--=-8arhKg79Gl8j06k+17m5
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

Le lundi 05 f=E9vrier 2007 =E0 16:06 +0100, Patrick McHardy a =E9crit :
> Eric Leblond wrote:
> I'm in the process of preparing my patches for upstream submission
> (which include your random patch).

Great.

> I'll look into the userspace patch
> after that, I'm not a big fan of the :random syntax.

I make this choice because iptables had the capabilities to have
multiple NAT ranges and hence randomization has to be linked with the
range.

But we can also assume to have a per iptables rule switch. I can rewrite
my patch in this way if you want.

BR,
--=20
=C9ric Leblond, eleblond@inl.fr
T=E9l=E9phone : 01 44 89 46 39, Fax : 01 44 89 45 01
INL, http://www.inl.fr

--=-8arhKg79Gl8j06k+17m5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBFx1N1nxA7CdMWjzIRArVfAJ91rhsmOTM8QYhDeISky5SvGenaogCggJa6
mjEwaScW++2WhipZiMRAnoY=
=31QW
-----END PGP SIGNATURE-----

--=-8arhKg79Gl8j06k+17m5--
