From: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
Subject: [PATCH conntrack 4/4] tests: conntrack: use local conntrack binary
Date: Mon, 25 Jan 2016 10:40:30 +0000
Message-ID: <1453718430-5784-4-git-send-email-ast@fiberby.dk>
References: <1453718430-5784-1-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([185.38.24.25]:57971 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932480AbcAYKlD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2016 05:41:03 -0500
In-Reply-To: <1453718430-5784-1-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The binary under test should be the one, this ensures
that it is in sync with the tests performed, and that
users who build from source, can test the binary prior
to `make install`.

Signed-off-by: Asbj=C3=B8rn Sloth T=C3=B8nnesen <ast@fiberby.dk>
---

This is my preference, others might prefer it as it is.
Maybe it should be possible to overwrite with an
enviromental variable or an argument, currently test-conntrack.c
doesn't take any arguments, but run-tests.sh passes the
testdir as an argument.

 tests/conntrack/test-conntrack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/conntrack/test-conntrack.c b/tests/conntrack/test-co=
nntrack.c
index e8d2eb3..f410c09 100644
--- a/tests/conntrack/test-conntrack.c
+++ b/tests/conntrack/test-conntrack.c
@@ -17,7 +17,7 @@
 #include <sys/wait.h>
 #include <dirent.h>
=20
-#define CT_PROG "/usr/sbin/conntrack"
+#define CT_PROG "../../src/conntrack"
=20
 int main()
 {
--=20
2.6.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
