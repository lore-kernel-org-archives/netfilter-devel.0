From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nftables 1/2] datatype: fix missing nul-terminator in string_type_print
Date: Mon, 25 Nov 2013 00:05:29 +0100
Message-ID: <1385334329-3969-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: loki@lokis-chaos.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42448 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723Ab3KXXFm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Nov 2013 18:05:42 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Berger reported that he is seeing garbage after some
valid string values, eg.

fwtest01 ~ # nft -i
nft> table filter
nft> add chain filter input
nft> add rule filter input meta iifname "lo" accept
nft> list table filter
table ip filter {
        chain input {
                 meta iifname "lo=EF=BF=BD.=EF=BF=BD" accept
        }
=2E..

The buffer that the string datatype was allocating did not include
room for the nul-terminator. This patch fixes bugzilla report #872:

https://bugzilla.netfilter.org/show_bug.cgi?id=3D872

Reported-by: Thomas Berger <loki@lokis-chaos.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/datatype.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/datatype.c b/src/datatype.c
index 4c5a70f..2e5788d 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -256,9 +256,10 @@ const struct datatype integer_type =3D {
 static void string_type_print(const struct expr *expr)
 {
 	unsigned int len =3D div_round_up(expr->len, BITS_PER_BYTE);
-	char data[len];
+	char data[len+1];
=20
 	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
+	data[len] =3D '\0';
 	printf("\"%s\"", data);
 }
=20
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
