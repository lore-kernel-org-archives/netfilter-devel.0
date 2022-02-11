Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDCACC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Feb 2022 23:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344326AbiBKX4T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Feb 2022 18:56:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245294AbiBKX4S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Feb 2022 18:56:18 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9BC8FD62
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Feb 2022 15:56:15 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 797646019D;
        Sat, 12 Feb 2022 00:55:54 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     eric.dumazet@gmail.com, fw@strlen.de
Subject: [PATCH nf] netfilter: xt_socket: missing ifdef CONFIG_IP6_NF_IPTABLES dependency
Date:   Sat, 12 Feb 2022 00:56:09 +0100
Message-Id: <20220211235609.218507-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nf_defrag_ipv6_disable() requires CONFIG_IP6_NF_IPTABLES.

Fixes: 75063c9294fb ("netfilter: xt_socket: fix a typo in socket_mt_destroy()")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_socket.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 662e5eb1cc39..7013f55f05d1 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -220,8 +220,10 @@ static void socket_mt_destroy(const struct xt_mtdtor_param *par)
 {
 	if (par->family == NFPROTO_IPV4)
 		nf_defrag_ipv4_disable(par->net);
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 	else if (par->family == NFPROTO_IPV6)
 		nf_defrag_ipv6_disable(par->net);
+#endif
 }
 
 static struct xt_match socket_mt_reg[] __read_mostly = {
-- 
2.30.2

