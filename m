From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/2] build: resolve build failure involving linux/netlink.h
Date: Tue, 21 Jan 2014 00:52:01 +0100
Message-ID: <1390261922-13182-2-git-send-email-jengelh@inai.de>
References: <1390261922-13182-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:43512 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbaATXwE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jan 2014 18:52:04 -0500
In-Reply-To: <1390261922-13182-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This was seen with a sufficiently-old /usr/include/linux
(from Linux 2.6.32).

	In file included from common.c:10:
	/usr/include/linux/netlink.h:34: error: expected
	specifier-qualifier-list before 'sa_family_t'

The solution is to include <linux/*> last of all system headers.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 src/common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/common.c b/src/common.c
index b9598bf..336d2b4 100644
--- a/src/common.c
+++ b/src/common.c
@@ -7,6 +7,8 @@
  * (at your option) any later version.
  */
 
+#include <stdlib.h>
+#include <sys/socket.h>
 #include <linux/netlink.h>
 #include <linux/netfilter/nfnetlink.h>
 
@@ -14,7 +16,6 @@
 #include <libnftnl/common.h>
 
 #include "internal.h"
-#include<stdlib.h>
 
 struct nlmsghdr *nft_nlmsg_build_hdr(char *buf, uint16_t cmd, uint16_t family,
 				     uint16_t type, uint32_t seq)
-- 
1.8.4

