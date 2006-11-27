From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] Check returnvalue of nfct_nat()
Date: Mon, 27 Nov 2006 17:51:49 +0100
Message-ID: <1164646309.30244.30.camel@localhost.localdomain>
References: <1164536011.30244.10.camel@localhost.localdomain>
	<456B114C.5000204@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-zqquE9wA8zlNULZnv+QL"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <456B114C.5000204@trash.net>
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


--=-zqquE9wA8zlNULZnv+QL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2006-11-27 at 17:24 +0100, Patrick McHardy wrote:

> Thanks, I just noticed the same crash when loading iptable_nat over
> ssh (it works fine with the additional checks now).

:)

I seem to always find new bugs when porting my patches to a newer
kernels :)
This time it was this bug and a strange locking bug in what appears to
be socket locking, Peter Zijlstra just mailed me a possible fix for
that.

> > Some of the checks in the patch might not be strictly neccessary, I hav=
n't
> > audited the calls, it was 4 AM :) The check added in nf_nat_fn() should=
 take
> > care of things for us...
>=20
> The nfct_help part is a bit more trickier since not only can
> nfct_help return NULL, but nfct_help(ct)->help can become NULL
> as well when the helper is unloaded even while it is still
> executing. I want to think about this some more, but I went
> over the nfct_nat part and added the ones that look necessary,
> it came down to only two :)

:) My brain was shutting down and the NAT core is still a lot of voodoo
for me :) I just added checks everywhere so I could continue to test my
patches, great that you reviewed it and sorted out which ones are really
neccessary.

I'll give your revised patch a go and see if it survives my tests.

Thanks.

--=20
/Martin

--=-zqquE9wA8zlNULZnv+QL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFaxelWm2vlfa207ERAjMKAJwM9vtPda3JSUZUo42YEV82gdcV1wCgxpDl
MFwpMW6HPbTb8gREPbulV0U=
=tkdV
-----END PGP SIGNATURE-----

--=-zqquE9wA8zlNULZnv+QL--
