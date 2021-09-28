Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 994F6C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Sep 2021 09:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75161610E5
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Sep 2021 09:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239872AbhI1J51 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Sep 2021 05:57:27 -0400
Received: from mail.netfilter.org ([217.70.188.207]:56914 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240026AbhI1J5Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Sep 2021 05:57:25 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id D04B663EA7;
        Tue, 28 Sep 2021 11:54:20 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        lukas@wunner.de, daniel@iogearbox.net, kadlec@netfilter.org,
        fw@strlen.de, ast@kernel.org, edumazet@google.com, tgraf@suug.ch,
        nevola@gmail.com, john.fastabend@gmail.com, willemb@google.com
Subject: [PATCH nf-next v5 1/6] netfilter: Rename ingress hook include file
Date:   Tue, 28 Sep 2021 11:55:33 +0200
Message-Id: <20210928095538.114207-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210928095538.114207-1-pablo@netfilter.org>
References: <20210928095538.114207-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

Prepare for addition of a netfilter egress hook by renaming
<linux/netfilter_ingress.h> to <linux/netfilter_netdev.h>.

The egress hook also necessitates a refactoring of the include file,
but that is done in a separate commit to ease reviewing.

No functional change intended.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/{netfilter_ingress.h => netfilter_netdev.h} | 0
 net/core/dev.c                                            | 2 +-
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename include/linux/{netfilter_ingress.h => netfilter_netdev.h} (100%)

diff --git a/include/linux/netfilter_ingress.h b/include/linux/netfilter_netdev.h
similarity index 100%
rename from include/linux/netfilter_ingress.h
rename to include/linux/netfilter_netdev.h
diff --git a/net/core/dev.c b/net/core/dev.c
index 7ee9fecd3aff..a92823710a25 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -140,7 +140,7 @@
 #include <linux/if_macvlan.h>
 #include <linux/errqueue.h>
 #include <linux/hrtimer.h>
-#include <linux/netfilter_ingress.h>
+#include <linux/netfilter_netdev.h>
 #include <linux/crash_dump.h>
 #include <linux/sctp.h>
 #include <net/udp_tunnel.h>
-- 
2.30.2

