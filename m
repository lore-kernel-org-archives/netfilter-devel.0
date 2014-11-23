From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] parser: restore named vmap
Date: Sun, 23 Nov 2014 21:11:03 +0100
Message-ID: <1416773463-8583-2-git-send-email-pablo@netfilter.org>
References: <1416773463-8583-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net, bjornar.ness@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37077 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbaKWUJE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Nov 2014 15:09:04 -0500
In-Reply-To: <1416773463-8583-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46or example:

nft add map filter my_vmap { type ipv4_addr : verdict\; }
nft add element filter my_vmap { 1.0.0.0 : drop}
nft add rule filter input ip saddr vmap @my_vmap

Reported-by: Bj=C3=B8rnar Ness <bjornar.ness@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6eb0475..ad2951a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1211,6 +1211,13 @@ verdict_map_expr	:	'{'	verdict_map_list_expr	'}'
 				$2->location =3D @$;
 				$$ =3D $2;
 			}
+			|	AT	identifier
+			{
+				$$ =3D symbol_expr_alloc(&@$, SYMBOL_SET,
+						       current_scope(state),
+						       $2);
+				xfree($2);
+			}
 			;
=20
 verdict_map_list_expr	:	verdict_map_list_member_expr
@@ -1691,6 +1698,10 @@ set_list_member_expr	:	opt_newline	expr	opt_newl=
ine
 			{
 				$$ =3D mapping_expr_alloc(&@$, $2, $4);
 			}
+			|	opt_newline	map_lhs_expr	COLON	verdict_expr	opt_newline
+			{
+				$$ =3D mapping_expr_alloc(&@$, $2, $4);
+			}
 			;
=20
 initializer_expr	:	expr
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
