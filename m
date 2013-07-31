From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - PATCH] xtables: Do not dump before command parsing has been finished
Date: Wed, 31 Jul 2013 15:18:52 +0300
Message-ID: <1375273132-10169-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51933 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab3GaMTD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 08:19:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On xtables-save.c, -d will not output right away but after the full
command line hase been parsed.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---

I ensure the same behavior as usual, so -d outputs and exit succesfully as usual.

 iptables/xtables-save.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index db03090..990c0fe 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -78,6 +78,7 @@ int
 xtables_save_main(int argc, char *argv[])
 {
 	const char *tablename = NULL;
+	bool dump = false;
 	struct nft_handle h = {
 		.family	= AF_INET,	/* default to AF_INET */
 	};
@@ -118,8 +119,8 @@ xtables_save_main(int argc, char *argv[])
 			xtables_modprobe_program = optarg;
 			break;
 		case 'd':
-			do_output(&h, tablename, show_counters);
-			exit(0);
+			dump = true;
+			break;
 		case '4':
 			h.family = AF_INET;
 			break;
@@ -135,5 +136,10 @@ xtables_save_main(int argc, char *argv[])
 		exit(1);
 	}
 
+	if (dump) {
+		do_output(&h, tablename, show_counters);
+		exit(0);
+	}
+
 	return !do_output(&h, tablename, show_counters);
 }
-- 
1.8.3.2

