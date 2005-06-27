From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2/2] updates for lib[ct|nf]netlink
Date: Mon, 27 Jun 2005 21:51:24 +0200
Message-ID: <20050627195124.GX19928@sunbeam.de.gnumonks.org>
References: <42C03F39.7000806@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+hZIELbchok2+JHy"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <42C03F39.7000806@eurodev.net>
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


--+hZIELbchok2+JHy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 27, 2005 at 08:02:33PM +0200, Pablo Neira wrote:
> This patch attached includes the updates to keep in sync the user space=
=20
> libraries with the kernel part.

no problem with your patches per se, but
please make sure your patches apply with the current code ins svn:

patching file libctnetlink/libctnetlink.c
Hunk #2 succeeded at 172 (offset -1 lines).
Hunk #3 succeeded at 184 (offset -1 lines).
Hunk #4 succeeded at 202 (offset -1 lines).
Hunk #5 succeeded at 271 (offset -1 lines).
Hunk #6 succeeded at 330 (offset -1 lines).
Hunk #7 succeeded at 348 (offset -1 lines).
Hunk #8 succeeded at 382 (offset -1 lines).
Hunk #9 succeeded at 409 (offset -1 lines).
Hunk #10 FAILED at 449.
1 out of 10 hunks FAILED -- saving rejects to file
libctnetlink/libctnetlink.c.rej
patching file libctnetlink/libctnetlink.h
Hunk #3 FAILED at 54.
1 out of 3 hunks FAILED -- saving rejects to file
libctnetlink/libctnetlink.h.rej
patching file libnfnetlink/libnfnetlink.c

(yes, I'm doing a significant amount of netfilter work again. I'll also
 start reading the list more frequently again).

please merge and test your patches, then resubmit.  Thanks!

btw: I've granted you write permissions to 'libctnetlink'.  Feel free to
submit (I'm reading the changelog mailinglist).  But please propose
large modifications / restructuring to the mailinglist before
implementing the changes.

Does anyone have experience with versioned symbols in the dynamic
linker?  We'd better make sure that we do this correctly once the first
official releases of libnfnetlink and libctnetlink were made public.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--+hZIELbchok2+JHy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCwFi8XaXGVTD0i/8RAszjAJ9V2TJtSumd0uXUA904mlYK3MybaACfTc1a
InIjGKCrnl+U1Wj51GCkRo8=
=Xb28
-----END PGP SIGNATURE-----

--+hZIELbchok2+JHy--
