Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39BA2C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Mar 2022 09:42:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241723AbiCUJng (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Mar 2022 05:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244989AbiCUJnf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Mar 2022 05:43:35 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 90BC05B3D1
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Mar 2022 02:42:09 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id DBAFC60212;
        Mon, 21 Mar 2022 10:39:26 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, sven.auhagen@voleatech.de
Subject: [PATCH nf-next] netfilter: nf_conntrack_tcp: preserve liberal flag in tcp options
Date:   Mon, 21 Mar 2022 10:42:05 +0100
Message-Id: <20220321094205.63121-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When tcp_options is called all flags are cleared.
When the IP_CT_TCP_FLAG_BE_LIBERAL is set it should be preserved
otherwise such connections will fail in the window check.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Supersedes: https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220318144939.69465-1-pablo@netfilter.org/ which is not correct, it breaks TCP FIN handling.

 net/netfilter/nf_conntrack_proto_tcp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index d1582b888c0d..d8599ab5f767 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -342,7 +342,7 @@ static void tcp_options(const struct sk_buff *skb,
 		return;
 
 	state->td_scale =
-	state->flags = 0;
+	state->flags &= IP_CT_TCP_FLAG_BE_LIBERAL;
 
 	while (length > 0) {
 		int opcode=*ptr++;
@@ -873,7 +873,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	struct nf_tcp_net *tn = nf_tcp_pernet(net);
 	struct nf_conntrack_tuple *tuple;
 	enum tcp_conntrack new_state, old_state;
-	unsigned int index, *timeouts;
+	unsigned int index, flags, *timeouts;
 	enum ip_conntrack_dir dir;
 	const struct tcphdr *th;
 	struct tcphdr _tcph;
@@ -968,8 +968,10 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			ct->proto.tcp.last_flags &= ~IP_CT_EXP_CHALLENGE_ACK;
 			ct->proto.tcp.seen[ct->proto.tcp.last_dir].flags =
 				ct->proto.tcp.last_flags;
+			flags = ct->proto.tcp.seen[dir].flags;
 			memset(&ct->proto.tcp.seen[dir], 0,
 			       sizeof(struct ip_ct_tcp_state));
+			ct->proto.tcp.seen[dir].flags = flags & IP_CT_TCP_FLAG_BE_LIBERAL;
 			break;
 		}
 		ct->proto.tcp.last_index = index;
-- 
2.30.2

