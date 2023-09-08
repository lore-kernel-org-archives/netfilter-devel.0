Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02120EEB564
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Sep 2023 17:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbjIHRdd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Sep 2023 13:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbjIHRdc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2023 13:33:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD431FC7
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2023 10:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694194360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a/DTIRXKjH/nK3ab6F0RzxkAIApHlJmGE54eBGmazX8=;
        b=R3WK8bN33Mdmgg/Gl4g7ZWD6fOERJS+Elem0dlnanrmp9FArT7MrXHaKLcK5X3RUzxPyPg
        Y0Jm+KxsJnoOGF7tR9SwHXv5Zv5UATB6aKlwVbgeXKfUIR/2brNkmSk+JZWovjMgSTfXMQ
        hzSzbkFr5W+2Im9ZinVHVpfeVXYguTw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-OgEfQK1yPrKDvs2wnolmPQ-1; Fri, 08 Sep 2023 13:32:39 -0400
X-MC-Unique: OgEfQK1yPrKDvs2wnolmPQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D06963C01BB3
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Sep 2023 17:32:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B49440C6CCC;
        Fri,  8 Sep 2023 17:32:38 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/2] include: include <stdlib.h> in <nft.h>
Date:   Fri,  8 Sep 2023 19:32:20 +0200
Message-ID: <20230908173226.1182353-2-thaller@redhat.com>
In-Reply-To: <20230908173226.1182353-1-thaller@redhat.com>
References: <20230908173226.1182353-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It provides malloc()/free(), which is so basic that we need it
everywhere. Include via <nft.h>.

The ultimate purpose is to define more things in <nft.h>. While it has
not corresponding C sources, <nft.h> can contain macros and static
inline functions, and is a good place for things that we shall have
everywhere. Since <stdlib.h> provides malloc()/free() and size_t, that
is a very basic dependency, that will be needed for that.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/nft.h             | 1 +
 include/utils.h           | 1 -
 src/cli.c                 | 1 -
 src/cmd.c                 | 1 -
 src/ct.c                  | 1 -
 src/datatype.c            | 1 -
 src/erec.c                | 1 -
 src/evaluate.c            | 1 -
 src/expression.c          | 1 -
 src/exthdr.c              | 1 -
 src/gmputil.c             | 1 -
 src/iface.c               | 1 -
 src/libnftables.c         | 1 -
 src/main.c                | 1 -
 src/meta.c                | 1 -
 src/mini-gmp.c            | 1 -
 src/misspell.c            | 1 -
 src/mnl.c                 | 1 -
 src/monitor.c             | 1 -
 src/netlink.c             | 1 -
 src/netlink_delinearize.c | 1 -
 src/nfnl_osf.c            | 1 -
 src/owner.c               | 1 -
 src/payload.c             | 1 -
 src/proto.c               | 1 -
 src/rt.c                  | 1 -
 src/rule.c                | 1 -
 src/segtree.c             | 1 -
 src/statement.c           | 1 -
 src/tcpopt.c              | 1 -
 src/utils.c               | 1 -
 src/xt.c                  | 1 -
 32 files changed, 1 insertion(+), 31 deletions(-)

diff --git a/include/nft.h b/include/nft.h
index 967eb7bcea09..9384054c11c8 100644
--- a/include/nft.h
+++ b/include/nft.h
@@ -6,5 +6,6 @@
 
 #include <stdbool.h>
 #include <stdint.h>
+#include <stdlib.h>
 
 #endif /* NFTABLES_NFT_H */
diff --git a/include/utils.h b/include/utils.h
index 5b8b181c1e99..36a28f893667 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -3,7 +3,6 @@
 
 #include <asm/byteorder.h>
 #include <stdarg.h>
-#include <stdlib.h>
 #include <stdio.h>
 #include <unistd.h>
 #include <assert.h>
diff --git a/src/cli.c b/src/cli.c
index bfae90e67554..e6971c109cb1 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -14,7 +14,6 @@
 
 #include <nft.h>
 
-#include <stdlib.h>
 #include <stdio.h>
 #include <stdarg.h>
 #include <unistd.h>
diff --git a/src/cmd.c b/src/cmd.c
index 98859674d24b..5e90fdcbd99a 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -15,7 +15,6 @@
 #include <utils.h>
 #include <iface.h>
 #include <errno.h>
-#include <stdlib.h>
 #include <cache.h>
 #include <string.h>
 
diff --git a/src/ct.c b/src/ct.c
index ca35087ad7b7..6760b08570de 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -13,7 +13,6 @@
 #include <nft.h>
 
 #include <stddef.h>
-#include <stdlib.h>
 #include <stdio.h>
 #include <inttypes.h>
 #include <string.h>
diff --git a/src/datatype.c b/src/datatype.c
index ba1192c83595..eff9fa53e354 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -10,7 +10,6 @@
 
 #include <nft.h>
 
-#include <stdlib.h>
 #include <string.h>
 #include <inttypes.h>
 #include <ctype.h> /* isdigit */
diff --git a/src/erec.c b/src/erec.c
index d26dee602e8a..8cadaa8069d1 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -13,7 +13,6 @@
 #include <stdio.h>
 #include <string.h>
 #include <stdarg.h>
-#include <stdlib.h>
 
 #include <netlink.h>
 #include <gmputil.h>
diff --git a/src/evaluate.c b/src/evaluate.c
index 7e0c8260e72e..8d53994a8f18 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -11,7 +11,6 @@
 #include <nft.h>
 
 #include <stddef.h>
-#include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
 #include <arpa/inet.h>
diff --git a/src/expression.c b/src/expression.c
index 147320f08937..cb222a2b08b9 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -11,7 +11,6 @@
 #include <nft.h>
 
 #include <stddef.h>
-#include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
 #include <limits.h>
diff --git a/src/exthdr.c b/src/exthdr.c
index 8aba7da1fa69..545370bd57a6 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -13,7 +13,6 @@
 #include <nft.h>
 
 #include <stddef.h>
-#include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
 #include <netinet/in.h>
diff --git a/src/gmputil.c b/src/gmputil.c
index 9cda18534d0a..7f65630db59c 100644
--- a/src/gmputil.c
+++ b/src/gmputil.c
@@ -11,7 +11,6 @@
 #include <nft.h>
 
 #include <stddef.h>
-#include <stdlib.h>
 #include <stdarg.h>
 #include <stdio.h>
 #include <unistd.h>
diff --git a/src/iface.c b/src/iface.c
index ec7f5c7f4cd9..e61ea2db1f4c 100644
--- a/src/iface.c
+++ b/src/iface.c
@@ -9,7 +9,6 @@
 #include <nft.h>
 
 #include <stdio.h>
-#include <stdlib.h>
 #include <net/if.h>
 #include <time.h>
 #include <string.h>
diff --git a/src/libnftables.c b/src/libnftables.c
index 9c802ec95f27..c5f5729409d1 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -16,7 +16,6 @@
 #include <iface.h>
 #include <cmd.h>
 #include <errno.h>
-#include <stdlib.h>
 #include <string.h>
 
 static int nft_netlink(struct nft_ctx *nft,
diff --git a/src/main.c b/src/main.c
index 260338d320ab..d796189435d8 100644
--- a/src/main.c
+++ b/src/main.c
@@ -10,7 +10,6 @@
 
 #include <nft.h>
 
-#include <stdlib.h>
 #include <stddef.h>
 #include <unistd.h>
 #include <stdio.h>
diff --git a/src/meta.c b/src/meta.c
index ea00f2396b99..d8fc5f585e74 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -15,7 +15,6 @@
 #include <errno.h>
 #include <limits.h>
 #include <stddef.h>
-#include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
 #include <net/if.h>
diff --git a/src/mini-gmp.c b/src/mini-gmp.c
index 6217f7454651..5d54df08eaa8 100644
--- a/src/mini-gmp.c
+++ b/src/mini-gmp.c
@@ -47,7 +47,6 @@ see https://www.gnu.org/licenses/.  */
 #include <ctype.h>
 #include <limits.h>
 #include <stdio.h>
-#include <stdlib.h>
 #include <string.h>
 
 #include "mini-gmp.h"
diff --git a/src/misspell.c b/src/misspell.c
index 18da4386ea5b..b48ab9cd3342 100644
--- a/src/misspell.c
+++ b/src/misspell.c
@@ -8,7 +8,6 @@
 
 #include <nft.h>
 
-#include <stdlib.h>
 #include <string.h>
 #include <limits.h>
 #include <utils.h>
diff --git a/src/mnl.c b/src/mnl.c
index d583177d5490..67bb44a6eb0d 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -35,7 +35,6 @@
 #include <arpa/inet.h>
 #include <fcntl.h>
 #include <errno.h>
-#include <stdlib.h>
 #include <utils.h>
 #include <nftables.h>
 #include <linux/netfilter.h>
diff --git a/src/monitor.c b/src/monitor.c
index 0554089b74ac..e6f4e15faec8 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -14,7 +14,6 @@
 #include <libmnl/libmnl.h>
 #include <netinet/in.h>
 #include <arpa/inet.h>
-#include <stdlib.h>
 #include <inttypes.h>
 
 #include <libnftnl/table.h>
diff --git a/src/netlink.c b/src/netlink.c
index af6fd427bd57..59cde9a48313 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -16,7 +16,6 @@
 #include <libmnl/libmnl.h>
 #include <netinet/in.h>
 #include <arpa/inet.h>
-#include <stdlib.h>
 #include <inttypes.h>
 
 #include <libnftnl/table.h>
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index bde783bdf4ad..19c3f0bd0b26 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -11,7 +11,6 @@
 
 #include <nft.h>
 
-#include <stdlib.h>
 #include <string.h>
 #include <limits.h>
 #include <linux/netfilter/nf_tables.h>
diff --git a/src/nfnl_osf.c b/src/nfnl_osf.c
index 48e83ea8a549..38a27a3683e2 100644
--- a/src/nfnl_osf.c
+++ b/src/nfnl_osf.c
@@ -25,7 +25,6 @@
 
 #include <ctype.h>
 #include <errno.h>
-#include <stdlib.h>
 #include <string.h>
 #include <time.h>
 
diff --git a/src/owner.c b/src/owner.c
index be1756a68c75..65eaad3e46d3 100644
--- a/src/owner.c
+++ b/src/owner.c
@@ -10,7 +10,6 @@
 
 #include <stdio.h>
 #include <unistd.h>
-#include <stdlib.h>
 #include <sys/time.h>
 #include <time.h>
 #include <inttypes.h>
diff --git a/src/payload.c b/src/payload.c
index 0afffb2338ef..c8faea99eb07 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -13,7 +13,6 @@
 #include <nft.h>
 
 #include <stddef.h>
-#include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
 #include <net/if_arp.h>
diff --git a/src/proto.c b/src/proto.c
index d3bcb0c4bd0b..b5cb0106dd7b 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -12,7 +12,6 @@
 #include <nft.h>
 
 #include <stddef.h>
-#include <stdlib.h>
 #include <string.h>
 #include <net/if_arp.h>
 #include <arpa/inet.h>
diff --git a/src/rt.c b/src/rt.c
index c8d75b369f8b..9ddcb210eaad 100644
--- a/src/rt.c
+++ b/src/rt.c
@@ -12,7 +12,6 @@
 
 #include <errno.h>
 #include <stddef.h>
-#include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
 #include <arpa/inet.h>
diff --git a/src/rule.c b/src/rule.c
index bce728ab9b46..1e9e6c1a92c2 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -11,7 +11,6 @@
 #include <nft.h>
 
 #include <stddef.h>
-#include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
 #include <inttypes.h>
diff --git a/src/segtree.c b/src/segtree.c
index bf207402c945..0a12a0cd5151 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -10,7 +10,6 @@
 
 #include <nft.h>
 
-#include <stdlib.h>
 #include <string.h>
 #include <inttypes.h>
 #include <arpa/inet.h>
diff --git a/src/statement.c b/src/statement.c
index 7b8e68f19117..721739498e2e 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -11,7 +11,6 @@
 #include <nft.h>
 
 #include <stddef.h>
-#include <stdlib.h>
 #include <stdio.h>
 #include <inttypes.h>
 #include <string.h>
diff --git a/src/tcpopt.c b/src/tcpopt.c
index 7b95a0113403..8a52d8722091 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -1,7 +1,6 @@
 #include <nft.h>
 
 #include <stddef.h>
-#include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
 #include <netinet/in.h>
diff --git a/src/utils.c b/src/utils.c
index d2841f3469b5..caedebda183b 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -11,7 +11,6 @@
 #include <nft.h>
 
 #include <stddef.h>
-#include <stdlib.h>
 #include <stdarg.h>
 #include <stdio.h>
 #include <unistd.h>
diff --git a/src/xt.c b/src/xt.c
index a217cc7b6bd0..d774e07395a6 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -9,7 +9,6 @@
 
 #include <nft.h>
 
-#include <stdlib.h>
 #include <time.h>
 #include <string.h>
 #include <net/if.h>
-- 
2.41.0

