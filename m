From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH] Set mark to 0 from libnetfilter_conntrack
Date: Fri, 27 Oct 2006 23:17:13 +0200
Message-ID: <1161983833.16181.6.camel@localhost>
References: <1161801498.12718.22.camel@localhost> <453FF539.3020107@trash.net>
	<1161898638.7358.22.camel@localhost.localdomain>
	<45420F5B.8090504@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-4EdATqnYtaMUCfpd2+++"
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, haypo@inl.fr,
	Patrick McHardy <kaber@trash.net>, vincent@inl.fr
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <45420F5B.8090504@netfilter.org>
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


--=-4EdATqnYtaMUCfpd2+++
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

Le vendredi 27 octobre 2006 =E0 15:53 +0200, Pablo Neira Ayuso a =E9crit :
> Eric Leblond wrote:
> > What's the status of this new API ? Current status of
> > libnetfilter_conntrack code is really disappointing.
>=20
> Indeed, you can blame me for that. I'm working on the new API that I'll=20
> try to release asap. I'm going to put this in my high priority queue.

That's good news !

>=20
> > We at INL are currently working on using libnetfilter_conntrack to
> > provide tools for firewall administrators. The first one
> > pynetfilter_conntrack is already available and a web management
> > interface will soon be released. By doing this we are trying to improve
> > the usability of this new system.
>=20
> I'd like to see your python binding in the libnetfilter_conntrack tree=20
> but I have to fix some stuff before, please consider that this would=20
> require some extra work from your part.

No problem. We really think it's the correct place for this code and it
will worth the work to put it there.

>=20
> > We are doing this because we think the new features provided by
> > libnetfilter_conntrack really improve a lot the way we use and "live"
> > with a Netfilter firewall.
>
> I already commented what my intentions are: add more new API, do not=20
> remove the old one but mark it as deprecated, strongly recommend people=20
> to move to the new API. The deprecated API will be removed after quite=20
> some time.

Is it possible to introduce a version number of the API in a #define to
be able to do some conditional compilations ?

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-4EdATqnYtaMUCfpd2+++
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBFQndZnxA7CdMWjzIRAreUAJ470kkgzwy7zvlypkahZd/vMeGtkQCdFTRN
tGq8jeyGuUrXRAM3J3EsGqU=
=Xh0p
-----END PGP SIGNATURE-----

--=-4EdATqnYtaMUCfpd2+++--
