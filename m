Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA02C4708E
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Dec 2022 17:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiLGRpn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 12:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiLGRpl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 12:45:41 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728A456557
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 09:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CbQy84V2ui7XOJWqJr4SUhkk+7zswHQFcSj4f76uwmU=; b=OTCRNsk/36TVjrtvqx2eVN6i6s
        caQQz/PHnhrzFLHO6ltbDmKWnTXtBlm2zIEzo4z9r64/DHewheb+e8wz6DUssygib1B3tJ/isXDcZ
        1Ooeq/8iI/qqmRxCCXcjp/fD5Dp/Ei+07I39L/+sbTgDTwH1sTO2C1cfLQIom61XTnrGCLliPiHub
        V4MwZwh3uifAbynqsnz955CPB4+v5HCT/PCJi4T86Gx5ODDONwDEgDVjgsmXrItcvVLWZpIG5wHJg
        isaT1SS5m+7R0U8H77PJy0rfU1DlS9wDxUgB5FlyUt9/i48FJ5f1CA9DbQ9Xb1Z7v7Cp/mW9NUs1t
        q9hbrvCw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p2yUD-0000in-RY
        for netfilter-devel@vger.kernel.org; Wed, 07 Dec 2022 18:45:37 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 05/11] iptables/Makefile: Reorg variable assignments
Date:   Wed,  7 Dec 2022 18:44:24 +0100
Message-Id: <20221207174430.4335-6-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221207174430.4335-1-phil@nwl.cc>
References: <20221207174430.4335-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce helper variables holding SOURCES, LDADD and CFLAGS used by
both legacy and nft builds. Specify also internal header files, builds
should depend on them. Doing that, reorder lists for clarity.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/Makefile.am | 58 ++++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index acd3ce0c438e1..406147f00f43d 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -6,46 +6,52 @@ AM_LDFLAGS       = ${regular_LDFLAGS}
 
 BUILT_SOURCES =
 
-xtables_legacy_multi_SOURCES  = xtables-legacy-multi.c iptables-xml.c
-xtables_legacy_multi_CFLAGS   = ${AM_CFLAGS}
-xtables_legacy_multi_LDADD    = ../extensions/libext.a
+common_sources = iptables-xml.c xtables-multi.h xshared.c xshared.h
+common_ldadd   = ../extensions/libext.a ../libxtables/libxtables.la -lm
+common_cflags  = ${AM_CFLAGS}
 if ENABLE_STATIC
-xtables_legacy_multi_CFLAGS  += -DALL_INCLUSIVE
+common_cflags += -DALL_INCLUSIVE
 endif
+
+xtables_legacy_multi_SOURCES  = ${common_sources} xtables-legacy-multi.c \
+				iptables-restore.c iptables-save.c
+xtables_legacy_multi_CFLAGS   = ${common_cflags}
+xtables_legacy_multi_LDADD    = ${common_ldadd}
 if ENABLE_IPV4
-xtables_legacy_multi_SOURCES += iptables-standalone.c iptables.c
+xtables_legacy_multi_SOURCES += iptables-standalone.c iptables.c iptables-multi.h
 xtables_legacy_multi_CFLAGS  += -DENABLE_IPV4
 xtables_legacy_multi_LDADD   += ../libiptc/libip4tc.la ../extensions/libext4.a
 endif
 if ENABLE_IPV6
-xtables_legacy_multi_SOURCES += ip6tables-standalone.c ip6tables.c
+xtables_legacy_multi_SOURCES += ip6tables-standalone.c ip6tables.c ip6tables-multi.h
 xtables_legacy_multi_CFLAGS  += -DENABLE_IPV6
 xtables_legacy_multi_LDADD   += ../libiptc/libip6tc.la ../extensions/libext6.a
 endif
-xtables_legacy_multi_SOURCES += xshared.c iptables-restore.c iptables-save.c
-xtables_legacy_multi_LDADD   += ../libxtables/libxtables.la -lm
 
 # iptables using nf_tables api
 if ENABLE_NFTABLES
-xtables_nft_multi_SOURCES  = xtables-nft-multi.c iptables-xml.c
-xtables_nft_multi_CFLAGS   = ${AM_CFLAGS}
-xtables_nft_multi_LDADD    = ../extensions/libext.a ../extensions/libext_ebt.a
-if ENABLE_STATIC
-xtables_nft_multi_CFLAGS  += -DALL_INCLUSIVE
-endif
+xtables_nft_multi_SOURCES  = ${common_sources} xtables-nft-multi.c
+xtables_nft_multi_CFLAGS   = ${common_cflags}
+xtables_nft_multi_LDADD    = ${common_ldadd} \
+			     ../extensions/libext_arpt.a \
+			     ../extensions/libext_ebt.a \
+			     ../extensions/libext4.a \
+			     ../extensions/libext6.a \
+			     ${libmnl_LIBS} ${libnftnl_LIBS} \
+			     ${libnetfilter_conntrack_LIBS}
 xtables_nft_multi_CFLAGS  += -DENABLE_NFTABLES -DENABLE_IPV4 -DENABLE_IPV6
-xtables_nft_multi_SOURCES += xtables-save.c xtables-restore.c \
-				xtables-standalone.c xtables.c nft.c \
-				nft-shared.c nft-ipv4.c nft-ipv6.c nft-arp.c \
-				xtables-monitor.c nft-cache.c \
-				xtables-arp.c \
-				nft-bridge.c nft-cmd.c nft-chain.c \
-				xtables-eb-standalone.c xtables-eb.c \
-				xtables-eb-translate.c \
-				xtables-translate.c
-xtables_nft_multi_LDADD   += ${libmnl_LIBS} ${libnftnl_LIBS} ${libnetfilter_conntrack_LIBS} ../extensions/libext4.a ../extensions/libext6.a ../extensions/libext_ebt.a ../extensions/libext_arpt.a
-xtables_nft_multi_SOURCES += xshared.c
-xtables_nft_multi_LDADD   += ../libxtables/libxtables.la -lm
+xtables_nft_multi_SOURCES += nft.c nft.h \
+			     nft-arp.c nft-ipv4.c nft-ipv6.c \
+			     nft-bridge.c nft-bridge.h \
+			     nft-cache.c nft-cache.h \
+			     nft-chain.c nft-chain.h \
+			     nft-cmd.c nft-cmd.h \
+			     nft-shared.c nft-shared.h \
+			     xtables-monitor.c \
+			     xtables.c xtables-arp.c xtables-eb.c \
+			     xtables-standalone.c xtables-eb-standalone.c \
+			     xtables-translate.c xtables-eb-translate.c \
+			     xtables-save.c xtables-restore.c
 endif
 
 sbin_PROGRAMS    = xtables-legacy-multi
-- 
2.38.0

