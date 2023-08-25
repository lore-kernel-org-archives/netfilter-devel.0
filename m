Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99D8AEE49A3
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Aug 2023 11:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbjHYLjx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Aug 2023 07:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjHYLjL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2023 07:39:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698EF2105
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 04:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692963507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kmRucEK7jgKiBFSSvDZLpuqNbO9bet9SWQV8W6ZNt1w=;
        b=OjP9MrAk7dck4+BxMhCUCP709hRk9+rQyJyovWr4MpOG1GYkJ+aiVZAwF8R0o4Nh3dE41z
        +UCmPEER6rW/HQCyXUGiYPp13K7Z7nnbe5ULE5ndDcKEs5ixBe0F2poZwM/Rke9nE46H9Q
        9e32GA6DXNSA52QcTbUqeOPbe0S5bis=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633--5VOujU2M-21gXz3GRA06g-1; Fri, 25 Aug 2023 07:38:26 -0400
X-MC-Unique: -5VOujU2M-21gXz3GRA06g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4BD8101A528
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 11:38:25 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 432001121319;
        Fri, 25 Aug 2023 11:38:25 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 5/6] include: include <std{bool,int}.h> via <nft.h>
Date:   Fri, 25 Aug 2023 13:36:33 +0200
Message-ID: <20230825113810.2620133-6-thaller@redhat.com>
In-Reply-To: <20230825113810.2620133-1-thaller@redhat.com>
References: <20230825113810.2620133-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There is a minimum base that all our sources will end up needing. This
is what <nft.h> provides.

Add <stdbool.h> and <stdint.h> there. It's unlikely that we want to
implement anything, without having "bool" and "uint32_t" types
available.

Yes, this means the internal headers are not self-contained, with
respect to what <nft.h> provides. This is the exception to the rule, and
our internal headers should rely to have <nft.h> included for them.
They should not include <nft.h> themselves, because <nft.h> needs always
be included as first. So when an internal header would include <nft.h>
it would be unnecessary, because the header is *always* included
already.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/datatype.h        | 1 -
 include/dccpopt.h         | 1 -
 include/expression.h      | 1 -
 include/nft.h             | 3 +++
 include/nftables.h        | 1 -
 include/rule.h            | 1 -
 include/utils.h           | 2 --
 src/dccpopt.c             | 1 -
 src/evaluate.c            | 1 -
 src/expression.c          | 1 -
 src/exthdr.c              | 1 -
 src/ipopt.c               | 1 -
 src/mergesort.c           | 1 -
 src/meta.c                | 1 -
 src/netlink_delinearize.c | 1 -
 src/nftutils.c            | 1 -
 src/nftutils.h            | 1 -
 src/parser_json.c         | 1 -
 src/payload.c             | 1 -
 src/proto.c               | 1 -
 src/rt.c                  | 1 -
 src/rule.c                | 1 -
 src/statement.c           | 1 -
 src/tcpopt.c              | 1 -
 24 files changed, 3 insertions(+), 24 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index be5c6d1b4011..9ce7359cd340 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -1,7 +1,6 @@
 #ifndef NFTABLES_DATATYPE_H
 #define NFTABLES_DATATYPE_H
 
-#include <stdbool.h>
 #include <json.h>
 
 /**
diff --git a/include/dccpopt.h b/include/dccpopt.h
index 9686932d74b7..3617fc1ae766 100644
--- a/include/dccpopt.h
+++ b/include/dccpopt.h
@@ -2,7 +2,6 @@
 #define NFTABLES_DCCPOPT_H
 
 #include <nftables.h>
-#include <stdint.h>
 
 #define DCCPOPT_TYPE_MIN 0
 #define DCCPOPT_TYPE_MAX UINT8_MAX
diff --git a/include/expression.h b/include/expression.h
index 1f58a68c329f..733dd3cfc89c 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -1,7 +1,6 @@
 #ifndef NFTABLES_EXPRESSION_H
 #define NFTABLES_EXPRESSION_H
 
-#include <stdbool.h>
 #include <gmputil.h>
 #include <linux/netfilter/nf_tables.h>
 
diff --git a/include/nft.h b/include/nft.h
index 0fd481c6ef04..967eb7bcea09 100644
--- a/include/nft.h
+++ b/include/nft.h
@@ -4,4 +4,7 @@
 
 #include <config.h>
 
+#include <stdbool.h>
+#include <stdint.h>
+
 #endif /* NFTABLES_NFT_H */
diff --git a/include/nftables.h b/include/nftables.h
index f073fa95a60d..219a10100206 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -1,7 +1,6 @@
 #ifndef NFTABLES_NFTABLES_H
 #define NFTABLES_NFTABLES_H
 
-#include <stdbool.h>
 #include <stdarg.h>
 #include <limits.h>
 #include <utils.h>
diff --git a/include/rule.h b/include/rule.h
index 13ab1bf3df5a..8e876d0a42ed 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -1,7 +1,6 @@
 #ifndef NFTABLES_RULE_H
 #define NFTABLES_RULE_H
 
-#include <stdint.h>
 #include <nftables.h>
 #include <list.h>
 #include <netinet/in.h>
diff --git a/include/utils.h b/include/utils.h
index 6764f9219ada..cee1e5c1e8ae 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -2,8 +2,6 @@
 #define NFTABLES_UTILS_H
 
 #include <asm/byteorder.h>
-#include <stdint.h>
-#include <stdbool.h>
 #include <stdarg.h>
 #include <stdio.h>
 #include <unistd.h>
diff --git a/src/dccpopt.c b/src/dccpopt.c
index d713d9034c92..ebb645a98c5a 100644
--- a/src/dccpopt.c
+++ b/src/dccpopt.c
@@ -1,7 +1,6 @@
 #include <nft.h>
 
 #include <stddef.h>
-#include <stdint.h>
 
 #include <datatype.h>
 #include <dccpopt.h>
diff --git a/src/evaluate.c b/src/evaluate.c
index 69a123511be8..1ae2ef0de10c 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -13,7 +13,6 @@
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
-#include <stdint.h>
 #include <string.h>
 #include <arpa/inet.h>
 #include <linux/netfilter.h>
diff --git a/src/expression.c b/src/expression.c
index 8ef008910da5..147320f08937 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -13,7 +13,6 @@
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
-#include <stdint.h>
 #include <string.h>
 #include <limits.h>
 
diff --git a/src/exthdr.c b/src/exthdr.c
index dd8c75815314..8aba7da1fa69 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -15,7 +15,6 @@
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
-#include <stdint.h>
 #include <string.h>
 #include <netinet/in.h>
 #include <netinet/ip6.h>
diff --git a/src/ipopt.c b/src/ipopt.c
index 3ba67b011166..37f779d468ab 100644
--- a/src/ipopt.c
+++ b/src/ipopt.c
@@ -1,6 +1,5 @@
 #include <nft.h>
 
-#include <stdint.h>
 
 #include <netinet/in.h>
 #include <netinet/ip.h>
diff --git a/src/mergesort.c b/src/mergesort.c
index 9315093b3359..5965236af6b7 100644
--- a/src/mergesort.c
+++ b/src/mergesort.c
@@ -8,7 +8,6 @@
 
 #include <nft.h>
 
-#include <stdint.h>
 #include <expression.h>
 #include <gmputil.h>
 #include <list.h>
diff --git a/src/meta.c b/src/meta.c
index fcb872e669df..4f383269d032 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -17,7 +17,6 @@
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
-#include <stdint.h>
 #include <string.h>
 #include <net/if.h>
 #include <net/if_arp.h>
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index dfa816cfdfb6..1121f730ffa7 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -12,7 +12,6 @@
 #include <nft.h>
 
 #include <stdlib.h>
-#include <stdbool.h>
 #include <string.h>
 #include <limits.h>
 #include <linux/netfilter/nf_tables.h>
diff --git a/src/nftutils.c b/src/nftutils.c
index 14cb1fcf07de..9c7fe5edc022 100644
--- a/src/nftutils.c
+++ b/src/nftutils.c
@@ -6,7 +6,6 @@
 
 #include <netdb.h>
 #include <string.h>
-#include <stdint.h>
 
 /* Buffer size used for getprotobynumber_r() and similar. The manual comments
  * that a buffer of 1024 should be sufficient "for most applications"(??), so
diff --git a/src/nftutils.h b/src/nftutils.h
index cb584b9ca32b..7db56f428980 100644
--- a/src/nftutils.h
+++ b/src/nftutils.h
@@ -2,7 +2,6 @@
 #ifndef NFTUTILS_H
 #define NFTUTILS_H
 
-#include <stdbool.h>
 #include <stddef.h>
 
 /* The maximum buffer size for (struct protoent).p_name. It is excessively large,
diff --git a/src/parser_json.c b/src/parser_json.c
index 323d15bb5b71..4ea5b4326a90 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -9,7 +9,6 @@
 #include <nft.h>
 
 #include <errno.h>
-#include <stdint.h> /* needed by gmputil.h */
 #include <string.h>
 #include <syslog.h>
 
diff --git a/src/payload.c b/src/payload.c
index 9fdbf4997c4e..0afffb2338ef 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -15,7 +15,6 @@
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
-#include <stdint.h>
 #include <string.h>
 #include <net/if_arp.h>
 #include <arpa/inet.h>
diff --git a/src/proto.c b/src/proto.c
index eb9c3ea18e68..4650e58cd6ed 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -13,7 +13,6 @@
 
 #include <stddef.h>
 #include <stdlib.h>
-#include <stdint.h>
 #include <string.h>
 #include <net/if_arp.h>
 #include <arpa/inet.h>
diff --git a/src/rt.c b/src/rt.c
index 33820d4c8719..c8d75b369f8b 100644
--- a/src/rt.c
+++ b/src/rt.c
@@ -14,7 +14,6 @@
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
-#include <stdint.h>
 #include <string.h>
 #include <arpa/inet.h>
 #include <linux/netfilter.h>
diff --git a/src/rule.c b/src/rule.c
index f2c4768e01ab..8ea606e146b2 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -13,7 +13,6 @@
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
-#include <stdint.h>
 #include <string.h>
 #include <inttypes.h>
 #include <errno.h>
diff --git a/src/statement.c b/src/statement.c
index e6ea43d0a4d1..7b8e68f19117 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -13,7 +13,6 @@
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
-#include <stdint.h>
 #include <inttypes.h>
 #include <string.h>
 #include <syslog.h>
diff --git a/src/tcpopt.c b/src/tcpopt.c
index 5dd760a51aab..7b95a0113403 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -3,7 +3,6 @@
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
-#include <stdint.h>
 #include <string.h>
 #include <netinet/in.h>
 #include <netinet/ip6.h>
-- 
2.41.0

