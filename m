Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D36DC433FE
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Dec 2020 15:16:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C717122C7C
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Dec 2020 15:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439230AbgLLPQ3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Dec 2020 10:16:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727395AbgLLPQ3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Dec 2020 10:16:29 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13F6C0613D3
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Dec 2020 07:15:48 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ko6cd-0005zd-Hb; Sat, 12 Dec 2020 16:15:47 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH xtables-nft 1/3] xtables-monitor: fix rule printing
Date:   Sat, 12 Dec 2020 16:15:32 +0100
Message-Id: <20201212151534.54336-2-fw@strlen.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201212151534.54336-1-fw@strlen.de>
References: <20201212151534.54336-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

trace_print_rule does a rule dump.  This prints unrelated rules
in the same chain.  Instead the function should only request the
specific handle.

Furthermore, flush output buffer afterwards so this plays nice when
output isn't a terminal.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/xtables-monitor.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index 4008cc00d469..364e600e1b38 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -227,12 +227,12 @@ static void trace_print_rule(const struct nftnl_trace *nlt, struct cb_arg *args)
 		exit(EXIT_FAILURE);
 	}
 
-	nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family, NLM_F_DUMP, 0);
+	nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family, 0, 0);
 
         nftnl_rule_set_u32(r, NFTNL_RULE_FAMILY, family);
 	nftnl_rule_set_str(r, NFTNL_RULE_CHAIN, chain);
 	nftnl_rule_set_str(r, NFTNL_RULE_TABLE, table);
-	nftnl_rule_set_u64(r, NFTNL_RULE_POSITION, handle);
+	nftnl_rule_set_u64(r, NFTNL_RULE_HANDLE, handle);
 	nftnl_rule_nlmsg_build_payload(nlh, r);
 	nftnl_rule_free(r);
 
@@ -248,24 +248,21 @@ static void trace_print_rule(const struct nftnl_trace *nlt, struct cb_arg *args)
 	}
 
 	portid = mnl_socket_get_portid(nl);
-        if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-                perror("mnl_socket_send");
-                exit(EXIT_FAILURE);
-        }
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		perror("mnl_socket_send");
+		exit(EXIT_FAILURE);
+	}
 
 	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-        while (ret > 0) {
+	if (ret > 0) {
 		args->is_event = false;
-                ret = mnl_cb_run(buf, ret, 0, portid, rule_cb, args);
-                if (ret <= 0)
-                        break;
-                ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-        }
-        if (ret == -1) {
-                perror("error");
-                exit(EXIT_FAILURE);
-        }
-        mnl_socket_close(nl);
+		ret = mnl_cb_run(buf, ret, 0, portid, rule_cb, args);
+	}
+	if (ret == -1) {
+		perror("error");
+		exit(EXIT_FAILURE);
+	}
+	mnl_socket_close(nl);
 }
 
 static void trace_print_packet(const struct nftnl_trace *nlt, struct cb_arg *args)
@@ -531,6 +528,7 @@ static int trace_cb(const struct nlmsghdr *nlh, struct cb_arg *arg)
 err_free:
 	nftnl_trace_free(nlt);
 err:
+	fflush(stdout);
 	return MNL_CB_OK;
 }
 
-- 
2.28.0

