From: Giorgio Dal Molin <giorgio.nicole@arcor.de>
Subject: [PATCH 5/8] autotools conversion: include the header 'config.h' in every C source file.
Date: Fri, 25 Jul 2014 23:52:56 +0159
Message-ID: <1406325204-23648-6-git-send-email-giorgio.nicole@arcor.de>
References: <20140725171646.GA5718@salvia>
 <1406325204-23648-1-git-send-email-giorgio.nicole@arcor.de>
Cc: Giorgio Dal Molin <giorgio.nicole@arcor.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:47068 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933391AbaGYVyz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2014 17:54:55 -0400
Received: from mail-in-16-z2.arcor-online.net (mail-in-16-z2.arcor-online.net [151.189.8.33])
	by mx.arcor.de (Postfix) with ESMTP id 8A47310BC18
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jul 2014 23:54:53 +0200 (CEST)
In-Reply-To: <1406325204-23648-1-git-send-email-giorgio.nicole@arcor.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Added an #include <config.h> to all the C source files so that the results
of the tests in the configure script are available to all the compilation
units.

We could have added the include also to 'yacc_parser.y' and 'scanner.l'
but we don't, because it is not strictly needed and to avoid to define
the variable 'VERSION' two times.
---
 src/cli.c                 | 2 ++
 src/ct.c                  | 2 ++
 src/datatype.c            | 2 ++
 src/erec.c                | 2 ++
 src/evaluate.c            | 2 ++
 src/expression.c          | 2 ++
 src/exthdr.c              | 2 ++
 src/gmputil.c             | 2 ++
 src/main.c                | 2 ++
 src/meta.c                | 2 ++
 src/mnl.c                 | 2 ++
 src/netlink.c             | 2 ++
 src/netlink_delinearize.c | 2 ++
 src/netlink_linearize.c   | 2 ++
 src/payload.c             | 2 ++
 src/proto.c               | 2 ++
 src/rbtree.c              | 2 ++
 src/rule.c                | 2 ++
 src/segtree.c             | 2 ++
 src/statement.c           | 2 ++
 src/utils.c               | 2 ++
 21 files changed, 42 insertions(+)

diff --git a/src/cli.c b/src/cli.c
index f748a0e..8943349 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -12,6 +12,8 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <config.h>
+
 #include <stdlib.h>
 #include <stdio.h>
 #include <stdarg.h>
diff --git a/src/ct.c b/src/ct.c
index 30639b2..3bddfcb 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -10,6 +10,8 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <config.h>
+
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
diff --git a/src/datatype.c b/src/datatype.c
index 55af227..2ce2997 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -8,6 +8,8 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <config.h>
+
 #include <stdlib.h>
 #include <string.h>
 #include <inttypes.h>
diff --git a/src/erec.c b/src/erec.c
index 4930085..8532470 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -8,6 +8,8 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <config.h>
+
 #include <stdio.h>
 #include <string.h>
 #include <stdarg.h>
diff --git a/src/evaluate.c b/src/evaluate.c
index e05473a..ae54d00 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -8,6 +8,8 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <config.h>
+
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
diff --git a/src/expression.c b/src/expression.c
index fa14d99..d3b4952 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -8,6 +8,8 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <config.h>
+
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
diff --git a/src/exthdr.c b/src/exthdr.c
index a619ecc..a980555 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -10,6 +10,8 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <config.h>
+
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
diff --git a/src/gmputil.c b/src/gmputil.c
index cb46445..3d22702 100644
--- a/src/gmputil.c
+++ b/src/gmputil.c
@@ -8,6 +8,8 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <config.h>
+
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdarg.h>
diff --git a/src/main.c b/src/main.c
index bd8feee..c2bbc9f 100644
--- a/src/main.c
+++ b/src/main.c
@@ -8,6 +8,8 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <config.h>
+
 #include <stdlib.h>
 #include <stddef.h>
 #include <unistd.h>
diff --git a/src/meta.c b/src/meta.c
index 80f88ff..b9db99f 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -10,6 +10,8 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <config.h>
+
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
diff --git a/src/mnl.c b/src/mnl.c
index 42b11f5..9f4a0c2 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -8,6 +8,8 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <config.h>
+
 #include <libmnl/libmnl.h>
 #include <libnftnl/common.h>
 #include <libnftnl/ruleset.h>
diff --git a/src/netlink.c b/src/netlink.c
index e149215..a85ee0d 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -9,6 +9,8 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <config.h>
+
 #include <string.h>
 #include <fcntl.h>
 #include <errno.h>
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 5c6ca80..1cb514f 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -9,6 +9,8 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <config.h>
+
 #include <stdlib.h>
 #include <stdbool.h>
 #include <string.h>
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 5c1b46d..7dbe99e 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -9,6 +9,8 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <config.h>
+
 #include <linux/netfilter/nf_tables.h>
 
 #include <string.h>
diff --git a/src/payload.c b/src/payload.c
index a1785a5..553597d 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -10,6 +10,8 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <config.h>
+
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
diff --git a/src/proto.c b/src/proto.c
index e5f49cb..4d81453 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -9,6 +9,8 @@
  *
  */
 
+#include <config.h>
+
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdint.h>
diff --git a/src/rbtree.c b/src/rbtree.c
index 325c012..c400c0d 100644
--- a/src/rbtree.c
+++ b/src/rbtree.c
@@ -19,6 +19,8 @@
  *
  */
 
+#include <config.h>
+
 #include <rbtree.h>
 
 static void __rb_rotate_left(struct rb_node *node, struct rb_root *root)
diff --git a/src/rule.c b/src/rule.c
index 1e54526..2958982 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -8,6 +8,8 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <config.h>
+
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
diff --git a/src/segtree.c b/src/segtree.c
index 1785f64..a538670 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -8,6 +8,8 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <config.h>
+
 #include <stdlib.h>
 #include <inttypes.h>
 #include <arpa/inet.h>
diff --git a/src/statement.c b/src/statement.c
index 2dd3f18..03f3ddc 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -8,6 +8,8 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <config.h>
+
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
diff --git a/src/utils.c b/src/utils.c
index 96ff419..bf1e8dc 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -8,6 +8,8 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <config.h>
+
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdarg.h>
-- 
2.0.3

