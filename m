From: Krzysztof Oledzki <olenf@ans.pl>
Subject: [PATCH] Fix type of ICMP_ID
Date: Sun, 6 Nov 2005 04:00:03 +0100 (CET)
Message-ID: <Pine.LNX.4.63.0511060358480.32033@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-656585828-1131246003=:32033"
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

---187430788-656585828-1131246003=:32033
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

[NETFILTER] Fix type of ICMP_ID

ICMP_ID is u_int16_t not u_int8_t. Handle this properly.

Signed-out-by: Krzysztof Piotr Oledzki <ole@ans.pl>


--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c=092005-11-06 02:17:29.00=
0000000 +0100
+++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c=092005-11-06 03:49:51.00=
0000000 +0100
@@ -304,7 +304,7 @@
  =09tuple->dst.u.icmp.code =3D
  =09=09=09*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_CODE-1]);
  =09tuple->src.u.icmp.id =3D
-=09=09=09*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_ID-1]);
+=09=09=09*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_ICMP_ID-1]);

  =09return 0;
  }


Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-656585828-1131246003=:32033
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=icmp_id_u16.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.63.0511060400030.32033@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=icmp_id_u16.patch

W05FVEZJTFRFUl0gRml4IHR5cGUgb2YgSUNNUF9JRCANCg0KSUNNUF9JRCBp
cyB1X2ludDE2X3Qgbm90IHVfaW50OF90LiBIYW5kbGUgdGhpcyBwcm9wZXJs
eS4NCg0KU2lnbmVkLW91dC1ieTogS3J6eXN6dG9mIFBpb3RyIE9sZWR6a2kg
PG9sZUBhbnMucGw+DQoNCg0KLS0tIGEvbmV0L2lwdjQvbmV0ZmlsdGVyL2lw
X2Nvbm50cmFja19wcm90b19pY21wLmMJMjAwNS0xMS0wNiAwMjoxNzoyOS4w
MDAwMDAwMDAgKzAxMDANCisrKyBiL25ldC9pcHY0L25ldGZpbHRlci9pcF9j
b25udHJhY2tfcHJvdG9faWNtcC5jCTIwMDUtMTEtMDYgMDM6NDk6NTEuMDAw
MDAwMDAwICswMTAwDQpAQCAtMzA0LDcgKzMwNCw3IEBADQogCXR1cGxlLT5k
c3QudS5pY21wLmNvZGUgPQ0KIAkJCSoodV9pbnQ4X3QgKilORkFfREFUQSh0
YltDVEFfUFJPVE9fSUNNUF9DT0RFLTFdKTsNCiAJdHVwbGUtPnNyYy51Lmlj
bXAuaWQgPQ0KLQkJCSoodV9pbnQ4X3QgKilORkFfREFUQSh0YltDVEFfUFJP
VE9fSUNNUF9JRC0xXSk7DQorCQkJKih1X2ludDE2X3QgKilORkFfREFUQSh0
YltDVEFfUFJPVE9fSUNNUF9JRC0xXSk7DQogDQogCXJldHVybiAwOw0KIH0N
Cg==

---187430788-656585828-1131246003=:32033--
