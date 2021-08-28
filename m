Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA66C43214
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 19:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3C2560EBD
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 19:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhH1Tlg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 28 Aug 2021 15:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbhH1Tle (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 28 Aug 2021 15:41:34 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC5CC0617AE
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Aug 2021 12:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NyzxAq6qR6YXxy4vjPrNzZu97mU70icmM6M4QZGNMZI=; b=DqlR4OgbHuAk0kDfHwXtaDOitZ
        r4zTigp22VM4kn3lTzle2a8n71qjyNtujrhIjylO91dTtZ1FVY7C7UNCKPN41VaJ2JfkY0byi7GLW
        9aUzExYipYoROaMKBcXSENLXgKrUdP+ROCQ+k5bEHfqPRj9M9b2mqxdUnx9ZVrucs/PK1DPpLOSH+
        mrv3UXJZfCpTTuiH9OHR2+CJKL+yhH/lnYgsZbJQ3KPPpwDB9FOnVr8HEn5SvsSOx3C3udKc77qId
        qDKcFF2OdbxQ1p8t5IJwtIEUBYesCDBsoG6kzTNzUVBCAVvwf+lHV1Gy76GiC+DDYX+PR/RJlwWA1
        1DbaiyMQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mK4C2-00FeN7-0L; Sat, 28 Aug 2021 20:40:42 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnetfilter_log 6/6] libipulog: fill in missing packet fields.
Date:   Sat, 28 Aug 2021 20:38:24 +0100
Message-Id: <20210828193824.1288478-7-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210828193824.1288478-1-jeremy@azazel.net>
References: <20210828193824.1288478-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Retrieval of time-stamp, input- and output-device fields had not been
implemented in `ipulog_get_packet`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/libipulog_compat.c | 23 ++++++++++++++++-------
 utils/ulog_test.c      |  7 +++++++
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/src/libipulog_compat.c b/src/libipulog_compat.c
index bf957274ca22..85f7cf59c2fc 100644
--- a/src/libipulog_compat.c
+++ b/src/libipulog_compat.c
@@ -4,6 +4,7 @@
 #include <unistd.h>
 #include <sys/types.h>
 #include <sys/socket.h>
+#include <net/if.h>
 #include <netinet/in.h>
 #include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_log/libnetfilter_log.h>
@@ -159,20 +160,29 @@ next_msg:	printf("next\n");
 		h->upmsg.mark = 0;
 
 	if (tb[NFULA_TIMESTAMP-1]) {
-		/* FIXME: 64bit network-to-host */
-		h->upmsg.timestamp_sec = h->upmsg.timestamp_usec = 0;
+		struct nfulnl_msg_packet_timestamp *ts;
+		ts = NFA_DATA(tb[NFULA_TIMESTAMP-1]);
+
+		h->upmsg.timestamp_sec  = __be64_to_cpu(ts->sec);
+		h->upmsg.timestamp_usec = __be64_to_cpu(ts->usec);
 	} else
 		h->upmsg.timestamp_sec = h->upmsg.timestamp_usec = 0;
 
 	if (tb[NFULA_IFINDEX_INDEV-1]) {
-		/* FIXME: ifindex lookup */	
-		h->upmsg.indev_name[0] = '\0';
+		void *indev_ptr = NFA_DATA(tb[NFULA_IFINDEX_INDEV-1]);
+		uint32_t indev_idx = ntohl(*(uint32_t *)indev_ptr);
+
+		if (!if_indextoname(indev_idx, h->upmsg.indev_name))
+			h->upmsg.indev_name[0] = '\0';
 	} else
 		h->upmsg.indev_name[0] = '\0';
 
 	if (tb[NFULA_IFINDEX_OUTDEV-1]) {
-		/* FIXME: ifindex lookup */	
-		h->upmsg.outdev_name[0] = '\0';
+		void *outdev_ptr = NFA_DATA(tb[NFULA_IFINDEX_OUTDEV-1]);
+		uint32_t outdev_idx = ntohl(*(uint32_t *)outdev_ptr);
+
+		if (!if_indextoname(outdev_idx, h->upmsg.outdev_name))
+			h->upmsg.outdev_name[0] = '\0';
 	} else
 		h->upmsg.outdev_name[0] = '\0';
 
@@ -222,4 +232,3 @@ void ipulog_perror(const char *s)
 		fprintf(stderr, ": %s", strerror(errno));
 	fputc('\n', stderr);
 }
-
diff --git a/utils/ulog_test.c b/utils/ulog_test.c
index f3adec2daf2e..20f61630d2ef 100644
--- a/utils/ulog_test.c
+++ b/utils/ulog_test.c
@@ -27,6 +27,13 @@ void handle_packet(ulog_packet_msg_t *pkt)
 	       pkt->hook, pkt->mark, pkt->data_len);
 	if (strlen(pkt->prefix))
 		printf("Prefix=%s ", pkt->prefix);
+	if (strlen(pkt->indev_name))
+		printf("Input device=%s ", pkt->indev_name);
+	if (strlen(pkt->outdev_name))
+		printf("Output device=%s ", pkt->outdev_name);
+	if (pkt->timestamp_sec || pkt->timestamp_usec)
+		printf("Timestamp=%ld.%06lds ",
+		       pkt->timestamp_sec, pkt->timestamp_usec);
 	
 	if (pkt->mac_len)
 	{
-- 
2.33.0

