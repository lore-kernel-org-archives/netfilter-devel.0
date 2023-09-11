Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1249EE57DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Sep 2023 05:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjIKFyk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Sep 2023 01:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjIKFyj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Sep 2023 01:54:39 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A941AE
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Sep 2023 22:54:32 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-68fac16ee5fso821664b3a.1
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Sep 2023 22:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694411671; x=1695016471; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=HVCfoYEBhI0078LM+zjKbwdJdpqXOANxQGWWW08MDLI=;
        b=ha1k1wiw6b90Jvbdy1jGr0YZS3jbx/KT07iITaswdmwqAdyHkp408pIld0VH/h8jN7
         B/pz91qIpvalD2E3jJbSydDeqw0IEMRwKkev09jfJvglPV0Cwt4pVxAPYsCS7y0gNc1f
         PxIGBhIyg2mUH06ZQuxvedpuTg5o4VDdiYUXe5sshD06ODmuzC6FijleMcDJVzZKpZhe
         6Yo/uiDXdGtwGbcvf3pQmgj80uPWp5XakcPUPzTLqOUGm8W+VHmOlvLRx3ZS4hg6nJMR
         gRzwp323X2wrdy5b+UuyYma/1fbjoSJ+DZgQoMrGnnxy0ZwymG/zR0ixStmFi+DrR4OP
         ek6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694411671; x=1695016471;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HVCfoYEBhI0078LM+zjKbwdJdpqXOANxQGWWW08MDLI=;
        b=havKiG3v0hQP3ViB4dI9ZAzwAVRHfDJMaU+B7afSMi1QbJIu41IAIyQdjbND5czfG+
         h3duMd20fjIwvvBE73VIOCOhnqxRGWeL11f5w1r2OY3GSEfaoOIs7VMZmYX2InDIPFL0
         k+HIUj8mIcs8voGt8bBO5X6jMxSLo/tmQtlZBkedXGMQQNIX9y8+nlSkqAcLYzgZjgVZ
         UXTvPyVeBZq4bRoY7V2B5JwBqzm92luDguPTmJp14knae/e84syD99BXfoiAKxguwmut
         ixru/8oWZLvjvjlVEuQ/rXkklDoCVpmIo0xuKSXyP2mAC7ut7jp4szCRT9xWakdkkxIi
         1nYA==
X-Gm-Message-State: AOJu0Yxboj47XaWxehbw7Ie3C7DLeLLV1T8THpuoIrvaivQtMt01ZvHX
        qJchubGEXpF2NMg/CptCfcAnuBfgWks=
X-Google-Smtp-Source: AGHT+IF0tLKTeJ5Jf65fovlyejibB6mN0nHF5JdxbfkCl2wuv4jpuiWNh4TCxrsp7BAuwLNQIS+L6A==
X-Received: by 2002:a05:6a20:158d:b0:14c:e8d4:fb3e with SMTP id h13-20020a056a20158d00b0014ce8d4fb3emr8669491pzj.43.1694411671443;
        Sun, 10 Sep 2023 22:54:31 -0700 (PDT)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id j3-20020a170902c08300b001c1f016015esm5547383pld.84.2023.09.10.22.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Sep 2023 22:54:30 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH RFC libnetfilter_queue] doc: Get rid of DEPRECATED tag (Work In Progress)
Date:   Mon, 11 Sep 2023 15:54:25 +1000
Message-Id: <20230911055425.8524-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a call for comments on how we want the documentation to look.
In conjunction with the git diff, readers may find it helpful to apply the patch
in a temporary branch and check how the web page / man pages look.
To get web & man pages, do something like

./configure --enable-html-doc; make -j; firefox doxygen/html/index.html
MANPATH=$PWD/doxygen/man:$MANPATH

Some changes are documented below - I'll post more later

--- Preparation for man 7 libnetfilter_queue
The /anchor / <h1> ... </h1> combo is in preparation for making
libnetfilter_queue.7 from the main page. mainpage is morphed to a group
(temporarily) so all \section lines have to be changed to <h1> because \section
doesn't work in a group. The appearance stays the same.

---1st stab at commit message for finished patch
libnetfilter_queue effectively supports 2 ABIs, the older being based on
libnfnetlink and the newer on libmnl. The libnetfilter_queue-based functions
were tagged DEPRECATED but there is a fading hope to re-implement these
functions using libmnl. So change DEPRECATED to "OLD API" and update the main
page to explain stuff.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/libnetfilter_queue.c | 64 +++++++++++++++++++++++++++++-----------
 1 file changed, 46 insertions(+), 18 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index a170143..aae50fc 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -83,15 +83,11 @@
  *
  * To write your own program using libnetfilter_queue, you should start by
  * reading (or, if feasible, compiling and stepping through with *gdb*)
- * nf-queue.c source file.
+ * the **examples/nf-queue.c** source file.
  * Simple compile line:
  * \verbatim
-gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
+gcc -g3 -gdwarf-4 -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
 \endverbatim
- * The doxygen documentation \link LibrarySetup \endlink is Deprecated and
- * incompatible with non-deprecated functions. It is hoped to produce a
- * corresponding non-deprecated (*Current*) topic soon.
- *
  * Somewhat outdated but possibly providing some insight into
  * libnetfilter_queue usage is the following
  * article:
@@ -102,26 +98,58 @@ gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
  * recv() may return -1 and errno is set to ENOBUFS in case that your
  * application is not fast enough to retrieve the packets from the kernel.
  * In that case, you can increase the socket buffer size by means of
- * nfnl_rcvbufsiz(). Although this delays the appearance of ENOBUFS errors,
- * you may hit it again sooner or later. The next section provides some hints
+ * nfnl_rcvbufsiz().
+ * \n
+ * FIXME: libmnl-based programs can increase the *kernel* buffer size using
+ * setsockopt (I've tried this). AFAICS nfnl_rcvbufsiz simply ups the userspace
+ * buffer size.
+ * \n
+ * Although this delays the appearance of ENOBUFS errors,
+ * you may hit it again sooner or later. The
+ * \link perf
+ * Performance
+ * \endlink
+ * section below provides some hints
  * on how to obtain the best performance for your application.
  *
- * \section perf Performance
+ * \anchor oldabi
+ * <h1>Why there are 2 ABIs</h1>
+ * Essentially, there are 2 ABIs because there are 2 underlying libraries.
+ * This is a historical accident of the development process.
+ * \n
+ * The original *libnfnetlink* library was only ever intended for use by the
+ * project developers and libnetfilter_queue contains wrapper functions for all
+ * relevant
+ * libnfnetlink entry points.
+ * \n
+ * The current *libmnl* library is designed to be used by developers and
+ * end-users alike. Programs written using the libmnl-based API consist of a mix
+ * of libmnl and libnetfilter_queue calls. libnetfilter_queue contains helpers
+ * for some libmnl calls and includes an optional *pktbuff* subsystem to assist
+ * with packet parsing and mangling.
+ * \n
+ * The pktbuff subsystem was sponsored by Vyatta Inc.
+ * <https://www.crunchbase.com/organization/vyatta>
+ *
+ * \anchor perf
+ * <h1>Performance</h1>
  * To improve your libnetfilter_queue application in terms of performance,
  * you may consider the following tweaks:
  *
  * - increase the default socket buffer size by means of nfnl_rcvbufsiz().
+ * FIXME: do we want to keep this? libmnl-based programs can declare a big buffer
  * - set nice value of your process to -20 (maximum priority).
  * - set the CPU affinity of your process to a spare core that is not used
  * to handle NIC interruptions.
  * - set NETLINK_NO_ENOBUFS socket option to avoid receiving ENOBUFS errors
  * (requires Linux kernel >= 2.6.30).
- * - see --queue-balance option in NFQUEUE target for multi-threaded apps
- * (it requires Linux kernel >= 2.6.31).
- * - consider using fail-open option see nfq_set_queue_flags() (it requires
+ * - see QUEUE_FLAG "fanout" in QUEUE STATEMENT in **man
+ * nft** for multi-threaded apps
+ * (requires Linux kernel >= 2.6.31).
+ * - consider using fail-open option see nfq_set_queue_flags() (requires
  *  Linux kernel >= 3.6)
- * - increase queue max length with nfq_set_queue_maxlen() to resist to packets
- * burst
+ * - increase queue max length with nfq_set_queue_maxlen() to resist packet
+ * bursts
  */
 
 struct nfq_handle
@@ -237,7 +265,7 @@ struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
 
 /**
  *
- * \defgroup Queue Queue handling [DEPRECATED]
+ * \defgroup Queue Queue handling [OLD API]
  *
  * Once libnetfilter_queue library has been initialised (See
  * \link LibrarySetup \endlink), it is possible to bind the program to a
@@ -325,7 +353,7 @@ int nfq_fd(struct nfq_handle *h)
  */
 
 /**
- * \defgroup LibrarySetup Library setup [DEPRECATED]
+ * \defgroup LibrarySetup Library setup [OLD API]
  *
  * Library initialisation is made in two steps.
  *
@@ -967,7 +995,7 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh, uint32_t id,
  *************************************************************/
 
 /**
- * \defgroup Parsing Message parsing functions [DEPRECATED]
+ * \defgroup Parsing Message parsing functions [OLD API]
  *
  * \manonly
 .SH SYNOPSIS
@@ -1375,7 +1403,7 @@ do {								\
 } while (0)
 
 /**
- * \defgroup Printing Printing [DEPRECATED]
+ * \defgroup Printing Printing [OLD API]
  *
  * \manonly
 .SH SYNOPSIS
-- 
2.35.8

