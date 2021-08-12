Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7085DC432BE
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Aug 2021 01:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5601E60231
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Aug 2021 01:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbhHLB4n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 21:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbhHLB4n (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 21:56:43 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1929C061765
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Aug 2021 18:56:18 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g12-20020a17090a7d0cb0290178f80de3d8so8039163pjl.2
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Aug 2021 18:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OMzS0HYtDnLKgchjZNdBkd74ZHxT6/VVpO6mfvYNbSM=;
        b=lZyCUemK3hIE7bnN7WUlh24+uQ8F+Dvku+1+NtM5JO0l60wyPvJ20acSRQFTTLg8ap
         unfoAMRbkqwpVhyX8FzcbEm+Iememv/Ic5wr660w+rqfeBGbj3njwdrVukYtoiICWET3
         ZMPj8kSq85JGUN6BLd/ZTlyxwgI7h2SXs/cqrxn8vJwj5uP7UxBIHLtwPwMkBIdi6dEE
         gKmpRbDspDtbLRl13xQdABBVeYk3Gf4hDk84Z4tE9DsgWT7f4vmmTmn2ODMLqlJM6T6K
         Rc/hP0VxB/muyxXdwl9YJKq7sZfqi76PMKNQJofVGDON6wSyTjnSbKVeDiIwwI1JOUaN
         RXWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=OMzS0HYtDnLKgchjZNdBkd74ZHxT6/VVpO6mfvYNbSM=;
        b=gokw50zNhlZScD406q2TbM6pHs9btPFJ+mE9Pis5m4BGXXtUQd3konVJUr1RhzDi11
         3xMKOwD48moVOGxOwC5r59xkFje/VqaB9Exl2OjW7cLEUxVM59oMP65hhSLxu6k68m9N
         cxlNbgubCBfMfy6U5sJloUXQt0wkfAWQyFGT+ewpougXvk9UwHPR60oDIBwA9fIJk8xu
         gkInxZMbLj2sQktRYdJajoaHqqgFDzIXKpbN7+HzPQIJf//1nMHOsfRlKitqiz/vVLBH
         aqZ8MV613qpnNx9aX9OUjQHWqhPeSHX27PXn4+BK2GzNTnMP+QuTCFwPB9TrSLZrfoti
         OzMA==
X-Gm-Message-State: AOAM530PeoRtNXTxOSZTIA3t9kSCUBcvZ71lbJGNvOaREkr+pBROB1xn
        y8s9P4TFNVV2dD8673mxCwI=
X-Google-Smtp-Source: ABdhPJxLFqiNRCjeYglglGQ4XaYAe1m+Ty4QPBnNzhK91lQGfk+lmpBGz1bXNLgtDhhO7ZhQkezNBQ==
X-Received: by 2002:aa7:8c14:0:b029:3e0:235a:5d58 with SMTP id c20-20020aa78c140000b02903e0235a5d58mr1711424pfd.57.1628733378365;
        Wed, 11 Aug 2021 18:56:18 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id m11sm8225523pjn.2.2021.08.11.18.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 18:56:17 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v2 1/1] src: doc: Insert SYNOPSIS sections for man pages
Date:   Thu, 12 Aug 2021 11:56:09 +1000
Message-Id: <20210812015609.14728-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210812015609.14728-1-duncan_roe@optusnet.com.au>
References: <20210812015609.14728-1-duncan_roe@optusnet.com.au>
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
index 40b9950..1050e6d 100644
--- a/src/extra/ipv6.c
+++ b/src/extra/ipv6.c
@@ -24,6 +24,16 @@
 
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
index 11a4e7c..e4625f7 100644
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
 
@@ -437,6 +447,13 @@ out_free:
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
@@ -950,6 +967,14 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh, uint32_t id,
 
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
 
@@ -1349,6 +1374,14 @@ do {								\
 
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

