From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] src: use limits.h header
Date: Sat,  5 Mar 2011 13:31:29 +0100
Message-ID: <1299328292-4469-2-git-send-email-jengelh@medozas.de>
References: <1299328292-4469-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58540 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455Ab1CEMbf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Mar 2011 07:31:35 -0500
In-Reply-To: <1299328292-4469-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

values.h is not present on other systems, and the glibc copy reads
right away: Old compatibility names for <limits.h> and <float.h>
constants.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 src/attr.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/src/attr.c b/src/attr.c
index c0ba938..55a80d6 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -6,10 +6,9 @@
  * by the Free Software Foundation; either version 2.1 of the License, or
  * (at your option) any later version.
  */
-
+#include <limits.h>	/* for INT_MAX */
 #include <libmnl/libmnl.h>
 #include <string.h>
-#include <values.h>	/* for INT_MAX */
 #include <errno.h>
 #include "internal.h"
 
-- 
1.7.1

