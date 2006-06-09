From: "Jing Min Zhao" <zhaojingmin@hotmail.com>
Subject: [H.323 Helper 1/5]: Change helper definitions
Date: Fri, 9 Jun 2006 00:17:48 -0400
Message-ID: <BAY109-DAV77178796DEC33C757D9D7B3880@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_005C_01C68B5A.23BA7EA0"
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.

------=_NextPart_000_005C_01C68B5A.23BA7EA0
Content-Type: text/plain;
	charset="GB18030"
Content-Transfer-Encoding: base64

Q2hhbmdlIGhlbHBlcnMnIHN0cnVjdHVyZSBkZWZpbml0aW9ucyB0byBtZWV0IHNvbWUgb2xkIGNv
bXBpbGVycy4NCg0KU2lnbmVkLW9mZi1ieTogSmluZyBNaW4gWmhhbyA8emhhb2ppbmdtaW5AdXNl
cnMuc291cmNlZm9yZ2Uub3JnPg==

------=_NextPart_000_005C_01C68B5A.23BA7EA0
Content-Type: application/octet-stream;
	name="patch2-helper-definition"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch2-helper-definition"

diff -pruN =
linux-2.6.17.orig/net/ipv4/netfilter/ip_conntrack_helper_h323.c =
linux-2.6.17/net/ipv4/netfilter/ip_conntrack_helper_h323.c=0A=
--- linux-2.6.17.orig/net/ipv4/netfilter/ip_conntrack_helper_h323.c	=
2006-06-08 14:19:49.000000000 -0400=0A=
+++ linux-2.6.17/net/ipv4/netfilter/ip_conntrack_helper_h323.c	=
2006-06-08 20:38:44.000000000 -0400=0A=
@@ -597,7 +597,7 @@ static struct ip_conntrack_helper ip_con=0A=
 	.max_expected =3D H323_RTP_CHANNEL_MAX * 4 + 2 /* T.120 */ ,=0A=
 	.timeout =3D 240,=0A=
 	.tuple =3D {.dst =3D {.protonum =3D IPPROTO_TCP}},=0A=
-	.mask =3D {.src =3D {.u =3D {0xFFFF}},=0A=
+	.mask =3D {.src =3D {.u =3D {.tcp =3D {.port =3D 0xFFFF}}},=0A=
 		 .dst =3D {.protonum =3D 0xFF}},=0A=
 	.help =3D h245_help=0A=
 };=0A=
@@ -1045,9 +1045,10 @@ static struct ip_conntrack_helper ip_con=0A=
 	.me =3D THIS_MODULE,=0A=
 	.max_expected =3D H323_RTP_CHANNEL_MAX * 4 + 4 /* T.120 and H.245 */ ,=0A=
 	.timeout =3D 240,=0A=
-	.tuple =3D {.src =3D {.u =3D {__constant_htons(Q931_PORT)}},=0A=
+	.tuple =3D {.src =3D=0A=
+		  {.u =3D {.tcp =3D {.port =3D __constant_htons(Q931_PORT)}}},=0A=
 		  .dst =3D {.protonum =3D IPPROTO_TCP}},=0A=
-	.mask =3D {.src =3D {.u =3D {0xFFFF}},=0A=
+	.mask =3D {.src =3D {.u =3D {.tcp =3D {.port =3D 0xFFFF}}},=0A=
 		 .dst =3D {.protonum =3D 0xFF}},=0A=
 	.help =3D q931_help=0A=
 };=0A=
@@ -1638,9 +1639,9 @@ static struct ip_conntrack_helper ip_con=0A=
 	.me =3D THIS_MODULE,=0A=
 	.max_expected =3D 32,=0A=
 	.timeout =3D 240,=0A=
-	.tuple =3D {.src =3D {.u =3D {__constant_htons(RAS_PORT)}},=0A=
+	.tuple =3D {.src =3D {.u =3D {.udp =3D {.port =3D =
__constant_htons(RAS_PORT)}}},=0A=
 		  .dst =3D {.protonum =3D IPPROTO_UDP}},=0A=
-	.mask =3D {.src =3D {.u =3D {0xFFFE}},=0A=
+	.mask =3D {.src =3D {.u =3D {.udp =3D {.port =3D 0xFFFE}}},=0A=
 		 .dst =3D {.protonum =3D 0xFF}},=0A=
 	.help =3D ras_help,=0A=
 };=0A=

------=_NextPart_000_005C_01C68B5A.23BA7EA0--
