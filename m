From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 2/2 nft] parser: Check commentaries length
Date: Mon, 30 May 2016 18:35:40 +0200
Message-ID: <1464626140-3449-2-git-send-email-carlosfg@riseup.net>
References: <1464626140-3449-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:38524 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161220AbcE3Qfv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 12:35:51 -0400
In-Reply-To: <1464626140-3449-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Checks the commentary maximum length and reports to user in case of err=
or.

Example:
> nft add table t
> nft add chain t c
> nft add rule t c ip saddr 1.1.1.1 counter comment "abc...xyz" # len >=
 128
<cmdline>:1:47-N: Error: Comment too long. 128 characters maximum allow=
ed
add rule t c ip saddr 1.1.1.1 counter comment abc...xyz
                                              ^^^^^^^^^

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 include/rule.h     | 2 ++
 src/parser_bison.y | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index bd24648..7e8daac 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -428,4 +428,6 @@ enum udata_type {
 };
 #define UDATA_TYPE_MAX (__UDATA_TYPE_MAX - 1)
=20
+#define UDATA_COMMENT_MAXLEN 128
+
 #endif /* NFTABLES_RULE_H */
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6f51a49..0bf0e27 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1275,6 +1275,11 @@ ruleid_spec		:	chain_spec	handle_spec	position_s=
pec
=20
 comment_spec		:	COMMENT		string
 			{
+				if (strlen($2) > UDATA_COMMENT_MAXLEN ) {
+					erec_queue(error(&@2, "Comment too long. %d characters maximum al=
lowed", UDATA_COMMENT_MAXLEN),
+						   state->msgs);
+					YYERROR;
+				}
 				$$ =3D $2;
 			}
 			;
--=20
2.8.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
