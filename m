Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96DBBE82CCC
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 19:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjI0Twh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 15:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjI0Twh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 15:52:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0794110A
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 12:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695844310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vvatQTvyYavr7rXjeAyrCoJ0kLIYhag/iBRrxCjYX9o=;
        b=cZvLB4M2eJaj8PQEKe35zBBZB1O5uBPk86Ux6eJAZ7fNwHsX7/+fo9NHFzh+CHeIEb2wX+
        QzFNQJujzbcZdIb2XRZhtRkaex3pBalUUXg8l6fIEdSS9A/RzxQnf5Fm2zExNE5etVb36c
        llnM5byI0bikKv4hlar9fd7hNzmd2gg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-XzU5gaD6MeqMRdi12zYsFg-1; Wed, 27 Sep 2023 15:51:47 -0400
X-MC-Unique: XzU5gaD6MeqMRdi12zYsFg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E6F6101A58B
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 19:51:47 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 835E414171B6;
        Wed, 27 Sep 2023 19:51:46 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/1] include: include <string.h> in <nft.h>
Date:   Wed, 27 Sep 2023 21:51:15 +0200
Message-ID: <20230927195133.3677265-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

<string.h> provides strcmp(), as such it's very basic and used
everywhere.

Include it via <nft.h>.

The benefit of this will be to add  a static-inline function
nft_strcmp0() to <nft.h>, which calls strcmp() but handles that strings
might be NULL. Such a basic utility will be useful, and <nft.h> is the
right place. So we will need <string.h> there. Regardless of that, not
including the same header basically everywhere, is already a benefit.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/cache.h           | 2 --
 include/nft.h             | 1 +
 include/rule.h            | 1 -
 src/cli.c                 | 1 -
 src/cmd.c                 | 1 -
 src/ct.c                  | 1 -
 src/datatype.c            | 1 -
 src/erec.c                | 1 -
 src/evaluate.c            | 1 -
 src/expression.c          | 1 -
 src/exthdr.c              | 1 -
 src/fib.c                 | 1 -
 src/gmputil.c             | 1 -
 src/iface.c               | 1 -
 src/json.c                | 1 -
 src/libnftables.c         | 1 -
 src/main.c                | 1 -
 src/meta.c                | 1 -
 src/mini-gmp.c            | 1 -
 src/misspell.c            | 1 -
 src/mnl.c                 | 1 -
 src/monitor.c             | 1 -
 src/netlink.c             | 1 -
 src/netlink_delinearize.c | 1 -
 src/netlink_linearize.c   | 1 -
 src/nfnl_osf.c            | 1 -
 src/nftutils.c            | 1 -
 src/optimize.c            | 1 -
 src/osf.c                 | 1 -
 src/parser_json.c         | 1 -
 src/payload.c             | 1 -
 src/proto.c               | 1 -
 src/rt.c                  | 1 -
 src/rule.c                | 1 -
 src/sctp_chunk.c          | 1 -
 src/segtree.c             | 1 -
 src/statement.c           | 1 -
 src/tcpopt.c              | 1 -
 src/utils.c               | 1 -
 src/xfrm.c                | 1 -
 src/xt.c                  | 1 -
 41 files changed, 1 insertion(+), 41 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index e66b0af5fe0f..8ca4a9a79c03 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -1,8 +1,6 @@
 #ifndef _NFT_CACHE_H_
 #define _NFT_CACHE_H_
 
-#include <string.h>
-
 #include <list.h>
 
 struct handle;
diff --git a/include/nft.h b/include/nft.h
index 9384054c11c8..3c894e5b67a7 100644
--- a/include/nft.h
+++ b/include/nft.h
@@ -7,5 +7,6 @@
 #include <stdbool.h>
 #include <stdint.h>
 #include <stdlib.h>
+#include <string.h>
 
 #endif /* NFTABLES_NFT_H */
diff --git a/include/rule.h b/include/rule.h
index 5ceb3ae62288..6236d2927c0a 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -6,7 +6,6 @@
 #include <netinet/in.h>
 #include <libnftnl/object.h>	/* For NFTNL_CTTIMEOUT_ARRAY_MAX. */
 #include <linux/netfilter/nf_tables.h>
-#include <string.h>
 #include <cache.h>
 
 /**
diff --git a/src/cli.c b/src/cli.c
index e6971c109cb1..448c25c26848 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -18,7 +18,6 @@
 #include <stdarg.h>
 #include <unistd.h>
 #include <errno.h>
-#include <string.h>
 #include <ctype.h>
 #include <limits.h>
 #ifdef HAVE_LIBREADLINE
diff --git a/src/cmd.c b/src/cmd.c
index 358dd1f9364e..68c476c69367 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -16,7 +16,6 @@
 #include <iface.h>
 #include <errno.h>
 #include <cache.h>
-#include <string.h>
 
 void cmd_add_loc(struct cmd *cmd, uint16_t offset, const struct location *loc)
 {
diff --git a/src/ct.c b/src/ct.c
index b2635543e6ec..1dda799d117e 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -15,7 +15,6 @@
 #include <stddef.h>
 #include <stdio.h>
 #include <inttypes.h>
-#include <string.h>
 
 #include <netinet/ip.h>
 #include <linux/netfilter.h>
diff --git a/src/datatype.c b/src/datatype.c
index f5d700bd8d21..6fe46e899c4b 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -10,7 +10,6 @@
 
 #include <nft.h>
 
-#include <string.h>
 #include <inttypes.h>
 #include <ctype.h> /* isdigit */
 #include <errno.h>
diff --git a/src/erec.c b/src/erec.c
index 8cadaa8069d1..cd9f62be8ba2 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -11,7 +11,6 @@
 #include <nft.h>
 
 #include <stdio.h>
-#include <string.h>
 #include <stdarg.h>
 
 #include <netlink.h>
diff --git a/src/evaluate.c b/src/evaluate.c
index c404e9a83ecc..c699a9bc7b86 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -12,7 +12,6 @@
 
 #include <stddef.h>
 #include <stdio.h>
-#include <string.h>
 #include <arpa/inet.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter_arp.h>
diff --git a/src/expression.c b/src/expression.c
index c914795041e6..a21dfec25722 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -12,7 +12,6 @@
 
 #include <stddef.h>
 #include <stdio.h>
-#include <string.h>
 #include <limits.h>
 
 #include <expression.h>
diff --git a/src/exthdr.c b/src/exthdr.c
index 545370bd57a6..60c7cd1e67f6 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -14,7 +14,6 @@
 
 #include <stddef.h>
 #include <stdio.h>
-#include <string.h>
 #include <netinet/in.h>
 #include <netinet/ip6.h>
 
diff --git a/src/fib.c b/src/fib.c
index b977fe28e803..e95271c9dcb8 100644
--- a/src/fib.c
+++ b/src/fib.c
@@ -16,7 +16,6 @@
 #include <datatype.h>
 #include <gmputil.h>
 #include <utils.h>
-#include <string.h>
 #include <fib.h>
 
 #include <linux/rtnetlink.h>
diff --git a/src/gmputil.c b/src/gmputil.c
index bf472c65de48..cb26b55810c2 100644
--- a/src/gmputil.c
+++ b/src/gmputil.c
@@ -14,7 +14,6 @@
 #include <stdarg.h>
 #include <stdio.h>
 #include <unistd.h>
-#include <string.h>
 
 #include <nftables.h>
 #include <datatype.h>
diff --git a/src/iface.c b/src/iface.c
index e61ea2db1f4c..428acaae2eac 100644
--- a/src/iface.c
+++ b/src/iface.c
@@ -11,7 +11,6 @@
 #include <stdio.h>
 #include <net/if.h>
 #include <time.h>
-#include <string.h>
 #include <errno.h>
 
 #include <libmnl/libmnl.h>
diff --git a/src/json.c b/src/json.c
index 1be58221c699..068c423addc7 100644
--- a/src/json.c
+++ b/src/json.c
@@ -9,7 +9,6 @@
 #include <nft.h>
 
 #include <stdio.h>
-#include <string.h>
 
 #include <expression.h>
 #include <list.h>
diff --git a/src/libnftables.c b/src/libnftables.c
index 1ca5a6f48c4c..4b4cf5b67ef8 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -16,7 +16,6 @@
 #include <iface.h>
 #include <cmd.h>
 #include <errno.h>
-#include <string.h>
 
 static int nft_netlink(struct nft_ctx *nft,
 		       struct list_head *cmds, struct list_head *msgs)
diff --git a/src/main.c b/src/main.c
index d796189435d8..9485b193cd34 100644
--- a/src/main.c
+++ b/src/main.c
@@ -14,7 +14,6 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <errno.h>
-#include <string.h>
 #include <getopt.h>
 #include <fcntl.h>
 #include <sys/types.h>
diff --git a/src/meta.c b/src/meta.c
index 181e111cbbdc..b578d5e24c06 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -16,7 +16,6 @@
 #include <limits.h>
 #include <stddef.h>
 #include <stdio.h>
-#include <string.h>
 #include <net/if.h>
 #include <net/if_arp.h>
 #include <pwd.h>
diff --git a/src/mini-gmp.c b/src/mini-gmp.c
index 5d54df08eaa8..186dc3a47a2c 100644
--- a/src/mini-gmp.c
+++ b/src/mini-gmp.c
@@ -47,7 +47,6 @@ see https://www.gnu.org/licenses/.  */
 #include <ctype.h>
 #include <limits.h>
 #include <stdio.h>
-#include <string.h>
 
 #include "mini-gmp.h"
 
diff --git a/src/misspell.c b/src/misspell.c
index b48ab9cd3342..c1e58a0e8a8c 100644
--- a/src/misspell.c
+++ b/src/misspell.c
@@ -8,7 +8,6 @@
 
 #include <nft.h>
 
-#include <string.h>
 #include <limits.h>
 #include <utils.h>
 #include <misspell.h>
diff --git a/src/mnl.c b/src/mnl.c
index 67bb44a6eb0d..0fb36bd588ee 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -29,7 +29,6 @@
 
 #include <mnl.h>
 #include <cmd.h>
-#include <string.h>
 #include <net/if.h>
 #include <sys/socket.h>
 #include <arpa/inet.h>
diff --git a/src/monitor.c b/src/monitor.c
index e6f4e15faec8..82762a0fe47b 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -8,7 +8,6 @@
 
 #include <nft.h>
 
-#include <string.h>
 #include <fcntl.h>
 #include <errno.h>
 #include <libmnl/libmnl.h>
diff --git a/src/netlink.c b/src/netlink.c
index 8af579c7b778..120a8ba9ceb1 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -11,7 +11,6 @@
 
 #include <nft.h>
 
-#include <string.h>
 #include <errno.h>
 #include <libmnl/libmnl.h>
 #include <netinet/in.h>
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 41cb37a3ccb3..e21451044451 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -11,7 +11,6 @@
 
 #include <nft.h>
 
-#include <string.h>
 #include <limits.h>
 #include <linux/netfilter/nf_tables.h>
 #include <arpa/inet.h>
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index c91211582b3d..0c62341112d8 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -14,7 +14,6 @@
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_log.h>
 
-#include <string.h>
 #include <rule.h>
 #include <statement.h>
 #include <expression.h>
diff --git a/src/nfnl_osf.c b/src/nfnl_osf.c
index 38a27a3683e2..20a1bfe7e745 100644
--- a/src/nfnl_osf.c
+++ b/src/nfnl_osf.c
@@ -25,7 +25,6 @@
 
 #include <ctype.h>
 #include <errno.h>
-#include <string.h>
 #include <time.h>
 
 #include <netinet/ip.h>
diff --git a/src/nftutils.c b/src/nftutils.c
index 9c7fe5edc022..ca178aa0fb94 100644
--- a/src/nftutils.c
+++ b/src/nftutils.c
@@ -5,7 +5,6 @@
 #include "nftutils.h"
 
 #include <netdb.h>
-#include <string.h>
 
 /* Buffer size used for getprotobynumber_r() and similar. The manual comments
  * that a buffer of 1024 should be sufficient "for most applications"(??), so
diff --git a/src/optimize.c b/src/optimize.c
index 9c1704831693..27e0ffe1e124 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -13,7 +13,6 @@
 
 #include <nft.h>
 
-#include <string.h>
 #include <errno.h>
 #include <inttypes.h>
 #include <nftables.h>
diff --git a/src/osf.c b/src/osf.c
index 6f5ed9bc895a..a8f80b2bbaac 100644
--- a/src/osf.c
+++ b/src/osf.c
@@ -11,7 +11,6 @@
 #include <nftables.h>
 #include <expression.h>
 #include <utils.h>
-#include <string.h>
 #include <osf.h>
 #include <json.h>
 
diff --git a/src/parser_json.c b/src/parser_json.c
index f03037af2548..199241a97cdb 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -9,7 +9,6 @@
 #include <nft.h>
 
 #include <errno.h>
-#include <string.h>
 #include <syslog.h>
 
 #include <erec.h>
diff --git a/src/payload.c b/src/payload.c
index cb8edfac0338..89bb38eb0099 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -14,7 +14,6 @@
 
 #include <stddef.h>
 #include <stdio.h>
-#include <string.h>
 #include <net/if_arp.h>
 #include <arpa/inet.h>
 #include <linux/netfilter.h>
diff --git a/src/proto.c b/src/proto.c
index 735e37f850c5..dd84f7c16380 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -12,7 +12,6 @@
 #include <nft.h>
 
 #include <stddef.h>
-#include <string.h>
 #include <net/if_arp.h>
 #include <arpa/inet.h>
 #include <linux/netfilter.h>
diff --git a/src/rt.c b/src/rt.c
index 9ddcb210eaad..f5c80559ffee 100644
--- a/src/rt.c
+++ b/src/rt.c
@@ -13,7 +13,6 @@
 #include <errno.h>
 #include <stddef.h>
 #include <stdio.h>
-#include <string.h>
 #include <arpa/inet.h>
 #include <linux/netfilter.h>
 
diff --git a/src/rule.c b/src/rule.c
index faa12afb3a07..52c0672d4cf0 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -12,7 +12,6 @@
 
 #include <stddef.h>
 #include <stdio.h>
-#include <string.h>
 #include <inttypes.h>
 #include <errno.h>
 
diff --git a/src/sctp_chunk.c b/src/sctp_chunk.c
index 1cd5e20abf78..24a07e208dcf 100644
--- a/src/sctp_chunk.c
+++ b/src/sctp_chunk.c
@@ -11,7 +11,6 @@
 #include <exthdr.h>
 #include <sctp_chunk.h>
 
-#include <string.h>
 
 #define PHT(__token, __offset, __len) \
 	PROTO_HDR_TEMPLATE(__token, &integer_type, BYTEORDER_BIG_ENDIAN, \
diff --git a/src/segtree.c b/src/segtree.c
index 0a12a0cd5151..28172b30c5b3 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -10,7 +10,6 @@
 
 #include <nft.h>
 
-#include <string.h>
 #include <inttypes.h>
 #include <arpa/inet.h>
 
diff --git a/src/statement.c b/src/statement.c
index a9fefc365650..475611664946 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -13,7 +13,6 @@
 #include <stddef.h>
 #include <stdio.h>
 #include <inttypes.h>
-#include <string.h>
 #include <syslog.h>
 #include <rule.h>
 
diff --git a/src/tcpopt.c b/src/tcpopt.c
index 8a52d8722091..3fcb2731ae73 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -2,7 +2,6 @@
 
 #include <stddef.h>
 #include <stdio.h>
-#include <string.h>
 #include <netinet/in.h>
 #include <netinet/ip6.h>
 #include <netinet/tcp.h>
diff --git a/src/utils.c b/src/utils.c
index caedebda183b..e6ad8b8b2af9 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -14,7 +14,6 @@
 #include <stdarg.h>
 #include <stdio.h>
 #include <unistd.h>
-#include <string.h>
 
 #include <nftables.h>
 #include <utils.h>
diff --git a/src/xfrm.c b/src/xfrm.c
index 041c0ce7ac6d..b32b2a1d760e 100644
--- a/src/xfrm.c
+++ b/src/xfrm.c
@@ -17,7 +17,6 @@
 #include <datatype.h>
 #include <gmputil.h>
 #include <utils.h>
-#include <string.h>
 
 #include <netinet/ip.h>
 #include <linux/netfilter.h>
diff --git a/src/xt.c b/src/xt.c
index bb87e86e02af..3cb5f028b20e 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -10,7 +10,6 @@
 #include <nft.h>
 
 #include <time.h>
-#include <string.h>
 #include <net/if.h>
 #include <getopt.h>
 #include <ctype.h>	/* for isspace */
-- 
2.41.0

