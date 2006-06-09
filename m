From: "Jing Min Zhao" <zhaojingmin@hotmail.com>
Subject: [H.323 Helper 1/5]: Check sequence range first
Date: Fri, 9 Jun 2006 00:14:02 -0400
Message-ID: <BAY109-DAV8A54D5C49239A562934E0B3880@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0053_01C68B59.9CDD3210"
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

------=_NextPart_000_0053_01C68B59.9CDD3210
Content-Type: text/plain;
	charset="GB18030"
Content-Transfer-Encoding: base64

SSdtIHNvcnJ5IGZvciBzZW5kaW5nIHBhdGNoZXMgYXMgYXR0YWNobWVudHMgYWdhaW4sIGJ1dCBt
eSBTTVRQIGFjY291bnQgb24gaW1hcC5uZXRmaWx0ZXIub3JnIGRvZXNuJ3Qgd29yay4NCg0KQ2hl
Y2sgc2VxdWVuY2UgcmFuZ2UgZmlyc3QsIG5vIG5lZWQgdG8gY2hlY2sgaXQgYWdhaW4gbGF0ZXIu
IFNvIHdlIHNhdmVkIGEgDQpmZXcgaW5zdHJ1Y3Rpb25zIGFuZCBuYW5vc2Vjb25kcyA6KQ0KDQpT
aWduZWQtb2ZmLWJ5OiBKaW5nIE1pbiBaaGFvDQo=

------=_NextPart_000_0053_01C68B59.9CDD3210
Content-Type: application/octet-stream;
	name="patch1-check-range"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch1-check-range"

diff -pruN =
linux-2.6.17.orig/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c =
linux-2.6.17/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c=0A=
--- linux-2.6.17.orig/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c	=
2006-06-08 14:19:49.000000000 -0400=0A=
+++ linux-2.6.17/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c	=
2006-06-08 20:06:59.000000000 -0400=0A=
@@ -555,15 +555,6 @@ int decode_seq(bitstr_t * bs, field_t * =0A=
 =0A=
 	/* Decode the extension components */=0A=
 	for (opt =3D 0; opt < bmp2_len; opt++, i++, son++) {=0A=
-		if (i < f->ub && son->attr & STOP) {=0A=
-			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",=0A=
-			      son->name);=0A=
-			return H323_ERROR_STOP;=0A=
-		}=0A=
-=0A=
-		if (!((0x80000000 >> opt) & bmp2))	/* Not present */=0A=
-			continue;=0A=
-=0A=
 		/* Check Range */=0A=
 		if (i >=3D f->ub) {	/* Newer Version? */=0A=
 			CHECK_BOUND(bs, 2);=0A=
@@ -573,6 +564,15 @@ int decode_seq(bitstr_t * bs, field_t * =0A=
 			continue;=0A=
 		}=0A=
 =0A=
+		if (son->attr & STOP) {=0A=
+			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",=0A=
+			      son->name);=0A=
+			return H323_ERROR_STOP;=0A=
+		}=0A=
+=0A=
+		if (!((0x80000000 >> opt) & bmp2))	/* Not present */=0A=
+			continue;=0A=
+=0A=
 		CHECK_BOUND(bs, 2);=0A=
 		len =3D get_len(bs);=0A=
 		CHECK_BOUND(bs, len);=0A=

------=_NextPart_000_0053_01C68B59.9CDD3210--
