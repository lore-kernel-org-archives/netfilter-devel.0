From: gideon olam <gideon@gideonolam.com>
Subject: Re: RBAC Integration
Date: 27 Jun 2003 13:15:47 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1056741347.7156.10.camel@skinny.gideonolam.com>
References: <1056734756.7156.2.camel@skinny.gideonolam.com>
	 <20030627174010.GB10045@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1IEg3ZjalmyTF4Mf097P"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20030627174010.GB10045@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-1IEg3ZjalmyTF4Mf097P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2003-06-27 at 11:40, Patrick Schaaf wrote:
> On Fri, Jun 27, 2003 at 11:25:56AM -0600, gideon olam wrote:
> > Are there any plans to provide integration between iptables and the
> > various rule based access control architectures available on the Linux
> > platform such as RSBAC, grsecurity or selinux?
>=20
> I cannot remember any discussion on that on this list. Care to elaborate
> what you imagine?
>=20
> best regards
>   Patrick (who knows those projects exist...)
>=20

Well,  I was thinking about "role" matches for filters and other policy
type matches,  be it MAC or whatever.  Userspace could use roles to
determine who has what access rights to a table.   Matches like owner
might be able to benefit.  I would think there would be a large variety
of implications for integration.

Joe Saland, CISSP
gideon#gideonolam.com

--=-1IEg3ZjalmyTF4Mf097P
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQA+/JfjnOx3U+/N6ccRAj1tAJsHVQTfXKPTlkX8SCwUeNlH3gA64QCbBuoi
3/Hmmr0ztczj/StxZbaQDkk=
=9YGE
-----END PGP SIGNATURE-----

--=-1IEg3ZjalmyTF4Mf097P--
