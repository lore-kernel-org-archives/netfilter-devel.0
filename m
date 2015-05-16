From: Felix Janda <felix.janda@posteo.de>
Subject: [libmnl PATCH 2/2] examples/netfilter: Include <endian.h> for be64toh
Date: Sat, 16 May 2015 12:40:03 +0200
Message-ID: <20150516103750.GL14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:53107 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbbEPKku (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 06:40:50 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id A332B25AF515
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 12:40:48 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpjnD2Vx9z5vN2
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 12:40:48 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 examples/netfilter/nfct-daemon.c | 1 +
 examples/netfilter/nfct-dump.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/examples/netfilter/nfct-daemon.c b/examples/netfilter/nfct-daemon.c
index a4ef0af..a97c2ec 100644
--- a/examples/netfilter/nfct-daemon.c
+++ b/examples/netfilter/nfct-daemon.c
@@ -3,6 +3,7 @@
  *
  * This example is placed in the public domain.
  */
+#include <endian.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
diff --git a/examples/netfilter/nfct-dump.c b/examples/netfilter/nfct-dump.c
index 25ccf2c..114af61 100644
--- a/examples/netfilter/nfct-dump.c
+++ b/examples/netfilter/nfct-dump.c
@@ -1,4 +1,5 @@
 /* This example is placed in the public domain. */
+#include <endian.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
-- 
2.3.6
