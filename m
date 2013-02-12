From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] Delete unused includes.
Date: Wed, 13 Feb 2013 00:08:31 +0100
Message-ID: <20130212230831.10643.41041.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pneira@us.es
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:51015 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758506Ab3BLXIk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:08:40 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---
 src/expr/match.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/src/expr/match.c b/src/expr/match.c
index 0c7427d..9ae849b 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -15,8 +15,6 @@
 #include <stdint.h>
 #include <string.h>	/* for memcpy */
 #include <arpa/inet.h>
-#include <stdlib.h>	/* bin to hex*/
-#include <math.h>	/* bin to hex*/
 
 #include <libmnl/libmnl.h>
 

