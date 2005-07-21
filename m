From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] conntrack-event-api
Date: Wed, 20 Jul 2005 20:18:07 -0400
Message-ID: <20050721001807.GB4384@rama.eicat.ca>
References: <20050719201646.GH3768@rama> <42DE0F2A.5050609@tac.ch>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
Content-Disposition: inline
In-Reply-To: <42DE0F2A.5050609@tac.ch>
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


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 20, 2005 at 10:45:30AM +0200, Roberto Nibali wrote:
> > Here's a revamped conntrack-event-api patch.  Instead of using
> > skb->nfcache, we now use a per-cpu data structure.  This saves 32bit in
> > sk_buff.
>=20
> I see that netconf really gets the ball rolling ;).

yup.

> > +	if (unlikely((struct ip_conntrack *) skb->nfct !=3D ecache->ct)) {
> > +		if (net_ratelimit()) {
> > +			printk(KERN_ERR "ctevent: skb->ct !=3D ecache->ct !!!\n");
>=20
> Not important, but: s/skb->ct/skb->nfct/ and could you maybe drop the
> !!!'s? ;)

ok, I'll make that cosmetic change once it shows up in dave's 2.6.14
tree.

> > +			dump_stack();
>=20
> Is this trace reliable regarding per-CPU structures?

? Those structues are not in the stack. =20

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC3um+XaXGVTD0i/8RAqMNAJ9NDAtRsGtub7tiKqpoNhJj+OMW1wCfc+Lt
Oa+cHswlno6Uinds6DdhFrk=
=/56U
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--
