From: Eric Leblond <eric@regit.org>
Subject: [PATCH 2/4] Fix warning on format
Date: Sat, 19 Jan 2013 10:53:49 +0100
Message-ID: <1358589231-1358-3-git-send-email-eric@regit.org>
References: <1358589231-1358-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:37680 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3ASJyg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Jan 2013 04:54:36 -0500
In-Reply-To: <1358589231-1358-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It seems Z is a libc5 only format modifier. Using standard 'z'
instead.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 util/printpkt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/util/printpkt.c b/util/printpkt.c
index 3983a68..6b646e9 100644
--- a/util/printpkt.c
+++ b/util/printpkt.c
@@ -299,7 +299,7 @@ static int printpkt_ipv6(struct ulogd_key *res, char *buf)
 				   (char *) ikey_get_ptr(&res[KEY_IP_DADDR]));
 
 	if (pp_is_valid(res, KEY_IP6_PAYLOAD_LEN))
-		buf_cur += sprintf(buf_cur, "LEN=%Zu ",
+		buf_cur += sprintf(buf_cur, "LEN=%zu ",
 				   ikey_get_u16(&res[KEY_IP6_PAYLOAD_LEN]) +
 				   sizeof(struct ip6_hdr));
 
-- 
1.7.10.4

