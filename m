From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 1/3] monitor: Fix printing of set declarations
Date: Tue, 25 Jul 2017 20:39:42 +0200
Message-ID: <20170725183944.9377-2-phil@nwl.cc>
References: <20170725183944.9377-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:47213 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751196AbdGYSkJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2017 14:40:09 -0400
In-Reply-To: <20170725183944.9377-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The optional attributes 'flags', 'gc-interval' and 'timeout' have to be
delimited by stmt_separator (either newline or semicolon), not 'nl'
which is set to whitespace by set_print_plain().

In order to restore readability, change stmt_separator to include a
single whitespace after the semicolon.

Here's monitor output for the following command:

| # nft add set ip t testset { type inet_service; \
|			timeout 60s; gc-interval 120s; }

Before this patch:

| add set ip t testset { type inet_service;timeout 1m gc-interval 2m }

With this patch applied:

| add set ip t testset { type inet_service; timeout 1m; gc-interval 2m; }

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Folded former patch 4 into this one since they are related.
---
 src/rule.c                             | 8 ++++----
 tests/monitor/testcases/set-maps.t     | 2 +-
 tests/monitor/testcases/set-mixed.t    | 2 +-
 tests/monitor/testcases/set-multiple.t | 4 ++--
 tests/monitor/testcases/set-simple.t   | 2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 7f83980c60818..12714ed3ccc70 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -335,18 +335,18 @@ static void set_print_declaration(const struct set *set,
 			printf("%stimeout", delim);
 			delim = ",";
 		}
-		printf("%s", opts->nl);
+		printf("%s", opts->stmt_separator);
 	}
 
 	if (set->timeout) {
 		printf("%s%stimeout ", opts->tab, opts->tab);
 		time_print(set->timeout / 1000);
-		printf("%s", opts->nl);
+		printf("%s", opts->stmt_separator);
 	}
 	if (set->gc_int) {
 		printf("%s%sgc-interval ", opts->tab, opts->tab);
 		time_print(set->gc_int / 1000);
-		printf("%s", opts->nl);
+		printf("%s", opts->stmt_separator);
 	}
 }
 
@@ -381,7 +381,7 @@ void set_print_plain(const struct set *s, struct output_ctx *octx)
 		.nl		= " ",
 		.table		= s->handle.table,
 		.family		= family2str(s->handle.family),
-		.stmt_separator	= ";",
+		.stmt_separator	= "; ",
 	};
 
 	do_set_print(s, &opts, octx);
diff --git a/tests/monitor/testcases/set-maps.t b/tests/monitor/testcases/set-maps.t
index d94016beb0767..6ea36cb9d11d6 100644
--- a/tests/monitor/testcases/set-maps.t
+++ b/tests/monitor/testcases/set-maps.t
@@ -2,7 +2,7 @@
 I add table ip t
 O add table ip t
 I add map ip t portip { type inet_service: ipv4_addr; flags interval; }
-O add map ip t portip { type inet_service : ipv4_addr;flags interval }
+O add map ip t portip { type inet_service : ipv4_addr;flags interval; }
 
 I add element ip t portip { 80-100: 10.0.0.1 }
 O add element ip t portip { 80-100 : 10.0.0.1 }
diff --git a/tests/monitor/testcases/set-mixed.t b/tests/monitor/testcases/set-mixed.t
index c4699edacec11..2eb35b5aa1efb 100644
--- a/tests/monitor/testcases/set-mixed.t
+++ b/tests/monitor/testcases/set-mixed.t
@@ -2,7 +2,7 @@
 I add table ip t
 O add table ip t
 I add set ip t portrange { type inet_service; flags interval; }
-O add set ip t portrange { type inet_service;flags interval }
+O add set ip t portrange { type inet_service;flags interval; }
 I add set ip t ports { type inet_service; }
 O add set ip t ports { type inet_service;}
 
diff --git a/tests/monitor/testcases/set-multiple.t b/tests/monitor/testcases/set-multiple.t
index d94f941b39693..ce919125a593f 100644
--- a/tests/monitor/testcases/set-multiple.t
+++ b/tests/monitor/testcases/set-multiple.t
@@ -2,9 +2,9 @@
 I add table ip t
 O add table ip t
 I add set ip t portrange { type inet_service; flags interval; }
-O add set ip t portrange { type inet_service;flags interval }
+O add set ip t portrange { type inet_service;flags interval; }
 I add set ip t portrange2 { type inet_service; flags interval; }
-O add set ip t portrange2 { type inet_service;flags interval }
+O add set ip t portrange2 { type inet_service;flags interval; }
 
 # make sure concurrent adds work
 I add element ip t portrange { 1024-65535 }
diff --git a/tests/monitor/testcases/set-simple.t b/tests/monitor/testcases/set-simple.t
index 22f648dbfa232..e44cce08f575c 100644
--- a/tests/monitor/testcases/set-simple.t
+++ b/tests/monitor/testcases/set-simple.t
@@ -2,7 +2,7 @@
 I add table ip t
 O add table ip t
 I add set ip t portrange { type inet_service; flags interval; }
-O add set ip t portrange { type inet_service;flags interval }
+O add set ip t portrange { type inet_service;flags interval; }
 
 # adding some ranges
 I add element ip t portrange { 1-10 }
-- 
2.13.1

