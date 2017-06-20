From: Florian Westphal <fw@strlen.de>
Subject: [PATCH lnf-queue] src: prepare for new release
Date: Wed, 21 Jun 2017 00:28:52 +0200
Message-ID: <20170620222852.19879-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56164 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752646AbdFTW2e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Jun 2017 18:28:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Its been 5 years, things like GSO and NFQA_CT have been in the master
branch for years but no released versions support them.

Needs bump of libversion, we have new interfaces but are compatible with
still compatible with the earlier 1.0.2 release.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Hi, some people are rightfully complaining about new features
 not being in any release, so I suggest we do one soon.

diff --git a/src/Makefile.am b/src/Makefile.am
index 6e5d50325525..9fdccfbd9ea5 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -18,7 +18,7 @@
 # set age to 0.
 # </snippet>
 #
-LIBVERSION=4:0:3
+LIBVERSION=5:0:4
 
 include ${top_srcdir}/Make_global.am
 
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index 211a8ba75d79..69db0e02fc5b 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -658,6 +658,7 @@ EXPORT_SYMBOL(nfq_set_mode);
  * - NFQA_CFG_F_GSO (requires Linux kernel >= 3.10): the kernel will
  *   not normalize offload packets, i.e. your application will need to
  *   be able to handle packets larger than the mtu (up to 64k).
+ *   Normalization is expensive, so this flag should always be set.
  *
  *   If your application validates checksums (e.g., tcp checksum),
  *   then you must also check if the NFQA_SKB_INFO attribute is present.
-- 
2.13.0

