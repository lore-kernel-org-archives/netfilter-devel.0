From: Zhang Chunyu <zhangcy@cn.fujitsu.com>
Subject: [PATCH V4 2/3] Add revision field for arptables userspace
Date: Sun, 29 Mar 2015 22:35:47 -0400
Message-ID: <1427682948-18699-3-git-send-email-zhangcy@cn.fujitsu.com>
References: <1427682948-18699-1-git-send-email-zhangcy@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Zhang Chunyu <zhangcy@cn.fujitsu.com>,
	Gao feng <gaofeng@cn.fujitsu.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49915 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752691AbbC3Ctp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Mar 2015 22:49:45 -0400
In-Reply-To: <1427682948-18699-1-git-send-email-zhangcy@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: Zhang Chunyu <zhangcy@cn.fujitsu.com>
---
 arptables.c                | 2 ++
 extensions/arpt_CLASSIFY.c | 1 +
 extensions/arpt_mangle.c   | 1 +
 extensions/arpt_standard.c | 1 +
 include/arptables.h        | 6 ++++++
 5 files changed, 11 insertions(+)

diff --git a/arptables.c b/arptables.c
index 845e226..3f24ef1 100644
--- a/arptables.c
+++ b/arptables.c
@@ -2067,6 +2067,7 @@ int do_command(int argc, char *argv[], char **table, arptc_handle_t *handle)
 				target->t->u.target_size = size;
 				strncpy(target->t->u.user.name, jumpto, sizeof(target->t->u.user.name));
 				target->t->u.user.name[sizeof(target->t->u.user.name)-1] = '\0';
+				target->t->u.user.revision = target->revision;
 /*
 				target->init(target->t, &fw.nfcache);
 */
@@ -2391,6 +2392,7 @@ int do_command(int argc, char *argv[], char **table, arptc_handle_t *handle)
 			target->t = fw_calloc(1, size);
 			target->t->u.target_size = size;
 			strcpy(target->t->u.user.name, jumpto);
+			target->t->u.user.revision = target->revision;
 			target->init(target->t);
 		}
 
diff --git a/extensions/arpt_CLASSIFY.c b/extensions/arpt_CLASSIFY.c
index cb5770b..7893aed 100644
--- a/extensions/arpt_CLASSIFY.c
+++ b/extensions/arpt_CLASSIFY.c
@@ -105,6 +105,7 @@ struct arptables_target classify
 	ARPTABLES_VERSION,
 	ARPT_ALIGN(sizeof(struct xt_classify_target_info)),
 	ARPT_ALIGN(sizeof(struct xt_classify_target_info)),
+	0,
 	&help,
 	&init,
 	&parse,
diff --git a/extensions/arpt_mangle.c b/extensions/arpt_mangle.c
index c38fc16..502fc2b 100644
--- a/extensions/arpt_mangle.c
+++ b/extensions/arpt_mangle.c
@@ -199,6 +199,7 @@ struct arptables_target change
     ARPTABLES_VERSION,
     ARPT_ALIGN(sizeof(struct arpt_mangle)),
     ARPT_ALIGN(sizeof(struct arpt_mangle)),
+	0,
     &help,
     &init,
     &parse,
diff --git a/extensions/arpt_standard.c b/extensions/arpt_standard.c
index cb3891d..c647316 100644
--- a/extensions/arpt_standard.c
+++ b/extensions/arpt_standard.c
@@ -54,6 +54,7 @@ struct arptables_target standard
     ARPTABLES_VERSION,
     ARPT_ALIGN(sizeof(int)),
     ARPT_ALIGN(sizeof(int)),
+	0,
     &help,
     &init,
     &parse,
diff --git a/include/arptables.h b/include/arptables.h
index 820b664..82e6e9a 100644
--- a/include/arptables.h
+++ b/include/arptables.h
@@ -32,6 +32,9 @@ struct arptables_match
 	/* Size of match data relevent for userspace comparison purposes */
 	size_t userspacesize;
 
+	/* Revision of target (0 by default). */
+	u_int8_t revision;
+
 	/* Function which prints out usage message. */
 	void (*help)(void);
 
@@ -81,6 +84,9 @@ struct arptables_target
 	/* Size of target data relevent for userspace comparison purposes */
 	size_t userspacesize;
 
+	/* Revision of target (0 by default). */
+	u_int8_t revision;
+
 	/* Function which prints out usage message. */
 	void (*help)(void);
 
-- 
1.7.12.4

