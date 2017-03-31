From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 4/4] iptables: iptables: switch and case should be at the same indent
Date: Fri, 31 Mar 2017 21:43:51 +0530
Message-ID: <20170331161351.26141-5-arushisinghal19971997@gmail.com>
References: <20170331161351.26141-1-arushisinghal19971997@gmail.com>
Cc: Arushi Singhal <arushisinghal19971997@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35363 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751032AbdDADQi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Mar 2017 23:16:38 -0400
Received: by mail-pg0-f66.google.com with SMTP id g2so20888655pge.2
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Mar 2017 20:16:38 -0700 (PDT)
In-Reply-To: <20170331161351.26141-1-arushisinghal19971997@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As per kernel coding style switch and case should be at the same
identation.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 iptables/ip6tables-restore.c | 62 ++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 8a47f09..24ea5ec 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -215,37 +215,37 @@ int ip6tables_restore_main(int argc, char *argv[])
 
 	while ((c = getopt_long(argc, argv, "bcvthnwWM:T:", options, NULL)) != -1) {
 		switch (c) {
-			case 'b':
-				fprintf(stderr, "-b/--binary option is not implemented\n");
-				break;
-			case 'c':
-				counters = 1;
-				break;
-			case 'v':
-				verbose = 1;
-				break;
-			case 't':
-				testing = 1;
-				break;
-			case 'h':
-				print_usage("ip6tables-restore",
-					    IPTABLES_VERSION);
-				break;
-			case 'n':
-				noflush = 1;
-				break;
-			case 'w':
-				wait = parse_wait_time(argc, argv);
-				break;
-			case 'W':
-				parse_wait_interval(argc, argv, &wait_interval);
-				break;
-			case 'M':
-				xtables_modprobe_program = optarg;
-				break;
-			case 'T':
-				tablename = optarg;
-				break;
+		case 'b':
+			fprintf(stderr, "-b/--binary option is not implemented\n");
+			break;
+		case 'c':
+			counters = 1;
+			break;
+		case 'v':
+			verbose = 1;
+			break;
+		case 't':
+			testing = 1;
+			break;
+		case 'h':
+			print_usage("ip6tables-restore",
+				    IPTABLES_VERSION);
+			break;
+		case 'n':
+			noflush = 1;
+			break;
+		case 'w':
+			wait = parse_wait_time(argc, argv);
+			break;
+		case 'W':
+			parse_wait_interval(argc, argv, &wait_interval);
+			break;
+		case 'M':
+			xtables_modprobe_program = optarg;
+			break;
+		case 'T':
+			tablename = optarg;
+			break;
 		}
 	}
 
-- 
2.11.0

