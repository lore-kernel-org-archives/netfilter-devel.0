Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AEDDC4338F
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Aug 2021 04:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAD8661038
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Aug 2021 04:44:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237413AbhHMEpN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Aug 2021 00:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234019AbhHMEpM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Aug 2021 00:45:12 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480F7C061756
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Aug 2021 21:44:46 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id q2so10271948plr.11
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Aug 2021 21:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WIiNbPDQJMwf3NFwpxeZnLXAk701VYHfBIobmKN23sI=;
        b=YDO3K2y24CUh4Dkex9i2NTT7ry7WpdZ1BHhTEL/f4u8zNoNTuc9Ovj/Fjpa+4IuoyN
         k2X95PlRd0PQ2i4GXkh89R7PA/OnGTPfROkBtQYGCLCAeKQdLSXTzSk3g8SWE/7dLESA
         20GxIwanC4OiQBWCNNxCll3JWYGAe9HSlg0tT8ExK3SSc1+XACW90ZgiNmnlkuUYTh0F
         iBjzbdT6OMBYhtDVvOYlr5QPdRsrubNxovWVKUNFiAl7QN9fMFfT7dLNUoKT58HpORc+
         PPylCW0CKUQA2Ie2LBXvMzFUNUd6QotNXM9Xyw2LaZyeqx5TEfyb4J9YgZvei+JV025S
         yF/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=WIiNbPDQJMwf3NFwpxeZnLXAk701VYHfBIobmKN23sI=;
        b=azNltnCVVG9GnNVM94Cu4TL8KGxXqzM0dDaFx57v6iX2O8XIGKQVdWGa2Bfmx4oCie
         BIYZkIUSG/IZJd9p8pppqycKGCqkdGDgIOs5XwwLaKH84uxGGsuTCmof9YZVVMCcc7DS
         fWW6HoAtDf12FwtR9mE7OCVdaUxYmxAa9foaF6QUR2IN+O2zQF7QCmWQumn78EoL1l9p
         pNYA8h3BICXHAP95jeXy+0/NB4az55+OhvuuTlap/txJT1HqISsotCi707on2cnF3rsY
         jSAHPD74yXToBqidsK91DtgbixmVJ2lA66FUI5WTyaAGQdvm/MuR42KRn30//itZOOVh
         Hyeg==
X-Gm-Message-State: AOAM532tSQDpanGwtoC6zh+pP2mrP9ZciTi9hf2v0gEAynlSZd9XEOTJ
        Z1MUfyIKXNShK38Zkd5m3mKT/JHTfi/h0Q==
X-Google-Smtp-Source: ABdhPJzwpL7vQt4+mqUuMz35KJrr4cd8vhxWMYkPECzom7p7dta1OYKd/ex889Qt+Hpdr+h1y2kBXA==
X-Received: by 2002:a63:1266:: with SMTP id 38mr577187pgs.219.1628829885838;
        Thu, 12 Aug 2021 21:44:45 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id s23sm427116pfg.208.2021.08.12.21.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 21:44:45 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 1/1] src: doc: Insert SYNOPSIS sections for man pages
Date:   Fri, 13 Aug 2021 14:44:36 +1000
Message-Id: <20210813044436.16066-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813044436.16066-1-duncan_roe@optusnet.com.au>
References: <20210813044436.16066-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In order to work with the post-processing logic in doxygen/Makefile.am,
SYNOPSIS sections must be inserted at the end of the module description
(text after \defgroup or \addtogroup)
(becomes Detailed Description in the man page).

Also a few minor updates including rename module uselessfns to do_not_use.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
v2: Rebase after "deprecate libnetfilter_queue/linux_nfnetlink_queue.h" patch
v3: Add extra #include lines to synopses as required by above patch
 src/extra/icmp.c         |  9 +++++++++
 src/extra/ipv4.c         | 20 +++++++++++++++++++-
 src/extra/ipv6.c         | 11 +++++++++++
 src/extra/pktbuff.c      | 37 +++++++++++++++++++++++++++++++------
 src/extra/tcp.c          | 20 ++++++++++++++++++++
 src/extra/udp.c          | 20 ++++++++++++++++++++
 src/libnetfilter_queue.c | 40 ++++++++++++++++++++++++++++++++++++++--
 src/nlmsg.c              | 28 ++++++++++++++++++++++++++++
 8 files changed, 176 insertions(+), 9 deletions(-)

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
index af4482d..58fb471 100644
--- a/src/extra/ipv4.c
+++ b/src/extra/ipv4.c
@@ -23,6 +23,15 @@
 
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
 
@@ -87,6 +96,15 @@ int nfq_ip_set_transport_header(struct pkt_buff *pktb, struct iphdr *iph)
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
@@ -143,7 +161,7 @@ int nfq_ip_mangle(struct pkt_buff *pktb, unsigned int dataoff,
 }
 
 /**
- * nfq_pkt_snprintf_ip - print IPv4 header into buffer in iptables LOG format
+ * nfq_ip_snprintf - print IPv4 header into buffer in iptables LOG format
  * \param buf: Pointer to buffer that will be used to print the header
  * \param size: Size of the buffer (or remaining room in it)
  * \param iph: Pointer to a valid IPv4 header
diff --git a/src/extra/ipv6.c b/src/extra/ipv6.c
index 40b9950..69d86a8 100644
--- a/src/extra/ipv6.c
+++ b/src/extra/ipv6.c
@@ -24,6 +24,17 @@
 
 /**
  * \defgroup ipv6 IPv6 helper functions
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <arpa/inet.h>
+#include <linux/netfilter/nfnetlink_queue.h>
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
index 01bfe8c..720afd2 100644
--- a/src/extra/tcp.c
+++ b/src/extra/tcp.c
@@ -29,6 +29,15 @@
 
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
 
@@ -91,6 +100,17 @@ unsigned int nfq_tcp_get_payload_len(struct tcphdr *tcph, struct pkt_buff *pktb)
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
index ff91311..ede2196 100644
--- a/src/extra/udp.c
+++ b/src/extra/udp.c
@@ -28,6 +28,15 @@
 
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
 
@@ -91,6 +100,17 @@ unsigned int nfq_udp_get_payload_len(struct udphdr *udph, struct pkt_buff *pktb)
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
index 11a4e7c..a170143 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -271,7 +271,7 @@ struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
 		nfq_handle_packet(h, buf, rv);
 	}
 \endverbatim
- * When the decision on a packet has been choosed, the verdict has to be given
+ * When the decision on a packet has been chosen, the verdict has to be given
  * by calling nfq_set_verdict() or nfq_set_verdict2(). The verdict
  * determines the destiny of the packet as follows:
  *
@@ -288,8 +288,18 @@ struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
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
 
@@ -437,6 +447,14 @@ out_free:
  *
  * When the program has finished with libnetfilter_queue, it has to call
  * the nfq_close() function to free all associated resources.
+ *
+ * \manonly
+.SH SYNOPSIS
+.nf
+\fB
+#include <linux/netfilter/nfnetlink_queue.h>
+#include <libnetfilter_queue/libnetfilter_queue.h>
+\endmanonly
  *
  * @{
  */
@@ -950,6 +968,15 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh, uint32_t id,
 
 /**
  * \defgroup Parsing Message parsing functions [DEPRECATED]
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
 
@@ -1349,6 +1376,15 @@ do {								\
 
 /**
  * \defgroup Printing Printing [DEPRECATED]
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
 
diff --git a/src/nlmsg.c b/src/nlmsg.c
index e141156..b1154fc 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -27,6 +27,16 @@
 
 /**
  * \defgroup nfq_verd Verdict helpers
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
 
@@ -139,6 +149,15 @@ void nfq_nlmsg_verdict_put_pkt(struct nlmsghdr *nlh, const void *pkt,
 
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
 
@@ -205,6 +224,15 @@ void nfq_nlmsg_cfg_put_qmaxlen(struct nlmsghdr *nlh, uint32_t queue_maxlen)
 
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

