From: netfilter@interlinx.bc.ca
Subject: Re: How to create a "persistent" expectation with newnat?
Date: Wed, 26 Feb 2003 17:24:31 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030226222431.GB4557@pc.ilinx>
References: <20030224051810.GB7523@pc.ilinx> <20030225044337.GA4113@pc.ilinx> <20030226174145.GN8883@sunbeam.de.gnumonks.org> <20030226204009.GA11142@pc.ilinx> <20030226211545.GI15997@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6sX45UoQRIJXqkqR"
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20030226211545.GI15997@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 26, 2003 at 10:15:45PM +0100, Harald Welte wrote:
>=20
> This was not what I was thinking about. You would try to put the same
> struct onto the list again.

Right.  I was assuming that was the point of the "use" reference
counter.  To be able to re-use objects.

> Bad things will happen.  You will need to
> allocate a new struct ip_conntrack_expect, initialize it with tuple/mask
> and then call expect_related on this newly-allocated struct.

OK.  Should be simple enough with a few memcpys.  I don't suppose
there is a "copy_ip_conntrack_expect()" courtesy function is there?

> I did mean 'the same expectation' on a logical level, not 'the same
> piece of memory representing the expectation'.

OK.  I will go correct that in my helper then.

> I've tried to describe this in documentation/newnat-summary.txt.

I looked at that, and maybe with the context I have now it will be
clearer, but it was not that clear on my first reading (obviously, or
I would have gotten this all right the first time :-).

Thanx much for the steering in the right direction Harald.

You know, writing helpers for various protocols would not be a bad
gig... for a while I guess... everything gets boring after a while I
suppose.  :-)=20
b.

--=20
Brian J. Murrell

--6sX45UoQRIJXqkqR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+XT6fl3EQlGLyuXARAkyjAJ9ZvzmCcDwLjzVnNBMZ5HJVRRMILgCgjLVJ
yPfMbYinR06DNAmbYQIsrFk=
=5CwS
-----END PGP SIGNATURE-----

--6sX45UoQRIJXqkqR--
