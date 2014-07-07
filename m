From: Giorgio Dal Molin <giorgio.nicole@arcor.de>
Subject: [PATCH 4/7] autotools conversion: include the header 'config.h' in every C source file.
Date: Mon,  7 Jul 2014 16:19:28 +0200
Message-ID: <1404742796-8039-5-git-send-email-giorgio.nicole@arcor.de>
References: <1404742796-8039-1-git-send-email-giorgio.nicole@arcor.de>
Cc: Giorgio Dal Molin <giorgio.nicole@arcor.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:46450 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077AbaGGOUL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:20:11 -0400
Received: from mail-in-13-z2.arcor-online.net (mail-in-13-z2.arcor-online.net [151.189.8.30])
	by mx.arcor.de (Postfix) with ESMTP id 5F5BC21237A
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Jul 2014 16:20:10 +0200 (CEST)
In-Reply-To: <1404742796-8039-1-git-send-email-giorgio.nicole@arcor.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Added an #include <config.h> to all the C source files so that the results
of the tests in the configure script are available to all the compilation
units.

We could have added the include also to 'yacc_parser.y' and 'scanner.l'
but we don't, because it is not strictly needed and to avoid to define
the variable 'VERSION' two times.
---
 src/cli.c                 | 3 +++
 src/ct.c                  | 3 +++
 src/datatype.c            | 3 +++
 src/erec.c                | 3 +++
 src/evaluate.c            | 3 +++
 src/expression.c          | 3 +++
 src/exthdr.c              | 3 +++
 src/gmputil.c             | 3 +++
 src/main.c                | 3 +++
 src/meta.c                | 3 +++
 src/mnl.c                 | 3 +++
 src/netlink.c             | 3 +++
 src/netlink_delinearize.c | 3 +++
 src/netlink_linearize.c   | 3 +++
 src/payload.c             | 3 +++
 src/proto.c               | 3 +++
 src/rbtree.c              | 3 +++
 src/rule.c                | 3 +++
 src/segtree.c             | 3 +++
 src/statement.c           | 3 +++
 src/utils.c               | 3 +++
 21 files changed, 63 insertions(+)

diff --git a/src/cli.c b/src/cli.c
index f748a0e..bf3caea 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -11,6 +11,9 @@
  *
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
 
 #include <stdlib.h>
 #include <stdio.h>
diff --git a/src/ct.c b/src/ct.c
index 30639b2..98e7fec 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -9,6 +9,9 @@
  *
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
 
 #include <stddef.h>
 #include <stdlib.h>
diff --git a/src/datatype.c b/src/datatype.c
index 55af227..2d773f2 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -7,6 +7,9 @@
  *
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
 
 #include <stdlib.h>
 #include <string.h>
diff --git a/src/erec.c b/src/erec.c
index 4930085..500691e 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -7,6 +7,9 @@
  *
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
 
 #include <stdio.h>
 #include <string.h>
diff --git a/src/evaluate.c b/src/evaluate.c
index 2330bbb..e66e8a2 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -7,6 +7,9 @@
  *
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
 
 #include <stddef.h>
 #include <stdlib.h>
diff --git a/src/expression.c b/src/expression.c
index fa14d99..b2a2f04 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -7,6 +7,9 @@
  *
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
 
 #include <stddef.h>
 #include <stdlib.h>
diff --git a/src/exthdr.c b/src/exthdr.c
index a619ecc..9d73d07 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -9,6 +9,9 @@
  *
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
 
 #include <stddef.h>
 #include <stdlib.h>
diff --git a/src/gmputil.c b/src/gmputil.c
index cb46445..38eafde 100644
--- a/src/gmputil.c
+++ b/src/gmputil.c
@@ -7,6 +7,9 @@
  *
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
 
 #include <stddef.h>
 #include <stdlib.h>
diff --git a/src/main.c b/src/main.c
index a446bc6..142e99c 100644
--- a/src/main.c
+++ b/src/main.c
@@ -7,6 +7,9 @@
  *
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
 
 #include <stdlib.h>
 #include <stddef.h>
diff --git a/src/meta.c b/src/meta.c
index 80f88ff..d82c524 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -9,6 +9,9 @@
  *
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
 
 #include <stddef.h>
 #include <stdlib.h>
diff --git a/src/mnl.c b/src/mnl.c
index a816106..dd5f172 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -7,6 +7,9 @@
  *
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/common.h>
diff --git a/src/netlink.c b/src/netlink.c
index 2e7c572..a0d21f6 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -8,6 +8,9 @@
  *
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
 
 #include <string.h>
 #include <fcntl.h>
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 5c6ca80..7c02138 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -8,6 +8,9 @@
  *
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
 
 #include <stdlib.h>
 #include <stdbool.h>
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 5c1b46d..ae3eb2d 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -8,6 +8,9 @@
  *
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
 
 #include <linux/netfilter/nf_tables.h>
 
diff --git a/src/payload.c b/src/payload.c
index a1785a5..3d2a2ae 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -9,6 +9,9 @@
  *
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
 
 #include <stddef.h>
 #include <stdlib.h>
diff --git a/src/proto.c b/src/proto.c
index 0a37a65..0179ddf 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -8,6 +8,9 @@
  * published by the Free Software Foundation.
  *
  */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
 
 #include <stddef.h>
 #include <stdlib.h>
diff --git a/src/rbtree.c b/src/rbtree.c
index 325c012..8cb6dd8 100644
--- a/src/rbtree.c
+++ b/src/rbtree.c
@@ -18,6 +18,9 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
  */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
 
 #include <rbtree.h>
 
diff --git a/src/rule.c b/src/rule.c
index a7bc6f4..ecaaa2e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -7,6 +7,9 @@
  *
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
 
 #include <stddef.h>
 #include <stdlib.h>
diff --git a/src/segtree.c b/src/segtree.c
index 1785f64..0258684 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -7,6 +7,9 @@
  *
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
 
 #include <stdlib.h>
 #include <inttypes.h>
diff --git a/src/statement.c b/src/statement.c
index 2dd3f18..42fb37f 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -7,6 +7,9 @@
  *
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
 
 #include <stddef.h>
 #include <stdlib.h>
diff --git a/src/utils.c b/src/utils.c
index 96ff419..f68ab57 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -7,6 +7,9 @@
  *
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
 
 #include <stddef.h>
 #include <stdlib.h>
-- 
2.0.1

