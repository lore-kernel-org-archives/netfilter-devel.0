From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] xtables-standalone: call nft_fini in the error path
Date: Mon,  2 Dec 2013 11:43:25 +0100
Message-ID: <1385981005-2843-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:54031 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab3LBKqW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Dec 2013 05:46:22 -0500
Received: by mail-wg0-f49.google.com with SMTP id x12so11482964wgg.28
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Dec 2013 02:46:21 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This error is shown with valgrind tools:

valgrind --leak-check=full xtables -A INPUT -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT

==7377== 16 bytes in 1 blocks are still reachable in loss record 1 of 14
==7377==    at 0x4C2B514: calloc (vg_replace_malloc.c:593)
==7377==    by 0x574CC76: mnl_socket_open (socket.c:117)
==7377==    by 0x417495: nft_init (nft.c:598)
==7377==    by 0x4134C2: xtables_main (xtables-standalone.c:64)
==7377==    by 0x5B87994: (below main) (libc-start.c:260)

This patch calls nft_fini to release the objects that have been allocated in
nft_init. This function was not used so far.
---
 iptables/xtables-standalone.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/iptables/xtables-standalone.c b/iptables/xtables-standalone.c
index cb685d6..c9f8e15 100644
--- a/iptables/xtables-standalone.c
+++ b/iptables/xtables-standalone.c
@@ -66,6 +66,7 @@ xtables_main(int argc, char *argv[])
 				xtables_globals.program_name,
 				xtables_globals.program_version,
 				strerror(errno));
+		nft_fini(&h);
 		exit(EXIT_FAILURE);
 	}
 
@@ -73,6 +74,8 @@ xtables_main(int argc, char *argv[])
 	if (ret)
 		ret = nft_commit(&h);
 
+	nft_fini(&h);
+
 	if (!ret) {
 		if (errno == EINVAL) {
 			fprintf(stderr, "iptables: %s. "
-- 
1.8.4.rc3

