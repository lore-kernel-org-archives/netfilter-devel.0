From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [libnftnl PATCH] log: define variable flags in xml parser
Date: Mon, 14 Jul 2014 21:04:31 +0200
Message-ID: <1405364671-26103-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47427 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbaGNTEn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:04:43 -0400
Received: by mail-wi0-f178.google.com with SMTP id hi2so3107060wib.5
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Jul 2014 12:04:41 -0700 (PDT)
Received: from localhost.localdomain (85.136.70.56.dyn.user.ono.com. [85.136.70.56])
        by mx.google.com with ESMTPSA id cj8sm27282706wjb.5.2014.07.14.12.04.40
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jul 2014 12:04:41 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

In the xml parser, we have used a variable flags for parsing it
but we have forgot define it. This patch solves a compile error
like:

expr/log.c:263:12: error: 'flags' undeclared (first use in this functio=
n)

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/expr/log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expr/log.c b/src/expr/log.c
index 740db03..bc70eca 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -233,7 +233,7 @@ static int nft_rule_expr_log_xml_parse(struct nft_r=
ule_expr *e,
 {
 #ifdef XML_PARSING
 	const char *prefix;
-	uint32_t snaplen, level;
+	uint32_t snaplen, level, flags;
 	uint16_t group, qthreshold;
=20
 	prefix =3D nft_mxml_str_parse(tree, "prefix", MXML_DESCEND_FIRST,
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
