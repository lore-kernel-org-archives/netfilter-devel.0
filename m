From: Alexander Samad <alex@samad.com.au>
Subject: Re: Problem with apply patch connlimit to 2.6.10 (debian 2.6.10-6)
Date: Sat, 26 Mar 2005 12:22:46 +1100
Message-ID: <20050326012246.GG10616@samad.com.au>
References: <20050325234332.GD10616@samad.com.au>
	<20050326001504.GE10616@samad.com.au>
	<20050326011742.GA4239@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XRI2XbIfl/05pQwm"
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050326011742.GA4239@linuxace.com>
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


--XRI2XbIfl/05pQwm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 25, 2005 at 05:17:42PM -0800, Phil Oester wrote:
> On Sat, Mar 26, 2005 at 11:15:04AM +1100, Alexander Samad wrote:
> > > I have had a look in include/linux/netfilter_ipv4/ip_conntrack.h  and=
 it
> > > seems like the structure has gone  and I am not sure what else I need=
 to
> > > apply to make it compile.
> >=20
> > I noticed on bugszilla there is an open bug about connlimit not
> > compiling on 2.6.11 (Bugzilla Bug 317) and the patch seems to remove any
> > access to infos !  Should i be using the patch attached to this bugzilla
>=20
> Yes, although 317 is a dupe of 268.  The fix is already applied to the=20
> 2.6.11 branch of POM-NG.
So does this mean I have to wait for the debian 2.6.11 source package,
as the current one is 2.6.10-6

>=20
> Which raises the question (Harald?) - can we now make the 2.6.11 branch
> the primary one?
>=20
> Phil
>=20
>=20

--XRI2XbIfl/05pQwm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCRLlmkZz88chpJ2MRAqykAKCZX2nqle6ITUb2AQ118jXHItW7ZQCgrHpZ
TgXLrS7r6PhCabJed826U8Y=
=Cvnr
-----END PGP SIGNATURE-----

--XRI2XbIfl/05pQwm--
