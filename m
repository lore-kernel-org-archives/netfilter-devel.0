Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C7ACC4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 11:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51BE360F4B
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 11:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbhHBLfY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 07:35:24 -0400
Received: from sender4-of-o55.zoho.com ([136.143.188.55]:21560 "EHLO
        sender4-of-o55.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbhHBLfY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 07:35:24 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1627904103; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=GQgO5AeeVi4sPpTR5ehN4PP9LGxyXVadxpJjIBZCriJ0Ui/PDA165SpgJOcVNWonJkF2x1llUucBhM2+orDVIO6E8878o4JgSbjFlvDopGLZfBo3d7tAG25e2EFiRUDMID3a3I3CUNPdhJvqUHPj0Fc96kfCQpJ7dg1w23EAiv8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1627904103; h=Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=p+A7VoPr9VjVAp/h7760U4gMDA5JknCfh73BDmvNuFs=; 
        b=jKh+Vnc8wfBGQ+Q1OsJ3eFehfZZEHK3CseOthW3KbrzMQTi1ePxnrkddNqHeEF0KIvhoZYC8Gvql7CoFWIiw3aBCC7vuV9Dw6PYK5FAXsq/yEWfzOb8yBZZBFrMcGf2QNIInn1AcJS0VO3/Ye5JtMNaVU0BouaO9bQzwwRBjP7w=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=proelbtn.com;
        spf=pass  smtp.mailfrom=contact@proelbtn.com;
        dmarc=pass header.from=<contact@proelbtn.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1627904103;
        s=default; d=proelbtn.com; i=contact@proelbtn.com;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
        bh=p+A7VoPr9VjVAp/h7760U4gMDA5JknCfh73BDmvNuFs=;
        b=d/ZfmPZ+Rrix/rIi8x+kHm1+tjiTtZc29JX/fo/Ewpnu+KFCYYoGXB7155B6h1/p
        ToHxWnaMGAhpdMkK5nKgR2HxFYwAr1qdAf5f6NxHGLDV9LiNGXq4/dK/gqHVAX1vTM9
        eKDpkOfnROcLgRYh/zKxj/sHeibnfKi8loF17nvQ=
Received: from kerneldev.prochi.io (softbank060108183144.bbtec.net [60.108.183.144]) by mx.zohomail.com
        with SMTPS id 1627904086239515.7469124623476; Mon, 2 Aug 2021 04:34:46 -0700 (PDT)
From:   proelbtn <contact@proelbtn.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, stefano.salsano@uniroma2.it,
        andrea.mayer@uniroma2.it, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        proelbtn <contact@proelbtn.com>
Subject: [PATCH v4 1/2] netfilter: add new sysctl toggle for lightweight tunnel netfilter hooks
Date:   Mon,  2 Aug 2021 11:34:32 +0000
Message-Id: <20210802113433.6099-2-contact@proelbtn.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210802113433.6099-1-contact@proelbtn.com>
References: <20210802113433.6099-1-contact@proelbtn.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch introduces new sysctl toggle for enabling lightweight tunnel
netfilter hooks.

Signed-off-by: proelbtn <contact@proelbtn.com>
---
 .../networking/nf_conntrack-sysctl.rst        |  7 +++
 include/net/lwtunnel.h                        |  3 ++
 include/net/netfilter/nf_conntrack_lwtunnel.h | 15 ++++++
 net/core/lwtunnel.c                           |  3 ++
 net/netfilter/Makefile                        |  3 ++
 net/netfilter/nf_conntrack_lwtunnel.c         | 52 +++++++++++++++++++
 net/netfilter/nf_conntrack_standalone.c       | 13 +++++
 7 files changed, 96 insertions(+)
 create mode 100644 include/net/netfilter/nf_conntrack_lwtunnel.h
 create mode 100644 net/netfilter/nf_conntrack_lwtunnel.c

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index d31ed6c1cb0d..5afa4603aa4b 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -30,6 +30,13 @@ nf_conntrack_checksum - BOOLEAN
 	in INVALID state. If this is enabled, such packets will not be
 	considered for connection tracking.
 
+nf_conntrack_lwtunnel - BOOLEAN
+	- 0 - disabled (default)
+	- not 0 - enabled
+
+	If this option is enabled, the lightweight tunnel netfilter hooks are
+	enabled. This option cannot be disabled once it is enabled.
+
 nf_conntrack_count - INTEGER (read-only)
 	Number of currently allocated flow entries.
 
diff --git a/include/net/lwtunnel.h b/include/net/lwtunnel.h
index 05cfd6ff6528..11a2e3ce50b3 100644
--- a/include/net/lwtunnel.h
+++ b/include/net/lwtunnel.h
@@ -51,6 +51,9 @@ struct lwtunnel_encap_ops {
 };
 
 #ifdef CONFIG_LWTUNNEL
+
+DECLARE_STATIC_KEY_FALSE(nf_ct_lwtunnel_enabled);
+
 void lwtstate_free(struct lwtunnel_state *lws);
 
 static inline struct lwtunnel_state *
diff --git a/include/net/netfilter/nf_conntrack_lwtunnel.h b/include/net/netfilter/nf_conntrack_lwtunnel.h
new file mode 100644
index 000000000000..230206d035b7
--- /dev/null
+++ b/include/net/netfilter/nf_conntrack_lwtunnel.h
@@ -0,0 +1,15 @@
+#include <linux/sysctl.h>
+#include <linux/types.h>
+
+#ifdef CONFIG_LWTUNNEL
+int nf_conntrack_lwtunnel_sysctl_handler(struct ctl_table *table, int write,
+					 void *buffer, size_t *lenp,
+					 loff_t *ppos);
+#else // CONFIG_LWTUNNEL
+int nf_conntrack_lwtunnel_sysctl_handler(struct ctl_table *table, int write,
+					 void *buffer, size_t *lenp,
+					 loff_t *ppos)
+{
+    return 0;
+}
+#endif
\ No newline at end of file
diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
index 8ec7d13d2860..8be3274e30ec 100644
--- a/net/core/lwtunnel.c
+++ b/net/core/lwtunnel.c
@@ -23,6 +23,9 @@
 #include <net/ip6_fib.h>
 #include <net/rtnh.h>
 
+DEFINE_STATIC_KEY_FALSE(nf_ct_lwtunnel_enabled);
+EXPORT_SYMBOL_GPL(nf_ct_lwtunnel_enabled);
+
 #ifdef CONFIG_MODULES
 
 static const char *lwtunnel_encap_str(enum lwtunnel_encap_types encap_type)
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 049890e00a3d..07209930b5e4 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -212,3 +212,6 @@ obj-$(CONFIG_IP_SET) += ipset/
 
 # IPVS
 obj-$(CONFIG_IP_VS) += ipvs/
+
+# lwtunnel
+obj-$(CONFIG_LWTUNNEL) += nf_conntrack_lwtunnel.o
diff --git a/net/netfilter/nf_conntrack_lwtunnel.c b/net/netfilter/nf_conntrack_lwtunnel.c
new file mode 100644
index 000000000000..cddbf8c5883a
--- /dev/null
+++ b/net/netfilter/nf_conntrack_lwtunnel.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/sysctl.h>
+#include <net/lwtunnel.h>
+#include <net/netfilter/nf_conntrack.h>
+
+static inline int nf_conntrack_lwtunnel_get(void)
+{
+	if (static_branch_unlikely(&nf_ct_lwtunnel_enabled))
+		return 1;
+	else
+		return 0;
+}
+
+static inline int nf_conntrack_lwtunnel_set(int enable)
+{
+	if (static_branch_unlikely(&nf_ct_lwtunnel_enabled)) {
+		if (!enable)
+			return -EPERM;
+	} else if (enable) {
+		static_branch_enable(&nf_ct_lwtunnel_enabled);
+	}
+
+	return 0;
+}
+
+int nf_conntrack_lwtunnel_sysctl_handler(struct ctl_table *table, int write,
+					 void *buffer, size_t *lenp,
+					 loff_t *ppos)
+{
+	int proc_nf_ct_lwtunnel_enabled = 0;
+	struct ctl_table tmp = {
+		.procname = table->procname,
+		.data = &proc_nf_ct_lwtunnel_enabled,
+		.maxlen = sizeof(int),
+		.mode = table->mode,
+		.extra1 = SYSCTL_ZERO,
+		.extra2 = SYSCTL_ONE,
+	};
+	int ret;
+
+	if (!write)
+		proc_nf_ct_lwtunnel_enabled = nf_conntrack_lwtunnel_get();
+
+	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+
+	if (write && ret == 0)
+		ret = nf_conntrack_lwtunnel_set(proc_nf_ct_lwtunnel_enabled);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_lwtunnel_sysctl_handler);
\ No newline at end of file
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 214d9f9e499b..bb00c8f131e8 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -22,6 +22,9 @@
 #include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_conntrack_timestamp.h>
+#ifdef CONFIG_LWTUNNEL
+#include <net/netfilter/nf_conntrack_lwtunnel.h>
+#endif
 #include <linux/rculist_nulls.h>
 
 static bool enable_hooks __read_mostly;
@@ -552,6 +555,7 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_COUNT,
 	NF_SYSCTL_CT_BUCKETS,
 	NF_SYSCTL_CT_CHECKSUM,
+	NF_SYSCTL_CT_LWTUNNEL,
 	NF_SYSCTL_CT_LOG_INVALID,
 	NF_SYSCTL_CT_EXPECT_MAX,
 	NF_SYSCTL_CT_ACCT,
@@ -650,6 +654,15 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.extra1 	= SYSCTL_ZERO,
 		.extra2 	= SYSCTL_ONE,
 	},
+#ifdef CONFIG_LWTUNNEL
+	[NF_SYSCTL_CT_LWTUNNEL] = {
+		.procname	= "nf_conntrack_lwtunnel",
+		.data		= NULL,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= nf_conntrack_lwtunnel_sysctl_handler,
+	},
+#endif
 	[NF_SYSCTL_CT_LOG_INVALID] = {
 		.procname	= "nf_conntrack_log_invalid",
 		.data		= &init_net.ct.sysctl_log_invalid,
-- 
2.25.1

