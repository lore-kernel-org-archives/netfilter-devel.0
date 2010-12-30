From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/4] qa: resolve compiler warnings
Date: Fri, 31 Dec 2010 00:41:42 +0100
Message-ID: <1293752503-13178-5-git-send-email-jengelh@medozas.de>
References: <1293752503-13178-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43771 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412Ab0L3Xls (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:41:48 -0500
In-Reply-To: <1293752503-13178-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-Wall flags this:

make  test_api test_filter
make[1]: Entering directory `/home/jengelh/code/libnetfilter_conntrack/=
qa'
  CC     test_api.o
test_api.c:16:8: warning: return type defaults to "int"
test_api.c: In function "eval_sigterm":
test_api.c:23:18: warning: too many arguments for format
test_api.c: In function "main":
test_api.c:55:2: warning: implicit declaration of function "fork"
test_api.c:34:22: warning: unused variable "h"
test_api.c:102:1: warning: control reaches end of non-void function
test_api.c: In function "eval_sigterm":
test_api.c:29:1: warning: control reaches end of non-void function
  CCLD   test_api
  CC     test_filter.o
test_filter.c: In function "main":
test_filter.c:58:4: warning: implicit declaration of function "inet_add=
r"
test_filter.c:74:2: warning: implicit declaration of function "strerror=
"
test_filter.c:74:2: warning: format "%s" expects type =E2=80=98char *=E2=
=80=99, but argument 3 has type =E2=80=98int=E2=80=99
test_filter.c:75:1: warning: control reaches end of non-void function
  CCLD   test_filter

make[1]: Leaving directory `/home/jengelh/code/libnetfilter_conntrack/q=
a'

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 qa/test_api.c    |    9 +++++----
 qa/test_filter.c |    6 +++++-
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/qa/test_api.c b/qa/test_api.c
index eda9d49..e7a8453 100644
--- a/qa/test_api.c
+++ b/qa/test_api.c
@@ -4,6 +4,7 @@
=20
 #include <stdio.h>
 #include <stdlib.h>
+#include <unistd.h>
 #include <sys/wait.h>
 #include <errno.h>
=20
@@ -13,14 +14,14 @@
  * this file contains a test to check the set/get/copy/cmp APIs.
  */
=20
-static eval_sigterm(int status)
+static void eval_sigterm(int status)
 {
 	switch(WTERMSIG(status)) {
 	case SIGSEGV:
 		printf("received SIGSEV\n");
 		break;
 	case 0:
-		printf("OK\n", WTERMSIG(status));
+		printf("OK\n");
 		break;
 	default:
 		printf("exited with signal: %d\n", WTERMSIG(status));
@@ -28,10 +29,9 @@ static eval_sigterm(int status)
 	}
 }
=20
-int main()
+int main(void)
 {
 	int ret, i;
-	struct nfct_handle *h;
 	struct nf_conntrack *ct, *tmp;
 	char data[32];
 	int status;
@@ -99,4 +99,5 @@ int main()
=20
 	nfct_destroy(ct);
 	nfct_destroy(tmp);
+	return EXIT_SUCCESS;
 }
diff --git a/qa/test_filter.c b/qa/test_filter.c
index 35fdbec..7877819 100644
--- a/qa/test_filter.c
+++ b/qa/test_filter.c
@@ -3,6 +3,9 @@
  */
=20
 #include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <arpa/inet.h>
 #include <errno.h>
=20
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
@@ -23,7 +26,7 @@ static int event_cb(enum nf_conntrack_msg_type type,
 	return NFCT_CB_CONTINUE;
 }
=20
-int main()
+int main(void)
 {
 	int i, ret;
 	struct nfct_handle *h;
@@ -72,4 +75,5 @@ int main()
=20
 	ret =3D nfct_catch(h);
 	printf("test ret=3D%d (%s)\n", ret, strerror(errno));
+	return EXIT_SUCCESS;
 }
--=20
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
