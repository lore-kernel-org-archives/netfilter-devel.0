Return-Path: <SRS0=HMuw=IE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CBD7C43603
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Mar 2021 12:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C59F56501B
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Mar 2021 12:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbhCFMMx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Mar 2021 07:12:53 -0500
Received: from correo.us.es ([193.147.175.20]:45990 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230409AbhCFMMk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Mar 2021 07:12:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F0751C5172
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Mar 2021 13:12:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E0FD7DA78F
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Mar 2021 13:12:30 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D61D9DA78A; Sat,  6 Mar 2021 13:12:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4806DA78C;
        Sat,  6 Mar 2021 13:12:28 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 06 Mar 2021 13:12:28 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 78BB742DC6E2;
        Sat,  6 Mar 2021 13:12:28 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/9] netfilter: conntrack: Remove a double space in a log message
Date:   Sat,  6 Mar 2021 13:12:16 +0100
Message-Id: <20210306121223.28711-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210306121223.28711-1-pablo@netfilter.org>
References: <20210306121223.28711-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Klemen Košir <klemen.kosir@kream.io>

Removed an extra space in a log message and an extra blank line in code.

Signed-off-by: Klemen Košir <klemen.kosir@kream.io>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_helper.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 118f415928ae..b055187235f8 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -219,7 +219,7 @@ nf_ct_lookup_helper(struct nf_conn *ct, struct net *net)
 			return NULL;
 		pr_info("nf_conntrack: default automatic helper assignment "
 			"has been turned off for security reasons and CT-based "
-			" firewall rule not found. Use the iptables CT target "
+			"firewall rule not found. Use the iptables CT target "
 			"to attach helpers instead.\n");
 		net->ct.auto_assign_helper_warned = 1;
 		return NULL;
@@ -228,7 +228,6 @@ nf_ct_lookup_helper(struct nf_conn *ct, struct net *net)
 	return __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 }
 
-
 int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 			      gfp_t flags)
 {
-- 
2.20.1

