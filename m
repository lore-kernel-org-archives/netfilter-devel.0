From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] xtables: Add locking to prevent concurrent instances
Date: Wed, 22 May 2013 13:35:11 -0400
Message-ID: <20130522173511.GB860@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="E39vaYmALEf/7YXx"
Cc: pablo@netfilter.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:53873 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563Ab3EVRf1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 May 2013 13:35:27 -0400
Received: by mail-oa0-f47.google.com with SMTP id m1so3036801oag.20
        for <netfilter-devel@vger.kernel.org>; Wed, 22 May 2013 10:35:27 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--E39vaYmALEf/7YXx
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

As long as I was adding locking, I also chose to add a retry loop, with 3
attempts made to grab the lock before giving up.

Phil


Signed-off-by: Phil Oester <kernel@linuxace.com>

--E39vaYmALEf/7YXx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-xtables-lock

diff --git a/iptables/xtables-multi.c b/iptables/xtables-multi.c
index 8014d5f..9c22a82 100644
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
@@ -35,7 +39,31 @@ static const struct subcommand multi_subcommands[] = {
 	{NULL},
 };
 
+#define XTMSOCKET_NAME "xtables_multi"
+#define XTMSOCKET_LEN 14
+
 int main(int argc, char **argv)
 {
-	return subcmd_main(argc, argv, multi_subcommands);
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
+	do {
+		ret = bind(xtm_socket, (struct sockaddr*)&xtm_addr,
+			   offsetof(struct sockaddr_un, sun_path)+XTMSOCKET_LEN);
+		if (ret == 0)
+			return subcmd_main(argc, argv, multi_subcommands);
+		i++;
+		sleep(1);
+	} while (i <= 2);
+
+	fprintf(stderr, "ERROR: unable to obtain lock - another instance is already running\n");
+	exit(RESOURCE_PROBLEM);
 }

--E39vaYmALEf/7YXx--
