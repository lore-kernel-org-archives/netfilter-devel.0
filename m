From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] ulogd 1.24 mysql bad identification
Date: Mon, 23 Jul 2007 17:10:39 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707231710270.32367@fbirervta.pbzchgretzou.qr>
References: <46A3EB93.6080701@free.fr>
	<Pine.LNX.4.64.0707230952530.32367@fbirervta.pbzchgretzou.qr>
	<46A48D1F.4060601@free.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: "eescar@free.fr" <eescar@free.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46A48D1F.4060601@free.fr>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Index: ulogd-1.24/configure.in
===================================================================
--- ulogd-1.24.orig/configure.in
+++ ulogd-1.24/configure.in
@@ -60,7 +60,6 @@ then
 else
         AC_DEFINE(HAVE_MYSQL)
         MYSQLINCLUDES=`$d/mysql_config --include`
-        MYSQLLIBS=`$d/mysql_config --libs`
 
 	DATABASE_DIR="${DATABASE_DIR} mysql"
 
@@ -83,15 +82,8 @@ else
 
 	AC_MSG_CHECKING(for mysql_real_escape_string support)
 
-	MYSQL_FUNCTION_TEST=`strings ${MYSQLLIBS}/libmysqlclient.so | grep mysql_real_escape_string`
-
-	if test "x$MYSQL_FUNCTION_TEST" = x
-	then
-                EXTRA_MYSQL_DEF="-DOLD_MYSQL=1 "
-                AC_MSG_RESULT(found old MySQL)
-	else
-		AC_MSG_RESULT(found new MySQL)
-	fi
+	AC_SEARCH_LIBS(mysql_real_escape_string, mysqlclient_r mysqlclient,
+		[EXTRA_MYSQL_DEF="-DOLD_MYSQL=1"])
 
 fi      
 ])      
