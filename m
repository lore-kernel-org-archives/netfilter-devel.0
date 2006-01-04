From: Heiko Schlittermann <hs@schlittermann.de>
Subject: Patch for ipt_time (to enable start > stop / crossing midnight)
Date: Wed, 4 Jan 2006 15:27:50 +0100
Message-ID: <20060104142750.GF15217@schlittermann.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oewGmZAZkT4pTohN"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--oewGmZAZkT4pTohN
Content-Type: multipart/mixed; boundary="x96pM+uot4Qe+FAK"
Content-Disposition: inline


--x96pM+uot4Qe+FAK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

orginally sent to Fabrice but resending it here.  (Fabrice doesn't seem to
have time...., so I just subscribed here.)


(Beside: I was wondering, why ipt_time is not part of the official
2.6. kernel -- did I miss something?)


So I applied the `time' patch from current patch-o-matic (20060101).


But with a rule like:

    iptables -A INPUT -m time --timestart 21:00 --timestop 15:00 -j ...
    (wrapping 'round midnight).

I missed my target :)


To enable times crossing midnight I hacked a bit in ipt_time.c. My diff
is appended (against the patch-o-matic 20060101)..

It would be nice if you could

    1) check it
    2) integrate it into the official patch-o-matic (and kernel tree?)

Thank you ...

    Best regards from Dresden
    Viele Gr=C3=BC=C3=9Fe aus Dresden
    Heiko Schlittermann
--=20
 SCHLITTERMANN.de ---------------------------- internet & unix support -
 Heiko Schlittermann HS12-RIPE -----------------------------------------
 gnupg encrypted messages are welcome - key ID: 48D0359B ---------------
 gnupg fingerprint: 3061 CFBF 2D88 F034 E8D2  7E92 EE4E AC98 48D0 359B -

--x96pM+uot4Qe+FAK
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="ipt_time.c.diff"
Content-Transfer-Encoding: quoted-printable

--- ipt_time.c.orig	2005-11-03 19:20:25.000000000 +0100
+++ ipt_time.c	2006-01-03 10:14:35.000000000 +0100
@@ -11,6 +11,7 @@
   2001-30-11 Fabrice : added the possibility to use the match in FORWARD/O=
UTPUT with a little hack,
      added Nguyen Dang Phuoc Dong <dongnd@tlnet.com.vn> patch to support t=
imezones.
   2004-05-02 Fabrice : added support for date matching, from an idea of Fa=
bien COELHO.
+  2006-01-03 Heiko Schlittermann <hs@schlittermann.de> : added support for=
 timestart > timestop
 */
=20
 #include <linux/module.h>
@@ -72,11 +73,14 @@
=20
 	/* ... check the time now */
 	packet_time =3D (currenttime.tm_hour * 60) + currenttime.tm_min;
-	if ((packet_time < info->time_start) || (packet_time > info->time_stop))
-		return 0;
=20
-	/* here we match ! */
-	return 1;
+	/* .hs now start > stop is possible */
+
+	if (info->time_start > info->time_stop)
+		return (packet_time >=3D info->time_start) || (packet_time < info->time_=
stop);
+
+	return (packet_time >=3D info->time_start) && (packet_time < info->time_s=
top);
+
 }
=20
 static int

--x96pM+uot4Qe+FAK--

--oewGmZAZkT4pTohN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDu9tm7k6smEjQNZsRAkwKAJ9EJ9JID3LUOM8OaNDUvAOEiXnkLQCgzmVF
UvRna4COL6T4/A8052/VhjE=
=5db/
-----END PGP SIGNATURE-----

--oewGmZAZkT4pTohN--
