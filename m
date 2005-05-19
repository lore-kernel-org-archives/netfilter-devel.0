From: Stephen Frost <sfrost@snowman.net>
Subject: Re: [PATCH] ipset type "expire"
Date: Thu, 19 May 2005 11:04:06 -0400
Message-ID: <20050519150406.GH30011@ns.snowman.net>
References: <20050519132414.GH6159@clifford.at>
	<Pine.LNX.4.58.0505191553010.12421@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5Wo9T3dGHPT+4OQz"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0505191553010.12421@blackhole.kfki.hu>
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


--5Wo9T3dGHPT+4OQz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Jozsef Kadlecsik (kadlec@blackhole.kfki.hu) wrote:
> | A new set type called 'iptree' (inspired and triggered by Clifford
> | Wolf) added, which makes possible to store IP addresses which
> | automatically time out. Please note, this is an initial new feature with
> | some hardcoded parameter (like the frequency of garbage collection) and
> | thus may change in the future.
>=20
> Sorry for not letting you directly about the decision.

Stupid question, does this now do everything ipt_recent does but better?
I certainly don't mind my module being depreciated in favor of this
provided it's better/faster/etc.  ipt_recent didn't need to implement
garbage collection, but perhaps that means you're able to support a
larger number of IP addresses than ipt_recent could?  Is it hash-based?
Are the set/check/update rules able to do the same thing?

	Thanks,

		Stephen

--5Wo9T3dGHPT+4OQz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCjKrmrzgMPqB3kigRAufcAKCTFgCOlwYNVGahCMN0/azEWawpFwCdEUJV
ryJgeHKmBbDDrNiKOpRFfkY=
=AQKb
-----END PGP SIGNATURE-----

--5Wo9T3dGHPT+4OQz--
