Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00462C636D6
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Feb 2023 15:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbjBVP4Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Feb 2023 10:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbjBVP4O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Feb 2023 10:56:14 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C558F3B3F7
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2023 07:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=S/eQBE7a8VMWqRXkJJMfo8oADOz097cioQik35D+dc0=; b=l4DeDeJ8bN5SCkVqi4arEDknrv
        2cponNhw2Xtuu5+c4oZRdxr1Peugr0C7VFm5nFo35sD8ajLK0OZKTEFMTj6cr8xlkmosLU6pn/aQa
        9arrm+VrtHwp+iia4H/tDuD4Sii/OerjPglrjJRg2Fh4NV8UjuOlGnRIWolAQ7/BuOzpY/2iVgZ15
        dtK3qdh7eNwl4pOBUfYEbw+6k9qOjo07NiGAAMO70nJ9MPXeAGvjinut1WbY9zDma2qEDEbEp5Leo
        d+4nP1Qd+IUj4mNQfmcDbhCoJVbuZzfXbZFHDmSQ6nLDYXBauGo/idy6NAfKsJAW9CR3FG0mBcKFW
        fmOgsJ0A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pUrTV-0004Zj-Ro; Wed, 22 Feb 2023 16:56:09 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Thomas Devoogdt <thomas@devoogdt.com>
Subject: [iptables PATCH] include: Add missing linux/netfilter/xt_LOG.h
Date:   Wed, 22 Feb 2023 16:56:01 +0100
Message-Id: <20230222155601.31645-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When merging IP-version-specific LOG extensions, a dependency to that
header was introduced without caching it. Fix this and drop the now
unused ip{,6}t_LOG.h files.

Reported-by: Thomas Devoogdt <thomas@devoogdt.com>
Fixes: 87e4f1bf0b87b ("extensions: libip*t_LOG: Merge extensions")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/linux/netfilter/xt_LOG.h        | 20 ++++++++++++++++++++
 include/linux/netfilter_ipv4/ipt_LOG.h  | 19 -------------------
 include/linux/netfilter_ipv6/ip6t_LOG.h | 19 -------------------
 3 files changed, 20 insertions(+), 38 deletions(-)
 create mode 100644 include/linux/netfilter/xt_LOG.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_LOG.h
 delete mode 100644 include/linux/netfilter_ipv6/ip6t_LOG.h

diff --git a/include/linux/netfilter/xt_LOG.h b/include/linux/netfilter/xt_LOG.h
new file mode 100644
index 0000000000000..167d4ddd2476b
--- /dev/null
+++ b/include/linux/netfilter/xt_LOG.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _XT_LOG_H
+#define _XT_LOG_H
+
+/* make sure not to change this without changing nf_log.h:NF_LOG_* (!) */
+#define XT_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
+#define XT_LOG_TCPOPT		0x02	/* Log TCP options */
+#define XT_LOG_IPOPT		0x04	/* Log IP options */
+#define XT_LOG_UID		0x08	/* Log UID owning local socket */
+#define XT_LOG_NFLOG		0x10	/* Unsupported, don't reuse */
+#define XT_LOG_MACDECODE	0x20	/* Decode MAC header */
+#define XT_LOG_MASK		0x2f
+
+struct xt_log_info {
+	unsigned char level;
+	unsigned char logflags;
+	char prefix[30];
+};
+
+#endif /* _XT_LOG_H */
diff --git a/include/linux/netfilter_ipv4/ipt_LOG.h b/include/linux/netfilter_ipv4/ipt_LOG.h
deleted file mode 100644
index dcdbadf9fd4a9..0000000000000
--- a/include/linux/netfilter_ipv4/ipt_LOG.h
+++ /dev/null
@@ -1,19 +0,0 @@
-#ifndef _IPT_LOG_H
-#define _IPT_LOG_H
-
-/* make sure not to change this without changing netfilter.h:NF_LOG_* (!) */
-#define IPT_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
-#define IPT_LOG_TCPOPT		0x02	/* Log TCP options */
-#define IPT_LOG_IPOPT		0x04	/* Log IP options */
-#define IPT_LOG_UID		0x08	/* Log UID owning local socket */
-#define IPT_LOG_NFLOG		0x10	/* Unsupported, don't reuse */
-#define IPT_LOG_MACDECODE	0x20	/* Decode MAC header */
-#define IPT_LOG_MASK		0x2f
-
-struct ipt_log_info {
-	unsigned char level;
-	unsigned char logflags;
-	char prefix[30];
-};
-
-#endif /*_IPT_LOG_H*/
diff --git a/include/linux/netfilter_ipv6/ip6t_LOG.h b/include/linux/netfilter_ipv6/ip6t_LOG.h
deleted file mode 100644
index 9dd5579e02ec7..0000000000000
--- a/include/linux/netfilter_ipv6/ip6t_LOG.h
+++ /dev/null
@@ -1,19 +0,0 @@
-#ifndef _IP6T_LOG_H
-#define _IP6T_LOG_H
-
-/* make sure not to change this without changing netfilter.h:NF_LOG_* (!) */
-#define IP6T_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
-#define IP6T_LOG_TCPOPT		0x02	/* Log TCP options */
-#define IP6T_LOG_IPOPT		0x04	/* Log IP options */
-#define IP6T_LOG_UID		0x08	/* Log UID owning local socket */
-#define IP6T_LOG_NFLOG		0x10	/* Unsupported, don't use */
-#define IP6T_LOG_MACDECODE	0x20	/* Decode MAC header */
-#define IP6T_LOG_MASK		0x2f
-
-struct ip6t_log_info {
-	unsigned char level;
-	unsigned char logflags;
-	char prefix[30];
-};
-
-#endif /*_IPT_LOG_H*/
-- 
2.38.0

