Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC9DDC0650E
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 11:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E642218A4
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 11:25:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ub+pNn57"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfGCLZk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 07:25:40 -0400
Received: from kadath.azazel.net ([81.187.231.250]:40796 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbfGCLZk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 07:25:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZKrkpjROQuQl5lJIb+OK7ftHH/K4WFuJcbTlGQaBews=; b=ub+pNn575AtIBMJW4HFt2UiCpt
        g75bfjK/+LnfWtj40qQsSsyS15msFddcSMAJlPm5eUIHspQaumiYyz4PM7PPOC9k/yEfavY5EE7eZ
        ZnARPDjCEWzB+2CjMTtneJ8flbObWAfyHicSqDE+xVLpLfe6WwhG3zRLYZFLe5klMe1/ML/mGIkLJ
        BgEscvMEj8gVgwSU+4YpBtxEVvDptFMrjooJfivBl4dICMzQY3EpCP/igHaJ8rQ3KqsuRJLNMkmOa
        sZwCOstVwwJAlYbglarTwRFE45cIhWRZxwS7eZqEOHIENF8IGM9PexSzXGchEjKdIChoh3rmuew2u
        5KXgRkng==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.89)
        (envelope-from <jeremy@azazel.net>)
        id 1hidOM-0005WL-K9; Wed, 03 Jul 2019 12:25:38 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Stefan Laufmann <stefan.laufmann@emlix.com>
Subject: [PATCH] Added extern "C" declarations to header-files.
Date:   Wed,  3 Jul 2019 12:25:38 +0100
Message-Id: <20190703112538.2506-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703111806.qtygttpa34dmfghp@breakpoint.cc>
References: <20190703111806.qtygttpa34dmfghp@breakpoint.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Declare functions with extern "C" for inclusion in C++.

Reported-by: Stefan Laufmann <stefan.laufmann@emlix.com>
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/libnetfilter_log/libipulog.h        | 8 ++++++++
 include/libnetfilter_log/libnetfilter_log.h | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/libnetfilter_log/libipulog.h b/include/libnetfilter_log/libipulog.h
index ee7890a2d93c..deb0dcc72577 100644
--- a/include/libnetfilter_log/libipulog.h
+++ b/include/libnetfilter_log/libipulog.h
@@ -16,6 +16,10 @@
 #define ULOG_PREFIX_LEN	32
 #define ULOG_IFNAMSIZ	16
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 /* Format of the ULOG packets passed through netlink */
 typedef struct ulog_packet_msg {
 	unsigned long mark;
@@ -67,5 +71,9 @@ enum
 };
 #define IPULOG_MAXERR IPULOG_ERR_INVNL
 
+#ifdef __cplusplus
+} /* extern "C" */
+#endif
+
 
 #endif /* _LIBIPULOG_H */
diff --git a/include/libnetfilter_log/libnetfilter_log.h b/include/libnetfilter_log/libnetfilter_log.h
index 46767eb003c9..6192fa3a5cf1 100644
--- a/include/libnetfilter_log/libnetfilter_log.h
+++ b/include/libnetfilter_log/libnetfilter_log.h
@@ -14,6 +14,10 @@
 #include <linux/netlink.h>
 #include <libnetfilter_log/linux_nfnetlink_log.h>
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 struct nflog_handle;
 struct nflog_g_handle;
 struct nflog_data;
@@ -97,4 +101,8 @@ int nflog_nlmsg_snprintf(char *buf, size_t bufsiz, const struct nlmsghdr *nlh,
 			 struct nlattr **attr, enum nflog_output_type type,
 			 uint32_t flags);
 
+#ifdef __cplusplus
+} /* extern "C" */
+#endif
+
 #endif	/* __LIBNETFILTER_LOG_H */
-- 
2.20.1

