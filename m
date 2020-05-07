Return-Path: <SRS0=DUCC=6V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FBF8C38A24
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 May 2020 11:29:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31ED62084D
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 May 2020 11:29:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgEGL32 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 May 2020 07:29:28 -0400
Received: from correo.us.es ([193.147.175.20]:50236 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgEGL31 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 May 2020 07:29:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 78734154E85
        for <netfilter-devel@vger.kernel.org>; Thu,  7 May 2020 13:29:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6B1D611541A
        for <netfilter-devel@vger.kernel.org>; Thu,  7 May 2020 13:29:25 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 60315A869; Thu,  7 May 2020 13:29:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 05A05A869;
        Thu,  7 May 2020 13:29:23 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 07 May 2020 13:29:23 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D116442EF4E0;
        Thu,  7 May 2020 13:29:22 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     jengelh@inai.de
Subject: [PATCH nft] mnl: fix error rule reporting with missing table/chain and anonymous sets
Date:   Thu,  7 May 2020 13:29:19 +0200
Message-Id: <20200507112919.21227-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Program received signal SIGSEGV, Segmentation fault.
0x00007ffff7f64f1e in erec_print (octx=0x55555555d2c0, erec=0x55555555fcf0, debug_mask=0) at erec.c:95
95              switch (indesc->type) {
(gdb) bt
    buf=0x55555555db20 "add rule inet traffic-filter input tcp dport { 22, 80, 443 } accept") at libnftables.c:459
(gdb) p indesc
$1 = (const struct input_descriptor *) 0x0

Closes: http://bugzilla.opensuse.org/show_bug.cgi?id=1171321
Fixes: 086ec6f30c96 ("mnl: extended error support for create command")
Reported-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index 94e80261afb7..9ce4072859b1 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1048,7 +1048,10 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, struct cmd *cmd,
 
 	cmd_add_loc(cmd, nlh->nlmsg_len, &h->table.location);
 	mnl_attr_put_strz(nlh, NFTA_SET_TABLE, h->table.name);
-	cmd_add_loc(cmd, nlh->nlmsg_len, &h->set.location);
+	if (set_is_anonymous(set->flags))
+		cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->location);
+	else
+		cmd_add_loc(cmd, nlh->nlmsg_len, &h->set.location);
 	mnl_attr_put_strz(nlh, NFTA_SET_NAME, h->set.name);
 
 	nftnl_set_nlmsg_build_payload(nlh, nls);
-- 
2.20.1

