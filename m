From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH] Add mark to packet from libipq
Date: Thu, 16 Oct 2003 09:23:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1066289019.20545.30.camel@porky>
References: <Pine.LNX.4.44.0310160902520.6046-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qILOUQxFAPOK9f1xVsOT"
Cc: netfilter-devel@lists.netfilter.org, nufw-devel@nongnu.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0310160902520.6046-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-qILOUQxFAPOK9f1xVsOT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le jeu 16/10/2003 =C3=A0 09:08, Henrik Nordstrom a =C3=A9crit :
> On Thu, 16 Oct 2003, Eric Leblond wrote:
>=20
> I have one question regarding the mark mask value in the kernel message..=
 =20
> what is the purpose of this? Todays implementation looks rather wasteful
> as the userspace may just as well apply the mask before the value is sent
> to the kernel.
> If you are to have a mask I propose this mask indicates which bits to sav=
e=20
> of the original mark, not a mask to the new mark value. I.e. something=20
> like this:
>=20
>             /* set mark of associated skb */
>             entry->skb->nfmark =3D vmsg->nfmark | (entry->skb->nfmark & v=
msg->mask);
>=20
> (alernately mask may be inverted)

That's what I was wanted ! I was too tired yesterday to see the huge
error I've done. I've found it at the end of my sleep ;-) you're mail
give the answer.
One other question I have it's whether or not it necessary to add
verdict value in the message if using mark sys call ?
If we mark the packet we wen to let it pass trough the gateway...

It will require some work (modification of some functions in ip_queue)
to do so but it's maybe a cleaner way to do.

> but in reality this is not needed either as the userspace knows the
> original mask and can a apply whatever transformations it likes=20
> when giving the new verdict mask.

How could userspace knows it ?

BR,
--=20
Eric Leblond
Nufw, Now User Filtering Works (http://www.nufw.org)

--=-qILOUQxFAPOK9f1xVsOT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e=2E?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/jkd7nxA7CdMWjzIRAmdgAJ91tifbZKAhQ4LI+zipRCD/4fvLwwCfZHlj
yy3j97FV0R3nnf9WNsP43iw=
=p45F
-----END PGP SIGNATURE-----

--=-qILOUQxFAPOK9f1xVsOT--
