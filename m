From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: limit extension
Date: Wed, 20 Jul 2005 16:45:31 +0200
Message-ID: <20050720144531.GA14941@zion.homelinux.com>
References: <42DD417F.4090804@rbw.goe.net> <42DE5C90.70603@rbw.goe.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Michael Schachtebeck <schachti@rbw.goe.net>
Content-Disposition: inline
In-Reply-To: <42DE5C90.70603@rbw.goe.net>
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


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Michael,

On Wed, Jul 20, 2005 at 04:15:44PM +0200, Michael Schachtebeck told us:
> As I could not test the rules that Jan has suggested in his answer to my
> postings (it's a production machine and I couldn't reboot it with a
> patched kernel so far), I did some more testing and discovered a very
> strange behaviour which I believe to be indeed a bug:
>=20

=2E.. <testing snipped>

>=20
> So this seems to be a bug in the kernel's iptables implementation, right?

I think this is "expected behaviour" and it behaves like that
because of the implentation of netfilter.

AFAIK, when you add, delete, replace a iptables rule, at first the
current rules are "downloaded" from kernel, the changes are made in
user space, then the ruleset is "uploaded" again to the kernel.
When uploading, I think that all the internal data structures for the
matches are deleted and then allocated freshly. That's why you see
this behaviour in your testing. When your cronjob runs (or you run
it manually) all the data structures get deleted and newly allocated,
thus the limit rule matches again.

Of course, anybody feel free to correct me if I'm wrong :-)


Regards,

Sven

>=20
> I'm using a 2.6.12.2 vanilla kernel and iptables 1.2.11 (gentoo package
> net-firewall/iptables-1.2.11-r3).
>=20
> Cheers,
>=20
> Michael.

--=20
Linux zion 2.6.13-rc3-mm1 #6 PREEMPT Mon Jul 18 19:42:52 CEST 2005 i686 ath=
lon i386 GNU/Linux
 16:40:37 up 1 day, 20:53,  1 user,  load average: 0.04, 0.01, 0.00

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFC3mOLo4FAdB2PneQRAgr2AJ9gxPSdTD0Cm8LdA05eX5Aikk5tnQCdF60G
O6ZxRsFIp+aCtewBerZ4ddM=
=GU6B
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
