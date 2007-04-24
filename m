From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: memory related question w/ netfilter
Date: Tue, 24 Apr 2007 15:58:47 +0200
Message-ID: <1177423127.3032.10.camel@henriknordstrom.net>
References: <ac3a99aa0704211430m7d85d5a7sb3799584d9e5af5f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-QhSujUpBgThbovavBpeI"
Cc: netfilter-devel@lists.netfilter.org
To: Ramnath R Iyer <ramnath.r.iyer@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <ac3a99aa0704211430m7d85d5a7sb3799584d9e5af5f@mail.gmail.com>
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


--=-QhSujUpBgThbovavBpeI
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

s=C3=B6n 2007-04-22 klockan 03:00 +0530 skrev Ramnath R Iyer:

> /struct sk_buff **/. So suppose I need to queue up the data in the
> buffer in my own application, and return NF_STOLEN, which of the
> following scenarios is applicable?
>=20
> (a) The sk_buff memory is subsequently unallocated, so I should copy
> the data into a new buffer before returning NF_STOLEN, or
>=20
> (b) The sk_buff memory remains allocated, so I should call kfree on
> the pointer to unallocate it when I'm done using the data, or
>=20
> (c) Something else


sk_buff's is reference counted. When you return NF_STOLEN you tell the
kernel that you have taken over the reference to this sk_buff.

sk_buff references is managed using skb_get/kfree_skb.

If you need to modify the contents of the sk_buff, remember to mangle
the reference via skb_share_check to make sure you have a private copy..

Note: If you need to inject the packets back to the kernel after you are
done with them it's better to use NF_QUEUE instead.=20

Regards
Henrik



--=-QhSujUpBgThbovavBpeI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Detta =?ISO-8859-1?Q?=E4r?= en digitalt signerad
	meddelandedel

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUARi4NFENPQ5Kbx8daAQJTxgP+LwCR/Ntpo5s2ebYVnbSex0BXlqayCabR
feZORU9xZUuaxRw+6YK9tvgyTYNnVc3RgZJyRojsAqUOJcO4GaSCFXBW+2QP5THB
wyvaBadfxKLWvboAsLYdc4uyo/Wp3n1iO5MTNg9vFa9d/Sh3E5/2YS9aHPNQE40f
ZhY8vAU2zAA=
=/kvB
-----END PGP SIGNATURE-----

--=-QhSujUpBgThbovavBpeI--
