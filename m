Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0453BC4167D
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 Nov 2023 06:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjKLG7e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 Nov 2023 01:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjKLG7d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Nov 2023 01:59:33 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160B72D6B
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Nov 2023 22:59:30 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id 46e09a7af769-6d645cfd238so1241380a34.2
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Nov 2023 22:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699772369; x=1700377169; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xbZSGy1GuXq7Yi0cRPHMpud49LlpnqvNjNCY/i2U5qE=;
        b=LYP7xYOTuANj+f8XuHP2lPAeYDeh7IvzS2u5H78AWNT5SA+o17Bfhqm0cgsxSlsP8W
         vwvimcSnI/CVjoba75cC5PXtwZLtWHkPEam9coF503TKz6RAJS75/R10ogbAtEA+Bd4n
         89Ow4KROJy0VnE7W9+cHk7M1JJ3oMX6cmVk4tGLb+tyusse3k/w6jesOAajZO0GXs+ad
         ER21OJbHuJ9NDv8UsFgaBbBcY0Y4SxAMlGJ4uRStW8Ahsdg4xXL5fPKmxgwAjhXwYdIS
         JdnT5GzGcQBp8lVPjumH4zmD3W92f4S3jhDmTyuEns78nYUv86EEYY3wz8sQDp9frZgP
         +baw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699772369; x=1700377169;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xbZSGy1GuXq7Yi0cRPHMpud49LlpnqvNjNCY/i2U5qE=;
        b=aYWB5HuBPrnTY7GJFDUalas8He1wRGq/F+IyVeeBLvhkahRF7o3E7DZmt8rrJVbWXV
         QCgiU5AjqPr0bVRWFarFKmcrjkUnOwJsB++NZRAJjlKpmO5JEaxtNQfWXcpQXFH5+koW
         GInrLB8psd69v048Z97Vpeh0KG3VoCpSr4IN1F8ZURJnyvcEmKhrbdIPKAVxZHyxryio
         P+E7MK/uipk3ecn8Kxyg526a4BeLIbTH15c4fdOA9brRc7BzPmvfQgoD8diVWPdUtjVt
         Eo5QeTY4e3ZbTpXqOWgvPhekWB+psE923yH6XMWIfo4vLX6Tx77n4ZySStWKgqgs20q2
         /P+g==
X-Gm-Message-State: AOJu0YzyEGIbMnvmKYYhJXWXq9qIQ3YMYMui1PuySgqBj0aVV3CV6Blr
        TF+IGAeJUMuhT+tcuryqknqaRKnvMG8=
X-Google-Smtp-Source: AGHT+IGrePm5zSgtv6X5dnemjEfsLNuc+/r2IMoBisAAhvp2eG/brf4VEskpPM4tj/APWkb9QwHZlw==
X-Received: by 2002:a9d:7ac5:0:b0:6d6:4972:b7ae with SMTP id m5-20020a9d7ac5000000b006d64972b7aemr4559971otn.13.1699772369232;
        Sat, 11 Nov 2023 22:59:29 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id b4-20020a170902d30400b001c9bfd20d0csm2159363plc.124.2023.11.11.22.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Nov 2023 22:59:28 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 1/1] doc: First update for libnfnetlink-based API over libmnl
Date:   Sun, 12 Nov 2023 17:59:22 +1100
Message-Id: <20231112065922.3414-2-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <20231112065922.3414-1-duncan_roe@optusnet.com.au>
References: <20231112065922.3414-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 - make it clear at the outset that there are 2 APIs
 - remove DEPRECATED tags, instead insert warning at top of these pages
 - update gdb options in compile line
 - remove the Library Setup line that follows
 - re-work how to increase default socket buffer size
   (i.e. other than by calling nfnl_rcvbufsiz()).

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/libnetfilter_queue.c | 56 +++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 18 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index bf67a19..54db391 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -41,12 +41,22 @@
  * libnetfilter_queue is a userspace library providing an API to packets that
  * have been queued by the kernel packet filter. It is is part of a system that
  * replaces the old ip_queue / libipq mechanism (withdrawn in kernel 3.5).
+ * \n
+ * libnetfilter_queue in fact offers 2 different APIs:
+ *   -# The modern API which provides helper functions for some
+ * libmnl functions. Users call other libmnl functions directly.
+ * The documentation calls this the **mnl** API.
+ *   -# An older API which provided wrappers for all relevant
+ * libnfnetlink functions.
+ * This API uses libmnl calls now, but its use in new software is discouraged.
+ * The documentation calls this the **nfnl** API.
+ * libnfnetlink itself is deprecated and will eventually be removed.
  *
  * libnetfilter_queue homepage is:
  * 	https://netfilter.org/projects/libnetfilter_queue/
  *
  <h1>Dependencies</h1>
- * libnetfilter_queue requires libmnl, libnfnetlink and a kernel that includes
+ * libnetfilter_queue requires libmnl and a kernel that includes
  * the Netfilter NFQUEUE over NFNETLINK interface (i.e. 2.6.14 or later).
  *
  * <h1>Main Features</h1>
@@ -86,18 +96,8 @@
  * nf-queue.c source file.
  * Simple compile line:
  * \verbatim
-gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
+gcc -g3 -gdwarf-4 -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
 \endverbatim
- *The doxygen documentation
- * \htmlonly
-<a class="el" href="group__LibrarySetup.html">LibrarySetup </a>
-\endhtmlonly
- * \manonly
-\fBLibrarySetup\fP\
-\endmanonly
- * is Deprecated and
- * incompatible with non-deprecated functions. It is hoped to produce a
- * corresponding non-deprecated (*Current*) topic soon.
  *
  * Somewhat outdated but possibly providing some insight into
  * libnetfilter_queue usage is the following
@@ -109,7 +109,7 @@ gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
  * recv() may return -1 and errno is set to ENOBUFS in case that your
  * application is not fast enough to retrieve the packets from the kernel.
  * In that case, you can increase the socket buffer size by means of
- * nfnl_rcvbufsiz(). Although this delays the appearance of ENOBUFS errors,
+ * setsocketopt(). Although this delays the appearance of ENOBUFS errors,
  * you may hit it again sooner or later. The next section provides some hints
  * on how to obtain the best performance for your application.
  *
@@ -117,7 +117,11 @@ gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
  * To improve your libnetfilter_queue application in terms of performance,
  * you may consider the following tweaks:
  *
- * - increase the default socket buffer size by means of nfnl_rcvbufsiz().
+ * - increase the default socket buffer size.
+ * Use setsocketopt() with SOL_SOCKET and SO_RCVBUFFORCE on the netlink socket
+ * fd returned by mnl_socket_get_fd()
+ * (software using the old nfnl API calls nfq_fd()).
+ * Software calling nfnl_rcvbufsiz() will continue to be supported.
  * - set nice value of your process to -20 (maximum priority).
  * - set the CPU affinity of your process to a spare core that is not used
  * to handle NIC interruptions.
@@ -247,7 +251,11 @@ struct nfnl_handle *nfq_nfnlh(struct nfq_handle *h)
 
 /**
  *
- * \defgroup Queue Queue handling [DEPRECATED]
+ * \defgroup Queue Queue handling
+ *
+ * \warning
+ * This page describes functions from the old nfnl API.
+ * Consider using the mnl API for new projects.
  *
  * Once libnetfilter_queue library has been initialised (See
  * \link LibrarySetup \endlink), it is possible to bind the program to a
@@ -335,7 +343,11 @@ int nfq_fd(struct nfq_handle *h)
  */
 
 /**
- * \defgroup LibrarySetup Library setup [DEPRECATED]
+ * \defgroup LibrarySetup Library setup
+ *
+ * \warning
+ * This page describes functions from the old nfnl API.
+ * Consider using the mnl API for new projects.
  *
  * Library initialisation is made in two steps.
  *
@@ -977,7 +989,11 @@ int nfq_set_verdict_mark(struct nfq_q_handle *qh, uint32_t id,
  *************************************************************/
 
 /**
- * \defgroup Parsing Message parsing functions [DEPRECATED]
+ * \defgroup Parsing Message parsing functions
+ *
+ * \warning
+ * This page describes functions from the old nfnl API.
+ * Consider using the mnl API for new projects.
  *
  * \manonly
 .SH SYNOPSIS
@@ -1385,7 +1401,11 @@ do {								\
 } while (0)
 
 /**
- * \defgroup Printing Printing [DEPRECATED]
+ * \defgroup Printing Printing
+ *
+ * \warning
+ * This page describes functions from the old nfnl API.
+ * Consider using the mnl API for new projects.
  *
  * \manonly
 .SH SYNOPSIS
-- 
2.35.8

