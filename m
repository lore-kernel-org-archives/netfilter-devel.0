From: Krzysztof Oledzki <olenf@ans.pl>
Subject: [PATCH] Add htons for icmp.id in
	conntrack/extensions/libct_proto_icmp.c
Date: Sun, 6 Nov 2005 03:49:13 +0100 (CET)
Message-ID: <Pine.LNX.4.63.0511060345410.29836@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1399156593-1131245353=:29836"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1399156593-1131245353=:29836
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

We need to add htons for icmp id.

Index: conntrack/extensions/libct_proto_icmp.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- conntrack/extensions/libct_proto_icmp.c=09(revision 4480)
+++ conntrack/extensions/libct_proto_icmp.c=09(working copy)
@@ -77,7 +77,7 @@
  =09=09=09break;
  =09=09case '3':
  =09=09=09if (optarg) {
-=09=09=09=09orig->l4src.icmp.id =3D atoi(optarg);
+=09=09=09=09orig->l4src.icmp.id =3D htons(atoi(optarg));
  =09=09=09=09reply->l4dst.icmp.id =3D 0;
  =09=09=09=09*flags |=3D ICMP_ID;
  =09=09=09}


Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1399156593-1131245353=:29836
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=icmp_id_htons-patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.63.0511060349130.29836@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=icmp_id_htons-patch

SW5kZXg6IGNvbm50cmFjay9leHRlbnNpb25zL2xpYmN0X3Byb3RvX2ljbXAu
Yw0KPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PQ0KLS0tIGNvbm50cmFjay9leHRl
bnNpb25zL2xpYmN0X3Byb3RvX2ljbXAuYwkocmV2aXNpb24gNDQ4MCkNCisr
KyBjb25udHJhY2svZXh0ZW5zaW9ucy9saWJjdF9wcm90b19pY21wLmMJKHdv
cmtpbmcgY29weSkNCkBAIC03Nyw3ICs3Nyw3IEBADQogCQkJYnJlYWs7DQog
CQljYXNlICczJzoNCiAJCQlpZiAob3B0YXJnKSB7DQotCQkJCW9yaWctPmw0
c3JjLmljbXAuaWQgPSBhdG9pKG9wdGFyZyk7DQorCQkJCW9yaWctPmw0c3Jj
LmljbXAuaWQgPSBodG9ucyhhdG9pKG9wdGFyZykpOw0KIAkJCQlyZXBseS0+
bDRkc3QuaWNtcC5pZCA9IDA7DQogCQkJCSpmbGFncyB8PSBJQ01QX0lEOw0K
IAkJCX0NCg==

---187430788-1399156593-1131245353=:29836--
