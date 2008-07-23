From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 3/4] Fix warning in IP2BIN.
Date: Wed, 23 Jul 2008 13:33:54 +0200
Message-ID: <1216812835-9851-4-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43433 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751684AbYGWLd5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 07:33:57 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch cast a expression to avoid a warning.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 filter/ulogd_filter_IP2BIN.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/filter/ulogd_filter_IP2BIN.c b/filter/ulogd_filter_IP2BIN.c
index d1b3c47..c4b44fa 100644
--- a/filter/ulogd_filter_IP2BIN.c
+++ b/filter/ulogd_filter_IP2BIN.c
@@ -137,7 +137,7 @@ static char *ip2bin(struct ulogd_key* inp, int index, char family)
 
 	switch (family) {
 		case AF_INET6:
-			addr = GET_VALUE(inp, index).ui128;
+			addr = (struct in6_addr *) GET_VALUE(inp, index).ui128;
 			break;
 		case AF_INET:
 			/* Convert IPv4 to IPv4 in IPv6 */
-- 
1.5.4.3

