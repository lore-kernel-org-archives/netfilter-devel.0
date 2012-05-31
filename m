From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH] conntrackd: resolve a compiler error
Date: Thu, 31 May 2012 14:03:17 +0200
Message-ID: <1338465797-9797-2-git-send-email-jengelh@inai.de>
References: <1338465797-9797-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:36327 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290Ab2EaMDr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 May 2012 08:03:47 -0400
In-Reply-To: <1338465797-9797-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Observed with gcc-4.7/glibc-2.15 and conntrack-tools-1.2.1:

  CC     parse.o
parse.c: In function 'msg2ct':
parse.c:258:34: error: 'NULL' undeclared (first use in this function)
parse.c:258:34: note: each undeclared identifier is reported only once for each function it appears in
parse.c: In function 'msg2exp':
parse.c:438:16: error: 'NULL' undeclared (first use in this function)

NULL is in stdio.h.
---
 src/parse.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/src/parse.c b/src/parse.c
index 1b83f81..391bf38 100644
--- a/src/parse.c
+++ b/src/parse.c
@@ -17,6 +17,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <stdio.h>
 #include "network.h"
 
 #include <stdlib.h>
-- 
1.7.7

