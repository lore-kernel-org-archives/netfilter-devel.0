From: Hani Benhabiles <kroosec@gmail.com>
Subject: [PATCH conntrack-tools] conntrackd: Don't hardcode libs dir path
Date: Mon, 14 Oct 2013 23:14:24 +0100
Message-ID: <20131014221424.GA10577@doj>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:47420 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998Ab3JNWOc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Oct 2013 18:14:32 -0400
Received: by mail-ee0-f50.google.com with SMTP id d51so3640697eek.23
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2013 15:14:31 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use CONNTRACKD_LIB_DIR instead of hardcoded path.

Signed-off-by: Hani Benhabiles <kroosec@gmail.com>
---

diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index fa517bb..73fabbf 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -1613,8 +1613,7 @@ helper_type: T_TYPE T_STRING T_STRING T_STRING '{' helper_type_list  '}'
 	}
 
 #ifdef BUILD_CTHELPER
-	/* XXX use configure.ac definitions. */
-	helper = helper_find("/usr/lib/conntrack-tools", $2, l4proto, RTLD_NOW);
+	helper = helper_find(CONNTRACKD_LIB_DIR, $2, l4proto, RTLD_NOW);
 	if (helper == NULL) {
 		print_err(CTD_CFG_ERROR, "Unknown `%s' helper", $2);
 		exit(EXIT_FAILURE);

