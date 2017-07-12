From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 2/4] list: Introduce list_last_entry
Date: Wed, 12 Jul 2017 14:36:56 +0200
Message-ID: <20170712123658.25363-3-phil@nwl.cc>
References: <20170712123658.25363-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:58035 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756650AbdGLMhP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2017 08:37:15 -0400
In-Reply-To: <20170712123658.25363-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Similar to list_first_entry, this macro allows to retrieve the list's
last entry.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/list.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/list.h b/include/list.h
index 75d2921240101..5405dbbc0066b 100644
--- a/include/list.h
+++ b/include/list.h
@@ -337,6 +337,17 @@ static inline void list_splice_tail_init(struct list_head *list,
 #define list_first_entry(ptr, type, member) \
 	list_entry((ptr)->next, type, member)
 
+/**
+ * list_last_entry - get the last element from a list
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Note, that list is expected to be not empty.
+ */
+#define list_last_entry(ptr, type, member) \
+	list_entry((ptr)->prev, type, member)
+
 
 /**
  * list_for_each_entry	-	iterate over list of given type
-- 
2.13.1

