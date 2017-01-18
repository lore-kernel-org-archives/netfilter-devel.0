From: thomas@habets.se
Subject: Re: [PATCH] iptables-save: Exit with error if unable to open proc file
Date: Wed, 18 Jan 2017 08:58:13 -0500
Message-ID: <CA+kHd+db15eUCFb+_-T1zJVPSkogyLUTp2Fe-2u9z8B0E3a-_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:34868 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752636AbdARN6P (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 08:58:15 -0500
Received: by mail-qk0-f193.google.com with SMTP id u25so1898921qki.2
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 05:58:14 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 18 Jan 2017 14:32:30 +0100, Florian Westphal <fw@strlen.de> said:
> static const char filename[] =

Done.

> iptables uses kernel coding style, so
>
> 	if (errno == ENOENT)
> 		return ret;

Gotcha. Making the code unambiguously worse, then. (cough, goto fail, cough)
Done.

> Looks like your mua mangled the patch and broke long lines.
> Can you send with git-send-email?

Using a better client this time.


commit 0d18c3e9488ac2e36a5c5ecccce93de795f6fe25
Author: Thomas Habets <habets@google.com>
Date:   Wed Jan 18 13:46:54 2017 +0000

    iptables-save: Exit with error if unable to open proc file

diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
index f35e921..053413a 100644
--- a/iptables/ip6tables-save.c
+++ b/iptables/ip6tables-save.c
@@ -35,10 +35,16 @@ static int for_each_table(int (*func)(const char
*tablename))
 	int ret = 1;
 	FILE *procfile = NULL;
 	char tablename[XT_TABLE_MAXNAMELEN+1];
-
-	procfile = fopen("/proc/net/ip6_tables_names", "re");
-	if (!procfile)
-		return ret;
+	static const char filename[] = "/proc/net/ip6_tables_names";
+
+	procfile = fopen(filename, "re");
+	if (!procfile) {
+		if (errno == ENOENT)
+			return ret;
+		fprintf(stderr, "Failed to list table names in %s: %s\n",
+		        filename, strerror(errno));
+		exit(1);
+	}

 	while (fgets(tablename, sizeof(tablename), procfile)) {
 		if (tablename[strlen(tablename) - 1] != '\n')
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index 238f368..e8ae9c6 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -33,10 +33,16 @@ static int for_each_table(int (*func)(const char
*tablename))
 	int ret = 1;
 	FILE *procfile = NULL;
 	char tablename[XT_TABLE_MAXNAMELEN+1];
-
-	procfile = fopen("/proc/net/ip_tables_names", "re");
-	if (!procfile)
-		return ret;
+	static const char filename[] = "/proc/net/ip_tables_names";
+
+	procfile = fopen(filename, "re");
+	if (!procfile) {
+		if (errno == ENOENT)
+			return ret;
+		fprintf(stderr, "Failed to list table names in %s: %s\n",
+		        filename, strerror(errno));
+		exit(1);
+	}

 	while (fgets(tablename, sizeof(tablename), procfile)) {
 		if (tablename[strlen(tablename) - 1] != '\n')
