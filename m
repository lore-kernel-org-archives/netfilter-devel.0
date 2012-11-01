From: Felipe Balbi <balbi-l0cyMroinI0@public.gmane.org>
Subject: Re: [PATCH V2 2/3] Remove VLAIS usage from gadget code
Date: Thu, 1 Nov 2012 09:21:16 +0200
Message-ID: <20121101072116.GA32013@arwen.pp.htv.fi>
References: <1351631937-21455-1-git-send-email-behanw@converseincode.com>
 <1351631937-21455-3-git-send-email-behanw@converseincode.com>
 <20121031132838.GQ10998@arwen.pp.htv.fi>
 <509144C0.8000601@converseincode.com>
Reply-To: <balbi-l0cyMroinI0@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Cc: <balbi-l0cyMroinI0@public.gmane.org>, <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Behan Webster <behanw-k/hB3zQhLwledRVtV/plodBPR1lH4CV8@public.gmane.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <509144C0.8000601-k/hB3zQhLwledRVtV/plodBPR1lH4CV8@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 31, 2012 at 11:33:20AM -0400, Behan Webster wrote:
> On 12-10-31 09:28 AM, Felipe Balbi wrote:
> >hi,
> >
> >On Tue, Oct 30, 2012 at 05:18:56PM -0400, Behan Webster wrote:
> >>The use of variable length arrays in structs (VLAIS) in the Linux Kerne=
l code
> >>precludes the use of compilers which don't implement VLAIS (for instanc=
e the
> >>Clang compiler). This patch instead calculates offsets into the kmalloc=
-ed
> >>memory buffer using macros from valign.h.
> >>
> >>Signed-off-by: Behan Webster <behanw-k/hB3zQhLwledRVtV/plodBPR1lH4CV8@public.gmane.org>
> >this won't apply after the current cleanups I applied to gadget code
> >from Sebastian.
> Makes sense. I'll try it with your repo, and regenerate.
>=20
> >If someone takes this patch, it will generate a series of annoying,
> >hard-to-figure-out conflicts (at least judging by the looks of
> >$SUBJECT).
> I just tried the patch on your git.kernel.org repo and thankfully
> there is only one hunk which is rejected, and fortunately the reason
> is trivial (descriptors -> fs_descriptors).
>=20
> Was:
> -        func->function.descriptors =3D data->fs_descs;
> +        func->function.descriptors =3D fs_descs;
>=20
> Now is:
> -        func->function.fs_descriptors =3D data->fs_descs;
> +        func->function.fs_descriptors =3D fs_descs;
>=20
> I will regenerate the patch set, but obviously the new gadget patch
> in the V3 patchset will only apply to the USB repo, and not to the
> netfilter repo.

then we can merge to net tree and handle the conflicts when merging to
Linus, that'd be fine by me as long as people know how to solve the
conflict properly ;-)

--=20
balbi

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkiLsAAoJEIaOsuA1yqREd1QQAKe3dQ1fDKIfatg1mHzvXktL
H/xNZs3FG42iC2lmi7dYQ2oe1B0XYrqrjRFAfr+5U/7J8bVO5nQAM3Dw0yN6Hsgh
Gs01NEvzCvrdB0iqMrmudp/rbDO68jdfJtTq7HDvN3gS2JTbh62ubLEp3iuGXYk8
CPgy/oqjZo8Gc7NDgQRCSFczIw8AAYeGAIkc5GW2KfjILgrelrXFtV5nQ3iKmZQD
Pj+mhaXzl/Xx0NaQosOAR0/h4AFrIQbh60t2l8KjJSEpfpuCgXiVC1hU0UrJXafa
xG7T3kYP6FKyWultL70UoSbGQ/tnnILVm3X0lmAmZ3V9CcDeIYhQtys2v7jUjasz
7nohu61lMt4+sruipoI21pWvXQbR9m9nfgp7+u9jIG0OZ6RJ2AAfEqAB/xuN/waT
4PPyVl1atob2cmG9ptQTIHwjoxljP1uPEfmnx35ivYR/UXI+kEp/b15xKy3j4BaG
v2IUDLPWajjvOwcSpXcHGGke5VcTNqDtBSr9X+nE1MjaENWQh+eFQTB7Bq9SSEyI
o/4MEdkT8PhQN75207EUHopGag68DCDDxBeuNygnCVOTdo3EorwCxwfOOy2nDZsI
44BN29BvtFxRhttMko3ljcqGoQDQL91HnuX9YOrxMWuaubLmxyiylz9YcnyapfnN
fToJE+ZrDwcgwcb4urIj
=2uiy
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
