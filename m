From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] admin-prohibited option. Let us look at it again.
Date: Sat, 24 May 2003 13:39:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030524113934.GA3077@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.51.0304091927060.13250@dns.toxicfilms.tv> <slrnbcn8rd.440.lunz@stoli.localnet>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kM/PxlMMHsUUNZZW"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jason Lunz <lunz@falooley.org>
Content-Disposition: inline
In-Reply-To: <slrnbcn8rd.440.lunz@stoli.localnet>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--kM/PxlMMHsUUNZZW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 21, 2003 at 04:02:05PM +0000, Jason Lunz wrote:

> So my question is, since this has been known about since January and
> netfilter 1.2.8 was released last month, what's holding up the inclusion
> of this feature? What needs to be done to get it included? Why didn't it
> go into 1.2.8? Not supporting RFC 1812 out of the box is a bug, IMO.

I've just simply overlooked that issue.  Maintaining iptables with all
the contributions/extensions can sometimes be a quite complex task - and
sometimes something gets lost. Sorry.

> Also, I checked to see whether it was feasible to code it so that the
> userspace could attempt to add an admin-prohibited rule, then fall back
> to host- or -net-prohibited if that fails on the running kernel. The
> problem is that it doesn't fail. In linux 2.4.20, the check() function
> in ipt_REJECT.c doesn't care whether it recognizes the reject type or
> not, and happily adds a rule with a bogus type if one is passed. Should
> something like the patch below be applied?

it might be a good idea for the future.  It doesn't help us with our
current problem (since it's the old kernels which will default to DROP
right now).

> Jason

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--kM/PxlMMHsUUNZZW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+z1n2XaXGVTD0i/8RAouQAJwJ72VJ1cWEEi4outz4MyIrmTU+7ACePn7W
aEaaDQn0NkwTjVYwuNpNu20=
=XheD
-----END PGP SIGNATURE-----

--kM/PxlMMHsUUNZZW--
