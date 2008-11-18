From: Jan Engelhardt <jengelh@medozas.de>
Subject: src: reuse the global modprobe_program variable
Date: Tue, 18 Nov 2008 11:44:15 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811181143590.17946@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48450 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYKRKoQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2008 05:44:16 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 2a87943e288e30162c6e8e42be10fdc7c3bd8313
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Nov 18 11:43:42 2008 +0100

src: reuse the global modprobe_program variable

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables-restore.c |   10 ++++------
 iptables-restore.c  |    9 ++++-----
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 0daae5f..01bccf7 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -56,8 +56,7 @@ static void print_usage(const char *name, const char *version)
 	exit(1);
 }
 
-static struct ip6tc_handle *create_handle(const char *tablename,
-                                    const char *modprobe)
+static struct ip6tc_handle *create_handle(const char *tablename)
 {
 	struct ip6tc_handle *handle;
 
@@ -65,7 +64,7 @@ static struct ip6tc_handle *create_handle(const char *tablename,
 
 	if (!handle) {
 		/* try to insmod the module if iptc_init failed */
-		load_xtables_ko(modprobe, 0);
+		load_xtables_ko(modprobe_program, 0);
 		handle = ip6tc_init(tablename);
 	}
 
@@ -124,7 +123,6 @@ int main(int argc, char *argv[])
 	int c;
 	char curtable[IP6T_TABLE_MAXNAMELEN + 1];
 	FILE *in;
-	const char *modprobe = NULL;
 	int in_table = 0, testing = 0;
 
 	program_name = "ip6tables-restore";
@@ -166,7 +164,7 @@ int main(int argc, char *argv[])
 				noflush = 1;
 				break;
 			case 'M':
-				modprobe = optarg;
+				modprobe_program = optarg;
 				break;
 		}
 	}
@@ -225,7 +223,7 @@ int main(int argc, char *argv[])
 			if (handle)
 				ip6tc_free(handle);
 
-			handle = create_handle(table, modprobe);
+			handle = create_handle(table);
 			if (noflush == 0) {
 				DEBUGP("Cleaning all chains of table '%s'\n",
 					table);
diff --git a/iptables-restore.c b/iptables-restore.c
index 12e558d..4ea9306 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -55,7 +55,7 @@ static void print_usage(const char *name, const char *version)
 	exit(1);
 }
 
-static struct iptc_handle *create_handle(const char *tablename, const char *modprobe)
+static struct iptc_handle *create_handle(const char *tablename)
 {
 	struct iptc_handle *handle;
 
@@ -63,7 +63,7 @@ static struct iptc_handle *create_handle(const char *tablename, const char *modp
 
 	if (!handle) {
 		/* try to insmod the module if iptc_init failed */
-		load_xtables_ko(modprobe, 0);
+		load_xtables_ko(modprobe_program, 0);
 		handle = iptc_init(tablename);
 	}
 
@@ -124,7 +124,6 @@ main(int argc, char *argv[])
 	int c;
 	char curtable[IPT_TABLE_MAXNAMELEN + 1];
 	FILE *in;
-	const char *modprobe = NULL;
 	int in_table = 0, testing = 0;
 	const char *tablename = NULL;
 
@@ -167,7 +166,7 @@ main(int argc, char *argv[])
 				noflush = 1;
 				break;
 			case 'M':
-				modprobe = optarg;
+				modprobe_program = optarg;
 				break;
 			case 'T':
 				tablename = optarg;
@@ -231,7 +230,7 @@ main(int argc, char *argv[])
 			if (handle)
 				iptc_free(handle);
 
-			handle = create_handle(table, modprobe);
+			handle = create_handle(table);
 			if (noflush == 0) {
 				DEBUGP("Cleaning all chains of table '%s'\n",
 					table);


