From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] ipt_hashlimit.c: expire's type overflow when showing
	tuples at bad moment.
Date: Tue, 1 Feb 2005 14:54:23 +0100
Message-ID: <20050201135423.GS6878@sunbeam.de.gnumonks.org>
References: <41F2FE92.6020603@cookinglinux.org>
	<20050201132915.GJ6878@sunbeam.de.gnumonks.org>
	<41FF877D.4080309@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qyZ1VOjRGk8hBWhg"
Cc: netfilter-devel@lists.netfilter.org,
	Samuel Jean <sj-netfilter@cookinglinux.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <41FF877D.4080309@trash.net>
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


--qyZ1VOjRGk8hBWhg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 01, 2005 at 02:43:25PM +0100, Patrick McHardy wrote:
> >>When garbage collector runs slow enough, we have a chance to print
> >>expired tuples before they get freed. We see weird expiry time.
> >
> >Thanks.  Patrick, please put this patch in your pending queue.
> >
> We also have this problem in ip_conntrack_standalone. I think the best
> fix would be to use %d for time deltas.

ACK.   we should never have times larger than five days anyway... way
less than the negative maximum of 32bit.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--qyZ1VOjRGk8hBWhg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB/4oPXaXGVTD0i/8RAjQFAKCgUpmClOSqcRku+BHh83lc0WzjmQCfcOP9
lVO2UOohWDF2TW5QwvCAhAs=
=gqJR
-----END PGP SIGNATURE-----

--qyZ1VOjRGk8hBWhg--
