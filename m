From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH-2.4-POM] replace flags test with lookups (was: CLOSE_WAIT..)
Date: Wed, 8 Oct 2003 17:14:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031008151407.GA25743@sunbeam.de.gnumonks.org>
References: <20031008131332.GA2135@alpha.home.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="apg+fY3UKMMABzWO"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
Content-Disposition: inline
In-Reply-To: <20031008131332.GA2135@alpha.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--apg+fY3UKMMABzWO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 08, 2003 at 03:13:32PM +0200, Willy Tarreau wrote:
> Well, I've just benchmarked both a u32 and a u8 version against the origi=
nal
> one, on x86. The shift operations are enough to slow them down, so it's n=
ot
> worth optimizing this way. The u8 implementation is already 50% slower
> than the original one, and the u32 implementation is twice as slow as
> the original one.

Mh, as I assumed :(

> But I think that porting latest ipt_unclean changes to ip_conntrack_proto=
_tcp
> should at least give a slight boost (just compiled it, did not test) :

Erm, are you aware of the
http://cvs.netfilter.org/netfilter/patch-o-matic/submitted/81_ipt_unclean-t=
cp-flag-table.patch
that has already been submitted for kernel inclusion?

> Regards,
> Willy

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--apg+fY3UKMMABzWO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/hCm/XaXGVTD0i/8RApPMAKCgkM6GiNrRyDlg1BuHIQKqH4fYggCeNLMh
x1Ig4koIAO4soaJFIu3znsQ=
=nkBs
-----END PGP SIGNATURE-----

--apg+fY3UKMMABzWO--
