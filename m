From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATH 1/2] Fix SNAT/DNAT target size checks
Date: Sat, 22 Jan 2005 14:59:15 +0100
Message-ID: <1106402355.20995.15.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-9FIKeF/eOM5E5XwTTwHW"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
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


--=-9FIKeF/eOM5E5XwTTwHW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Patrick

This patch fixes two size checks in the checkentry() for SNAT and DNAT
targets.
The patch to remove support for multiple ranges forgot to use
IPT_ALIGN()
This isn't a problem on x86 but other archs like parisc are affected and
thus can't add any SNAT/DNAT rules.

Reported and tested by a user on irc.

Please submit this patch to davem for inclusion in 2.6.11 (-rc2 was just
released)

diff -X /home/gandalf/dontdiff.ny -urNp linux-2.6.11-rc2/net/ipv4/netfilter=
/ip_nat_rule.c linux-2.6.11-rc2.align/net/ipv4/netfilter/ip_nat_rule.c
--- linux-2.6.11-rc2/net/ipv4/netfilter/ip_nat_rule.c	2005-01-22 12:17:40.0=
00000000 +0100
+++ linux-2.6.11-rc2.align/net/ipv4/netfilter/ip_nat_rule.c	2005-01-22 14:5=
5:45.000000000 +0100
@@ -181,7 +181,7 @@ static int ipt_snat_checkentry(const cha
 		return 0;
 	}
=20
-	if (targinfosize !=3D sizeof(struct ip_nat_multi_range_compat)) {
+	if (targinfosize !=3D IPT_ALIGN(sizeof(struct ip_nat_multi_range_compat))=
) {
 		DEBUGP("SNAT: Target size %u wrong for %u ranges\n",
 		       targinfosize, mr->rangesize);
 		return 0;
@@ -214,7 +214,7 @@ static int ipt_dnat_checkentry(const cha
 		return 0;
 	}
=20
-	if (targinfosize !=3D sizeof(struct ip_nat_multi_range_compat)) {
+	if (targinfosize !=3D IPT_ALIGN(sizeof(struct ip_nat_multi_range_compat))=
) {
 		DEBUGP("DNAT: Target size %u wrong for %u ranges\n",
 		       targinfosize, mr->rangesize);
 		return 0;
=20
--=20
/Martin

--=-9FIKeF/eOM5E5XwTTwHW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBB8lwzWm2vlfa207ERAv17AKCfc1IuTPYlAsTctcTbguBSNHFQWQCgnmnD
JwI5yxELkG/wlBadEJjUixQ=
=0Job
-----END PGP SIGNATURE-----

--=-9FIKeF/eOM5E5XwTTwHW--
