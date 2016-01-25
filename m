From: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
Subject: [PATCH conntrack 2/4] tests: conntrack: flush stdout to keep sync
Date: Mon, 25 Jan 2016 10:40:28 +0000
Message-ID: <1453718430-5784-2-git-send-email-ast@fiberby.dk>
References: <1453718430-5784-1-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([185.38.24.25]:42721 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932481AbcAYKlD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2016 05:41:03 -0500
In-Reply-To: <1453718430-5784-1-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Asbj=C3=B8rn Sloth T=C3=B8nnesen <ast@fiberby.dk>
---
 tests/conntrack/test-conntrack.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/conntrack/test-conntrack.c b/tests/conntrack/test-co=
nntrack.c
index 8f1cea0..9d06a23 100644
--- a/tests/conntrack/test-conntrack.c
+++ b/tests/conntrack/test-conntrack.c
@@ -65,6 +65,7 @@ int main()
 			strcpy(tmp + strlen(CT_PROG) + 1, buf);
 			printf("(%d) Executing: %s\n", line, tmp);
=20
+			fflush(stdout);
 			ret =3D system(tmp);
=20
 			if (WIFEXITED(ret) &&
--=20
2.6.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
