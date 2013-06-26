From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] iptables: Sort table names in ip[6]tables-save
Date: Wed, 26 Jun 2013 19:42:02 -0400
Message-ID: <20130626234202.GA31099@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="jRHKVT23PllUwdXP"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:53216 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab3F0Udr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Jun 2013 16:33:47 -0400
Received: by mail-pb0-f41.google.com with SMTP id rp16so1397698pbb.0
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2013 13:33:46 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Depending upon the load order of rules, the output from ip[6]tables-save
will vary, as ip[6]_tables_names is sorted LIFO.  As reported by
Linus van Geuns, this makes comparing output from ip[6]tables-save across
reboots difficult.  Fix this by sorting table names prior to walking
the tables, making output consistent.

This closes bugzilla #580.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-sort-tables

diff --git a/include/xtables.h b/include/xtables.h
index c35a6e6..dc6e566 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -479,6 +479,8 @@ extern void xtables_ip6parse_any(const char *, struct in6_addr **,
 extern void xtables_ip6parse_multiple(const char *, struct in6_addr **,
 	struct in6_addr **, unsigned int *);
 
+extern int stringcmp(const void *, const void *);
+
 /**
  * Print the specified value to standard output, quoting dangerous
  * characters if required.
diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
index d819b30..7ec0f75 100644
--- a/iptables/ip6tables-save.c
+++ b/iptables/ip6tables-save.c
@@ -36,8 +36,9 @@ static const struct option options[] = {
 /* Debugging prototype. */
 static int for_each_table(int (*func)(const char *tablename))
 {
-	int ret = 1;
+	int i, count = 0, ret = 1;
 	FILE *procfile = NULL;
+	char **tables = NULL;
 	char tablename[XT_TABLE_MAXNAMELEN+1];
 
 	procfile = fopen("/proc/net/ip6_tables_names", "re");
@@ -50,10 +51,17 @@ static int for_each_table(int (*func)(const char *tablename))
 				   "Badly formed tablename `%s'\n",
 				   tablename);
 		tablename[strlen(tablename) - 1] = '\0';
-		ret &= func(tablename);
+		count++;
+		tables = (char **)realloc(tables, sizeof(char*)*count);
+		tables[count-1] = strdup(tablename);
 	}
-
 	fclose(procfile);
+
+	qsort(tables, count, sizeof(char *), stringcmp);
+	for (i = 0 ; i < count ; i++) {
+		ret &= func(tables[i]);
+	}
+
 	return ret;
 }
 
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index e599fce..802f94d 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -34,8 +34,9 @@ static const struct option options[] = {
 /* Debugging prototype. */
 static int for_each_table(int (*func)(const char *tablename))
 {
-	int ret = 1;
+	int i, count = 0, ret = 1;
 	FILE *procfile = NULL;
+	char **tables = NULL;
 	char tablename[XT_TABLE_MAXNAMELEN+1];
 
 	procfile = fopen("/proc/net/ip_tables_names", "re");
@@ -48,10 +49,17 @@ static int for_each_table(int (*func)(const char *tablename))
 				   "Badly formed tablename `%s'\n",
 				   tablename);
 		tablename[strlen(tablename) - 1] = '\0';
-		ret &= func(tablename);
+		count++;
+		tables = (char **)realloc(tables, sizeof(char*)*count);
+		tables[count-1] = strdup(tablename);
 	}
-
 	fclose(procfile);
+
+	qsort(tables, count, sizeof(char *), stringcmp);
+	for (i = 0 ; i < count ; i++) {
+		ret &= func(tables[i]);
+	}
+
 	return ret;
 }
 
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index ebc77b6..ca94f4e 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1957,3 +1957,10 @@ void get_kernel_version(void)
 	sscanf(uts.release, "%d.%d.%d", &x, &y, &z);
 	kernel_version = LINUX_VERSION(x, y, z);
 }
+
+int stringcmp(const void *a, const void *b) 
+{ 
+	const char **ia = (const char **)a;
+	const char **ib = (const char **)b;
+	return strcmp(*ia, *ib);
+} 

--jRHKVT23PllUwdXP--
