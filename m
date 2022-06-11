Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D04A7C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jun 2022 10:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiFKKH4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Jun 2022 06:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiFKKH4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Jun 2022 06:07:56 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0C7C08
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jun 2022 03:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fBM9JNPyYNTfif3jYrsKEZF+KJBwn27fzoqJ/hvvz4A=; b=oIZaTblodHqY0R8AvkhKns7lA6
        kg4C204/jaa7AE4VQWCPSKr446COELPR2qmkC4m8pCrkobIhljWCDfqskuVec5ecY41munWJmvq87
        5AJLQxfT2ypKzPfSxm4rzIWEpoUM0nUdml6L7T05P34TE19ZbfS+Xy0mRCkIpMrp8li+XUnUCxEJU
        SMY14YykkscZ7+muC+Jhulg7JXl31WoxKn6UntgOh1+d1kgbN3leBUiTXPVsgD+u8qGJyCDnweS9J
        5pGM/bs/Sd9eXcWj2BGJHNn0xYK3duIS6fPJbo23u4JK4X2RWzj+mK9qS7WV6F1Uly+Dw12yC/rPC
        hlWvFOjw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nzy23-00061e-46; Sat, 11 Jun 2022 12:07:51 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] libxtables: Move struct xtables_afinfo into xtables.h
Date:   Sat, 11 Jun 2022 12:07:41 +0200
Message-Id: <20220611100742.4888-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220611100742.4888-1-phil@nwl.cc>
References: <20220611100742.4888-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The library "owns" this structure and maintains 'afinfo' pointer to
instances of it. With libxt_set, there's even an extension making use of
the data.

To avoid impact on library users, guard it by XTABLES_INTERNAL.

To eliminate the xshared.h include by libxt_set, DEBUGP has to be
redefined. Other extensions have similar defines, fix this later.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_set.c |  6 ++++++
 extensions/libxt_set.h |  1 -
 include/xtables.h      | 22 ++++++++++++++++++++++
 iptables/xshared.h     | 22 ----------------------
 4 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/extensions/libxt_set.c b/extensions/libxt_set.c
index 16921023a22f8..a2137ab1eb180 100644
--- a/extensions/libxt_set.c
+++ b/extensions/libxt_set.c
@@ -22,6 +22,12 @@
 #include <linux/netfilter/xt_set.h>
 #include "libxt_set.h"
 
+#ifdef DEBUG
+#define DEBUGP(x, args...) fprintf(stderr, x, ## args)
+#else
+#define DEBUGP(x, args...)
+#endif
+
 /* Revision 0 */
 
 static void
diff --git a/extensions/libxt_set.h b/extensions/libxt_set.h
index ad895a7504d9d..597bf7ebe575a 100644
--- a/extensions/libxt_set.h
+++ b/extensions/libxt_set.h
@@ -6,7 +6,6 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <errno.h>
-#include "../iptables/xshared.h"
 
 static int
 get_version(unsigned *version)
diff --git a/include/xtables.h b/include/xtables.h
index f1937f3ea0530..b8d8372d0e498 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -665,6 +665,28 @@ void xtables_announce_chain(const char *name);
 
 extern void _init(void);
 
+/**
+ * xtables_afinfo - protocol family dependent information
+ * @kmod:		kernel module basename (e.g. "ip_tables")
+ * @proc_exists:	file which exists in procfs when module already loaded
+ * @libprefix:		prefix of .so library name (e.g. "libipt_")
+ * @family:		nfproto family
+ * @ipproto:		used by setsockopt (e.g. IPPROTO_IP)
+ * @so_rev_match:	optname to check revision support of match
+ * @so_rev_target:	optname to check revision support of target
+ */
+struct xtables_afinfo {
+	const char *kmod;
+	const char *proc_exists;
+	const char *libprefix;
+	uint8_t family;
+	uint8_t ipproto;
+	int so_rev_match;
+	int so_rev_target;
+};
+
+extern const struct xtables_afinfo *afinfo;
+
 #endif /* XTABLES_INTERNAL */
 
 #ifdef __cplusplus
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 1d6b9bf4ee9b7..1fdc760a32442 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -75,26 +75,6 @@ struct xtables_target;
 #define IPT_INV_ARPOP		0x0400
 #define IPT_INV_ARPHRD		0x0800
 
-/**
- * xtables_afinfo - protocol family dependent information
- * @kmod:		kernel module basename (e.g. "ip_tables")
- * @proc_exists:	file which exists in procfs when module already loaded
- * @libprefix:		prefix of .so library name (e.g. "libipt_")
- * @family:		nfproto family
- * @ipproto:		used by setsockopt (e.g. IPPROTO_IP)
- * @so_rev_match:	optname to check revision support of match
- * @so_rev_target:	optname to check revision support of target
- */
-struct xtables_afinfo {
-	const char *kmod;
-	const char *proc_exists;
-	const char *libprefix;
-	uint8_t family;
-	uint8_t ipproto;
-	int so_rev_match;
-	int so_rev_target;
-};
-
 /* trick for ebtables-compat, since watchers are targets */
 struct ebt_match {
 	struct ebt_match			*next;
@@ -187,8 +167,6 @@ int parse_counters(const char *string, struct xt_counters *ctr);
 bool tokenize_rule_counters(char **bufferp, char **pcnt, char **bcnt, int line);
 bool xs_has_arg(int argc, char *argv[]);
 
-extern const struct xtables_afinfo *afinfo;
-
 #define MAX_ARGC	255
 struct argv_store {
 	int argc;
-- 
2.34.1

