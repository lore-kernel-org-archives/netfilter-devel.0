From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 14/14] Fix computation of length of mac address.
Date: Sun, 23 Mar 2008 17:25:22 +0100
Message-ID: <12062895232871-git-send-email-eric@inl.fr>
References: <1206289522679-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:55064 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752920AbYCWQZ1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Mar 2008 12:25:27 -0400
In-Reply-To: <1206289522679-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Length of MAC address was set to big and thus display was wrong. This
misbehaviour was also causing to read datas out of the correct range.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 util/printpkt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/util/printpkt.c b/util/printpkt.c
index 6636ac3..b62eed8 100644
--- a/util/printpkt.c
+++ b/util/printpkt.c
@@ -428,7 +428,7 @@ int printpkt_print(struct ulogd_key *res, char *buf)
 	/* FIXME: configurable */
 	if (pp_is_valid(res, KEY_RAW_MAC)) {
 		unsigned char *mac = (unsigned char *) GET_VALUE(res, KEY_RAW_MAC).ptr;
-		int i, len = GET_VALUE(res, KEY_RAW_MACLEN).ui16 * 2;
+		int i, len = GET_VALUE(res, KEY_RAW_MACLEN).ui16;
 
 		buf_cur += sprintf(buf_cur, "MAC=");
 		for (i = 0; i < len; i++)
-- 
1.5.2.5

