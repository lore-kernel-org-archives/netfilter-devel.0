From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 5/9] Fix crash IP2BIN and IP2STR due to ui128 type introduction.
Date: Tue, 20 May 2008 00:31:31 +0200
Message-ID: <1211236295-30207-6-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:38770 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757091AbYESWag (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 May 2008 18:30:36 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

IP2BIN and IP2STR were using the ptr field of the value but the type used
for IPv6 address is now ui128. This patch fix this problem by using ui128
instead of ptr.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 filter/ulogd_filter_IP2BIN.c |    2 +-
 filter/ulogd_filter_IP2STR.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/filter/ulogd_filter_IP2BIN.c b/filter/ulogd_filter_IP2BIN.c
index 33db6a2..7412e38 100644
--- a/filter/ulogd_filter_IP2BIN.c
+++ b/filter/ulogd_filter_IP2BIN.c
@@ -137,7 +137,7 @@ static char *ip2bin(struct ulogd_key* inp, int index, char family)
 
 	switch (family) {
 		case AF_INET6:
-			addr = GET_VALUE(inp, index).ptr;
+			addr = GET_VALUE(inp, index).ui128;
 			break;
 		case AF_INET:
 			/* Convert IPv4 to IPv4 in IPv6 */
diff --git a/filter/ulogd_filter_IP2STR.c b/filter/ulogd_filter_IP2STR.c
index e4ec06d..9ad3b81 100644
--- a/filter/ulogd_filter_IP2STR.c
+++ b/filter/ulogd_filter_IP2STR.c
@@ -174,7 +174,7 @@ static char *ip2str(struct ulogd_key *inp, int index)
 	switch (convfamily) {
 	case AF_INET6:
 		inet_ntop(AF_INET6,
-			  GET_VALUE(inp, index).ptr,
+			  GET_VALUE(inp, index).ui128,
 			  tmp, sizeof(tmp));
 		break;
 	case AF_INET:
-- 
1.5.4.3

