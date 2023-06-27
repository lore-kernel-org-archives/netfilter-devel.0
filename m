Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 168B1C001B0
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jun 2023 06:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjF0Gxn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jun 2023 02:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbjF0Gx3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jun 2023 02:53:29 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B1F7326BD;
        Mon, 26 Jun 2023 23:53:11 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 3/6] linux/netfilter.h: fix kernel-doc warnings
Date:   Tue, 27 Jun 2023 08:53:01 +0200
Message-Id: <20230627065304.66394-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230627065304.66394-1-pablo@netfilter.org>
References: <20230627065304.66394-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

kernel-doc does not support DECLARE_PER_CPU(), so don't mark it with
kernel-doc notation.

One comment block is not kernel-doc notation, so just use
"/*" to begin the comment.

Quietens these warnings:

netfilter.h:493: warning: Function parameter or member 'bool' not described in 'DECLARE_PER_CPU'
netfilter.h:493: warning: Function parameter or member 'nf_skb_duplicated' not described in 'DECLARE_PER_CPU'
netfilter.h:493: warning: expecting prototype for nf_skb_duplicated(). Prototype was for DECLARE_PER_CPU() instead
netfilter.h:496: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Contains bitmask of ctnetlink event subscribers, if any.

Fixes: e7c8899f3e6f ("netfilter: move tee_active to core")
Fixes: fdf6491193e4 ("netfilter: ctnetlink: make event listener tracking global")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 0762444e3767..d4fed4c508ca 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -481,7 +481,7 @@ struct nfnl_ct_hook {
 };
 extern const struct nfnl_ct_hook __rcu *nfnl_ct_hook;
 
-/**
+/*
  * nf_skb_duplicated - TEE target has sent a packet
  *
  * When a xtables target sends a packet, the OUTPUT and POSTROUTING
@@ -492,7 +492,7 @@ extern const struct nfnl_ct_hook __rcu *nfnl_ct_hook;
  */
 DECLARE_PER_CPU(bool, nf_skb_duplicated);
 
-/**
+/*
  * Contains bitmask of ctnetlink event subscribers, if any.
  * Can't be pernet due to NETLINK_LISTEN_ALL_NSID setsockopt flag.
  */
-- 
2.30.2

