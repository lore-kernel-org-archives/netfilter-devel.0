Return-Path: <SRS0=rW9L=RY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC3AC43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 11:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 937DE2083D
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 11:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbfCUL3J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 07:29:09 -0400
Received: from mail.us.es ([193.147.175.20]:42774 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727874AbfCUL3D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 07:29:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B7480C2316
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Mar 2019 12:29:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 99305BAAB0
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Mar 2019 12:29:00 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 903B1BAAAC; Thu, 21 Mar 2019 12:29:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 72D87BAAAE;
        Thu, 21 Mar 2019 12:28:58 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 21 Mar 2019 12:28:58 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [195.39.71.253])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 069A34265A4E;
        Thu, 21 Mar 2019 12:28:57 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 9/9] netfilter: nf_tables: add missing ->release_ops() in error path of newrule()
Date:   Thu, 21 Mar 2019 12:28:45 +0100
Message-Id: <20190321112845.10627-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190321112845.10627-1-pablo@netfilter.org>
References: <20190321112845.10627-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

->release_ops() callback releases resources and this is used in error path.
If nf_tables_newrule() fails after ->select_ops(), it should release
resources. but it can not call ->destroy() because that should be called
after ->init().
At this point, ->release_ops() should be used for releasing resources.

Test commands:
   modprobe -rv xt_tcpudp
   iptables-nft -I INPUT -m tcp   <-- error command
   lsmod

Result:
   Module                  Size  Used by
   xt_tcpudp              20480  2      <-- it should be 0

Fixes: b8e204006340 ("netfilter: nft_compat: use .release_ops and remove list of extension")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 513f93118604..ef7772e976cc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2806,8 +2806,11 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	nf_tables_rule_release(&ctx, rule);
 err1:
 	for (i = 0; i < n; i++) {
-		if (info[i].ops != NULL)
+		if (info[i].ops) {
 			module_put(info[i].ops->type->owner);
+			if (info[i].ops->type->release_ops)
+				info[i].ops->type->release_ops(info[i].ops);
+		}
 	}
 	kvfree(info);
 	return err;
-- 
2.11.0

