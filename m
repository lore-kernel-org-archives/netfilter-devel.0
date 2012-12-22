From: Eric Leblond <eric@regit.org>
Subject: [PATCH 1/2] Add missing u64 function.
Date: Sat, 22 Dec 2012 12:28:30 +0100
Message-ID: <1356175711-13254-2-git-send-email-eric@regit.org>
References: <1356175711-13254-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:54711 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab2LVL3U (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Dec 2012 06:29:20 -0500
In-Reply-To: <1356175711-13254-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/ulogd/ulogd.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
index 81933f2..41c2e9b 100644
--- a/include/ulogd/ulogd.h
+++ b/include/ulogd/ulogd.h
@@ -184,6 +184,11 @@ static inline u_int32_t ikey_get_u32(struct ulogd_key *key)
 	return key->u.source->u.value.ui32;
 }
 
+static inline u_int64_t ikey_get_u64(struct ulogd_key *key)
+{
+	return key->u.source->u.value.ui64;
+}
+
 static inline void *ikey_get_u128(struct ulogd_key *key)
 {
 	return &key->u.source->u.value.ui128;
-- 
1.7.10.4

