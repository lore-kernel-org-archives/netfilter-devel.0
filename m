Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 140CBC352A1
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Nov 2022 10:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiKXKIN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Nov 2022 05:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiKXKIM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2022 05:08:12 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5926531222
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2022 02:08:11 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrackd 3/3] Fix -Wimplicit-function-declaration
Date:   Thu, 24 Nov 2022 11:08:04 +0100
Message-Id: <20221124100804.25674-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221124100804.25674-1-pablo@netfilter.org>
References: <20221124100804.25674-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Sam James <sam@gentoo.org>

read_config_yy.c: In function ‘yyparse’:
read_config_yy.c:1765:16: warning: implicit declaration of function ‘yylex’ [-Wimplicit-function-declaration]
 1765 |       yychar = yylex ();
      |                ^~~~~
read_config_yy.c:1765:16: warning: nested extern declaration of ‘yylex’ [-Wnested-externs]
read_config_yy.y:120:17: warning: implicit declaration of function ‘dlog’ [-Wimplicit-function-declaration]
  120 |                 dlog(LOG_ERR, "LogFile path is longer than %u characters",
      |                 ^~~~
read_config_yy.y:120:17: warning: nested extern declaration of ‘dlog’ [-Wnested-externs]
read_config_yy.y:240:14: warning: implicit declaration of function ‘inet_aton’; did you mean ‘in6_pton’? [-Wimplicit-function-declaration]
  240 |         if (!inet_aton($2, &conf.channel[conf.channel_num].u.mcast.in)) {
      |              ^~~~~~~~~
      |              in6_pton

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1637
Signed-off-by: Sam James <sam@gentoo.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
posted via https://bugzilla.netfilter.org/show_bug.cgi?id=1637

 src/read_config_lex.l |  3 ++-
 src/read_config_yy.y  | 11 +++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/src/read_config_lex.l b/src/read_config_lex.l
index 7dc400a3a9b5..27084329d185 100644
--- a/src/read_config_lex.l
+++ b/src/read_config_lex.l
@@ -21,6 +21,7 @@
 
 #include <string.h>
 
+#include "log.h"
 #include "conntrackd.h"
 #include "read_config_yy.h"
 %}
@@ -174,7 +175,7 @@ notrack		[N|n][O|o][T|t][R|r][A|a][C|c][K|k]
 %%
 
 int
-yywrap()
+yywrap(void)
 {
 	return 1;
 }
diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index a2154be3733e..f06c6afff7cb 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -31,14 +31,25 @@
 #include "cidr.h"
 #include "helper.h"
 #include "stack.h"
+#include "log.h"
+
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
+
 #include <sched.h>
 #include <dlfcn.h>
+
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack_tcp.h>
 
 extern char *yytext;
 extern int   yylineno;
 
+int yylex (void);
+int yyerror (char *msg);
+void yyrestart (FILE *input_file);
+
 struct ct_conf conf;
 
 static void __kernel_filter_start(void);
-- 
2.30.2

