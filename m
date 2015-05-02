From: Felix Janda <felix.janda@posteo.de>
Subject: [iptables PATCH 1/2] Consistently use <errno.h>
Date: Sat, 2 May 2015 21:51:01 +0200
Message-ID: <20150502195101.GA17994@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:48940 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947060AbbEBTvL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 15:51:11 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 2606625B17C6
	for <netfilter-devel@vger.kernel.org>; Sat,  2 May 2015 21:51:10 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lfLfj6ppmz5vN9
	for <netfilter-devel@vger.kernel.org>; Sat,  2 May 2015 21:51:09 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On glibc, <sys/errno.h> is a synomym for <errno.h>.
<errno.h> is specified by POSIX, so use that.

Fixes compilation error with musl libc
---
 iptables/ip6tables-restore.c | 2 +-
 iptables/ip6tables-save.c    | 2 +-
 iptables/iptables-restore.c  | 2 +-
 iptables/iptables-save.c     | 2 +-
 iptables/iptables-xml.c      | 2 +-
 iptables/xtables-restore.c   | 2 +-
 iptables/xtables-save.c      | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 0f4dd97..9393924 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -9,7 +9,7 @@
  */
 
 #include <getopt.h>
-#include <sys/errno.h>
+#include <errno.h>
 #include <stdbool.h>
 #include <string.h>
 #include <stdio.h>
diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
index 56e5afb..f35e921 100644
--- a/iptables/ip6tables-save.c
+++ b/iptables/ip6tables-save.c
@@ -6,7 +6,7 @@
  * This code is distributed under the terms of GNU GPL v2
  */
 #include <getopt.h>
-#include <sys/errno.h>
+#include <errno.h>
 #include <stdio.h>
 #include <fcntl.h>
 #include <stdlib.h>
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 261822d..638b171 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -6,7 +6,7 @@
  */
 
 #include <getopt.h>
-#include <sys/errno.h>
+#include <errno.h>
 #include <stdbool.h>
 #include <string.h>
 #include <stdio.h>
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index bcf88ae..238f368 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -6,7 +6,7 @@
  *
  */
 #include <getopt.h>
-#include <sys/errno.h>
+#include <errno.h>
 #include <stdio.h>
 #include <fcntl.h>
 #include <stdlib.h>
diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index c7615ab..7461412 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -7,7 +7,7 @@
  */
 
 #include <getopt.h>
-#include <sys/errno.h>
+#include <errno.h>
 #include <string.h>
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 3cb095f..8808ee9 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -6,7 +6,7 @@
  */
 
 #include <getopt.h>
-#include <sys/errno.h>
+#include <errno.h>
 #include <stdbool.h>
 #include <string.h>
 #include <stdio.h>
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index d51cdcf..6b33bed 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -7,7 +7,7 @@
  *
  */
 #include <getopt.h>
-#include <sys/errno.h>
+#include <errno.h>
 #include <stdio.h>
 #include <fcntl.h>
 #include <stdlib.h>
-- 
2.3.6
