From: Alexander Samad <alex@samad.com.au>
Subject: Re: [RFC, PATCH 5/5]: netfilter+ipsec - policy checks
Date: Fri, 19 Mar 2004 17:31:43 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040319063143.GC29442@samad.com.au>
References: <20040308110331.GA20719@gondor.apana.org.au> <404C874D.4000907@trash.net> <20040308115858.75cdddca.davem@redhat.com> <4059CF27.4030803@trash.net> <20040318221904.45011167.davem@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ar8KwLu88Tj76bHi"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20040318221904.45011167.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Ar8KwLu88Tj76bHi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I have applied these to 2.6.4 (debian source) and compiles okay and
seems to work okay, ie the NAT + IPSEC

my 2c

On Thu, Mar 18, 2004 at 10:19:04PM -0800, David S. Miller wrote:
> On Thu, 18 Mar 2004 17:32:39 +0100
> Patrick McHardy <kaber@trash.net> wrote:
>=20
> > This patch makes xfrm_policy_check locate the correct policy after NAT.
> > For protocols which do policy checks in their receive routines the
> > reference to nfct has to be kept until policy checks are done, the
> > other ones still drop it in ip_local_deliver_finish.
>=20
> This patch looks fine to me.
>=20
> Other than the minor comments I've made the most unhappy I am
> with the input patch, and you agree it's grotty too.  Let's look
> for a better solution, perhaps with new top-level SKB state,
> and then we can put all of your work in after you're made the other
> minor fixes I've asked for as well.
>=20
> Thanks Patrick.
>=20
>=20
>=20

--Ar8KwLu88Tj76bHi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAWpPPkZz88chpJ2MRAsDKAKC1IeErun8HsYsO9qolY5R2NLf1vwCdFZQH
TQeU4G0CDW60td3A2uebSpU=
=Hef+
-----END PGP SIGNATURE-----

--Ar8KwLu88Tj76bHi--
