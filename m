From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] h323 module unloading fix
Date: Wed, 9 Feb 2005 09:24:59 +0100
Message-ID: <20050209082459.GY6878@sunbeam.de.gnumonks.org>
References: <20050208145908.GS6878@sunbeam.de.gnumonks.org>
	<420946FF.107@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nfnKjHknX58/oBIK"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <420946FF.107@trash.net>
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


--nfnKjHknX58/oBIK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 09, 2005 at 12:10:55AM +0100, Patrick McHardy wrote:
> You can initialize helper->list and replace LIST_DELETE by list_del,=20
> then you can avoid the check for list.next.=20

I thought about that for a second, but somehow deferred the idea.
Looking at other options, I think I'll go for that solution.

> But I think splitting the code to evict expectations and expected
> conntracks from ip_conntrack_helper_unregister is a cleaner solution.

Mh, but then every author of a helper would explicitly have to take care
of calling the 'evicting function'.  Considering that any existing
helper, tutorial and other documentation tells him that he doesn't have
to, it's easy to get it wrong and introduce further bugs.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--nfnKjHknX58/oBIK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCCcjbXaXGVTD0i/8RArDxAJ4/FALVGbWcHyUBy7B442QD/68SFQCeIpGd
Zvf6HKQmkF77hJld+3a1gKM=
=aLCT
-----END PGP SIGNATURE-----

--nfnKjHknX58/oBIK--
