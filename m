From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl,v2 4/4] src: do not nul-terminate internal helper functions
Date: Wed,  4 Oct 2017 14:23:23 +0200
Message-ID: <1507119803-15127-4-git-send-email-pablo@netfilter.org>
References: <1507119803-15127-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42392 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751949AbdJDMXc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2017 08:23:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 564921DA086
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 14:23:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 45C47DA7E9
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 14:23:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 29D2ADA7E9
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 14:23:29 +0200 (CEST)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BBC7A40584CF
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 14:23:28 +0200 (CEST)
In-Reply-To: <1507119803-15127-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Public API already does this for us, no need to do this again from
internal helper functions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/chain.c         | 3 ---
 src/expr/data_reg.c | 3 ---
 src/gen.c           | 3 ---
 src/object.c        | 3 ---
 src/rule.c          | 3 ---
 src/ruleset.c       | 6 ------
 src/set.c           | 3 ---
 src/set_elem.c      | 2 --
 src/table.c         | 3 ---
 9 files changed, 29 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 5e30a8016cac..a11bcf5cba03 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -827,9 +827,6 @@ static int nftnl_chain_cmd_snprintf(char *buf, size_t size,
 {
 	int ret, remain = size, offset = 0;
 
-	if (size)
-		buf[0] = '\0';
-
 	ret = nftnl_cmd_header_snprintf(buf + offset, remain, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index c925e2013c2f..a246952f7f01 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -194,9 +194,6 @@ int nftnl_data_reg_snprintf(char *buf, size_t size,
 			    uint32_t output_format, uint32_t flags,
 			    int reg_type)
 {
-	if (size)
-		buf[0] = '\0';
-
 	switch(reg_type) {
 	case DATA_VALUE:
 		switch(output_format) {
diff --git a/src/gen.c b/src/gen.c
index e42dd4055cb4..58b3a96dbdcb 100644
--- a/src/gen.c
+++ b/src/gen.c
@@ -168,9 +168,6 @@ static int nftnl_gen_cmd_snprintf(char *buf, size_t size,
 {
 	int ret, remain = size, offset = 0;
 
-	if (size)
-		buf[0] = '\0';
-
 	ret = nftnl_cmd_header_snprintf(buf + offset, remain, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
diff --git a/src/object.c b/src/object.c
index f907dd22d13a..9a4ee712a2a9 100644
--- a/src/object.c
+++ b/src/object.c
@@ -448,9 +448,6 @@ static int nftnl_obj_cmd_snprintf(char *buf, size_t size,
 {
 	int ret, remain = size, offset = 0;
 
-	if (size)
-		buf[0] = '\0';
-
 	ret = nftnl_cmd_header_snprintf(buf + offset, remain, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
diff --git a/src/rule.c b/src/rule.c
index 7cbd15bbd93c..a9e9870cbea9 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -792,9 +792,6 @@ static int nftnl_rule_cmd_snprintf(char *buf, size_t size,
 	int ret, remain = size, offset = 0;
 	uint32_t inner_flags = flags;
 
-	if (size)
-		buf[0] = '\0';
-
 	inner_flags &= ~NFTNL_OF_EVENT_ANY;
 
 	ret = nftnl_cmd_header_snprintf(buf + offset, remain, cmd, type, flags);
diff --git a/src/ruleset.c b/src/ruleset.c
index cc43866c13bc..3de9b8728329 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -846,9 +846,6 @@ nftnl_ruleset_do_snprintf(char *buf, size_t size, const struct nftnl_ruleset *rs
 	void *prev = NULL;
 	uint32_t inner_flags = flags;
 
-	if (size)
-		buf[0] = '\0';
-
 	/* dont pass events flags to child calls of _snprintf() */
 	inner_flags &= ~NFTNL_OF_EVENT_ANY;
 
@@ -922,9 +919,6 @@ static int nftnl_ruleset_cmd_snprintf(char *buf, size_t size,
 				    const struct nftnl_ruleset *r, uint32_t cmd,
 				    uint32_t type, uint32_t flags)
 {
-	if (size)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 	case NFTNL_OUTPUT_JSON:
diff --git a/src/set.c b/src/set.c
index 36e59c38536c..592ea246b05e 100644
--- a/src/set.c
+++ b/src/set.c
@@ -895,9 +895,6 @@ static int nftnl_set_cmd_snprintf(char *buf, size_t size,
 	if (type == NFTNL_OUTPUT_XML)
 		return 0;
 
-	if (size)
-		buf[0] = '\0';
-
 	/* prevent set_elems to print as events */
 	inner_flags &= ~NFTNL_OF_EVENT_ANY;
 
diff --git a/src/set_elem.c b/src/set_elem.c
index a99876a90cac..e45dbc6bfe3e 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -696,8 +696,6 @@ static int nftnl_set_elem_cmd_snprintf(char *buf, size_t size,
 
 	if (type == NFTNL_OUTPUT_XML)
 		return 0;
-	if (size)
-		buf[0] = '\0';
 
 	ret = nftnl_cmd_header_snprintf(buf + offset, remain, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
diff --git a/src/table.c b/src/table.c
index db870cd98437..cf61ddaad3a6 100644
--- a/src/table.c
+++ b/src/table.c
@@ -378,9 +378,6 @@ static int nftnl_table_cmd_snprintf(char *buf, size_t size,
 {
 	int ret, remain = size, offset = 0;
 
-	if (size)
-		buf[0] = '\0';
-
 	ret = nftnl_cmd_header_snprintf(buf + offset, remain, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-- 
2.1.4

