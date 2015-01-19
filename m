From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables] iptables: use flock() instead of abstract unix sockets
Date: Mon, 19 Jan 2015 19:09:17 +0100
Message-ID: <1421690957-11279-1-git-send-email-pablo@netfilter.org>
Cc: kernel@linuxace.com, lennart@poettering.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36811 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbbASSGZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:06:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Abstract unix sockets cannot be used to synchronize several concurrent
instances of iptables since an unpriviledged process can create them and
prevent the legitimate iptables instance from running.

Use flock() and /run instead as suggested by Lennart Poettering.

Fixes: 93587a0 ("ip[6]tables: Add locking to prevent concurrent instances")
Reported-by: Lennart Poettering <lennart@poettering.net>
Cc: Phil Oester <kernel@linuxace.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/xshared.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index b18022e..7beb86b 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -9,11 +9,11 @@
 #include <sys/socket.h>
 #include <sys/un.h>
 #include <unistd.h>
+#include <fcntl.h>
 #include <xtables.h>
 #include "xshared.h"
 
-#define XT_SOCKET_NAME "xtables"
-#define XT_SOCKET_LEN 8
+#define XT_LOCK_NAME	"/run/xtables.lock"
 
 /*
  * Print out any special helps. A user might like to be able to add a --help
@@ -245,22 +245,14 @@ void xs_init_match(struct xtables_match *match)
 
 bool xtables_lock(int wait)
 {
-	int i = 0, ret, xt_socket;
-	struct sockaddr_un xt_addr;
-	int waited = 0;
-
-	memset(&xt_addr, 0, sizeof(xt_addr));
-	xt_addr.sun_family = AF_UNIX;
-	strcpy(xt_addr.sun_path+1, XT_SOCKET_NAME);
-	xt_socket = socket(AF_UNIX, SOCK_STREAM, 0);
-	/* If we can't even create a socket, fall back to prior (lockless) behavior */
-	if (xt_socket < 0)
+	int fd, waited = 0, i = 0;
+
+	fd = open(XT_LOCK_NAME, O_CREAT, 0600);
+	if (fd < 0)
 		return true;
 
 	while (1) {
-		ret = bind(xt_socket, (struct sockaddr*)&xt_addr,
-			   offsetof(struct sockaddr_un, sun_path)+XT_SOCKET_LEN);
-		if (ret == 0)
+		if (flock(fd, LOCK_EX | LOCK_NB) == 0)
 			return true;
 		else if (wait >= 0 && waited >= wait)
 			return false;
-- 
1.7.10.4

