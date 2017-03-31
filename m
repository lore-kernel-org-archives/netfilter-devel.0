From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 3/4] iptables: iptables: Indent the code.
Date: Fri, 31 Mar 2017 21:43:50 +0530
Message-ID: <20170331161351.26141-4-arushisinghal19971997@gmail.com>
References: <20170331161351.26141-1-arushisinghal19971997@gmail.com>
Cc: Arushi Singhal <arushisinghal19971997@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34548 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933126AbdCaQOR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Mar 2017 12:14:17 -0400
Received: by mail-pg0-f65.google.com with SMTP id o123so18390259pga.1
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Mar 2017 09:14:16 -0700 (PDT)
In-Reply-To: <20170331161351.26141-1-arushisinghal19971997@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ident the code.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 iptables/xtables-arp.c | 4 ++--
 iptables/xtables-eb.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 6aa000a..38b0206 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -481,8 +481,8 @@ exit_printhelp(void)
 "  --set-counters PKTS BYTES	set the counter during insert/append\n"
 "[!] --version	-V		print package version.\n");
 	printf(" opcode strings: \n");
-        for (i = 0; i < NUMOPCODES; i++)
-                printf(" %d = %s\n", i + 1, opcodes[i]);
+	for (i = 0; i < NUMOPCODES; i++)
+		printf(" %d = %s\n", i + 1, opcodes[i]);
         printf(
 " hardware type string: 1 = Ethernet\n"
 " protocol type string: 0x800 = IPv4\n");
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index c8b5d4f..2cb3ae6 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -327,9 +327,9 @@ static void ebt_list_extensions(const struct xtables_target *t,
 	printf("%s v%s\n", prog_name, prog_vers);
 	printf("Loaded userspace extensions:\n");
 	/*printf("\nLoaded tables:\n");
-        while (tbl) {
+	while (tbl) {
 		printf("%s\n", tbl->name);
-                tbl = tbl->next;
+		tbl = tbl->next;
 	}*/
 	printf("\nLoaded targets:\n");
         for (t = xtables_targets; t; t = t->next) {
-- 
2.11.0

