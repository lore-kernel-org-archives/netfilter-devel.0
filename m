Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234FAC71145
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Aug 2023 11:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238188AbjHXLQd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 07:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241020AbjHXLQT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 07:16:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B06219B4
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 04:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692875714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ex/X/wr3Cyri7u2GEZa+bXLFghuX+YKoSmZUzo8QaJY=;
        b=fq5yuDWZBaQ1WrCUwHVqYeG6KpQ6CuZwrqLW7MaB358lPQI4Pm3VEV4eBGu+oG+JjeNIr+
        djnB4B5LEcRGdLMO/ylb+iy6938xNnVAabWhGrhIDhod3SkvnKMtDx9stlvPLr64BdNgRl
        BktYprlkZ1fa7bOqApi5fJXnEIrekKI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-Bs9aK69MNiqCMt9i5p1jHQ-1; Thu, 24 Aug 2023 07:15:13 -0400
X-MC-Unique: Bs9aK69MNiqCMt9i5p1jHQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D68BC800193
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 11:15:12 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5606EC1602B;
        Thu, 24 Aug 2023 11:15:12 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 5/6] include: include <std{bool,int}.h> via nftdefault.h
Date:   Thu, 24 Aug 2023 13:13:33 +0200
Message-ID: <20230824111456.2005125-6-thaller@redhat.com>
In-Reply-To: <20230824111456.2005125-1-thaller@redhat.com>
References: <20230824111456.2005125-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There is a minimum base that all our sources will end up needing. That
is what <nftdefault.h> provides.

Add <stdbool.h> and <stdint.h> there. It's unlikely that we want to
implement anything, without having "bool" and "uint32_t" types
available.

Yes, this means the internal headers are not self-contained, with
respect to what "nftdefault.h" provides. This is the exception to the
rule, where headers on having "nftdefault.h" included for them.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/datatype.h        | 1 -
 include/dccpopt.h         | 1 -
 include/expression.h      | 1 -
 include/nftables.h        | 1 -
 include/nftdefault.h      | 3 +++
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
diff --git a/include/nftdefault.h b/include/nftdefault.h
index 0912cd188850..747ef32d6b4b 100644
--- a/include/nftdefault.h
+++ b/include/nftdefault.h
@@ -4,4 +4,7 @@
 
 #include <config.h>
 
+#include <stdbool.h>
+#include <stdint.h>
+
 #endif /* NFTABLES_NFTDEFAULT_H */
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
index e1981ef0f780..74c903185dcb 100644
--- a/src/dccpopt.c
+++ b/src/dccpopt.c
@@ -1,7 +1,6 @@
 #include <nftdefault.h>
 
 #include <stddef.h>
-#include <stdint.h>
 
 #include <datatype.h>
 #include <dccpopt.h>
diff --git a/src/evaluate.c b/src/evaluate.c
index a2e194f06379..e06c1a0e7d46 100644
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
index 271a5ac231f7..e786abc7b64e 100644
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
index 14616c43c653..e42716cd1b78 100644
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
index 79c9c3bb9551..bc1c547d9790 100644
--- a/src/ipopt.c
+++ b/src/ipopt.c
@@ -1,6 +1,5 @@
 #include <nftdefault.h>
 
-#include <stdint.h>
 
 #include <netinet/in.h>
 #include <netinet/ip.h>
diff --git a/src/mergesort.c b/src/mergesort.c
index 9b4636ff8916..7159270f200b 100644
--- a/src/mergesort.c
+++ b/src/mergesort.c
@@ -8,7 +8,6 @@
 
 #include <nftdefault.h>
 
-#include <stdint.h>
 #include <expression.h>
 #include <gmputil.h>
 #include <list.h>
diff --git a/src/meta.c b/src/meta.c
index 1ded655c6fca..f9327edf6f90 100644
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
index 67c2d0a2718d..fd358396a940 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -12,7 +12,6 @@
 #include <nftdefault.h>
 
 #include <stdlib.h>
-#include <stdbool.h>
 #include <string.h>
 #include <limits.h>
 #include <linux/netfilter/nf_tables.h>
diff --git a/src/nftutils.c b/src/nftutils.c
index b16bf5232c17..aae57a2afe8e 100644
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
index 3b7c0a5ddd75..c7c5b77ecfb5 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -9,7 +9,6 @@
 #include <nftdefault.h>
 
 #include <errno.h>
-#include <stdint.h> /* needed by gmputil.h */
 #include <string.h>
 #include <syslog.h>
 
diff --git a/src/payload.c b/src/payload.c
index bb44f1f3bb3d..f67445d2a151 100644
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
index c548a1d11614..600107517a07 100644
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
index 8bee1f6128f9..60bd0c5e74f3 100644
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
index 7951e9e9db7a..0caca0774bdb 100644
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
index 72d0689aae4e..82073dde6854 100644
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
index 2677b9d8db4c..b990ad044524 100644
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

