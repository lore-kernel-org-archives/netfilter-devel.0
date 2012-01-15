From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/2] Support stored mysql procedures besides stored functions
Date: Sun, 15 Jan 2012 16:04:48 +0100
Message-ID: <1326639889-28836-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1326639889-28836-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	marty <martinbarrowcliff@gmail.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:43563 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab2AOPFA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Jan 2012 10:05:00 -0500
In-Reply-To: <1326639889-28836-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

MySQL stored procedures must be invoked by the "CALL" SQL command and
not by "SELECT". Add the convention that if the procedure name starts
with "CALL", then the issued SQL command is "CALL procedurename(args)".

The stored procedure support in MySQL automatically brings transaction
support too.
---
 doc/ulogd.sgml |    4 ++++
 util/db.c      |    2 ++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/doc/ulogd.sgml b/doc/ulogd.sgml
index 547b56a..0f18611 100644
--- a/doc/ulogd.sgml
+++ b/doc/ulogd.sgml
@@ -471,6 +471,10 @@ If procedure name is:
   "table" variable.</item>
 <item>start with "INSERT ": Configuration has to specify the start of the INSERT query that will be used. For example,
 a typical value is "INSERT INTO ulog2".</item>
+<item>start with "CALL": the named stored procedure is executed with
+the "CALL" MySQL command.</item>
+<item>Otherwise the named stored function is executed with
+the "SELECT" MySQL command.</item> 
 </itemize>
 <tag>db</tag>
 Name of the mysql database.
diff --git a/util/db.c b/util/db.c
index 8d812c7..54f8882 100644
--- a/util/db.c
+++ b/util/db.c
@@ -122,6 +122,8 @@ static int sql_createstmt(struct ulogd_pluginstance *upi)
 		*(mi->stmt_val - 1) = ')';
 
 		sprintf(mi->stmt_val, " values (");
+	} else if (strncasecmp(procedure,"CALL", strlen("CALL")) == 0) {
+		sprintf(mi->stmt, "CALL %s(", procedure);
 	} else {
 		sprintf(mi->stmt, "SELECT %s(", procedure);
 
-- 
1.7.0.4

