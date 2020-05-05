Return-Path: <SRS0=RRXz=6T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3166C47247
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 19:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96B31206B9
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 19:12:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgEETM3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 May 2020 15:12:29 -0400
Received: from correo.us.es ([193.147.175.20]:54298 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgEETM3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 May 2020 15:12:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 88D9D396273
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 21:12:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7BB64115412
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 21:12:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 714BB115410; Tue,  5 May 2020 21:12:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7507D2067D
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 21:12:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 05 May 2020 21:12:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5A70542EE38F
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 21:12:25 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] expr: dynset: release stateful expression from .free path
Date:   Tue,  5 May 2020 21:12:22 +0200
Message-Id: <20200505191222.30596-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

==22778==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 64 byte(s) in 1 object(s) allocated from:
    #0 0x7f3212406518 in calloc (/usr/lib/x86_64-linux-gnu/libasan.so.5+0xe9518)
    #1 0x7f321041703e in nftnl_expr_alloc /home/pablo/devel/scm/git-netfilter/libnftnl/src/expr.c:37
    #2 0x7f3211d51c16 in netlink_gen_limit_stmt /home/pablo/devel/scm/git-netfilter/nftables/src/netlink_linearize.c:859
    #3 0x7f3211d5220c in netlink_gen_stmt_stateful /home/pablo/devel/scm/git-netfilter/nftables/src/netlink_linearize.c:891
    #4 0x7f3211d58630 in netlink_gen_meter_stmt /home/pablo/devel/scm/git-netfilter/nftables/src/netlink_linearize.c:1441
[...]

SUMMARY: AddressSanitizer: 64 byte(s) leaked in 1 allocation(s).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/dynset.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index b2d8edca20ac..8b63cb0e5f92 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -277,6 +277,7 @@ static void nftnl_expr_dynset_free(const struct nftnl_expr *e)
 	struct nftnl_expr_dynset *dynset = nftnl_expr_data(e);
 
 	xfree(dynset->set_name);
+	nftnl_expr_free(dynset->expr);
 }
 
 struct expr_ops expr_ops_dynset = {
-- 
2.20.1

