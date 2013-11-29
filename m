From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] meta: fix endianness in UID/GID
Date: Fri, 29 Nov 2013 11:31:55 +0100
Message-ID: <1385721116-5910-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?q?Bj=C3=B8rnar=20Ness?= <bjornar.ness@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59305 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab3K2KcI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Nov 2013 05:32:08 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 add rule filter output meta skuid vmap { 1000 =3D> accept }
 list table filter
 meta skuid map { 3892510720 =3D> accept}
                  ^--------^
        this is 1000 in network byte order

Reported-by: Bj=C3=B8rnar Ness <bjornar.ness@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/meta.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index 9606a44..80c2638 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -230,7 +230,7 @@ static const struct datatype uid_type =3D {
 	.type		=3D TYPE_UID,
 	.name		=3D "uid",
 	.desc		=3D "user ID",
-	.byteorder	=3D BYTEORDER_BIG_ENDIAN,
+	.byteorder	=3D BYTEORDER_HOST_ENDIAN,
 	.size		=3D sizeof(uid_t) * BITS_PER_BYTE,
 	.basetype	=3D &integer_type,
 	.print		=3D uid_type_print,
@@ -275,7 +275,7 @@ static const struct datatype gid_type =3D {
 	.type		=3D TYPE_GID,
 	.name		=3D "gid",
 	.desc		=3D "group ID",
-	.byteorder	=3D BYTEORDER_BIG_ENDIAN,
+	.byteorder	=3D BYTEORDER_HOST_ENDIAN,
 	.size		=3D sizeof(gid_t) * BITS_PER_BYTE,
 	.basetype	=3D &integer_type,
 	.print		=3D gid_type_print,
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
