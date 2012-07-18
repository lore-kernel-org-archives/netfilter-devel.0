From: Eric Leblond <eric@regit.org>
Subject: Re: Unable to post - Ulogd / NFCT - Request for changes
Date: Wed, 18 Jul 2012 20:53:41 +0200
Message-ID: <1342637621.5282.10.camel@tiger.regit.org>
References: <CAAJpzgYYNbET-M07dKN6tEa7qpL3z0+6Tm=mRewnsoZue_Yddw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-67fgLT9hbZIA6AtX02qo"
Cc: netfilter-devel@vger.kernel.org
To: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:36448 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab2GRSyd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jul 2012 14:54:33 -0400
In-Reply-To: <CAAJpzgYYNbET-M07dKN6tEa7qpL3z0+6Tm=mRewnsoZue_Yddw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-67fgLT9hbZIA6AtX02qo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Le mercredi 18 juillet 2012 =C3=A0 08:10 -0700, Gomathivinayagam
Muthuvinayagam a =C3=A9crit :
> Hi,
>=20
> Currently NFCT supports polling mode, but polling mode only propagates
> the message to output plugin during DESTROY event.
> This is a problem for long living connections, since I want to know
> the amount of data transfer before the destroy event.

For accounting, you may want to look NFACCT. For more information, you
can read my recent blog post:
https://home.regit.org/2012/07/flow-accounting-with-netfilter-and-ulogd2/


> After getting a quick walk through on NFCT plugin code, It seems I
> have to change the do_purge method, which is called in a regular time
> interval.
>=20
> I came with the following updates in the code (I added the else block onl=
y).
>=20
>=20
> static int do_purge(void *data1, void *data2)
> {
>         int ret;
>         struct ulogd_pluginstance *upi =3D data1;
>         struct ct_timestamp *ts =3D data2;
>         struct nfct_pluginstance *cpi =3D
>                                 (struct nfct_pluginstance *) upi->private=
;
>=20
>         ulogd_log(ULOGD_NOTICE,"Inside do_purge method\n");
>=20
>         /* if it is not in kernel anymore, purge it */
>         ret =3D nfct_query(cpi->pgh, NFCT_Q_GET, ts->ct);
>         if (ret =3D=3D -1 && errno =3D=3D ENOENT) {
>                 do_propagate_ct(upi, ts->ct, NFCT_T_DESTROY, ts);
>                 hashtable_del(cpi->ct_active, &ts->hashnode);
>                 nfct_destroy(ts->ct);
>                 free(ts);
>         }
>         else // Added code
>         {
>                 do_propagate_ct(upi, ts->ct,NFCT_T_UPDATE,ts);
>         }
>=20
>         return 0;
> }
>=20
> The else part propagates a flow eventhough there were no updates
> happened to the flow. Could you help somone here, I would like to
> propagate about the updates of a connection, if there was a change
> happened to the long living connection. Is this correct approach?
>=20
> My intuition, I have to call nfct_cmp method by passing the local hash
> table connection, and the available connection in the kernel. If they
> are same, then there were no updates happened to the connection,
> otherwise I will propagate the details of the particular connection.
>=20
> Thanks & Regards,
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Eric Leblond=20
Blog: http://home.regit.org/ - Portfolio: http://regit.500px.com/

--=-67fgLT9hbZIA6AtX02qo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlAHBjUACgkQnxA7CdMWjzIlOQCeJSQJeP106tT8ir2BhmJbnGAx
KEQAn3a+1NjBuS+foNonjZBFhgGC8Vt0
=s2TK
-----END PGP SIGNATURE-----

--=-67fgLT9hbZIA6AtX02qo--

