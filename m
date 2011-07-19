From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [RELEASE] ebtables v2.0.10-1
Date: Tue, 19 Jul 2011 22:54:32 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1107192253330.21154@frira.zrqbmnf.qr>
References: <4E19EE09.8070602@pandora.be> <alpine.LNX.2.01.1107102141380.7932@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:46410 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab1GSUye (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jul 2011 16:54:34 -0400
In-Reply-To: <alpine.LNX.2.01.1107102141380.7932@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2011-07-10 21:53, Jan Engelhardt wrote:

>On Sunday 2011-07-10 20:23, Bart De Schuymer wrote:
>
>> Hi all,
>>
>> I just released a new version of the ebtables tool.

I had produced this patch in response to a gcc warning. Compiles, but=20
not tested.

--->8---
=46rom: Jan Engelhardt <jengelh@medozas.de>
Date: 2011-07-11 01:11 +0200

libebt_among: fix undefined behavior on dereference of typepunned ptr

extensions/ebt_among.c: In function =E2=80=98create_wormhash=E2=80=99:
extensions/ebt_among.c:250:4: warning: dereferencing type-punned pointe=
r will break strict-aliasing rules
extensions/ebt_among.c:261:3: warning: dereferencing type-punned pointe=
r will break strict-aliasing rules

---
 extensions/ebt_among.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

Index: ebtables-v2.0.10-1/extensions/ebt_among.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ebtables-v2.0.10-1.orig/extensions/ebt_among.c
+++ ebtables-v2.0.10-1/extensions/ebt_among.c
@@ -183,7 +183,7 @@ static struct ebt_mac_wormhash *create_w
 	char *endptr;
 	struct ebt_mac_wormhash *workcopy, *result, *h;
 	unsigned char mac[6];
-	unsigned char ip[4];
+	uint32_t ip;
 	int nmacs =3D 0;
 	int i;
 	char token[4];
@@ -222,16 +222,18 @@ static struct ebt_mac_wormhash *create_w
 			ebt_print_error("MAC parse error: %.20s", anchor);
 			return NULL;
 		}
+		ip =3D 0;
 		if (*pc =3D=3D '=3D') {
 			/* an IP follows the MAC; collect similarly to MAC */
 			pc++;
 			anchor =3D pc;
-			for (i =3D 0; i < 3; i++) {
+			for (i =3D 3; i > 0; --i) {
 				if (read_until(&pc, ".", token, 3) < 0 || token[0] =3D=3D 0) {
 					ebt_print_error("IP parse error: %.20s", anchor);
 					return NULL;
 				}
-				ip[i] =3D strtol(token, &endptr, 10);
+				/* 0xFF warrants using 8 - not CHAR_BIT. */
+				ip |=3D (strtoul(token, &endptr, 10) & 0xFF) << (8 * i);
 				if (*endptr) {
 					ebt_print_error("IP parse error: %.20s", anchor);
 					return NULL;
@@ -242,23 +244,21 @@ static struct ebt_mac_wormhash *create_w
 				ebt_print_error("IP parse error: %.20s", anchor);
 				return NULL;
 			}
-			ip[3] =3D strtol(token, &endptr, 10);
+			ip |=3D strtoul(token, &endptr, 10) & 0xFF;
 			if (*endptr) {
 				ebt_print_error("IP parse error: %.20s", anchor);
 				return NULL;
 			}
-			if (*(uint32_t*)ip =3D=3D 0) {
+			ip =3D htonl(ip);
+			if (ip =3D=3D 0) {
 				ebt_print_error("Illegal IP 0.0.0.0");
 				return NULL;
 			}
-		} else {
-			/* no IP, we set it to 0.0.0.0 */
-			memset(ip, 0, 4);
 		}
=20
 		/* we have collected MAC and IP, so we add an entry */
 		memcpy(((char *) workcopy->pool[nmacs].cmp) + 2, mac, 6);
-		workcopy->pool[nmacs].ip =3D *(const uint32_t *) ip;
+		workcopy->pool[nmacs].ip =3D ip;
 		nmacs++;
=20
 		/* re-allocate memory if needed */
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
