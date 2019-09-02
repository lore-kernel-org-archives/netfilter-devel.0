Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBBEC3A5A5
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3F0F216C8
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:06:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="nTksOkJp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfIBXG4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 19:06:56 -0400
Received: from kadath.azazel.net ([81.187.231.250]:43564 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbfIBXGy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 19:06:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OMdPVB4nABAr2ckXqWNbKVCrMuC48xAXSNmo3Xnba3s=; b=nTksOkJprPf8Zugyc3vy5mgd1c
        hjeJmOo9x9Pding4172MK4pqiB3VZ97ucOLylUSIwmdUnW2qIe9ls00j1DzWCTWEP9ypBef//M8J2
        3gWW3J/3/VfE1v3CMHdCfC5MMMrCfdqBgQLklcUd0dL4CMGYF5Iqur3l+CvGmCe+rtJgXVwDxfwBZ
        9VKn9fsTlg9np06k/UprbzqIwPKfiBsjz3q7W1r5AOK5SUR5yrIjVqEnUcmsWkjeAdW211cBTpfFZ
        YVq+ddPQeA0ELTJhoXCnnneGYszcJfQosCtFNcnky9zrV+xUTR1LkWsCGQ1i7sqbxfgQVZu29nqIp
        0QEJEKxw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4vPP-0004la-Si; Tue, 03 Sep 2019 00:06:51 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 09/30] netfilter: remove unused includes.
Date:   Tue,  3 Sep 2019 00:06:29 +0100
Message-Id: <20190902230650.14621-10-jeremy@azazel.net>
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

Some header-files are included in places where they are not needed.
Remove them.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 1 -
 net/ipv6/netfilter/nf_socket_ipv6.c        | 1 -
 net/netfilter/xt_physdev.c                 | 1 -
 3 files changed, 3 deletions(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 4f5444d2a526..c9ce321fcac1 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -17,7 +17,6 @@
 #include <net/netfilter/nf_conntrack_bridge.h>
 
 #include <linux/netfilter/nf_tables.h>
-#include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #include <net/netfilter/nf_tables.h>
 
 #include "../br_private.h"
diff --git a/net/ipv6/netfilter/nf_socket_ipv6.c b/net/ipv6/netfilter/nf_socket_ipv6.c
index 437d95545c31..b9df879c48d3 100644
--- a/net/ipv6/netfilter/nf_socket_ipv6.c
+++ b/net/ipv6/netfilter/nf_socket_ipv6.c
@@ -12,7 +12,6 @@
 #include <net/sock.h>
 #include <net/inet_sock.h>
 #include <net/inet6_hashtables.h>
-#include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #include <net/netfilter/nf_socket.h>
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <net/netfilter/nf_conntrack.h>
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index ead7c6022208..4f311e5703e8 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -10,7 +10,6 @@
 #include <linux/netfilter_bridge.h>
 #include <linux/netfilter/xt_physdev.h>
 #include <linux/netfilter/x_tables.h>
-#include <net/netfilter/br_netfilter.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Bart De Schuymer <bdschuym@pandora.be>");
-- 
2.23.0.rc1

