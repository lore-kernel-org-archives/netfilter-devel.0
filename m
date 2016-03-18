From: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] ulogd: fix cross compilation errors with mysql_config
Date: Fri, 18 Mar 2016 15:43:24 +0100
Message-ID: <1458312204-2874-1-git-send-email-helmut.schaa@googlemail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36922 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbcCROoP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Mar 2016 10:44:15 -0400
Received: by mail-wm0-f49.google.com with SMTP id p65so40548746wmp.0
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Mar 2016 07:44:14 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When cross-compiling ulogd, mysql_config and pg_config will return build host
configuration not build target configuration. This leads to build failures
if mysql_config is installed on the host system but mysql is not available
on the build target.

Fix this by not using mysql_config and pg_config for cross-compilation.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 acinclude.m4 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/acinclude.m4 b/acinclude.m4
index 56d47b8..bd21255 100644
--- a/acinclude.m4
+++ b/acinclude.m4
@@ -35,7 +35,7 @@ if test "$pg_prefix" != "no"; then
 AC_MSG_CHECKING([for PostgreSQL pg_config program])
 for d in $pg_prefix/bin /usr/bin /usr/local/bin /usr/local/pgsql/bin /opt/pgsql/bin /opt/packages/pgsql/bin
 do
-	if test -x $d/pg_config
+	if test -x $d/pg_config -a "$cross_compiling" = "no";
 	then
 		AC_MSG_RESULT(found pg_config in $d)
 		PQINCPATH=`$d/pg_config --includedir`
@@ -130,7 +130,7 @@ if test "$my_prefix" != "no"; then
 AC_MSG_CHECKING([for MySQL mysql_config program])
 for d in $my_prefix/bin /usr/bin /usr/local/bin /usr/local/mysql/bin /opt/mysql/bin /opt/packages/mysql/bin
 do
-	if test -x $d/mysql_config
+	if test -x $d/mysql_config -a "$cross_compiling" = "no";
 	then
 		AC_MSG_RESULT(found mysql_config in $d)
 		MYSQL_INC=`$d/mysql_config --include`
-- 
1.8.4.5

