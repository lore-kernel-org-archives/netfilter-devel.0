Return-Path: <SRS0=uYLw=7H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92575C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 16:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 793B92071A
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 16:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731340AbgEYQSS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 May 2020 12:18:18 -0400
Received: from correo.us.es ([193.147.175.20]:51286 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbgEYQSS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 May 2020 12:18:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 33AD8B26C1
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2020 18:18:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 24DC1DA701
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2020 18:18:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1A433DA714; Mon, 25 May 2020 18:18:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 14258DA701
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2020 18:18:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 25 May 2020 18:18:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id F19DE42EE38E
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2020 18:18:13 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] flowtable: relax logic to build NFTA_FLOWTABLE_HOOK
Date:   Mon, 25 May 2020 18:18:11 +0200
Message-Id: <20200525161811.24928-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The logic to build NFTA_FLOWTABLE_HOOK enforces the presence of the hook
number and priority to include the devices. Relax this to allow for
incremental device updates.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/flowtable.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/src/flowtable.c b/src/flowtable.c
index 19e288247e34..658115dd2476 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -313,31 +313,38 @@ EXPORT_SYMBOL(nftnl_flowtable_nlmsg_build_payload);
 void nftnl_flowtable_nlmsg_build_payload(struct nlmsghdr *nlh,
 					 const struct nftnl_flowtable *c)
 {
+	struct nlattr *nest = NULL;
 	int i;
 
 	if (c->flags & (1 << NFTNL_FLOWTABLE_TABLE))
 		mnl_attr_put_strz(nlh, NFTA_FLOWTABLE_TABLE, c->table);
 	if (c->flags & (1 << NFTNL_FLOWTABLE_NAME))
 		mnl_attr_put_strz(nlh, NFTA_FLOWTABLE_NAME, c->name);
-	if ((c->flags & (1 << NFTNL_FLOWTABLE_HOOKNUM)) &&
-	    (c->flags & (1 << NFTNL_FLOWTABLE_PRIO))) {
-		struct nlattr *nest;
 
+	if (c->flags & (1 << NFTNL_FLOWTABLE_HOOKNUM) ||
+	    c->flags & (1 << NFTNL_FLOWTABLE_PRIO) ||
+	    c->flags & (1 << NFTNL_FLOWTABLE_DEVICES))
 		nest = mnl_attr_nest_start(nlh, NFTA_FLOWTABLE_HOOK);
+
+	if (c->flags & (1 << NFTNL_FLOWTABLE_HOOKNUM))
 		mnl_attr_put_u32(nlh, NFTA_FLOWTABLE_HOOK_NUM, htonl(c->hooknum));
+	if (c->flags & (1 << NFTNL_FLOWTABLE_PRIO))
 		mnl_attr_put_u32(nlh, NFTA_FLOWTABLE_HOOK_PRIORITY, htonl(c->prio));
-		if (c->flags & (1 << NFTNL_FLOWTABLE_DEVICES)) {
-			struct nlattr *nest_dev;
 
-			nest_dev = mnl_attr_nest_start(nlh,
-						       NFTA_FLOWTABLE_HOOK_DEVS);
-			for (i = 0; i < c->dev_array_len; i++)
-				mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME,
-						  c->dev_array[i]);
-			mnl_attr_nest_end(nlh, nest_dev);
+	if (c->flags & (1 << NFTNL_FLOWTABLE_DEVICES)) {
+		struct nlattr *nest_dev;
+
+		nest_dev = mnl_attr_nest_start(nlh, NFTA_FLOWTABLE_HOOK_DEVS);
+		for (i = 0; i < c->dev_array_len; i++) {
+			mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME,
+					  c->dev_array[i]);
 		}
-		mnl_attr_nest_end(nlh, nest);
+		mnl_attr_nest_end(nlh, nest_dev);
 	}
+
+	if (nest)
+		mnl_attr_nest_end(nlh, nest);
+
 	if (c->flags & (1 << NFTNL_FLOWTABLE_FLAGS))
 		mnl_attr_put_u32(nlh, NFTA_FLOWTABLE_FLAGS, htonl(c->ft_flags));
 	if (c->flags & (1 << NFTNL_FLOWTABLE_USE))
-- 
2.20.1

