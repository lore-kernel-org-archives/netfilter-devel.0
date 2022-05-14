Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 996C1C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 May 2022 16:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbiENQmj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 May 2022 12:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234299AbiENQmh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 May 2022 12:42:37 -0400
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2a11:7980:3::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D196EDF2C
        for <netfilter-devel@vger.kernel.org>; Sat, 14 May 2022 09:42:36 -0700 (PDT)
From:   Nick Hainke <vincent@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1652546011;
        bh=X4H17jH84dYJuM3OAWRba5KEFaDj6w9pcvgLkWroFfI=;
        h=From:To:Cc:Subject:Date:From;
        b=EsVSoPFc7lEewz8NrT/IamGN76K0mvAcUOeUp2gE8j8llvwxBI15uStek79u+B5zR
         jGnirqyxQhzwmiB9T/LjVQFpvAW/8L5leIApfxw43JkGlulfraHVg0k56VcG2mReVL
         l4NZ4cIRuhoFId1tkMjABuVi0YQXy/rVsZEnpyUPbxQIzGPrG4l91R5gOx4qcBzPut
         nJRuNSO78UkCbWLlJpJ14WxCXcE5o61dCLk6KM/SKjZKJIAdoySDU9x8uS+jMKCz/J
         KLiodhSsIlAzskyNNcHPJWv9J9AruvF8D0Yup3Zk0M7Ghkz3VHh+BQplI0DfOurVT9
         EsmeLelVbp2rQ==
To:     netfilter-devel@vger.kernel.org
Cc:     Nick Hainke <vincent@systemli.org>
Subject: [PATCH iptables 1/2] xtables: fix compilation with musl
Date:   Sat, 14 May 2022 18:33:24 +0200
Message-Id: <20220514163325.54266-1-vincent@systemli.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Only include <linux/if_ether.h> if glibc is used.

Fixes errors in the form of:
In file included from /home/nick/openwrt/staging_dir/toolchain-aarch64_cortex-a53_gcc-11.2.0_musl/include/netinet/ether.h:8,
                 from xtables.c:2238:
/home/nick/openwrt/staging_dir/toolchain-aarch64_cortex-a53_gcc-11.2.0_musl/include/netinet/if_ether.h:115:8: error: redefinition of 'struct ethhdr'
  115 | struct ethhdr {
      |        ^~~~~~
In file included from xtables.c:48:
/home/nick/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-mediatek_mt7622/linux-5.15.38/user_headers/include/linux/if_ether.h:168:8: note: originally defined here
  168 | struct ethhdr {
      |        ^~~~~~
make[5]: *** [Makefile:471: libxtables_la-xtables.lo] Error 1

Signed-off-by: Nick Hainke <vincent@systemli.org>
---
 libxtables/xtables.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 96fd783a..1eb22209 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -45,7 +45,9 @@
 
 #include <xtables.h>
 #include <limits.h> /* INT_MAX in ip_tables.h/ip6_tables.h */
+#if defined(__GLIBC__)
 #include <linux/if_ether.h> /* ETH_ALEN */
+#endif
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <libiptc/libxtc.h>
-- 
2.36.1

