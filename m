Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1B8C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 May 2022 16:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234429AbiEPQY4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 May 2022 12:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233696AbiEPQYz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 May 2022 12:24:55 -0400
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2a11:7980:3::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B2128E3A
        for <netfilter-devel@vger.kernel.org>; Mon, 16 May 2022 09:24:54 -0700 (PDT)
From:   vincent@systemli.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1652718293;
        bh=wh1hIvnzVfhCVkufTjnnISPaL9qOhTZ36NOtwoZkII4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wGxNPsF87o7lqYT3UM0KUub7zguvRORpoBKRTJPrqfW9d1QsXYD+H1V3AhxNpHF9U
         RGzmpT4NRHJAMC4EaZlJGs+sQ+RNXkD/TD0CnidKT79MDN60tCI+3kATS086ReaSS7
         oe0dLd97P3PZx6hBsCfzJh50gKueztm3TGdc/ED0W16Qrr6/qNGWZELSpQ+WTfonmu
         BssYt/IPm+0MoEVQyzp2eGqAUvDdw7oo9UkWlxICH0PRp/RlSrEv0PYnIWuwpEgDZd
         lEiHGprlJ+qaKqEcm7h2YvXFjiBHyI6zi5eZi+RDWO5xZH80OtGc53KSaJ6NSg/qGa
         leyq76GT0FGVQ==
To:     netfilter-devel@vger.kernel.org
Cc:     Nick Hainke <vincent@systemli.org>
Subject: [PATCH] xtables: fix compilation with musl
Date:   Mon, 16 May 2022 18:24:48 +0200
Message-Id: <20220516162448.24800-1-vincent@systemli.org>
In-Reply-To: <CANP3RGfRcx-ykxVUMGE+Nw6vwC6OPQDq0R+BE36aJ=_MqTCHGQ@mail.gmail.com>
References: <CANP3RGfRcx-ykxVUMGE+Nw6vwC6OPQDq0R+BE36aJ=_MqTCHGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Nick Hainke <vincent@systemli.org>

Only include <linux/if_ether.h> if bionic is used.

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
index 96fd783a..7dd7729d 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -45,7 +45,9 @@
 
 #include <xtables.h>
 #include <limits.h> /* INT_MAX in ip_tables.h/ip6_tables.h */
+#ifdef __BIONIC__
 #include <linux/if_ether.h> /* ETH_ALEN */
+#endif
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <libiptc/libxtc.h>
-- 
2.36.1

