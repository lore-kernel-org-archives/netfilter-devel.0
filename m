From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2] Make libnftables a local static library
Date: Thu, 30 Nov 2017 19:36:23 +0100
Message-ID: <20171130183623.19719-1-phil@nwl.cc>
References: <20171130183008.GP32305@orbyte.nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:52322 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750723AbdK3Sge (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Nov 2017 13:36:34 -0500
In-Reply-To: <20171130183008.GP32305@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This changes Makefiles so that libnftables is built into a static
library which is not installed. This allows for incompatible changes
while still providing a library to link to for testing purposes.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Keep it a libtool library.
- Update src/.gitignore.
---
 src/.gitignore  | 1 +
 src/Makefile.am | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/.gitignore b/src/.gitignore
index 36d6acd1e4d01..e27d4f8431eec 100644
--- a/src/.gitignore
+++ b/src/.gitignore
@@ -1,3 +1,4 @@
+libnftables.a
 libnftables.la
 parser.c
 parser.h
diff --git a/src/Makefile.am b/src/Makefile.am
index 9f7a4bfbb90a4..7581ec2090092 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -27,7 +27,7 @@ parser_bison.o scanner.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-decl
 
 BUILT_SOURCES = parser_bison.h
 
-lib_LTLIBRARIES = libnftables.la
+noinst_LTLIBRARIES = libnftables.la
 
 libnftables_la_SOURCES =			\
 		rule.c				\
-- 
2.13.1

