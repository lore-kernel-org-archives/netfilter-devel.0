From: Stephen Frost <sfrost@snowman.net>
Subject: Re: ipt_recent patch
Date: Wed, 22 Mar 2006 09:26:36 -0500
Message-ID: <20060322142636.GF4474@ns.snowman.net>
References: <dt51lh$b63$1@sea.gmane.org> <43F9EA77.4060208@ufomechanic.net>
	<44096532.2070000@trash.net> <440DAB6B.4020208@ufomechanic.net>
	<440ECB1B.4070507@trash.net> <4415B019.6050409@ufomechanic.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e/S+UvxZ7d2xayYf"
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
Content-Disposition: inline
In-Reply-To: <4415B019.6050409@ufomechanic.net>
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


--e/S+UvxZ7d2xayYf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Amin Azez (azez@ufomechanic.net) wrote:
> This patch has some sort of versioning built in so that the new userland=
=20
> features are not enabled unless built against a new header file.
>=20
> If a new kernel module is called with rules by old userland, then it=20
> refuses to accept the rule.

Works for me.

> Changes:
> * /proc/net/ipt_recent/* is sorted by age, most recent first
> * include Per Hedelands patch in message=20
> <200603062203.k26M3pI5024778@tordmule.bluetail.com>
> * fix problem of not moving up list entries after deleting entries which=
=20
> meant that sometimes you could never fill the list
> * fix problems of items with hash of 0 being erased whenever an empty=20
> slot is used

These changes look good.  The sorting by age makes sense though isn't
entirely necessary.  The fixes are good, sorry I didn't consider the
case where the hash result was 0. :/

> * Add these new features:

I don't really see the use-case for these new options...  Perhaps if it
was combined with an IP mask of some kind, ie: packets from 5 IPs in the
same /24 in the last 60 seconds, or some such.  That could also be
accomplished by providing a way to tell ipt_recent to look for a mask
instead of individual IPs though.  ie: For this table, consider any IPs
in the same /24 to be the 'same' IP.

Anyway, they don't really affect how the module works as they just add
additional ways to check on the data stored in the tables, so I'm not
strongly against them just don't entirely see the point.

	Thanks,

		Stephen

--e/S+UvxZ7d2xayYf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFEIV6brzgMPqB3kigRAiA9AJ9NGJgJbAjdarb/Bj5weZvgXX519wCfeokO
HOlb9f5By2Ln4ch11BOXgbA=
=sa44
-----END PGP SIGNATURE-----

--e/S+UvxZ7d2xayYf--
