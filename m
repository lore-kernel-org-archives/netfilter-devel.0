From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/4] utils: resolve compiler warnings
Date: Fri, 31 Dec 2010 00:41:41 +0100
Message-ID: <1293752503-13178-4-git-send-email-jengelh@medozas.de>
References: <1293752503-13178-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43766 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab0L3Xlr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:41:47 -0500
In-Reply-To: <1293752503-13178-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The addition of -Wall flagged some legitimate warnings:

make  expect_dump expect_create expect_get expect_delete expect_flush e=
xpect_events expect_create_userspace conntrack_create conntrack_dump co=
nntrack_update conntrack_delete conntrack_flush conntrack_create_nat co=
nntrack_get conntrack_events conntrack_master conntrack_filter conntrac=
k_grp_create ctexp_events
make[1]: Entering directory `/home/jengelh/code/libnetfilter_conntrack/=
utils'
  CC     expect_dump.o
expect_dump.c: In function "main":
expect_dump.c:36:3: warning: implicit declaration of function "strerror=
"
expect_dump.c:36:3: warning: format "%s" expects type =E2=80=98char *=E2=
=80=99, but argument 3 has type =E2=80=98int=E2=80=99
  CCLD   expect_dump
  CC     expect_create.o
expect_create.c: In function "main":
expect_create.c:31:2: warning: implicit declaration of function "inet_a=
ddr"
expect_create.c:54:3: warning: implicit declaration of function "strerr=
or"
expect_create.c:54:3: warning: format "%s" expects type =E2=80=98char *=
=E2=80=99, but argument 3 has type =E2=80=98int=E2=80=99
expect_create.c:117:3: warning: format "%s" expects type =E2=80=98char =
*=E2=80=99, but argument 3 has type =E2=80=98int=E2=80=99
  CCLD   expect_create
  CC     expect_get.o
expect_get.c: In function "main":
expect_get.c:33:2: warning: implicit declaration of function "inet_addr=
"
expect_get.c:59:3: warning: implicit declaration of function "strerror"
expect_get.c:59:3: warning: format "%s" expects type =E2=80=98char *=E2=
=80=99, but argument 3 has type =E2=80=98int=E2=80=99
  CCLD   expect_get
  CC     expect_delete.o
expect_delete.c: In function "main":
expect_delete.c:21:2: warning: implicit declaration of function "inet_a=
ddr"
expect_delete.c:46:3: warning: implicit declaration of function "strerr=
or"
expect_delete.c:46:3: warning: format "%s" expects type =E2=80=98char *=
=E2=80=99, but argument 3 has type =E2=80=98int=E2=80=99
  CCLD   expect_delete
  CC     expect_flush.o
expect_flush.c: In function "main":
expect_flush.c:23:3: warning: implicit declaration of function "strerro=
r"
expect_flush.c:23:3: warning: format "%s" expects type =E2=80=98char *=E2=
=80=99, but argument 3 has type =E2=80=98int=E2=80=99
  CCLD   expect_flush
  CC     expect_events.o
expect_events.c: In function "main":
expect_events.c:44:3: warning: implicit declaration of function "strerr=
or"
expect_events.c:44:3: warning: format "%s" expects type =E2=80=98char *=
=E2=80=99, but argument 3 has type =E2=80=98int=E2=80=99
  CCLD   expect_events
  CC     expect_create_userspace.o
expect_create_userspace.c: In function "main":
expect_create_userspace.c:31:2: warning: implicit declaration of functi=
on "inet_addr"
expect_create_userspace.c:58:3: warning: implicit declaration of functi=
on "strerror"
expect_create_userspace.c:58:3: warning: format "%s" expects type =E2=80=
=98char *=E2=80=99, but argument 3 has type =E2=80=98int=E2=80=99
expect_create_userspace.c:121:3: warning: format "%s" expects type =E2=80=
=98char *=E2=80=99, but argument 3 has type =E2=80=98int=E2=80=99
  CCLD   expect_create_userspace
  CC     conntrack_create.o
conntrack_create.c: In function "main":
conntrack_create.c:21:2: warning: implicit declaration of function "ine=
t_addr"
conntrack_create.c:43:3: warning: implicit declaration of function "str=
error"
conntrack_create.c:43:3: warning: format "%s" expects type =E2=80=98cha=
r *=E2=80=99, but argument 3 has type =E2=80=98int=E2=80=99
  CCLD   conntrack_create
  CC     conntrack_dump.o
conntrack_dump.c: In function "main":
conntrack_dump.c:37:3: warning: implicit declaration of function "strer=
ror"
conntrack_dump.c:37:3: warning: format "%s" expects type =E2=80=98char =
*=E2=80=99, but argument 3 has type =E2=80=98int=E2=80=99
conntrack_dump.c:24:7: warning: unused variable "buf"
  CCLD   conntrack_dump
  CC     conntrack_update.o
conntrack_update.c: In function "main":
conntrack_update.c:21:2: warning: implicit declaration of function "ine=
t_addr"
conntrack_update.c:43:3: warning: implicit declaration of function "str=
error"
conntrack_update.c:43:3: warning: format "%s" expects type =E2=80=98cha=
r *=E2=80=99, but argument 3 has type =E2=80=98int=E2=80=99
  CCLD   conntrack_update
  CC     conntrack_delete.o
conntrack_delete.c: In function "main":
conntrack_delete.c:21:2: warning: implicit declaration of function "ine=
t_addr"
conntrack_delete.c:38:3: warning: implicit declaration of function "str=
error"
conntrack_delete.c:38:3: warning: format "%s" expects type =E2=80=98cha=
r *=E2=80=99, but argument 3 has type =E2=80=98int=E2=80=99
  CCLD   conntrack_delete
  CC     conntrack_flush.o
conntrack_flush.c: In function "main":
conntrack_flush.c:24:3: warning: implicit declaration of function "stre=
rror"
conntrack_flush.c:24:3: warning: format "%s" expects type =E2=80=98char=
 *=E2=80=99, but argument 3 has type =E2=80=98int=E2=80=99
conntrack_flush.c:12:7: warning: unused variable "buf"
  CCLD   conntrack_flush
  CC     conntrack_create_nat.o
conntrack_create_nat.c: In function "main":
conntrack_create_nat.c:21:2: warning: implicit declaration of function =
"inet_addr"
conntrack_create_nat.c:45:3: warning: implicit declaration of function =
"strerror"
conntrack_create_nat.c:45:3: warning: format "%s" expects type =E2=80=98=
char *=E2=80=99, but argument 3 has type =E2=80=98int=E2=80=99
  CCLD   conntrack_create_nat
  CC     conntrack_get.o
conntrack_get.c: In function "main":
conntrack_get.c:33:2: warning: implicit declaration of function "inet_a=
ddr"
conntrack_get.c:52:3: warning: implicit declaration of function "strerr=
or"
conntrack_get.c:52:3: warning: format "%s" expects type =E2=80=98char *=
=E2=80=99, but argument 3 has type =E2=80=98int=E2=80=99
  CCLD   conntrack_get
  CC     conntrack_events.o
conntrack_events.c: In function "main":
conntrack_events.c:45:3: warning: implicit declaration of function "str=
error"
conntrack_events.c:45:3: warning: format "%s" expects type =E2=80=98cha=
r *=E2=80=99, but argument 3 has type =E2=80=98int=E2=80=99
conntrack_events.c:29:7: warning: unused variable "buf"
conntrack_events.c:28:23: warning: unused variable "ct"
conntrack_events.c:26:11: warning: unused variable "family"
  CCLD   conntrack_events
  CC     conntrack_master.o
conntrack_master.c: In function "main":
conntrack_master.c:22:2: warning: implicit declaration of function "ine=
t_addr"
conntrack_master.c:44:3: warning: implicit declaration of function "str=
error"
conntrack_master.c:44:3: warning: format "%s" expects type =E2=80=98cha=
r *=E2=80=99, but argument 3 has type =E2=80=98int=E2=80=99
conntrack_master.c:86:3: warning: format "%s" expects type =E2=80=98cha=
r *=E2=80=99, but argument 3 has type =E2=80=98int=E2=80=99
  CCLD   conntrack_master
  CC     conntrack_filter.o
conntrack_filter.c: In function "main":
conntrack_filter.c:58:3: warning: implicit declaration of function "ine=
t_addr"
conntrack_filter.c:98:3: warning: implicit declaration of function "str=
error"
conntrack_filter.c:98:3: warning: format "%s" expects type =E2=80=98cha=
r *=E2=80=99, but argument 3 has type =E2=80=98int=E2=80=99
conntrack_filter.c:31:7: warning: unused variable "buf"
conntrack_filter.c:30:23: warning: unused variable "ct"
conntrack_filter.c:27:11: warning: unused variable "family"
  CCLD   conntrack_filter
  CC     conntrack_grp_create.o
conntrack_grp_create.c: In function "main":
conntrack_grp_create.c:21:3: warning: implicit declaration of function =
"inet_addr"
conntrack_grp_create.c:49:3: warning: implicit declaration of function =
"strerror"
conntrack_grp_create.c:49:3: warning: format "%s" expects type =E2=80=98=
char *=E2=80=99, but argument 3 has type =E2=80=98int=E2=80=99
  CCLD   conntrack_grp_create
  CC     ctexp_events.o
ctexp_events.c: In function "main":
ctexp_events.c:63:3: warning: implicit declaration of function "strerro=
r"
ctexp_events.c:63:3: warning: format "%s" expects type =E2=80=98char *=E2=
=80=99, but argument 3 has type =E2=80=98int=E2=80=99
  CCLD   ctexp_events
make[1]: Leaving directory `/home/jengelh/code/libnetfilter_conntrack/u=
tils'

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 utils/conntrack_create.c        |    4 +++-
 utils/conntrack_create_nat.c    |    4 +++-
 utils/conntrack_delete.c        |    4 +++-
 utils/conntrack_dump.c          |    4 ++--
 utils/conntrack_events.c        |    6 ++----
 utils/conntrack_filter.c        |    7 +++----
 utils/conntrack_flush.c         |    4 ++--
 utils/conntrack_get.c           |    4 +++-
 utils/conntrack_grp_create.c    |    4 +++-
 utils/conntrack_master.c        |    4 +++-
 utils/conntrack_update.c        |    4 +++-
 utils/ctexp_events.c            |    1 +
 utils/expect_create.c           |    4 +++-
 utils/expect_create_userspace.c |    4 +++-
 utils/expect_delete.c           |    4 +++-
 utils/expect_dump.c             |    3 ++-
 utils/expect_events.c           |    3 ++-
 utils/expect_flush.c            |    3 ++-
 utils/expect_get.c              |    4 +++-
 19 files changed, 49 insertions(+), 26 deletions(-)

diff --git a/utils/conntrack_create.c b/utils/conntrack_create.c
index a168d2c..7140b97 100644
--- a/utils/conntrack_create.c
+++ b/utils/conntrack_create.c
@@ -1,11 +1,13 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <errno.h>
+#include <arpa/inet.h>
=20
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack_tcp.h>
=20
-int main()
+int main(void)
 {
 	int ret;
 	struct nfct_handle *h;
diff --git a/utils/conntrack_create_nat.c b/utils/conntrack_create_nat.=
c
index 3cc65df..f7426ee 100644
--- a/utils/conntrack_create_nat.c
+++ b/utils/conntrack_create_nat.c
@@ -1,11 +1,13 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <errno.h>
+#include <arpa/inet.h>
=20
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack_tcp.h>
=20
-int main()
+int main(void)
 {
 	int ret;
 	struct nfct_handle *h;
diff --git a/utils/conntrack_delete.c b/utils/conntrack_delete.c
index 227319f..b3204dd 100644
--- a/utils/conntrack_delete.c
+++ b/utils/conntrack_delete.c
@@ -1,11 +1,13 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <errno.h>
+#include <arpa/inet.h>
=20
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack_tcp.h>
=20
-int main()
+int main(void)
 {
 	int ret;
 	struct nfct_handle *h;
diff --git a/utils/conntrack_dump.c b/utils/conntrack_dump.c
index a15acc1..a36e753 100644
--- a/utils/conntrack_dump.c
+++ b/utils/conntrack_dump.c
@@ -1,5 +1,6 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <errno.h>
=20
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
@@ -16,12 +17,11 @@ static int cb(enum nf_conntrack_msg_type type,
 	return NFCT_CB_CONTINUE;
 }
=20
-int main()
+int main(void)
 {
 	int ret;
 	u_int32_t family =3D AF_INET;
 	struct nfct_handle *h;
-	char buf[1024];
=20
 	h =3D nfct_open(CONNTRACK, 0);
 	if (!h) {
diff --git a/utils/conntrack_events.c b/utils/conntrack_events.c
index 1f115e2..f5e72c7 100644
--- a/utils/conntrack_events.c
+++ b/utils/conntrack_events.c
@@ -1,5 +1,6 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <errno.h>
=20
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
@@ -20,13 +21,10 @@ static int event_cb(enum nf_conntrack_msg_type type=
,
 	return NFCT_CB_CONTINUE;
 }
=20
-int main()
+int main(void)
 {
 	int ret;
-	u_int8_t family =3D AF_INET;
 	struct nfct_handle *h;
-	struct nf_conntrack *ct;
-	char buf[1024];
=20
 	h =3D nfct_open(CONNTRACK, NFCT_ALL_CT_GROUPS);
 	if (!h) {
diff --git a/utils/conntrack_filter.c b/utils/conntrack_filter.c
index b05c37c..a3eeebc 100644
--- a/utils/conntrack_filter.c
+++ b/utils/conntrack_filter.c
@@ -1,6 +1,8 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <errno.h>
+#include <arpa/inet.h>
=20
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack_tcp.h>
@@ -21,14 +23,11 @@ static int event_cb(enum nf_conntrack_msg_type type=
,
 	return NFCT_CB_CONTINUE;
 }
=20
-int main()
+int main(void)
 {
 	int ret;
-	u_int8_t family =3D AF_INET;
 	struct nfct_handle *h;
 	struct nfct_filter *filter;
-	struct nf_conntrack *ct;
-	char buf[1024];
=20
 	h =3D nfct_open(CONNTRACK, NF_NETLINK_CONNTRACK_NEW |=20
 				 NF_NETLINK_CONNTRACK_UPDATE);
diff --git a/utils/conntrack_flush.c b/utils/conntrack_flush.c
index 92aac86..36437e2 100644
--- a/utils/conntrack_flush.c
+++ b/utils/conntrack_flush.c
@@ -1,15 +1,15 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <errno.h>
=20
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
=20
-int main()
+int main(void)
 {
 	int ret;
 	u_int8_t family =3D AF_INET;
 	struct nfct_handle *h;
-	char buf[1024];
=20
 	h =3D nfct_open(CONNTRACK, 0);
 	if (!h) {
diff --git a/utils/conntrack_get.c b/utils/conntrack_get.c
index 33c836b..7d7badd 100644
--- a/utils/conntrack_get.c
+++ b/utils/conntrack_get.c
@@ -1,6 +1,8 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <errno.h>
+#include <arpa/inet.h>
=20
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack_tcp.h>
@@ -17,7 +19,7 @@ static int cb(enum nf_conntrack_msg_type type,
 	return NFCT_CB_CONTINUE;
 }
=20
-int main()
+int main(void)
 {
 	int ret;
 	struct nfct_handle *h;
diff --git a/utils/conntrack_grp_create.c b/utils/conntrack_grp_create.=
c
index b77d155..b47d09a 100644
--- a/utils/conntrack_grp_create.c
+++ b/utils/conntrack_grp_create.c
@@ -1,11 +1,13 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <errno.h>
+#include <arpa/inet.h>
=20
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack_tcp.h>
=20
-int main()
+int main(void)
 {
 	int ret;
 	struct nfct_handle *h;
diff --git a/utils/conntrack_master.c b/utils/conntrack_master.c
index d1552a4..d08219a 100644
--- a/utils/conntrack_master.c
+++ b/utils/conntrack_master.c
@@ -1,11 +1,13 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <errno.h>
+#include <arpa/inet.h>
=20
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack_tcp.h>
=20
-int main()
+int main(void)
 {
 	int ret;
 	struct nfct_handle *h;
diff --git a/utils/conntrack_update.c b/utils/conntrack_update.c
index 0256b7a..24545ca 100644
--- a/utils/conntrack_update.c
+++ b/utils/conntrack_update.c
@@ -1,11 +1,13 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <errno.h>
+#include <arpa/inet.h>
=20
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack_tcp.h>
=20
-int main()
+int main(void)
 {
 	int ret;
 	struct nfct_handle *h;
diff --git a/utils/ctexp_events.c b/utils/ctexp_events.c
index ec459e4..c53d026 100644
--- a/utils/ctexp_events.c
+++ b/utils/ctexp_events.c
@@ -1,5 +1,6 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <errno.h>
=20
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
diff --git a/utils/expect_create.c b/utils/expect_create.c
index 9e3c7fb..912ab8e 100644
--- a/utils/expect_create.c
+++ b/utils/expect_create.c
@@ -1,6 +1,8 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <errno.h>
+#include <arpa/inet.h>
=20
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack_tcp.h>
@@ -10,7 +12,7 @@
  * Therefore, make sure you have load nf_conntrack_ftp before executin=
g it.=20
  */
=20
-int main()
+int main(void)
 {
 	int ret;
 	struct nfct_handle *h;
diff --git a/utils/expect_create_userspace.c b/utils/expect_create_user=
space.c
index 67e7b2a..0e910e6 100644
--- a/utils/expect_create_userspace.c
+++ b/utils/expect_create_userspace.c
@@ -1,6 +1,8 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <errno.h>
+#include <arpa/inet.h>
=20
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack_tcp.h>
@@ -10,7 +12,7 @@
  * a Linux kernel >=3D 2.6.37.
  */
=20
-int main()
+int main(void)
 {
 	int ret;
 	struct nfct_handle *h;
diff --git a/utils/expect_delete.c b/utils/expect_delete.c
index d6b56f1..18f4a79 100644
--- a/utils/expect_delete.c
+++ b/utils/expect_delete.c
@@ -1,10 +1,12 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <errno.h>
+#include <arpa/inet.h>
=20
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
=20
-int main()
+int main(void)
 {
 	int ret;
 	struct nfct_handle *h;
diff --git a/utils/expect_dump.c b/utils/expect_dump.c
index fa25bad..b227e1a 100644
--- a/utils/expect_dump.c
+++ b/utils/expect_dump.c
@@ -1,5 +1,6 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <errno.h>
=20
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
@@ -16,7 +17,7 @@ static int cb(enum nf_conntrack_msg_type type,
 	return NFCT_CB_CONTINUE;
 }
=20
-int main()
+int main(void)
 {
 	int ret;
 	u_int8_t family =3D AF_INET;
diff --git a/utils/expect_events.c b/utils/expect_events.c
index 89426f4..8adacb6 100644
--- a/utils/expect_events.c
+++ b/utils/expect_events.c
@@ -1,5 +1,6 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <errno.h>
=20
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
@@ -20,7 +21,7 @@ static int event_cb(enum nf_conntrack_msg_type type,
 	return NFCT_CB_CONTINUE;
 }
=20
-int main()
+int main(void)
 {
 	int ret;
 	struct nfct_handle *h;
diff --git a/utils/expect_flush.c b/utils/expect_flush.c
index 4e28c1c..1ae69c9 100644
--- a/utils/expect_flush.c
+++ b/utils/expect_flush.c
@@ -1,10 +1,11 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <errno.h>
=20
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
=20
-int main()
+int main(void)
 {
 	int ret;
 	u_int8_t family =3D AF_INET;
diff --git a/utils/expect_get.c b/utils/expect_get.c
index cda5a3b..fc7e116 100644
--- a/utils/expect_get.c
+++ b/utils/expect_get.c
@@ -1,6 +1,8 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <errno.h>
+#include <arpa/inet.h>
=20
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
=20
@@ -16,7 +18,7 @@ static int cb(enum nf_conntrack_msg_type type,
 	return NFCT_CB_CONTINUE;
 }
=20
-int main()
+int main(void)
 {
 	int ret;
 	struct nfct_handle *h;
--=20
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
