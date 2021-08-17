Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A51C4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Aug 2021 06:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8F4860F5C
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Aug 2021 06:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbhHQGgS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Aug 2021 02:36:18 -0400
Received: from sender4-of-o55.zoho.com ([136.143.188.55]:21594 "EHLO
        sender4-of-o55.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhHQGgR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 02:36:17 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1629182118; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=GBTl5gAwtp9jaAVua/D4+d/7ZbBDkJV9wtSvE96TAYkvkkDRVk5jdZJKZhblmeeuop49BRifhArKmysLZjBPVwAeXu0pOClnFLwNabssdy0uRP/eX9Jm45BaNSGdSjqJAFiQhuXDUaYOMiRJA9dl/dNlbI1yj9YSLI4GjfXHL2A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1629182118; h=Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=zT/dqvfLxXsUQl+9oQ7LqWNg/IaQ55janQpznF3jgLw=; 
        b=lOl8h8vqzAiv8IAzESwHmX5Od6EMaj6+UX+MthpxeN+MPK1NTp7eiuIlJeNHc0czL2z42CGkqFxhYQGjWZHSYSWzWW/syVtKuXGD/8H4fxcJktmW8IRqMCZRaZdhNVeq0wo1548yfvYM2iSM62lNNaXwxdF7Omr396YrqAAXHnU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=proelbtn.com;
        spf=pass  smtp.mailfrom=contact@proelbtn.com;
        dmarc=pass header.from=<contact@proelbtn.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1629182118;
        s=default; d=proelbtn.com; i=contact@proelbtn.com;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
        bh=zT/dqvfLxXsUQl+9oQ7LqWNg/IaQ55janQpznF3jgLw=;
        b=BvJw7kJV/vVGfV2cz0SnDyrCDwHF8CyrhHSJ+Bc3gYlQQZ9PzK2Z4802mEYnAHUt
        qH440FyYItHKAMXFqD6MgcWaX1Ry0eJeYxVE7wN3wEx86RSVdBqC126cxplnwRaWQ4l
        Cwh5k5GIENueUzGes14kUhZ/2iRSRh5Fxem3zFfQ=
Received: from kerneldev.prochi.io (softbank060108183144.bbtec.net [60.108.183.144]) by mx.zohomail.com
        with SMTPS id 1629182116804175.82257435223312; Mon, 16 Aug 2021 23:35:16 -0700 (PDT)
From:   Ryoga Saito <contact@proelbtn.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, stefano.salsano@uniroma2.it,
        andrea.mayer@uniroma2.it, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        Ryoga Saito <contact@proelbtn.com>
Subject: [PATCH v6 1/2] netfilter: add new sysctl toggle for lightweight tunnel netfilter hooks
Date:   Tue, 17 Aug 2021 06:34:52 +0000
Message-Id: <20210817063453.8487-2-contact@proelbtn.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210817063453.8487-1-contact@proelbtn.com>
References: <20210817063453.8487-1-contact@proelbtn.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch introduces new sysctl toggle for enabling lightweight tunnel
netfilter hooks.

Signed-off-by: Ryoga Saito <contact@proelbtn.com>
---
 .../networking/nf_conntrack-sysctl.rst        |  7 ++
 include/net/lwtunnel.h                        |  3 +
 include/net/netfilter/nf_hooks_lwtunnel.h     | 15 +++++
 net/core/lwtunnel.c                           |  3 +
 net/netfilter/Makefile                        |  3 +
 net/netfilter/nf_conntrack_standalone.c       | 15 +++++
 net/netfilter/nf_hooks_lwtunnel.c             | 66 +++++++++++++++++++
 7 files changed, 112 insertions(+)
 create mode 100644 include/net/netfilter/nf_hooks_lwtunnel.h
 create mode 100644 net/netfilter/nf_hooks_lwtunnel.c

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 024d784157c8..34ca762ea56f 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -184,6 +184,13 @@ nf_conntrack_gre_timeout_stream - INTEGER (seconds)
 	This extended timeout will be used in case there is an GRE stream
 	detected.
 
+nf_hooks_lwtunnel - BOOLEAN
+	- 0 - disabled (default)
+	- not 0 - enabled
+
+	If this option is enabled, the lightweight tunnel netfilter hooks are
+	enabled. This option cannot be disabled once it is enabled.
+
 nf_flowtable_tcp_timeout - INTEGER (seconds)
         default 30
 
diff --git a/include/net/lwtunnel.h b/include/net/lwtunnel.h
index 05cfd6ff6528..6f15e6fa154e 100644
--- a/include/net/lwtunnel.h
+++ b/include/net/lwtunnel.h
@@ -51,6 +51,9 @@ struct lwtunnel_encap_ops {
 };
 
 #ifdef CONFIG_LWTUNNEL
+
+DECLARE_STATIC_KEY_FALSE(nf_hooks_lwtunnel_enabled);
+
 void lwtstate_free(struct lwtunnel_state *lws);
 
 static inline struct lwtunnel_state *
diff --git a/include/net/netfilter/nf_hooks_lwtunnel.h b/include/net/netfilter/nf_hooks_lwtunnel.h
new file mode 100644
index 000000000000..f10ee2ccbdc8
--- /dev/null
+++ b/include/net/netfilter/nf_hooks_lwtunnel.h
@@ -0,0 +1,15 @@
+#include <linux/sysctl.h>
+#include <linux/types.h>
+
+#ifdef CONFIG_LWTUNNEL
+int nf_hooks_lwtunnel_sysctl_handler(struct ctl_table *table, int write,
+					 void *buffer, size_t *lenp,
+					 loff_t *ppos);
+#else
+int nf_hooks_lwtunnel_sysctl_handler(struct ctl_table *table, int write,
+					 void *buffer, size_t *lenp,
+					 loff_t *ppos)
+{
+    return 0;
+}
+#endif
diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
index 8ec7d13d2860..3e6960b455e1 100644
--- a/net/core/lwtunnel.c
+++ b/net/core/lwtunnel.c
@@ -23,6 +23,9 @@
 #include <net/ip6_fib.h>
 #include <net/rtnh.h>
 
+DEFINE_STATIC_KEY_FALSE(nf_hooks_lwtunnel_enabled);
+EXPORT_SYMBOL_GPL(nf_hooks_lwtunnel_enabled);
+
 #ifdef CONFIG_MODULES
 
 static const char *lwtunnel_encap_str(enum lwtunnel_encap_types encap_type)
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 049890e00a3d..aab20e575ecd 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -212,3 +212,6 @@ obj-$(CONFIG_IP_SET) += ipset/
 
 # IPVS
 obj-$(CONFIG_IP_VS) += ipvs/
+
+# lwtunnel
+obj-$(CONFIG_LWTUNNEL) += nf_hooks_lwtunnel.o
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index e84b499b7bfa..7e0d956da51d 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -22,6 +22,9 @@
 #include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_conntrack_timestamp.h>
+#ifdef CONFIG_LWTUNNEL
+#include <net/netfilter/nf_hooks_lwtunnel.h>
+#endif
 #include <linux/rculist_nulls.h>
 
 static bool enable_hooks __read_mostly;
@@ -612,6 +615,9 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_PROTO_TIMEOUT_GRE,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_GRE_STREAM,
 #endif
+#ifdef CONFIG_LWTUNNEL
+	NF_SYSCTL_CT_LWTUNNEL,
+#endif
 
 	__NF_SYSCTL_CT_LAST_SYSCTL,
 };
@@ -958,6 +964,15 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode           = 0644,
 		.proc_handler   = proc_dointvec_jiffies,
 	},
+#endif
+#ifdef CONFIG_LWTUNNEL
+	[NF_SYSCTL_CT_LWTUNNEL] = {
+		.procname	= "nf_hooks_lwtunnel",
+		.data		= NULL,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= nf_hooks_lwtunnel_sysctl_handler,
+	},
 #endif
 	{}
 };
diff --git a/net/netfilter/nf_hooks_lwtunnel.c b/net/netfilter/nf_hooks_lwtunnel.c
new file mode 100644
index 000000000000..15b79469048f
--- /dev/null
+++ b/net/netfilter/nf_hooks_lwtunnel.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/sysctl.h>
+#include <net/lwtunnel.h>
+#include <net/netfilter/nf_hooks_lwtunnel.h>
+
+static inline int nf_hooks_lwtunnel_get(void)
+{
+	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
+		return 1;
+	else
+		return 0;
+}
+
+static inline int nf_hooks_lwtunnel_set(int enable)
+{
+	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled)) {
+		if (!enable)
+			return -EBUSY;
+	} else if (enable) {
+		static_branch_enable(&nf_hooks_lwtunnel_enabled);
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_SYSCTL
+
+int nf_hooks_lwtunnel_sysctl_handler(struct ctl_table *table, int write,
+					 void *buffer, size_t *lenp,
+					 loff_t *ppos)
+{
+	int proc_nf_hooks_lwtunnel_enabled = 0;
+	struct ctl_table tmp = {
+		.procname = table->procname,
+		.data = &proc_nf_hooks_lwtunnel_enabled,
+		.maxlen = sizeof(int),
+		.mode = table->mode,
+		.extra1 = SYSCTL_ZERO,
+		.extra2 = SYSCTL_ONE,
+	};
+	int ret;
+
+	if (!write)
+		proc_nf_hooks_lwtunnel_enabled = nf_hooks_lwtunnel_get();
+
+	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+
+	if (write && ret == 0)
+		ret = nf_hooks_lwtunnel_set(proc_nf_hooks_lwtunnel_enabled);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_hooks_lwtunnel_sysctl_handler);
+
+#else // CONFIG_SYSCTL
+
+int nf_hooks_lwtunnel_sysctl_handler(struct ctl_table *table, int write,
+					 void *buffer, size_t *lenp,
+					 loff_t *ppos)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nf_hooks_lwtunnel_sysctl_handler);
+
+#endif
-- 
2.25.1

