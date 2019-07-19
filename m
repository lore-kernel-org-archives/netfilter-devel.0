Return-Path: <SRS0=2jko=VQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52640C76188
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 07:31:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EEB821849
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 07:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfGSHb1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Jul 2019 03:31:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:47946 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726036AbfGSHb0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 03:31:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DE86BAE44;
        Fri, 19 Jul 2019 07:31:24 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 7E803E00A9; Fri, 19 Jul 2019 09:31:24 +0200 (CEST)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH conntrack-tools] conntrackd: cthelper: Add new SLP helper
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Message-Id: <20190719073124.7E803E00A9@unicorn.suse.cz>
Date:   Fri, 19 Jul 2019 09:31:24 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Service Location Protocol (SLP) uses multicast requests for DA (Directory
agent) and SA (Service agent) discovery. Replies to these requests are
unicast and their source address does not match destination address of the
request so that we need a conntrack helper. A kernel helper was submitted
back in 2013 but was rejected as userspace helper infrastructure is
preferred. This adds an SLP helper to conntrackd.

As the function of SLP helper is the same as what existing mDNS helper
does, src/helpers/slp.c is essentially just a copy of src/helpers/mdns.c,
except for the default timeout and example usage. As with mDNS helper,
there is no NAT support for the time being as that would probably require
kernel side changes and certainly further study (and could possibly work
only for source NAT).

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 doc/helper/conntrackd.conf |  8 ++++
 src/helpers/Makefile.am    |  5 +++
 src/helpers/slp.c          | 87 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 100 insertions(+)
 create mode 100644 src/helpers/slp.c

diff --git a/doc/helper/conntrackd.conf b/doc/helper/conntrackd.conf
index 41485449a3c1..6ffe00863c88 100644
--- a/doc/helper/conntrackd.conf
+++ b/doc/helper/conntrackd.conf
@@ -96,6 +96,14 @@ Helper {
 			ExpectTimeout 300
 		}
 	}
+	Type slp inet udp {
+		QueueNum 7
+		QueueLen 10240
+		Policy slp {
+			ExpectMax 8
+			ExpectTimeout 16
+		}
+	}
 }
 
 #
diff --git a/src/helpers/Makefile.am b/src/helpers/Makefile.am
index 51e2841a7646..58c9ad00e67b 100644
--- a/src/helpers/Makefile.am
+++ b/src/helpers/Makefile.am
@@ -8,6 +8,7 @@ pkglib_LTLIBRARIES = ct_helper_amanda.la \
 		     ct_helper_tftp.la	\
 		     ct_helper_tns.la	\
 		     ct_helper_sane.la	\
+		     ct_helper_slp.la	\
 		     ct_helper_ssdp.la
 
 HELPER_LDFLAGS = -avoid-version -module $(LIBNETFILTER_CONNTRACK_LIBS) @LAZY_LDFLAGS@
@@ -45,6 +46,10 @@ ct_helper_sane_la_SOURCES = sane.c
 ct_helper_sane_la_LDFLAGS = $(HELPER_LDFLAGS)
 ct_helper_sane_la_CFLAGS = $(HELPER_CFLAGS)
 
+ct_helper_slp_la_SOURCES = slp.c
+ct_helper_slp_la_LDFLAGS = $(HELPER_LDFLAGS)
+ct_helper_slp_la_CFLAGS = $(HELPER_CFLAGS)
+
 ct_helper_ssdp_la_SOURCES = ssdp.c
 ct_helper_ssdp_la_LDFLAGS = $(HELPER_LDFLAGS)
 ct_helper_ssdp_la_CFLAGS = $(HELPER_CFLAGS)
diff --git a/src/helpers/slp.c b/src/helpers/slp.c
new file mode 100644
index 000000000000..b8339d605dbe
--- /dev/null
+++ b/src/helpers/slp.c
@@ -0,0 +1,87 @@
+/*
+ * This helper creates and expectation to allow unicast replies to multicast
+ * requests (RFC2608 section 6.1). While the destination address of the
+ * outcoming request is known, the reply can come from any unicast address so
+ * that we need to allow replies from any source address. Default expectation]
+ * timeout is set one second longer than default CONFIG_MC_MAX from RFC2608
+ * section 13.
+ *
+ * Example usage:
+ *
+ *     nfct add helper slp inet udp
+ *     iptables -t raw -A OUTPUT -m addrtype --dst-type MULTICAST \
+ *         -p udp --dport 427 -j CT --helper slp
+ *     iptables -t raw -A OUTPUT -m addrtype --dst-type BROADCAST \
+ *         -p udp --dport 427 -j CT --helper slp
+ *     iptables -t filter -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED \
+ *         -j ACCEPT
+ *
+ * Requires Linux 3.12 or higher. NAT is unsupported.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "conntrackd.h"
+#include "helper.h"
+#include "myct.h"
+#include "log.h"
+
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+#include <linux/netfilter.h>
+
+static int slp_helper_cb(struct pkt_buff *pkt, uint32_t protoff,
+			 struct myct *myct, uint32_t ctinfo)
+{
+	struct nf_expect *exp;
+	int dir = CTINFO2DIR(ctinfo);
+	union nfct_attr_grp_addr saddr;
+	uint16_t sport, dport;
+
+	exp = nfexp_new();
+	if (!exp) {
+		pr_debug("conntrack_slp: failed to allocate expectation\n");
+		return NF_ACCEPT;
+	}
+
+	cthelper_get_addr_src(myct->ct, dir, &saddr);
+	cthelper_get_port_src(myct->ct, dir, &sport);
+	cthelper_get_port_src(myct->ct, !dir, &dport);
+
+	if (cthelper_expect_init(exp,
+				 myct->ct,
+				 0 /* class */,
+				 NULL /* saddr */,
+				 &saddr /* daddr */,
+				 IPPROTO_UDP,
+				 &dport /* sport */,
+				 &sport /* dport */,
+				 NF_CT_EXPECT_PERMANENT)) {
+		pr_debug("conntrack_slp: failed to init expectation\n");
+		nfexp_destroy(exp);
+		return NF_ACCEPT;
+	}
+
+	myct->exp = exp;
+	return NF_ACCEPT;
+}
+
+static struct ctd_helper slp_helper = {
+	.name		= "slp",
+	.l4proto	= IPPROTO_UDP,
+	.priv_data_len	= 0,
+	.cb		= slp_helper_cb,
+	.policy		= {
+		[0] = {
+			.name		= "slp",
+			.expect_max	= 8,
+			.expect_timeout	= 16, /* default CONFIG_MC_MAX + 1 */
+		},
+	},
+};
+
+static void __attribute__ ((constructor)) slp_init(void)
+{
+	helper_register(&slp_helper);
+}
-- 
2.22.0

