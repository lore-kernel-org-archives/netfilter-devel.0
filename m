Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C12C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 07:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7546161053
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 07:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbhHIHtX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Aug 2021 03:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbhHIHtV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Aug 2021 03:49:21 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA52DC0613CF
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Aug 2021 00:48:57 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id ca5so26559283pjb.5
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Aug 2021 00:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JLggGPS4zKd1PIdOMPPvlSOnokFjxip17fHzx/eSGn4=;
        b=NeY99rXkEgut0QWqYfyrTdnPFsTdiGTkvQSxSltiDMpFg+9UB8BaMixilU+mgkSsij
         488kYSI6yoOdz8xrEsIlDsCkKJRI15Vfgl19uRBPQ9dgrRObmrrc8YxSX6wTqiGWy5oM
         Y4RCJItwC14Mw0CxjCbjt/OrCLSFBiuU5oPwoIt+CS4FQyH6qfaQ9ZAIJHcAdmkUY+2n
         gDnM/OffRvgxKWe8E+frE4BtXurPoVsLn8kLuLBiLjj3HtGcltJj0CK1sCNAfwrc9RRm
         +SHz+qDwT5sXgmu6vBbE8s3S0VM1oqj1lJfTdxktLHkvJqyAL7IY8XlU/EJY9jG4mlLo
         rsNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=JLggGPS4zKd1PIdOMPPvlSOnokFjxip17fHzx/eSGn4=;
        b=ln9szydvjn5wASc67rusOQPGi/a/jlo/jJn9Pal314jBatXe8QQBLQF3y7CwxwO3gV
         58KkytA+BS9/I3Y5wUTtfCxdG+8pRhBgbvb3FaKg45Jr/XQdykj0Z+mEI/qSNRnOr6xf
         E5vj4nIo8KYya5JenhXNYYqxTN52ujpIuKAC31hXmsgoiS0J9wyVc539f0r2Rq1QgTkt
         9L5j18S3wpCMV+vaRB1T8KdntN8lYDgP9zSRcj71Tau/UvYCXIbT+sVicD7JLWG4Cl2b
         q2w8kZKsRx2Poty/Wh5eyl3tLSB3XE5gSTlMEXU3rGZxMt4g8XyEGb/mebeuZHJ2DXP2
         ln/A==
X-Gm-Message-State: AOAM532MqRaK60Eap3607VObkiGuyM6vjtyrfzBJmNwdZyoUT9QJsT8G
        fxyuzOR6F9SgeV8Bbc2VwSs=
X-Google-Smtp-Source: ABdhPJxiUX4O8bQRVAXdpLMF8AlTO9x5zkRSxKSYVW89BhuiNJl5zM1vxL5rFKB4AiHXWCSYQmdBZA==
X-Received: by 2002:a17:902:d4cc:b029:12c:dd57:d097 with SMTP id o12-20020a170902d4ccb029012cdd57d097mr8719229plg.23.1628495337464;
        Mon, 09 Aug 2021 00:48:57 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id z14sm19325904pfr.121.2021.08.09.00.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 00:48:57 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] src: doc: Insert SYNOPSIS sections for man pages
Date:   Mon,  9 Aug 2021 17:48:50 +1000
Message-Id: <20210809074850.11328-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In order to work with the post-processing logic in doxygen/Makefile.am,
SYNOPSIS sections must be inserted at the end of the module description
(text after \defgroup or \addtogroup)
(becomes Detailed Description in the man page).

Also a few minor updates including rename module uselessfns to do_not_use

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/extra/icmp.c         |  9 +++++++++
 src/extra/ipv4.c         | 20 +++++++++++++++++++-
 src/extra/ipv6.c         | 10 ++++++++++
 src/extra/pktbuff.c      | 37 +++++++++++++++++++++++++++++++------
 src/extra/tcp.c          | 20 ++++++++++++++++++++
 src/extra/udp.c          | 20 ++++++++++++++++++++
 src/libnetfilter_queue.c | 37 +++++++++++++++++++++++++++++++++++--
 src/nlmsg.c              | 27 +++++++++++++++++++++++++++
 8 files changed, 171 insertions(+), 9 deletions(-)

diff --git a/src/extra/icmp.c b/src/extra/icmp.c
index a97979b..eaade7b 100644
--- a/src/extra/icmp.c
+++ b/src/extra/icmp.c
@@ -19,6 +19,15 @@
 
 /**
  * \defgroup icmp ICMP helper functions
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <libmnl/libmnl.h>
+#include <libnetfilter_queue/libnetfilter_queue_icmp.h>
+\endmanonly
+ *
  * @{
  */
 
diff --git a/src/extra/ipv4.c b/src/extra/ipv4.c
index 797bab1..303d8b6 100644
--- a/src/extra/ipv4.c
+++ b/src/extra/ipv4.c
@@ -22,6 +22,15 @@
 
 /**
  * \defgroup ipv4 IPv4 helper functions
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <libmnl/libmnl.h>
+#include <libnetfilter_queue/libnetfilter_queue_ipv4.h>
+\endmanonly
+ *
  * @{
  */
 
@@ -86,6 +95,15 @@ int nfq_ip_set_transport_header(struct pkt_buff *pktb, struct iphdr *iph)
  * \defgroup ip_internals Internal IP functions
  *
  * Most user-space programs will never need these.
+ *
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <libmnl/libmnl.h>
+#include <libnetfilter_queue/libnetfilter_queue_ipv4.h>
+\endmanonly
  *
  * @{
  */
@@ -142,7 +160,7 @@ int nfq_ip_mangle(struct pkt_buff *pktb, unsigned int dataoff,
 }
 
 /**
- * nfq_pkt_snprintf_ip - print IPv4 header into buffer in iptables LOG format
+ * nfq_ip_snprintf - print IPv4 header into buffer in iptables LOG format
  * \param buf: Pointer to buffer that will be used to print the header
  * \param size: Size of the buffer (or remaining room in it)
  * \param iph: Pointer to a valid IPv4 header
diff --git a/src/extra/ipv6.c b/src/extra/ipv6.c
index 23f64ba..b9f1f6f 100644
--- a/src/extra/ipv6.c
+++ b/src/extra/ipv6.c
@@ -23,6 +23,16 @@
 
 /**
  * \defgroup ipv6 IPv6 helper functions
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <arpa/inet.h>
+#include <libnetfilter_queue/libnetfilter_queue.h>
+#include <libnetfilter_queue/libnetfilter_queue_ipv6.h>
+\endmanonly
+ *
  * @{
  */
 
diff --git a/src/extra/pktbuff.c b/src/extra/pktbuff.c
index 9bdc6bd..005172c 100644
--- a/src/extra/pktbuff.c
+++ b/src/extra/pktbuff.c
@@ -23,8 +23,17 @@
 /**
  * \defgroup pktbuff User-space network packet buffer
  *
- * This library provides the user-space network packet buffer. This abstraction
- * is strongly inspired by Linux kernel network buffer, the so-called sk_buff.
+ * These functions provide the user-space network packet buffer.
+ * This abstraction is strongly inspired by Linux kernel network buffer,
+ * the so-called sk_buff.
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <libmnl/libmnl.h>
+#include <libnetfilter_queue/pktbuff.h>
+\endmanonly
  *
  * @{
  */
@@ -150,20 +159,36 @@ void pktb_free(struct pkt_buff *pktb)
  * \n
  * 1. Functions to get values of members of opaque __struct pktbuff__, described
  * below
- * \n
+ *
  * 2. Internal functions, described in Module __Internal functions__
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <libmnl/libmnl.h>
+#include <libnetfilter_queue/pktbuff.h>
+\endmanonly
  *
  * @{
  */
 
 /**
- * \defgroup uselessfns Internal functions
+ * \defgroup do_not_use Internal functions
  *
- * \warning Do not use these functions. Instead, always use the mangle
+ * Do not use these functions. Instead, always use the mangle
  * function appropriate to the level at which you are working.
  * \n
  * pktb_mangle() uses all the below functions except _pktb_pull_, which is not
  * used by anything.
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <libmnl/libmnl.h>
+#include <libnetfilter_queue/pktbuff.h>
+\endmanonly
  *
  * @{
  */
@@ -317,7 +342,7 @@ static int enlarge_pkt(struct pkt_buff *pktb, unsigned int extra)
  * excess of \b rep_len over \b match_len
  \warning pktb_mangle does not update any checksums. Developers should use the
  appropriate mangler for the protocol level: nfq_ip_mangle(),
- nfq_tcp_mangle_ipv4() or nfq_udp_mangle_ipv4(). IPv6 versions are planned.
+ nfq_tcp_mangle_ipv4(), nfq_udp_mangle_ipv4() or IPv6 variants.
  \n
  It is appropriate to use pktb_mangle to change the MAC header.
  */
diff --git a/src/extra/tcp.c b/src/extra/tcp.c
index 933c6ee..048ba12 100644
--- a/src/extra/tcp.c
+++ b/src/extra/tcp.c
@@ -28,6 +28,15 @@
 
 /**
  * \defgroup tcp TCP helper functions
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <libmnl/libmnl.h>
+#include <libnetfilter_queue/libnetfilter_queue_tcp.h>
+\endmanonly
+ *
  * @{
  */
 
@@ -90,6 +99,17 @@ unsigned int nfq_tcp_get_payload_len(struct tcphdr *tcph, struct pkt_buff *pktb)
  * \defgroup tcp_internals Internal TCP functions
  *
  * Most user-space programs will never need these.
+ *
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <netinet/ip.h>
+#include <netinet/ip6.h>
+#include <netinet/tcp.h>
+#include <libnetfilter_queue/libnetfilter_queue_tcp.h>
+\endmanonly
  *
  * @{
  */
diff --git a/src/extra/udp.c b/src/extra/udp.c
index f232127..42a86e1 100644
--- a/src/extra/udp.c
+++ b/src/extra/udp.c
@@ -27,6 +27,15 @@
 
 /**
  * \defgroup udp UDP helper functions
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <libmnl/libmnl.h>
+#include <libnetfilter_queue/libnetfilter_queue_udp.h>
+\endmanonly
+ *
  * @{
  */
 
@@ -90,6 +99,17 @@ unsigned int nfq_udp_get_payload_len(struct udphdr *udph, struct pkt_buff *pktb)
  * \defgroup udp_internals Internal UDP functions
  *
  * Most user-space programs will never need these.
+ *
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <netinet/ip.h>
+#include <netinet/ip6.h>
+#include <netinet/udp.h>
+#include <libnetfilter_queue/libnetfilter_queue_udp.h>
+\endmanonly
  *
  * @{
  */
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index ef3b211..fb23ee5 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -270,7 +270,7 @@ struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
 		nfq_handle_packet(h, buf, rv);
 	}
 \endverbatim
- * When the decision on a packet has been choosed, the verdict has to be given
+ * When the decision on a packet has been chosen, the verdict has to be given
  * by calling nfq_set_verdict() or nfq_set_verdict2(). The verdict
  * determines the destiny of the packet as follows:
  *
@@ -287,8 +287,18 @@ struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
  * is to also set an nfmark using nfq_set_verdict2, and set up the nefilter
  * rules to only queue a packet when the mark is not (yet) set.
  *
- * Data and information about the packet can be fetch by using message parsing
+ * Data and information about the packet can be fetched by using message parsing
  * functions (See \link Parsing \endlink).
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <linux/netfilter.h>
+#include <linux/netfilter/nfnetlink_queue.h>
+#include <libnetfilter_queue/libnetfilter_queue.h>
+\endmanonly
+ *
  * @{
  */
 
@@ -436,6 +446,13 @@ out_free:
  *
  * When the program has finished with libnetfilter_queue, it has to call
  * the nfq_close() function to free all associated resources.
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <libnetfilter_queue/libnetfilter_queue.h>
+\endmanonly
  *
  * @{
  */
@@ -949,6 +966,14 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh, uint32_t id,
 
 /**
  * \defgroup Parsing Message parsing functions [DEPRECATED]
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <libnetfilter_queue/libnetfilter_queue.h>
+\endmanonly
+ *
  * @{
  */
 
@@ -1348,6 +1373,14 @@ do {								\
 
 /**
  * \defgroup Printing Printing [DEPRECATED]
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <libnetfilter_queue/libnetfilter_queue.h>
+\endmanonly
+ *
  * @{
  */
 
diff --git a/src/nlmsg.c b/src/nlmsg.c
index e141156..2ded4db 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -27,6 +27,15 @@
 
 /**
  * \defgroup nfq_verd Verdict helpers
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <linux/netfilter.h>
+#include <libnetfilter_queue/libnetfilter_queue.h>
+\endmanonly
+ *
  * @{
  */
 
@@ -139,6 +148,15 @@ void nfq_nlmsg_verdict_put_pkt(struct nlmsghdr *nlh, const void *pkt,
 
 /**
  * \defgroup nfq_cfg Config helpers
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <linux/netfilter/nfnetlink_queue.h>
+#include <libnetfilter_queue/libnetfilter_queue.h>
+\endmanonly
+ *
  * @{
  */
 
@@ -205,6 +223,15 @@ void nfq_nlmsg_cfg_put_qmaxlen(struct nlmsghdr *nlh, uint32_t queue_maxlen)
 
 /**
  * \defgroup nlmsg Netlink message helper functions
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <linux/netfilter/nfnetlink_queue.h>
+#include <libnetfilter_queue/libnetfilter_queue.h>
+\endmanonly
+ *
  * @{
  */
 
-- 
2.17.5

