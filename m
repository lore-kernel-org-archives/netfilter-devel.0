From: Mansour Moufid <mansourmoufid@gmail.com>
Subject: [PATCH] netfilter: nf_conntrack_ftp: prevent integer overflows in get_port()
Date: Wed, 4 May 2011 18:31:34 -0400
Message-ID: <BANLkTikp9ZV4w1E8NNsGBkftGh=jRDx5fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62953 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab1EDWbz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 May 2011 18:31:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Mansour Moufid <mansourmoufid@gmail.com>

This patch prevents potential integer overflows from occurring in the
port number parsing function `get_port', in the file
net/netfilter/nf_conntrack_ftp.c; related constants are defined in
include/linux/kernel.h. This applies to stable version 2.6.38.5.

The concern is a firewall could be made to open an otherwise closed
port. For example, get_port("65558?", 0, 6, '?', foo) currently
returns 22 in *foo.

Signed-off-by: Mansour Moufid <mansourmoufid@gmail.com>
---
diff -uprN -X linux-2.6.38.5-vanilla/Documentation/dontdiff
linux-2.6.38.5-vanilla/include/linux/kernel.h
linux-2.6.38.5/include/linux/kernel.h
--- linux-2.6.38.5-vanilla/include/linux/kernel.h	2011-05-04
17:48:40.619103335 -0400
+++ linux-2.6.38.5/include/linux/kernel.h	2011-05-04 18:09:12.183411601 -0400
@@ -34,6 +34,8 @@
 #define LLONG_MAX	((long long)(~0ULL>>1))
 #define LLONG_MIN	(-LLONG_MAX - 1)
 #define ULLONG_MAX	(~0ULL)
+#define SIZE_MAX	(~((size_t)0))
+#define UINT16_MAX	(~((u_int16_t)0))

 #define STACK_MAGIC	0xdeadbeef

diff -uprN -X linux-2.6.38.5-vanilla/Documentation/dontdiff
linux-2.6.38.5-vanilla/net/netfilter/nf_conntrack_ftp.c
linux-2.6.38.5/net/netfilter/nf_conntrack_ftp.c
--- linux-2.6.38.5-vanilla/net/netfilter/nf_conntrack_ftp.c	2011-05-04
17:14:11.533008253 -0400
+++ linux-2.6.38.5/net/netfilter/nf_conntrack_ftp.c	2011-05-04
18:09:38.863070568 -0400
@@ -9,6 +9,7 @@
  * published by the Free Software Foundation.
  */

+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/netfilter.h>
@@ -162,11 +163,16 @@ static int try_rfc959(const char *data,
 }

 /* Grab port: number up to delimiter */
-static int get_port(const char *data, int start, size_t dlen, char delim,
+static int get_port(const char *data, size_t start, size_t dlen, char delim,
 		    __be16 *port)
 {
 	u_int16_t tmp_port = 0;
-	int i;
+	size_t i;
+
+	if (start > SIZE_MAX - dlen) {
+		pr_debug("get_port: invalid parameters\n");
+		return 0;
+	}

 	for (i = start; i < dlen; i++) {
 		/* Finished? */
@@ -176,14 +182,18 @@ static int get_port(const char *data, in
 			*port = htons(tmp_port);
 			pr_debug("get_port: return %d\n", tmp_port);
 			return i + 1;
-		}
-		else if (data[i] >= '0' && data[i] <= '9')
-			tmp_port = tmp_port*10 + data[i] - '0';
-		else { /* Some other crap */
+		} else if (data[i] >= '0' && data[i] <= '9') {
+			if (tmp_port > (UINT16_MAX - (data[i] - '0')) / 10) {
+				pr_debug("get_port: integer overflow\n");
+				break;
+			}
+			tmp_port = tmp_port * 10 + data[i] - '0';
+		} else { /* Some other crap */
 			pr_debug("get_port: invalid char.\n");
 			break;
 		}
 	}
+
 	return 0;
 }
