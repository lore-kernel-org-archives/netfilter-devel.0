From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [2/2] osf: fixed /proc reading bug
Date: Mon, 23 Aug 2004 14:30:59 +0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1093257059.21197.106.camel@uganda>
References: <20040822010358.79048eda@zanzibar.2ka.mipt.ru>
	 <4127CCF9.2030505@trash.net>
	 <Pine.LNX.4.61.0408220142220.21373@filer.marasystems.com>
	 <4127E586.5000707@trash.net> <1093251429.21197.8.camel@uganda>
	 <4129BF18.3010204@trash.net>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tvGKGulNUYDMbU4bGamg"
Cc: Henrik Nordstrom <hno@marasystems.com>,
        Harald Welte <laforge@netfilter.org>,
        netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4129BF18.3010204@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-tvGKGulNUYDMbU4bGamg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2004-08-23 at 13:55, Patrick McHardy wrote:
> Evgeniy Polyakov wrote:
>=20
> >It simply checks if return value from snprintf is 0 and breaks,
> >otherwise it proceeds.
> >
> Still broken. snprintf returns a value > n if it truncated to n bytes.
> See my last mail again. BTW, did the overflow actually cause problems ?
> proc has an extra k of space just for overflows ..

If it truncates than we have [avoided] overflow and definetely will not
write anything after it(except zero-lengh snprintf) since
 __count-count =3D=3D 0 there.

Do you mean following:
	list_for_each()
	{
		snprintf();
		if (count > __count)
			break;
	}

>=20
> Regards
> Patrick
>=20
> >ipt_osf.diff.1 - patch for 2.6
> >ipt_osf.diff.1.24 - patch for 2.4
> >
> >Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> >
> > =20
> >
> >>Regards
> >>Patrick
> >>   =20
> >>
> >>-----------------------------------------------------------------------=
-
> >>
> >>--- netfilter_cvs/patch-o-matic-ng/osf/linux-2.4/net/ipv4/netfilter/ipt=
_osf.c	2004-08-22 00:54:44.000000000 +0400
> >>+++ netfilter_cvs/patch-o-matic-ng/osf/linux-2.4/net/ipv4/netfilter/ipt=
_osf.c	2004-08-20 22:36:24.000000000 +0400
> >>@@ -182,7 +185,6 @@
> >> 		optsize =3D tcp->doff*4 - sizeof(struct tcphdr);
> >> 	}
> >>=20
> >>-=09
> >> 	/* Actually we can create hash/table of all genres and search
> >> 	 * only in appropriate part, but here is initial variant,
> >> 	 * so will use slow path.
> >>@@ -601,9 +603,10 @@
> >> {
> >> 	struct list_head *ent;
> >> 	struct osf_finger *f =3D NULL;
> >>-	int i;
> >>+	int i, __count, err;
> >> =09
> >> 	*eof =3D 1;
> >>+	__count =3D count;
> >> 	count =3D 0;
> >>=20
> >> 	read_lock_bh(&osf_lock);
> >>@@ -613,10 +616,13 @@
> >>=20
> >> 		log("%s [%s]", f->genre, f->details);
> >> 	=09
> >>-		count +=3D sprintf(buf+count, "%s - %s[%s] : %s",=20
> >>+		err =3D snprintf(buf+count, __count-count, "%s - %s[%s] : %s",=20
> >> 					f->genre, f->version,
> >> 					f->subtype, f->details);
> >>-	=09
> >>+		if (err =3D=3D 0)
> >>+			break;
> >>+		else
> >>+			count +=3D err;
> >> 		if (f->opt_num)
> >> 		{
> >> 			loga(" OPT: ");
> >>@@ -630,7 +636,11 @@
> >> 			}
> >> 		}
> >> 		loga("\n");
> >>-		count +=3D sprintf(buf+count, "\n");
> >>+		err =3D snprintf(buf+count, __count-count, "\n");
> >>+		if (err =3D=3D 0)
> >>+			break;
> >>+		else
> >>+			count +=3D err;
> >> 	}
> >> 	read_unlock_bh(&osf_lock);
> >>=20
> >>   =20
> >>
> >>-----------------------------------------------------------------------=
-
> >>
> >>--- netfilter_cvs/patch-o-matic-ng/osf/linux-2.4/net/ipv4/netfilter/ipt=
_osf.c	2004-08-22 00:54:44.000000000 +0400
> >>+++ netfilter_cvs/patch-o-matic-ng/osf/linux-2.4/net/ipv4/netfilter/ipt=
_osf.c	2004-08-20 22:36:24.000000000 +0400
> >>@@ -182,7 +185,6 @@
> >> 		optsize =3D tcp->doff*4 - sizeof(struct tcphdr);
> >> 	}
> >>=20
> >>-=09
> >> 	/* Actually we can create hash/table of all genres and search
> >> 	 * only in appropriate part, but here is initial variant,
> >> 	 * so will use slow path.
> >>@@ -601,9 +603,10 @@
> >> {
> >> 	struct list_head *ent;
> >> 	struct osf_finger *f =3D NULL;
> >>-	int i;
> >>+	int i, __count, err;
> >> =09
> >> 	*eof =3D 1;
> >>+	__count =3D count;
> >> 	count =3D 0;
> >>=20
> >> 	read_lock_bh(&osf_lock);
> >>@@ -613,10 +616,13 @@
> >>=20
> >> 		log("%s [%s]", f->genre, f->details);
> >> 	=09
> >>-		count +=3D sprintf(buf+count, "%s - %s[%s] : %s",=20
> >>+		err =3D snprintf(buf+count, __count-count, "%s - %s[%s] : %s",=20
> >> 					f->genre, f->version,
> >> 					f->subtype, f->details);
> >>-	=09
> >>+		if (err =3D=3D 0)
> >>+			break;
> >>+		else
> >>+			count +=3D err;
> >> 		if (f->opt_num)
> >> 		{
> >> 			loga(" OPT: ");
> >>@@ -630,7 +636,11 @@
> >> 			}
> >> 		}
> >> 		loga("\n");
> >>-		count +=3D sprintf(buf+count, "\n");
> >>+		err =3D snprintf(buf+count, __count-count, "\n");
> >>+		if (err =3D=3D 0)
> >>+			break;
> >>+		else
> >>+			count +=3D err;
> >> 	}
> >> 	read_unlock_bh(&osf_lock);
> >>=20
> >>   =20
> >>
--=20
	Evgeniy Polyakov ( s0mbre )

Crash is better than data corruption. -- Art Grabowski

--=-tvGKGulNUYDMbU4bGamg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBKcdjIKTPhE+8wY0RAlIWAJ47V+pB7mJqO1w2JUYl6fwG+qkeGQCeJgUo
ON7ur6xHnuC/n4z3nBL2QZ0=
=v3An
-----END PGP SIGNATURE-----

--=-tvGKGulNUYDMbU4bGamg--
