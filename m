Return-Path: <SRS0=3cJm=SY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0641C282E1
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 20:48:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EBDE20859
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 20:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730995AbfDVUsR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 16:48:17 -0400
Received: from mail.us.es ([193.147.175.20]:46722 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730781AbfDVUsP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 16:48:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D1D3744382F
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 22:48:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BC4CBDA708
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 22:48:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A8336DA710; Mon, 22 Apr 2019 22:48:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9B3E5DA706;
        Mon, 22 Apr 2019 22:48:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 22 Apr 2019 22:48:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 66C7D4265A32;
        Mon, 22 Apr 2019 22:48:11 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 10/10] netfilter: fix nf_l4proto_log_invalid to log invalid packets
Date:   Mon, 22 Apr 2019 22:48:01 +0200
Message-Id: <20190422204801.26321-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190422204801.26321-1-pablo@netfilter.org>
References: <20190422204801.26321-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

It doesn't log a packet if sysctl_log_invalid isn't equal to protonum
OR sysctl_log_invalid isn't equal to IPPROTO_RAW. This sentence is
always true. I believe we need to replace OR to AND.

Cc: Florian Westphal <fw@strlen.de>
Fixes: c4f3db1595827 ("netfilter: conntrack: add and use nf_l4proto_log_invalid")
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index b9403a266a2e..37bb530d848f 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -55,7 +55,7 @@ void nf_l4proto_log_invalid(const struct sk_buff *skb,
 	struct va_format vaf;
 	va_list args;
 
-	if (net->ct.sysctl_log_invalid != protonum ||
+	if (net->ct.sysctl_log_invalid != protonum &&
 	    net->ct.sysctl_log_invalid != IPPROTO_RAW)
 		return;
 
-- 
2.11.0

