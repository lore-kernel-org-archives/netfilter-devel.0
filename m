Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E979C3A59E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA29122CF7
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="FzhLzRaM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbfIBXcW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 19:32:22 -0400
Received: from kadath.azazel.net ([81.187.231.250]:44034 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727733AbfIBXcW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 19:32:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pdyHo8ieFdhGkHwIfMPc7UK4jX427NsdvAJFCmOyDy8=; b=FzhLzRaMXA3FCo8P5DkFCSS8PO
        /24m3GvisJ0UDRPBPHOTleGNv2tjyQj9zyWKsBbmHU9xqM/sXRwK1MtZFVDujCSnQKcgJUQziEXWf
        pKZLccPsbN6fC8yFILsmC3sKlilWl4ioonuNNIysqrP+wHcdXGTuYGNmQUYW8sx2e7SR2bufuLPpl
        7Qbo5fB7FF9D0Ol5CKwedF50uZs+WDYAAPAwHQx+mTNV/fsP2DUhFC6A7gGnNEk7xs/m9t/nIFkTP
        kPKi73rL+nvNAG8r5auQt5xphkYuuuMiZzxR0RXUMqv6IjFBSh3hM0M7BYcgoEX67oMagXz6Fs8sU
        eEykHYBw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4vPQ-0004la-Lt; Tue, 03 Sep 2019 00:06:52 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 14/30] netfilter: remove superfluous header.
Date:   Tue,  3 Sep 2019 00:06:34 +0100
Message-Id: <20190902230650.14621-15-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190902230650.14621-1-jeremy@azazel.net>
References: <20190902230650.14621-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nf_conntrack_icmpv6.h contains two object macros which duplicate macros
in linux/icmpv6.h.  The latter definitions are also visible wherever it
is included, so remove it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 .../net/netfilter/ipv6/nf_conntrack_icmpv6.h  | 21 -------------------
 include/net/netfilter/nf_conntrack.h          |  1 -
 net/netfilter/nf_conntrack_proto_icmpv6.c     |  1 -
 3 files changed, 23 deletions(-)
 delete mode 100644 include/net/netfilter/ipv6/nf_conntrack_icmpv6.h

diff --git a/include/net/netfilter/ipv6/nf_conntrack_icmpv6.h b/include/net/netfilter/ipv6/nf_conntrack_icmpv6.h
deleted file mode 100644
index c86895bc5eb6..000000000000
--- a/include/net/netfilter/ipv6/nf_conntrack_icmpv6.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * ICMPv6 tracking.
- *
- * 21 Apl 2004: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
- *	- separated from nf_conntrack_icmp.h
- *
- * Derived from include/linux/netfiter_ipv4/ip_conntrack_icmp.h
- */
-
-#ifndef _NF_CONNTRACK_ICMPV6_H
-#define _NF_CONNTRACK_ICMPV6_H
-
-#ifndef ICMPV6_NI_QUERY
-#define ICMPV6_NI_QUERY 139
-#endif
-#ifndef ICMPV6_NI_REPLY
-#define ICMPV6_NI_REPLY 140
-#endif
-
-#endif /* _NF_CONNTRACK_ICMPV6_H */
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 2cc304efe7f9..22275f42f0bb 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -23,7 +23,6 @@
 #include <linux/netfilter/nf_conntrack_dccp.h>
 #include <linux/netfilter/nf_conntrack_sctp.h>
 #include <linux/netfilter/nf_conntrack_proto_gre.h>
-#include <net/netfilter/ipv6/nf_conntrack_icmpv6.h>
 
 #include <net/netfilter/nf_conntrack_tuple.h>
 
diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index 7e317e6698ba..6f9144e1f1c1 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -22,7 +22,6 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
 #include <net/netfilter/nf_conntrack_zones.h>
-#include <net/netfilter/ipv6/nf_conntrack_icmpv6.h>
 #include <net/netfilter/nf_log.h>
 
 static const unsigned int nf_ct_icmpv6_timeout = 30*HZ;
-- 
2.23.0.rc1

