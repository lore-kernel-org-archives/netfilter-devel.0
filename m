From: "Samuel Jean" <sjean@cookinglinux.org>
Subject: Re: [PATCH 2.4/2.6]: TTL target
Date: Tue, 27 Jul 2004 15:09:20 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1177.216.239.71.162.1090955360.squirrel@216.239.71.162>
Mime-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20040727150920_34867"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

------=_20040727150920_34867
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Patrick,

Patrick wrote:
>The patches for 2.4 and 2.6 don't apply, your mailer may have mangled
>them. Please send them again as attachment.

I attached both patches. Sorry for all the complications.


>Regards
>Patrick

Cheers,

--=20
Samuel Jean
SysAdmin & NetAdmin
at cookinglinux.org
------=_20040727150920_34867
Content-Type: text/plain; name="ipt_TTL.c.patch-2.4"
Content-Disposition: attachment; filename="ipt_TTL.c.patch-2.4"
Content-Transfer-Encoding: quoted-printable

--- linux/net/ipv4/netfilter/ipt_TTL.c.orig	2004-07-24 21:09:23.000000000=
 -0400
+++ linux/net/ipv4/netfilter/ipt_TTL.c	2004-07-25 18:15:08.000000000 -040=
0
@@ -37,7 +37,7 @@ static unsigned int ipt_ttl_target(struc
 				new_ttl =3D 255;
 			break;
 		case IPT_TTL_DEC:
-			new_ttl =3D iph->ttl + info->ttl;
+			new_ttl =3D iph->ttl - info->ttl;
 			if (new_ttl < 0)
 				new_ttl =3D 0;
 			break;
@@ -85,11 +85,6 @@ static int ipt_ttl_checkentry(const char
 		return 0;
 	}
=20
-	if ((info->mode !=3D IPT_TTL_SET) && (info->ttl =3D=3D 0)) {
-		printk(KERN_WARNING "TTL: increment/decrement doesn't make sense with =
value 0\n");
-		return 0;
-	}
-=09
 	return 1;
 }
=20
------=_20040727150920_34867
Content-Type: text/plain; name="ipt_TTL.c.patch-2.6"
Content-Disposition: attachment; filename="ipt_TTL.c.patch-2.6"
Content-Transfer-Encoding: quoted-printable

--- linux-2.6/net/ipv4/netfilter/ipt_TTL.c.orig	2004-07-25 18:30:56.00000=
0000 -0400
+++ linux-2.6/net/ipv4/netfilter/ipt_TTL.c	2004-07-25 18:31:52.000000000 =
-0400
@@ -43,7 +43,7 @@ ipt_ttl_target(struct sk_buff **pskb, co
 				new_ttl =3D 255;
 			break;
 		case IPT_TTL_DEC:
-			new_ttl =3D iph->ttl + info->ttl;
+			new_ttl =3D iph->ttl - info->ttl;
 			if (new_ttl < 0)
 				new_ttl =3D 0;
 			break;
@@ -91,11 +91,6 @@ static int ipt_ttl_checkentry(const char
 		return 0;
 	}
=20
-	if ((info->mode !=3D IPT_TTL_SET) && (info->ttl =3D=3D 0)) {
-		printk(KERN_WARNING "TTL: increment/decrement doesn't make sense with =
value 0\n");
-		return 0;
-	}
-=09
 	return 1;
 }
=20
------=_20040727150920_34867--
