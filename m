From: Harald Welte <laforge@netfilter.org>
Subject: Re: IPtables performance (fwd)
Date: Wed, 28 May 2003 21:20:19 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030528192019.GC12978@naboo>
References: <Pine.LNX.4.44.0305031129230.8273-100000@localhost> <Pine.LNX.4.33.0305031750040.8241-100000@fantomas.insite.com.br>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UFHRwCdBEJvubb2X"
Cc: Chris Wilson <chris@netservers.co.uk>,
	"netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>,
	Robert Olsson <robban@robtex.com>,
	John McEleney <john@netservers.co.uk>,
	Ben McKeegan <ben@netservers.co.uk>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andre Uratsuka Manoel <andre@insite.com.br>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0305031750040.8241-100000@fantomas.insite.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--UFHRwCdBEJvubb2X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 03, 2003 at 07:39:46PM -0300, Andre Uratsuka Manoel wrote:

> 	Be my guest to implement it. I thought of doing it myself, but I'm
> still looking around and trying to understand all those structures and
> pointers and I am still trying to find my way around.

While a long train ride I recently had the time to think about your
algorithm and I really like it.  I even started with an implementation,
but came to the following problem:

> 	Here is the pseudo-code for the algorithm:
>=20
> -------------------------------------------------
> 	for every chain:
> 		paint it white=20
> 		set chain->comefrom to 0=20

how can we safely iterate over the whole table (which might contain
loops) and paint all chains white?  I mean, if there is a loop in it,
already the initialization-to-white function would loop indefinitely.

any ideas?

> 	Regards,
> 	Andre

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--UFHRwCdBEJvubb2X
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+1QvzXaXGVTD0i/8RAoTeAJ48zmq1kyhmrtKX9s+mf7NMsyRlJQCgtTg0
weOpncBOrDyTa0S810CJ1rk=
=Mue9
-----END PGP SIGNATURE-----

--UFHRwCdBEJvubb2X--
