From: Eric Leblond <eric@regit.org>
Subject: RE: A humble proposal
Date: Fri, 26 Sep 2003 09:21:58 +0200
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <1064560917.3997.26.camel@porky>
References: <7C9884991ADAE0479C14F10C858BCDF5122E53@alderaan.smgtec.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vg8VmcECxMvwwnLuhHBZ"
Cc: firewalldude@newkirk.us, netfilter@lists.netfilter.org,  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-admin@lists.netfilter.org>
To: Daniel Chemko <dchemko@smgtec.com>
In-Reply-To: <7C9884991ADAE0479C14F10C858BCDF5122E53@alderaan.smgtec.com>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org


--=-vg8VmcECxMvwwnLuhHBZ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le ven 26/09/2003 =C3=A0 02:19, Daniel Chemko a =C3=A9crit :
> I had a thought about this, and I see a lot of work taking this
> approach.
>=20
> How about this:
>=20
> Write a jump target that applies only inside the filter table, since the
> first revision would just implement filtering control.
>=20
> The module itself would be initialized by a userspace tool be adding
> rules. An example would be:
>=20
> iptables -I INPUT -m expire --expire-condition timer=3D6000 --expire-id
> 12123124325 --source 192.168.1.1/24 -j ACCEPT
> iptables -I OUTPUT -m expire --expire-condition timer=3D6000 --expire-id
> 12123124326 --destination 192.168.1.1/24 -j ACCEPT

Great, but Have you any idea of the induced overload ? (I've never work
with dynamic rules).

> - The CONNTRACK entries for the allowed sessions are not dropped. Once
> again, it would be nice if the jump module could clean up the CONNTRACK
> entry.
> My humble suggestion would be that this should be handled in the
> stateful
> connection tracking - If a session is authenticated and certain
> connections
> allowing different chains to be traversed based on the mark found.

=46rom my point of view this is a good idea for a mono user machine land.
But I think this appproach is for more too restrictive and too unsecure.

First, lot's of people use "terminal server" (X remote server, rdesktop,
cytrix,...) so you've got different people coming from the same IP who
should have dissociated IPs. In such a case, the permissions of these
users is the sum of the permissions of all users. It's really unsecure.

Second, you encounter harsh limitation with Full multiuser server. It's
a nice security feature to be able to say for example :
  - Clamav daemon can connect directly to sites providing antivirus
pattern update
  - Other users can't go directly out by http.
It's a small example taken from my test environnement of NuFW, but I
think it shows what can be done.

BR,
--=20
Eric Leblond
Nufw, Now User Filtering Works (http://www.nufw.org)

--=-vg8VmcECxMvwwnLuhHBZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e=2E?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/c+kVnxA7CdMWjzIRAv6DAJ9l+mrTL1+3sgRmn+hkKyV1prQxwwCfbeN0
TDFv8yu/ruiIv1zAnmpeKPQ=
=V2vm
-----END PGP SIGNATURE-----

--=-vg8VmcECxMvwwnLuhHBZ--
