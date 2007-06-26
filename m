From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_u32 20070626 (Re: VLAN match within iptables)
Date: Tue, 26 Jun 2007 15:35:06 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706261528330.3137@fbirervta.pbzchgretzou.qr>
References: <1182849745.22167.13.camel@blas> <4680E3D7.6020401@netfilter.org>
	<4680E5CC.8070807@trash.net>
	<Pine.LNX.4.64.0706261423150.3137@fbirervta.pbzchgretzou.qr>
	<46810B7A.5020609@trash.net>
	<Pine.LNX.4.64.0706261511140.3137@fbirervta.pbzchgretzou.qr>
	<46811258.9020309@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-699020219-1218229204-1182864855=:3137"
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46811258.9020309@trash.net>
Content-ID: <Pine.LNX.4.64.0706261534170.3137@fbirervta.pbzchgretzou.qr>
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

---699020219-1218229204-1182864855=:3137
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-ID: <Pine.LNX.4.64.0706261534171.3137@fbirervta.pbzchgretzou.qr>
Content-Transfer-Encoding: quoted-printable


On Jun 26 2007 15:19, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> Subject: Add the U32 match from POM-NG
>
> I prefer incremental patches.

Hm, some UTF-8 got broken. Hence I attach the (incremental)
patch (also fixes 3 -> 4) with a 8 bit preserving mime type.
Inline version below for by-standers to look at :)

=3D=3D=3D

Correct overflow checks in xt_u32 and separate BUG_ON from expressions wi=
th
side-effects.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 net/netfilter/xt_u32.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

Index: linux-2.6.22/net/netfilter/xt_u32.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.22.orig/net/netfilter/xt_u32.c
+++ linux-2.6.22/net/netfilter/xt_u32.c
@@ -2,7 +2,7 @@
  *	xt_u32 - kernel module to match u32 packet content
  *
  *	Original author: Don Cohen <don@isis.cs3-inc.com>
- *	 Jan Engelhardt <jengelh@gmx.de>, 2007
+ *	Copyright =C2=A9 Jan Engelhardt <jengelh@gmx.de>, 2007
  */
=20
 #include <linux/module.h>
@@ -13,7 +13,6 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_u32.h>
=20
-
 static bool u32_match_it(const struct xt_u32 *data,
 			 const struct sk_buff *skb)
 {
@@ -25,6 +24,7 @@ static bool u32_match_it(const struct xt
 	u_int32_t pos;
 	u_int32_t val;
 	u_int32_t at;
+	int ret;
=20
 	/*
 	 * Small example: "0 >> 28 =3D=3D 4 && 8 & 0xFF0000 >> 16 =3D 6, 17"
@@ -35,10 +35,11 @@ static bool u32_match_it(const struct xt
 		at  =3D 0;
 		pos =3D ct->location[0].number;
=20
-		if (at + pos + 3 > skb->len || at + pos < 0)
+		if (skb->len < 4 || pos > skb->len - 4);
 			return false;
=20
-		BUG_ON(skb_copy_bits(skb, pos, &val, sizeof(val)) < 0);
+		ret   =3D skb_copy_bits(skb, pos, &val, sizeof(val));
+		BUG_ON(ret < 0);
 		val   =3D ntohl(val);
 		nnums =3D ct->nnums;
=20
@@ -56,13 +57,17 @@ static bool u32_match_it(const struct xt
 				val >>=3D number;
 				break;
 			case XT_U32_AT:
+				if (at + val < at)
+					return false;
 				at +=3D val;
 				pos =3D number;
-				if (at + pos + 3 > skb->len || at + pos < 0)
+				if (at + 4 < at || skb->len < at + 4 ||
+				    pos > skb->len - at - 4)
 					return false;
=20
-				BUG_ON(skb_copy_bits(skb, at+pos, &val,
-				       sizeof(val)) < 0);
+				ret =3D skb_copy_bits(skb, at + pos, &val,
+				      sizeof(val));
+				BUG_ON(ret < 0);
 				val =3D ntohl(val);
 				break;
 			}
---699020219-1218229204-1182864855=:3137
Content-Type: APPLICATION/x-bzip; name=xt_u32_2.diff.bz2
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0706261535060.3137@fbirervta.pbzchgretzou.qr>
Content-Description: 
Content-Disposition: attachment; filename=xt_u32_2.diff.bz2

QlpoOTFBWSZTWXhBpO8AAdPflHhwWX////+xjkq//9/+ACAQAFAD2I3urW5a
OTWuEokyCmT1Ho00am1Nohpo0aNAAaAAyaACSinkaT1PUmRmhNAaGgAAAAAA
GgYmoRMgmp+qeRkENG1DRgBGgNAaeoDagcNNMEMhppkZMIBpoAwmjTJgAQNB
JIQNTJiaR5KZiT9UwQeoA9QAAADZRM3IgVohY1rMkAoNJmIUJBIhw24bCcJJ
IayAaAZTSHgx3d4j7PIy0aVw0MqNan4p7lTp3MIt7b9r3YhJCz1TtkjZr6KN
duemqofBmCQUDmTS85XA5ikjyYL8gd6D5YoZQt92YqgYZzDe23HsRXUN0TFh
sV6VkUZXH1IJR50NY0TWIyadjU8UjlhH3mOZO8SlE0FmJcS1KtCov6YG27NJ
NaeGSx7AQ/V51s04MsiVuq1ZsFrM96ufIK8JgtstDjzaNwD2E5oKh6KcNYIz
vsMC6fDF40L8UcrInGCAXjwe45wqMKPrjQ3OShanSIkkrAOFEUxgGAIQPPBb
Jvdl4YgNnRnGDEBKbSTgd2TWXZ7EMxYDszA88kDqTKoVxfqpuz2qtHadpcVd
j3/JTTIRgAX7B3PLy3AsddYgPSqLfCW7nbYUp7HPYmognnKnvqPAmaMLX2g9
WBZU8JxVaBSlbYqd++cIkZqcTit6di7Vkb3t5fxJYE8l1QqcwJOoQbGR0srm
5oKjuniaYlCA5yvAl74h5OhlMsed7n11Vj6hemuoNamZCFCBrfLO70QbV1Kc
qFNIU74bKWAgRK9wQ+6D8CNQS5wJB8pWqRKmOfjcoqLcYhxVEc1gTyZ0lIus
HlgFA/l2LqBuCv11IoI3yqaFoNkAc8xEhFEOeRv0NKddxwDunDwcIaEGDMa6
2eizIqMU4TMblHeGRwuuuTjhNlQ+kHMJ7lTaXIstBnps7+GGUU7popNsTSar
1UnIZNFQRXpNLNSb7EsuGj+J82lZRU0sNbAPloCAaVyDgCNw9Eb84aiAK5eM
G8KUEoqSg+lqoFJVi5CyEk3shULqkiDleUXDhqHYppoKhgnwWJXrEVFiHtBs
FlszBwr93CThq3SEQs4d+OQHi4gYNNkdKFbY1djguxczeZl28wTCZlgFZdTH
tGSO4hRHbrT8YO0Ici1l08agDwLNTNKq7KcV7p0Wap/1DiygQEgEFhvEQQM5
h3yQjWm6GtdI6pD3BLUDDiUJUz5wGlmBwpKxSihbei+6tOQROEXqqpmIYF1Q
RFZVciilSaKeHEWi+4PMBsywTKzb0OJAiz0V6w4Ah+GYGRL/lP8XckU4UJB4
QaTv

---699020219-1218229204-1182864855=:3137--
