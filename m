From: Thomas Habets <thomas@habets.se>
Subject: [PATCH] iptables-save: Exit with error if unable to open proc file
Date: Wed, 18 Jan 2017 13:23:59 +0000
Message-ID: <CA+kHd+fMWmomd0ZTWO3nj0iCSOTmXoW-J4S7XNrYq86JznBM0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:34183 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752189AbdARNYk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 08:24:40 -0500
Received: by mail-qt0-f174.google.com with SMTP id l7so11328611qtd.1
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 05:24:25 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I sent this before without being subscribed, but it doesn't seem to
have reached the archives so now retrying while subscribed.

If you're not root, then iptables-save silently fails (both to stderr
and exit code). This patch fixes that.
--


Author: Thomas Habets <habets@google.com>
Date:   Tue Jan 17 14:22:25 2017 +0000

    iptables-save: Exit with error if unable to open proc file

diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
index f35e921..5097406 100644
--- a/iptables/ip6tables-save.c
+++ b/iptables/ip6tables-save.c
@@ -35,10 +35,16 @@ static int for_each_table(int (*func)(const char
*tablename))
        int ret = 1;
        FILE *procfile = NULL;
        char tablename[XT_TABLE_MAXNAMELEN+1];
+       const char *filename = "/proc/net/ip6_tables_names";

-       procfile = fopen("/proc/net/ip6_tables_names", "re");
-       if (!procfile)
-               return ret;
+       procfile = fopen(filename, "re");
+       if (!procfile) {
+               if (errno == ENOENT) {
+                       return ret;
+               }
+               fprintf(stderr, "Failed to list table names in %s:
%s\n", filename, strerror(errno));
+               exit(1);
+       }

        while (fgets(tablename, sizeof(tablename), procfile)) {
                if (tablename[strlen(tablename) - 1] != '\n')
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index 238f368..47d5378 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -33,10 +33,16 @@ static int for_each_table(int (*func)(const char
*tablename))
        int ret = 1;
        FILE *procfile = NULL;
        char tablename[XT_TABLE_MAXNAMELEN+1];
+       const char *filename = "/proc/net/ip_tables_names";

-       procfile = fopen("/proc/net/ip_tables_names", "re");
-       if (!procfile)
-               return ret;
+       procfile = fopen(filename, "re");
+       if (!procfile) {
+               if (errno == ENOENT) {
+                       return ret;
+               }
+               fprintf(stderr, "Failed to list table names in %s:
%s\n", filename, strerror(errno));
+               exit(1);
+       }

        while (fgets(tablename, sizeof(tablename), procfile)) {
                if (tablename[strlen(tablename) - 1] != '\n')

-- 
typedef struct me_s {
 char name[]      = { "Thomas Habets" };
 char email[]     = { "thomas@habets.se" };
 char kernel[]    = { "Linux" };
 char *pgpKey[]   = { "http://www.habets.pp.se/pubkey.txt" };
 char pgp[] = { "9907 8698 8A24 F52F 1C2E  87F6 39A4 9EEA 460A 0169" };
 char coolcmd[]   = { "echo '. ./_&. ./_'>_;. ./_" };
} me_t;
