From: Harald Welte <laforge@netfilter.org>
Subject: Re: vlan target for iptables
Date: Fri, 21 Oct 2005 14:17:59 +0200
Message-ID: <20051021121759.GQ27778@sunbeam.de.gnumonks.org>
References: <dd80kc$n5o$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GviraxgP0A7vmYdC"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
Content-Disposition: inline
In-Reply-To: <dd80kc$n5o$1@sea.gmane.org>
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


--GviraxgP0A7vmYdC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 08, 2005 at 05:18:28PM +0100, Amin Azez wrote:
> Please consider this for inclusion in iptables. Should this go in pom?

I would merge it, once I'm sure that it is safe to use ;)

> This adds --vlan target matching for iptables.
> Useful when running as a bridge and perhaps in other cases.
>=20

> I'm afraid I had to steal the vlan packet matching code IS_VLAN_* from
> one of the  vlan modules as it was private to that module.  I hate
> having to do that.

Well, it actually makes sense since you cannot know whether the local
network stack actually has vlan support (and therefore has those
functions for vlan matching).

> For user-space:
>=20
> Just add dump libipt_vlan.c extensions and add vlan to PF_EXT_SLIB
> definition in extensions/Makefile
>=20
> I'm not sending a patch for extensions/Makefile that because it's bound
> to fail applying with all the PF_EXT_SLIB stuff all on one line.

The question is:

What happens with packets that don't have a vlan tag?

In order to alway work, it has to be sure that

1) you can match on all valid vlan tag numbers plus "NONE" for no tag
2) the kernel code produces reasonable results, i.e. also cleanly
   deals with (and matches) packets that don't have a vlan tag.

Cheers,
	Harald
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--GviraxgP0A7vmYdC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDWNx3XaXGVTD0i/8RAjK2AKCMYRFbFNIjZCvaDwvGB4ZfBrbo1gCbBTk/
5NNcAT/Ck1P5nVYYu5jwXK0=
=vDv0
-----END PGP SIGNATURE-----

--GviraxgP0A7vmYdC--
