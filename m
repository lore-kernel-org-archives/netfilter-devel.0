From: Daniel De Graaf <danield@iastate.edu>
Subject: Re: Correct iptables-save output of osf module
Date: Wed, 29 Mar 2006 08:37:25 -0600
Message-ID: <442A9BA5.5040108@iastate.edu>
References: <427c54c0603242025qc0a9c8bqfc00af825fca88bc@mail.gmail.com>
	<442A4B72.1020405@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig3ED1F51D5936DE5CF5A12725"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <442A4B72.1020405@trash.net>
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

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3ED1F51D5936DE5CF5A12725
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Patrick McHardy wrote:
> Daniel De Graaf wrote:
>  =20
>> This adds the optional flags for the osf module to the iptables-save o=
utput.
>>    =20
>
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: base64
> Content-Disposition: inline
>
> I can't apply this since my mail client saves it base64 encoded. Please=

> resend as plain text.
>  =20

Sorry, I'll use a real mail client to send patches from now on. Here's
the patch again:

Index: extensions/libipt_osf.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- extensions/libipt_osf.c     (revision 6560)
+++ extensions/libipt_osf.c     (working copy)
@@ -134,6 +134,14 @@
        const struct ipt_osf_info *info =3D (const struct ipt_osf_info*) =
match->data;

        printf("--genre %s%s ", (info->invert) ? "! ": "", info->genre);
+       if (info->flags & IPT_OSF_SMART)
+               printf("--smart ");
+       if (info->flags & IPT_OSF_LOG)
+               printf("--log %d ", info->loglevel);
+       if (info->flags & IPT_OSF_NETLINK)
+               printf("--netlink ");
+       if (info->flags & IPT_OSF_CONNECTOR)
+               printf("--connector ");
 }




--------------enig3ED1F51D5936DE5CF5A12725
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFEKpuoZz9quLVV3/MRAk2iAJ9UYNdVfpBGw8uzvz68z+nZOYMHQQCZAd4p
Ty0kXvXGQD5fHsbEPhhMC0M=
=Bhwe
-----END PGP SIGNATURE-----

--------------enig3ED1F51D5936DE5CF5A12725--
