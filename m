Return-Path: <SRS0=4Kr+=Y2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E43C47E49
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Nov 2019 10:30:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE38421726
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Nov 2019 10:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfKBKaL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Nov 2019 06:30:11 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:54960 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726163AbfKBKaL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Nov 2019 06:30:11 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id C5E3D43F78F
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Nov 2019 21:29:52 +1100 (AEDT)
Received: (qmail 17961 invoked by uid 501); 2 Nov 2019 10:29:52 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 2/2] src: doc: Update the Main Page to be nft-focussed
Date:   Sat,  2 Nov 2019 21:29:52 +1100
Message-Id: <20191102102952.17912-3-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20191102102952.17912-1-duncan_roe@optusnet.com.au>
References: <20191102102952.17912-1-duncan_roe@optusnet.com.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=MeAgGD-zjQ4A:10 a=PO7r1zJSAAAA:8
        a=3HDBlxybAAAA:8 a=9f_XAzr4AAAA:8 a=j9f4X28PHRRZGwzI-EYA:9
        a=laEoCiVfU_Unz3mSdgXN:22 a=PqKS1jQba-4VMEoqN8_h:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Updated:

 src/libnetfilter_queue.c: - ip_queue withdrawn in kernel 3.5
                           - Update some URLs
                           - libmnl is a dependency
                           - Multiword section headers need a tag
                           - Re-work cinematic to refer to nft
                           - Some native English speaker updates
                             (e.g. enqueue *is* a word)
                           - Prefer nf-queue.c over deprecated doxygen doco

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/libnetfilter_queue.c | 65 +++++++++++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 26 deletions(-)

diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 0ab5030..7033174 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -39,49 +39,62 @@
  *
  * libnetfilter_queue is a userspace library providing an API to packets that
  * have been queued by the kernel packet filter. It is is part of a system that
- * deprecates the old ip_queue / libipq mechanism.
+ * replaces the old ip_queue / libipq mechanism (withdrawn in kernel 3.5).
  *
  * libnetfilter_queue homepage is:
- * 	http://netfilter.org/projects/libnetfilter_queue/
+ * 	https://netfilter.org/projects/libnetfilter_queue/
  *
- * \section Dependencies
- * libnetfilter_queue requires libnfnetlink and a kernel that includes the
- * nfnetlink_queue subsystem (i.e. 2.6.14 or later).
+ * \section deps Dependencies
+ * libnetfilter_queue requires libmnl, libnfnetlink and a kernel that includes
+ * the Netfilter NFQUEUE over NFNETLINK interface (i.e. 2.6.14 or later).
  *
- * \section Main Features
+ * \section features Main Features
  *  - receiving queued packets from the kernel nfnetlink_queue subsystem
- *  - issuing verdicts and/or reinjecting altered packets to the kernel
+ *  - issuing verdicts and possibly reinjecting altered packets to the kernel
  *  nfnetlink_queue subsystem
  *
- * The cinematic is the following: When an iptables rules with target NFQUEUE
- * matches, the kernel en-queued the packet in a chained list. It then format
- * a nfnetlink message and sends the information (packet data , packet id and
- * metadata) via a socket to the software connected to the queue. The software
- * can then read the message.
- *
- * To remove the packet from the queue, the userspace software must issue a
- * verdict asking kernel to accept or drop the packet. Userspace can also alter
- * the packet. Verdict can be done in asynchronous manner, as the only needed
+ * The cinematic is the following: When an nft rule with action **queue**
+ * matches, the kernel terminates the current nft chain and enqueues the packet
+ * in a chained list. It then formats
+ * and sends an nfnetlink message containing the packet id and whatever
+ * information the userspace program configured to receive (packet data
+ * and/or metadata) via a socket to the userspace program.
+ *
+ * The userspace program must issue a verdict advising the kernel to **accept**
+ * or **drop** the packet. Either verdict takes the packet off the queue:
+ * **drop** discards the packet while
+ * **accept** passes it on to the next chain.
+ * Userspace can also alter
+ * packet contents or metadata (e.g. packet mark, contrack mark).
+ * Verdict can be done in asynchronous manner, as the only needed
  * information is the packet id.
  *
- * When a queue is full, packets that should have been en-queued are dropped by
- * kernel instead of being en-queued.
+ * When a queue is full, packets that should have been enqueued are dropped by
+ * kernel instead of being enqueued.
  *
- * \section Git Tree
- * The current development version of libnetfilter_queue can be accessed
- * at https://git.netfilter.org/cgi-bin/gitweb.cgi?p=libnetfilter_queue.git;a=summary.
+ * \section git Git Tree
+ * The current development version of libnetfilter_queue can be accessed at
+ * https://git.netfilter.org/libnetfilter_queue.
  *
- * \section Privileges
+ * \section privs Privileges
  * You need the CAP_NET_ADMIN capability in order to allow your application
  * to receive from and to send packets to kernel-space.
  *
- * \section Using libnetfilter_queue
+ * \section using Using libnetfilter_queue
  * 
- * To write your own program using libnetfilter_queue, you should start by reading
- * the doxygen documentation (start by \link LibrarySetup \endlink page) and
+ * To write your own program using libnetfilter_queue, you should start by
+ * reading (or, if feasible, compiling and stepping through with *gdb*)
  * nf-queue.c source file.
+ * Simple compile line:
+ * \verbatim
+gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
+\endverbatim
+ * The doxygen documentation \link LibrarySetup \endlink is Deprecated and
+ * incompatible with non-deprecated functions. It is hoped to produce a
+ * corresponding non-deprecated (*Current*) topic soon.
  *
- * Another source of information on libnetfilter_queue usage is the following
+ * Somewhat outdated but possibly providing some insight into
+ * libnetfilter_queue usage is the following
  * article:
  *  https://home.regit.org/netfilter-en/using-nfqueue-and-libnetfilter_queue/
  *
-- 
2.14.5

