From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH 1/8] iptables: Coverity: DEADCODE
Date: Fri, 10 Jun 2011 15:25:55 +0200
Message-ID: <1307712362-17727-2-git-send-email-jpopelka@redhat.com>
References: <1307712362-17727-1-git-send-email-jpopelka@redhat.com>
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755989Ab1FJN0k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:26:40 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5ADQe3C009033
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jun 2011 09:26:40 -0400
In-Reply-To: <1307712362-17727-1-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libiptc/libiptc.c:407: dead_error_condition: On this path, the condition "res > 0" cannot be false.
libiptc/libiptc.c:396: at_least: After this line, the value of "res" is at least 1.
libiptc/libiptc.c:393: equality_cond: Condition "res == 0" is evaluated as false.
libiptc/libiptc.c:396: new_values: Noticing condition "res < 0".
libiptc/libiptc.c:425: new_values: Noticing condition "res < 0".
libiptc/libiptc.c:407: new_values: Noticing condition "res > 0".
libiptc/libiptc.c:435: dead_error_line: Execution cannot reach this statement "return list_pos;".
---
 libiptc/libiptc.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 0b6d5e3..c2cb0bc 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -403,7 +403,7 @@ __iptcc_bsearch_chain_index(const char *name, unsigned int offset,
 		}
 		debug("jump back to pos:%d (end:%d)\n", pos, end);
 		goto loop;
-	} else if (res > 0 ){ /* Not far enough, jump forward */
+	} else { /* Not far enough, jump forward */
 
 		/* Exit case: Last element of array */
 		if (pos == handle->chain_index_sz-1) {
@@ -430,8 +430,6 @@ __iptcc_bsearch_chain_index(const char *name, unsigned int offset,
 		debug("jump forward to pos:%d (end:%d)\n", pos, end);
 		goto loop;
 	}
-
-	return list_pos;
 }
 
 /* Wrapper for string chain name based bsearch */
-- 
1.7.5.2

