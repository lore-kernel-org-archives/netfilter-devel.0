From: Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH 1/1] ipset: fix timeout data type size
Date: Thu, 31 Oct 2013 00:34:31 -0400
Message-ID: <1383194071-25937-1-git-send-email-mar.kolya@gmail.com>
Cc: Nikolay Martynov <mar.kolya@gmail.com>,
	netfilter-devel@vger.kernel.org
To: kadlec@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:45976 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab3JaEei (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Oct 2013 00:34:38 -0400
Received: by mail-ob0-f180.google.com with SMTP id wo20so2458879obc.25
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2013 21:34:38 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently it is impossible to set timeout on some architectures
(MIPS ar71xx at least) because timeout is parsed into long long data
type but used as uint32 without proper conversion. This patch fixes
this issue. Tested on ar71xx router.

Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
---
 lib/parse.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/lib/parse.c b/lib/parse.c
index 8ea8542..440ef8f 100644
--- a/lib/parse.c
+++ b/lib/parse.c
@@ -1292,15 +1292,20 @@ ipset_parse_timeout(struct ipset_session *session,
 		    enum ipset_opt opt, const char *str)
 {
 	int err;
-	unsigned long long num = 0;
+	unsigned long long llnum = 0;
+	uint32_t num = 0;
 
 	assert(session);
 	assert(opt == IPSET_OPT_TIMEOUT);
 	assert(str);
 
-	err = string_to_number_ll(session, str, 0, UINT_MAX/1000, &num);
-	if (err == 0)
+	err = string_to_number_ll(session, str, 0, UINT_MAX/1000, &llnum);
+	if (err == 0) {
+		/* Timeout is expected to be 32bits wide, so we have
+		   to convert it here */
+		num = llnum;
 		return ipset_session_data_set(session, opt, &num);
+	}
 
 	return err;
 }
-- 
Thanks.
Nikolay.

