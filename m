From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH] mark newly opened fds as FD_CLOEXEC (close on exec) [part 2]
Date: Wed, 21 Mar 2012 03:52:00 -0700
Message-ID: <1332327120-22444-1-git-send-email-zenczykowski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f51.google.com ([209.85.210.51]:56499 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab2CUKwX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Mar 2012 06:52:23 -0400
Received: by dady9 with SMTP id y9so1358620dad.10
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Mar 2012 03:52:23 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

This is iptables-1.4.11-cloexec.patch from Fedora 18 iptables source
rpm, in particular:
  http://kojipkgs.fedoraproject.org/packages/iptables/1.4.12.2/4.fc18/s=
rc/iptables-1.4.12.2-4.fc18.src.rpm

Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
---
 extensions/libxt_set.h |    7 +++++++
 libiptc/libiptc.c      |    8 ++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_set.h b/extensions/libxt_set.h
index 4ac84fa9c022..47c3f5b6f5d4 100644
--- a/extensions/libxt_set.h
+++ b/extensions/libxt_set.h
@@ -2,6 +2,7 @@
 #define _LIBXT_SET_H
=20
 #include <unistd.h>
+#include <fcntl.h>
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <errno.h>
@@ -23,6 +24,12 @@ get_version(unsigned *version)
 		xtables_error(OTHER_PROBLEM,
 			      "Can't open socket to ipset.\n");
=20
+	if (fcntl(sockfd, F_SETFD, FD_CLOEXEC) =3D=3D -1) {
+		xtables_error(OTHER_PROBLEM,
+			      "Could not set close on exec: %s\n",
+			      strerror(errno));
+	}
+
 	req_version.op =3D IP_SET_OP_VERSION;
 	res =3D getsockopt(sockfd, SOL_IP, SO_IP_SET, &req_version, &size);
 	if (res !=3D 0)
diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 13e41d525f28..63965e738596 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -29,6 +29,8 @@
  * 	- performance work: speedup initial ruleset parsing.
  * 	- sponsored by ComX Networks A/S (http://www.comx.dk/)
  */
+#include <unistd.h>
+#include <fcntl.h>
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <stdbool.h>
@@ -1316,6 +1318,12 @@ TC_INIT(const char *tablename)
 	if (sockfd < 0)
 		return NULL;
=20
+	if (fcntl(sockfd, F_SETFD, FD_CLOEXEC) =3D=3D -1) {
+		fprintf(stderr, "Could not set close on exec: %s\n",
+			strerror(errno));
+		abort();
+	}
+
 retry:
 	s =3D sizeof(info);
=20
--=20
1.7.7.3

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
