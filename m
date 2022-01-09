Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 017F0C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jan 2022 03:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbiAIDRK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 8 Jan 2022 22:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbiAIDRJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Jan 2022 22:17:09 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E0FC06173F
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Jan 2022 19:17:09 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id g5so63695plo.12
        for <netfilter-devel@vger.kernel.org>; Sat, 08 Jan 2022 19:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WQYX4ufjWZGZm83J0NaJVCXfXP17ItAbPD7g29Rlxj4=;
        b=iBHM+JwTdzQZX8PgSdryGeD1BehSLGYrIGwbAVhF+J4AdqW3ROjSq5YBFo02MN3lFv
         8Pek6GTMcGqw/HWI6R2vA7pEJmbM/C5xhsGuv6FN6tQnU6crOF+YYzGMzm7/PvSyRThX
         7ajXlBZoQmqLI/1nMYf0BRkZ9w1wf7uEzyhIkWuZghIey0PdYcmVGrlPuIY1rNATksSD
         G1ddoPx43M13ylpLS+XbnwzMqIpYG2PyFF1Sz4mhwKWeVKdkOLhTyG2YBTVLBZvDmG6K
         0DrKRoUf5n6N2E2Z0VIqfo24bMwPjkNUqzMsMXywrR/5PighInuXlLtTuJ3D+ei0zaQa
         oZxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=WQYX4ufjWZGZm83J0NaJVCXfXP17ItAbPD7g29Rlxj4=;
        b=JsqYWwQFaXrrBYbatY+E+ekLfnGebtGAx7BPyPG6AR0OEjkoOP56NtqDzsdhxhGFGC
         7BeOaeL/3cHWYzmMwdXvBbTOXaFmAq+CPslseuuYUCMmPCSicEynJ2XV8Zyfb1jvR1rO
         05pSrWUtnvtevGpwumm5/hPz3J3cWBRCFmYqfiz5eHqN0+2N+z/dpw+2p6wWroP7VhsK
         hiRnSHabdp6XxjTn45l52ebvj9VYDXHdMqLpGF+MCLwKTSAEdkdcv3a+qgP1yNqmPyqU
         xsI4WTwzBPiUkWL2At8L6zgU7/Rr0SGZvM/RhMpdRVC8rlmvCTxQQUMJFNRFVtPlwRqt
         s5NQ==
X-Gm-Message-State: AOAM533wbc0DIWaVKrqLL0YjLP83lR95npEZcnkSJQb+hgrFEaf/qzU4
        xOjNNDqzn2fzbcC+FRLLkfz8Vw2DOCE=
X-Google-Smtp-Source: ABdhPJywGRDaZwQtH9Tuyc3LcjtWzFtxPSn96ylDsNbHG+/gudYfIhWCNbg4uEAedE/5DgjvIgxqIg==
X-Received: by 2002:a17:90a:c243:: with SMTP id d3mr10416938pjx.21.1641698228705;
        Sat, 08 Jan 2022 19:17:08 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id me18sm3881864pjb.3.2022.01.08.19.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 19:17:08 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 5/5] src: struct pktbuff is no longer opaque
Date:   Sun,  9 Jan 2022 14:16:53 +1100
Message-Id: <20220109031653.23835-6-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20220109031653.23835-1-duncan_roe@optusnet.com.au>
References: <20220109031653.23835-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With the advent of nfq_run_cb() and pktb_populate(),
there is no longer ever a buffer tacked on the end of a struct pktbuff.
Now that struct pktbuff is purely a buffer descriptor, there seems little
point in keeping it opaque so expose it.
Some code simplification ensues: the new callback function prototype only
differs from the old one in having 1 extra arg being available free space.
An application creates a struct pktbuff instance by just declaring it.
pktb_populate() zeroises pktb because it's no longer guaranteed zero.
As before, no new doxygen documentation until function prototypes are agreed,
but examples/nf-queue.c is updated.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
v3: New patch
 examples/nf-queue.c                   |  6 +++---
 include/libnetfilter_queue/callback.h |  2 +-
 include/libnetfilter_queue/pktbuff.h  | 13 ++++++++++++-
 src/extra/callback.c                  |  4 +---
 src/extra/pktbuff.c                   |  1 +
 src/internal.h                        | 14 +-------------
 6 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/examples/nf-queue.c b/examples/nf-queue.c
index 4074e5a..f330b97 100644
--- a/examples/nf-queue.c
+++ b/examples/nf-queue.c
@@ -49,11 +49,12 @@ nfq_send_verdict(int queue_num, uint32_t id)
 }
 
 static int queue_cb(const struct nlmsghdr *nlh, void *data,
-		    struct pkt_buff *supplied_pktb, size_t supplied_extra)
+		    size_t supplied_extra)
 {
 	struct nfqnl_msg_packet_hdr *ph = NULL;
 	struct nlattr *attr[NFQA_MAX+1] = {};
 	struct pkt_buff *pktb;
+	struct pkt_buff pkt_b;
 	uint32_t id = 0, skbinfo;
 	struct nfgenmsg *nfg;
 	uint8_t *payload;
@@ -77,8 +78,7 @@ static int queue_cb(const struct nlmsghdr *nlh, void *data,
 	plen = mnl_attr_get_payload_len(attr[NFQA_PAYLOAD]);
 	payload = mnl_attr_get_payload(attr[NFQA_PAYLOAD]);
 
-	pktb = pktb_populate(supplied_pktb, AF_INET, payload, plen,
-			     supplied_extra);
+	pktb = pktb_populate(&pkt_b, AF_INET, payload, plen, supplied_extra);
 
 	skbinfo = attr[NFQA_SKB_INFO] ? ntohl(mnl_attr_get_u32(attr[NFQA_SKB_INFO])) : 0;
 
diff --git a/include/libnetfilter_queue/callback.h b/include/libnetfilter_queue/callback.h
index 27bfe31..756cb38 100644
--- a/include/libnetfilter_queue/callback.h
+++ b/include/libnetfilter_queue/callback.h
@@ -4,7 +4,7 @@
 struct nlattr;
 struct pkt_buff;
 
-typedef int (*nfq_cb_t)(const struct nlmsghdr *nlh, void *data, struct pkt_buff *pktb, size_t extra);
+typedef int (*nfq_cb_t)(const struct nlmsghdr *nlh, void *data, size_t extra);
 
 int nfq_cb_run(const void *buf, size_t buflen, size_t bufcap, unsigned int portid, nfq_cb_t cb_data, void *data);
 
diff --git a/include/libnetfilter_queue/pktbuff.h b/include/libnetfilter_queue/pktbuff.h
index 33829cc..7ad7cb1 100644
--- a/include/libnetfilter_queue/pktbuff.h
+++ b/include/libnetfilter_queue/pktbuff.h
@@ -1,7 +1,18 @@
 #ifndef _PKTBUFF_H_
 #define _PKTBUFF_H_
 
-struct pkt_buff;
+struct pkt_buff {
+	uint8_t *mac_header;
+	uint8_t *network_header;
+	uint8_t *transport_header;
+
+	uint8_t *data;
+
+	uint32_t len;
+	uint32_t data_len;
+
+	bool	mangled;
+};
 
 struct pkt_buff *pktb_alloc(int family, void *data, size_t len, size_t extra);
 void pktb_free(struct pkt_buff *pktb);
diff --git a/src/extra/callback.c b/src/extra/callback.c
index dee6fc2..23e88f7 100644
--- a/src/extra/callback.c
+++ b/src/extra/callback.c
@@ -31,10 +31,9 @@ struct data_carrier
 
 static int local_cb(const struct nlmsghdr *nlh, void *data)
 {
-	struct pkt_buff pktb_instance = { };
 	struct data_carrier *d = (struct data_carrier *)data;
 
-	return d->cb_func(nlh, d->data, &pktb_instance, d->bufcap - d->buflen);
+	return d->cb_func(nlh, d->data, d->bufcap - d->buflen);
 }
 
 EXPORT_SYMBOL int nfq_cb_run(const void *buf, size_t buflen, size_t bufcap,
@@ -54,6 +53,5 @@ EXPORT_SYMBOL int nfq_cb_run(const void *buf, size_t buflen, size_t bufcap,
 		return MNL_CB_ERROR;
 	}
 
-
 	return mnl_cb_run(buf, buflen, 0, portid, local_cb, &dc);
 }
diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index 86d8fe6..ae3e454 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -125,6 +125,7 @@ EXPORT_SYMBOL
 struct pkt_buff *pktb_populate(struct pkt_buff *pktb, int family, void *data,
 			       size_t len, size_t extra)
 {
+	memset(pktb, 0, sizeof *pktb);
 	pktb_setup_metadata(pktb, data, len, extra);
 	if (__pktb_setup(family, pktb) < 0)
 		pktb = NULL;
diff --git a/src/internal.h b/src/internal.h
index ae849d6..6adf3d1 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -4,6 +4,7 @@
 #include "config.h"
 #include <stdint.h>
 #include <stdbool.h>
+#include <libnetfilter_queue/pktbuff.h>
 #ifdef HAVE_VISIBILITY_HIDDEN
 #	define EXPORT_SYMBOL __attribute__((visibility("default")))
 #else
@@ -18,19 +19,6 @@ uint16_t nfq_checksum_tcpudp_ipv4(struct iphdr *iph, uint16_t protonum);
 uint16_t nfq_checksum_tcpudp_ipv6(struct ip6_hdr *ip6h, void *transport_hdr,
 				  uint16_t protonum);
 
-struct pkt_buff {
-	uint8_t *mac_header;
-	uint8_t *network_header;
-	uint8_t *transport_header;
-
-	uint8_t *data;
-
-	uint32_t len;
-	uint32_t data_len;
-
-	bool	mangled;
-};
-
 static inline uint8_t *pktb_tail(struct pkt_buff *pktb)
 {
 	return pktb->data + pktb->len;
-- 
2.17.5

