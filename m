From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/4] build: resolve build errors in dependent programs
Date: Mon, 28 Oct 2013 13:27:18 +0100
Message-ID: <1382963240-18760-3-git-send-email-jengelh@inai.de>
References: <1382963240-18760-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:34047 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756328Ab3J1M12 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:27:28 -0400
In-Reply-To: <1382963240-18760-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The headers do not compile standalone, which also causes nftables to
fail to build for the same reason.

	$ gcc -x c -Wall -c *.h
	chain.h:62:35: error: unknown type name =E2=80=98size_t=E2=80=99
	expr.h:40:39: error: unknown type name =E2=80=98size_t=E2=80=99
	rule.h:60:34: error: unknown type name =E2=80=98size_t=E2=80=99
	ruleset.h:20:1: error: unknown type name =E2=80=98bool=E2=80=99
	ruleset.h:20:59: error: unknown type name =E2=80=98uint16_t=E2=80=99
	ruleset.h:21:52: error: unknown type name =E2=80=98uint16_t=E2=80=99
	ruleset.h:22:50: error: unknown type name =E2=80=98uint16_t=E2=80=99
	ruleset.h:23:63: error: unknown type name =E2=80=98uint16_t=E2=80=99
	ruleset.h:39:37: error: unknown type name =E2=80=98size_t=E2=80=99
	ruleset.h:39:80: error: unknown type name =E2=80=98uint32_t=E2=80=99
	ruleset.h:39:95: error: unknown type name =E2=80=98uint32_t=E2=80=99
	set.h:40:33: error: unknown type name =E2=80=98size_t=E2=80=99
	set.h:110:38: error: unknown type name =E2=80=98size_t=E2=80=99
	table.h:50:35: error: unknown type name =E2=80=98size_t=E2=80=99

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/libnftables/chain.h   | 1 +
 include/libnftables/expr.h    | 1 +
 include/libnftables/rule.h    | 1 +
 include/libnftables/ruleset.h | 4 ++++
 include/libnftables/set.h     | 1 +
 include/libnftables/table.h   | 1 +
 6 files changed, 9 insertions(+)

diff --git a/include/libnftables/chain.h b/include/libnftables/chain.h
index d85a2a2..d3ba75b 100644
--- a/include/libnftables/chain.h
+++ b/include/libnftables/chain.h
@@ -3,6 +3,7 @@
=20
 #include <stdint.h>
 #include <stdbool.h>
+#include <sys/types.h>
=20
 #ifdef __cplusplus
 extern "C" {
diff --git a/include/libnftables/expr.h b/include/libnftables/expr.h
index 64c407c..81e224c 100644
--- a/include/libnftables/expr.h
+++ b/include/libnftables/expr.h
@@ -3,6 +3,7 @@
=20
 #include <stdint.h>
 #include <stdbool.h>
+#include <sys/types.h>
=20
 #ifdef __cplusplus
 extern "C" {
diff --git a/include/libnftables/rule.h b/include/libnftables/rule.h
index a501d2d..5b5263a 100644
--- a/include/libnftables/rule.h
+++ b/include/libnftables/rule.h
@@ -3,6 +3,7 @@
=20
 #include <stdint.h>
 #include <stdbool.h>
+#include <sys/types.h>
=20
 #ifdef __cplusplus
 extern "C" {
diff --git a/include/libnftables/ruleset.h b/include/libnftables/rulese=
t.h
index a4a1279..49f7c4e 100644
--- a/include/libnftables/ruleset.h
+++ b/include/libnftables/ruleset.h
@@ -1,6 +1,10 @@
 #ifndef _RULESET_H_
 #define _RULESET_H_
=20
+#include <stdbool.h>
+#include <stdint.h>
+#include <sys/types.h>
+
 #ifdef __cplusplus
 extern "C" {
 #endif
diff --git a/include/libnftables/set.h b/include/libnftables/set.h
index 14a6327..1bd7670 100644
--- a/include/libnftables/set.h
+++ b/include/libnftables/set.h
@@ -3,6 +3,7 @@
=20
 #include <stdint.h>
 #include <stdbool.h>
+#include <sys/types.h>
=20
 enum {
 	NFT_SET_ATTR_TABLE,
diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index 42a4aa7..86978e1 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -3,6 +3,7 @@
=20
 #include <stdint.h>
 #include <stdbool.h>
+#include <sys/types.h>
=20
 #ifdef __cplusplus
 extern "C" {
--=20
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
