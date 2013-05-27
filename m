From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH v3] xtables: Add locking to prevent concurrent instances
Date: Mon, 27 May 2013 12:23:11 -0400
Message-ID: <20130527162311.GA1366@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="BOKacYhQ+x31HxR3"
Cc: pablo@netfilter.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:48020 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3E0QXR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 May 2013 12:23:17 -0400
Received: by mail-ie0-f182.google.com with SMTP id a14so19075199iee.27
        for <netfilter-devel@vger.kernel.org>; Mon, 27 May 2013 09:23:17 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

There have been numerous complaints and bug reports over the years when admins
attempt to run more than one instance of iptables simultaneously.  Currently
open bug reports which are related:

325: Parallel execution of the iptables is impossible
758: Retry iptables command on transient failure
764: Doing -Z twice in parallel breaks counters
822: iptables shows negative or other bad packet/byte counts

As Patrick notes in 325:  "Since this has been a problem people keep running
into, I'd suggest to simply add some locking to iptables to catch the most
common case."

I started looking into alternatives to add locking, and of course the most
common/obvious solution is to use a pidfile.  But this has various downsides,
such as if the application is terminated abnormally and the pidfile isn't
cleaned up.  And this also requires a writable filesystem.  Using a UNIX domain
socket file (e.g. in /var/run) has similar issues.

Starting in 2.2, Linux added support for abstract sockets.  These sockets
require no filesystem, and automatically disappear once the application
terminates.  This is the locking solution I chose to implement in xtables-multi.
As an added bonus, since each network namespace has its own socket pool, an
iptables instance running in one namespace will not lock out an iptables
instance running in another namespace.  A filesystem approach would have
to recognize and handle multiple network namespaces.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>

---

v2: Addressed Patrick's comments - locking attempts will be made indefinitely until successful
v3: Update warning message to more closely resemble locking output from yum


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-xtables-lock

diff --git a/iptables/xtables-multi.c b/iptables/xtables-multi.c
index 8014d5f..56d2c91 100644
--- a/iptables/xtables-multi.c
+++ b/iptables/xtables-multi.c
@@ -1,8 +1,12 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <sys/socket.h>
+#include <sys/un.h>
+#include <unistd.h>
 #include "xshared.h"
 
+#include "xtables.h"
 #include "xtables-multi.h"
 
 #ifdef ENABLE_IPV4
@@ -35,7 +39,32 @@ static const struct subcommand multi_subcommands[] = {
 	{NULL},
 };
 
+#define XTMSOCKET_NAME "xtables_multi"
+#define XTMSOCKET_LEN 14
+
 int main(int argc, char **argv)
 {
+	int i = 0, ret, xtm_socket;
+	struct sockaddr_un xtm_addr;
+
+	memset(&xtm_addr, 0, sizeof(xtm_addr));
+	xtm_addr.sun_family = AF_UNIX;
+	strcpy(xtm_addr.sun_path+1, XTMSOCKET_NAME);
+	xtm_socket = socket(AF_UNIX, SOCK_STREAM, 0);
+	/* If we can't even create a socket, just revert to prior (lockless) behavior */
+	if (xtm_socket < 0)
+		return subcmd_main(argc, argv, multi_subcommands);
+
+	while (1) {
+		ret = bind(xtm_socket, (struct sockaddr*)&xtm_addr,
+			   offsetof(struct sockaddr_un, sun_path)+XTMSOCKET_LEN);
+		if (ret == 0)
+			break;
+		if (++i % 5 == 0)
+			fprintf(stderr, "Another app is currently holding the xtables lock; "
+				"waiting for it to exit...\n");
+		sleep(1);
+	}
+
 	return subcmd_main(argc, argv, multi_subcommands);
 }

--BOKacYhQ+x31HxR3--
