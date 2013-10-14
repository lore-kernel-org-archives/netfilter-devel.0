From: "mancha" <mancha1@hush.com>
Subject: ip{,6}tables-save misleading return code
Date: Mon, 14 Oct 2013 20:38:16 +0000
Message-ID: <20131014203816.CC16360191@smtp.hushmail.com>
Reply-To: mancha1@hush.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp10.hushmail.com ([65.39.178.143]:49214 "EHLO
	smtp10.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815Ab3JNVLU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Oct 2013 17:11:20 -0400
Received: from smtp10.hushmail.com (localhost [127.0.0.1])
	by smtp10.hushmail.com (Postfix) with SMTP id EA74CC01B0
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2013 20:38:16 +0000 (UTC)
Received: from smtp.hushmail.com (w6.hushmail.com [65.39.178.92])
	by smtp10.hushmail.com (Postfix) with ESMTP
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2013 20:38:16 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello, this came up on freenode's #netfilter today.

ip{,6}tables-save(8), when run as an unprivileged user (who
doesn't have access to /proc/net/ip{,6}_tables_names), displays
no output and returns 0 because of a Boolean inversion.

luser@myhost:~$ iptables-save; echo $? 
0

The patch below changes the return to 1 if fopen() fails.
Additionally, one could add "if (errno == EACCESS)" conditioned
error messages.

--mancha

--- a/iptables/iptables-save.c  2013-10-14
+++ b/iptables/iptables-save.c  2013-10-14
@@ -40,7 +40,7 @@ static int for_each_table(int (*func)(co

        procfile = fopen("/proc/net/ip_tables_names", "re");
        if (!procfile)
-               return ret;
+               return 0;

        while (fgets(tablename, sizeof(tablename), procfile)) {
                if (tablename[strlen(tablename) - 1] != '\n')
--- a/iptables/ip6tables-save.c 2013-10-14
+++ b/iptables/ip6tables-save.c 2013-10-14
@@ -42,7 +42,7 @@ static int for_each_table(int (*func)(co

        procfile = fopen("/proc/net/ip6_tables_names", "re");
        if (!procfile)
-               return ret;
+               return 0;

        while (fgets(tablename, sizeof(tablename), procfile)) {
                if (tablename[strlen(tablename) - 1] != '\n')

