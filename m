Return-Path: <SRS0=eJXe=SP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D563FC10F11
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 22:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99DB9218C3
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 22:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555195503;
	bh=8QSDTp9CjNirtU5GpGMiJzIZLOjbkJLPoXQuifAKaUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=CCTr8RVq1AzcqbE9WQXiLK7ibXw+J8F5n+eLzRDk8DwT3oimwCxX8CmSHfxlFw/MI
	 JkwHOHGkHW2bqPUlh99fbNW7HDz8MYj13WKZkCgqJVGp19+F3Xf6HzS+za2KZkiKMo
	 CnswuJgNXYDUna4FWvX8ig1WPoliZP+Rbq1+hkP4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfDMWpC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Apr 2019 18:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727301AbfDMWo6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Apr 2019 18:44:58 -0400
Received: from sinanubuntu1604.mkjiurmyylmellclgttazegk5f.bx.internal.cloudapp.net (unknown [40.117.159.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF4CF21721;
        Sat, 13 Apr 2019 22:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555195497;
        bh=8QSDTp9CjNirtU5GpGMiJzIZLOjbkJLPoXQuifAKaUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJ28aDLfYxbce4yt/gI3hs/o9KQ3+s82zOiZ0Fx+M+gLFGlI+rD/WlcGgDwE+Fueh
         Yd6pxQEux+aUi4xNEGtJD3T9fOgRDzW5HNfTqhNBzVJkbVkNoe5oaY/mhon2W1AQKS
         y7GDEzQhfsVkXho/KuseqfqE2O+j/jEfurAf1AQQ=
From:   Sinan Kaya <okaya@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     josh@joshtriplett.org, keescook@chromium.org,
        Sinan Kaya <okaya@kernel.org>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org (open list:NETFILTER),
        coreteam@netfilter.org (open list:NETFILTER),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH v5 5/5] net: Replace CONFIG_DEBUG_KERNEL with CONFIG_DEBUG_MISC
Date:   Sat, 13 Apr 2019 22:44:38 +0000
Message-Id: <20190413224438.10802-6-okaya@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190413224438.10802-1-okaya@kernel.org>
References: <20190413224438.10802-1-okaya@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

CONFIG_DEBUG_KERNEL should not impact code generation. Use the newly
defined CONFIG_DEBUG_MISC instead to keep the current code.

Signed-off-by: Sinan Kaya <okaya@kernel.org>
Acked-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 net/netfilter/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 93aaec3a54ec..cac3bad47f5e 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -162,7 +162,7 @@ nf_hook_entries_grow(const struct nf_hook_entries *old,
 
 static void hooks_validate(const struct nf_hook_entries *hooks)
 {
-#ifdef CONFIG_DEBUG_KERNEL
+#ifdef CONFIG_DEBUG_MISC
 	struct nf_hook_ops **orig_ops;
 	int prio = INT_MIN;
 	size_t i = 0;
-- 
2.21.0

