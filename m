From: gideon olam <gideon@gideonolam.com>
Subject: Re: RBAC Integration
Date: 28 Jun 2003 00:30:40 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1056781840.16194.17.camel@skinny.gideonolam.com>
References: <1056734756.7156.2.camel@skinny.gideonolam.com>
	 <20030627174010.GB10045@oknodo.bof.de>
	 <1056741347.7156.10.camel@skinny.gideonolam.com>
	 <20030628054834.GC10045@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+mQQ45ARPw1wuKz0OOcl"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20030628054834.GC10045@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-+mQQ45ARPw1wuKz0OOcl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2003-06-27 at 23:48, Patrick Schaaf wrote:
> Hi Joe,
>=20
> > Well,  I was thinking about "role" matches for filters and other policy
> > type matches,  be it MAC or whatever.
>=20
> In the existing RBAC systems, is there already a well defined notion
> of "role" for individual network packets (aka sk_buffs), as they pass
> through the stack?
>=20

The state of network control in the different systems are at varying
levels.   Grsecurity is adding network controls in 2.0.


> > Matches like owner might be able to benefit.
>=20
> That one is obvious. It should be straightforward to do, in that
> case, right? Processes have role tags, the owner match is the
> sole point which knows process context, so process roles could
> be checked by some clone of the owner match.
>=20

This would follow from the above,  if there is already a context for the
objects in the RBAC,  then it follows there would be a role associated
with the object.


> > Userspace could use roles to determine who has what access rights
> > to a table.
>=20
> You mean something like this: who is permitted to modify this or that cha=
in,
> e.g. a userspace role "permitted to set MARKs from 1 to 100 in
> mangle/PREROUTING"?
>=20
> That could be very useful. Also very complex to get all interesting
> criteria (like the MARK range I mention) covered.
>=20

Yes,  but even more simply,  on a secure system root shouldn't have to
manage filters.  The RBAC MAC could control access to the iptables
objects at a more granular level then just read/write. =20

Perhaps even new filters could be checked against some policy to
determine whether or not to apply it.   This could be very useful in a
dynamic firewall application.


> A last comment: an owner like role match, and probably other similar
> things, would better be part of the respective RBAC system. At least
> until the time when that RBAC system is part of the base kernel.
> I don't think that the iptables core implementation could / should
> contain parts useful solely by out-of-kernel patches / modules.
> Maybe patch-o-matic/extra could cope with this.
>=20

Well,  most of these modules are kernel patches and the like.  I suspect
any project would become part of the RBAC's patches to the kernel, an
add-on to the RBAC to provide iptables integration.  That being the
case, the RBAC and how it integrates,  what capabilities are feasible,=20
really depend upon the specific RBAC chosen.  It would be nice if any
interface could satisfy them all,  but I do not think that's realistic
considering the nature of these projects. =20

http://www.rsbac.org
http://www.grsecurity.org
http://www.nasa.gov/selinux

Selinux has some possible patent issues (search google on selinux
patent)  It is available as part of the Hardened Gentoo project (see
below)

RSBAC is used in Adamantix (previously Trusted Debian)
http://www.adamantix.org

GRSecurity is getting more mature and is available as part of the
Hardened Gentoo Project
http://www.gentoo.org/proj/en/hardened/

Most of these can go right on top of any distro,  though some of these
features can break apps on an OS.  For instance, some PaX options in
grsecurity can wreak havoc on XFree,  but it's other adds are sweet,=20
things like IP ID randomization,  TCP Seq randomization,  source port
randomization, pid randomization, etc..


> best regards
>   Patrick

--jrs

--=-+mQQ45ARPw1wuKz0OOcl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQA+/TYPnOx3U+/N6ccRArv2AKCW9E+mxi7Bdlv/KFtfGlyi1EqmcQCfT0l5
CZmidI9k0nswxw2ctTWs0JI=
=KEAE
-----END PGP SIGNATURE-----

--=-+mQQ45ARPw1wuKz0OOcl--
