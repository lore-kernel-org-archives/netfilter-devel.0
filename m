From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [conntrack-tools PATCH 1/4] src/main: refresh help message
Date: Tue, 30 Aug 2016 14:20:35 +0200
Message-ID: <147255963490.17411.649527820452381341.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:37025 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755916AbcH3MUc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 08:20:32 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 80BF851F144
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 12:20:28 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3MLsT4ltIVYC for <netfilter-devel@vger.kernel.org>;
        Tue, 30 Aug 2016 14:20:23 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 8309B51EC20
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 14:20:23 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It seems there are two kind of options:
 * general commands (-d, -v, -h, -C)
 * client commands (which requires another conntrackd instance)

Refresh the help message to better reflect this.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/main.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/src/main.c b/src/main.c
index d12fe18..2be9b2f 100644
--- a/src/main.c
+++ b/src/main.c
@@ -36,9 +36,12 @@
 struct ct_general_state st;
 struct ct_state state;
 
-static const char usage_daemon_commands[] =
-	"Daemon mode commands:\n"
-	"  -d [options]\t\tRun in daemon mode\n";
+static const char usage_general_commands[] =
+	"General commands:\n"
+	"  -d, run in daemon mode\n"
+	"  -C [configfile], configuration file path\n"
+	"  -v, display conntrackd version\n"
+	"  -h, display this help information\n";
 
 static const char usage_client_commands[] =
 	"Client mode commands:\n"
@@ -54,22 +57,15 @@ static const char usage_client_commands[] =
 	"  -n, request resync with other node (only FT-FW and NOTRACK modes)\n"
 	"  -B, force a bulk send to other replica firewalls\n"
 	"  -x, dump cache in XML format (requires -i or -e)\n"
-	"  -t, reset the kernel timeout (see PurgeTimeout clause)\n"
-	"  -v, display conntrackd version\n"
-	"  -h, display this help information\n";
-
-static const char usage_options[] =
-	"Options:\n"
-	"  -C [configfile], configuration file path\n";
+	"  -t, reset the kernel timeout (see PurgeTimeout clause)\n";
 
 static void
 show_usage(char *progname)
 {
 	fprintf(stdout, "Connection tracking userspace daemon v%s\n", VERSION);
 	fprintf(stdout, "Usage: %s [commands] [options]\n\n", progname);
-	fprintf(stdout, "%s\n", usage_daemon_commands);
+	fprintf(stdout, "%s\n", usage_general_commands);
 	fprintf(stdout, "%s\n", usage_client_commands);
-	fprintf(stdout, "%s\n", usage_options);
 }
 
 static void

