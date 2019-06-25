Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01DD7C48BD5
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 00:12:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D09AA2077C
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 00:12:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbfFYAMs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 20:12:48 -0400
Received: from mail.us.es ([193.147.175.20]:38016 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729244AbfFYAMs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 20:12:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 57ED5C04A8
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2019 02:12:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 47B67DA706
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2019 02:12:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3D03CDA705; Tue, 25 Jun 2019 02:12:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4523CDA706;
        Tue, 25 Jun 2019 02:12:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:12:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 118CE4265A2F;
        Tue, 25 Jun 2019 02:12:43 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 05/26] netfilter: ipset: Fix the last missing check of nla_parse_deprecated()
Date:   Tue, 25 Jun 2019 02:12:12 +0200
Message-Id: <20190625001233.22057-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190625001233.22057-1-pablo@netfilter.org>
References: <20190625001233.22057-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

In dump_init() the outdated comment was incorrect and we had a missing
validation check of nla_parse_deprecated().

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index d0f4c627ff91..039892cd2b7d 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1293,11 +1293,13 @@ dump_init(struct netlink_callback *cb, struct ip_set_net *inst)
 	struct nlattr *attr = (void *)nlh + min_len;
 	u32 dump_type;
 	ip_set_id_t index;
+	int ret;
 
-	/* Second pass, so parser can't fail */
-	nla_parse_deprecated(cda, IPSET_ATTR_CMD_MAX, attr,
-			     nlh->nlmsg_len - min_len, ip_set_setname_policy,
-			     NULL);
+	ret = nla_parse_deprecated(cda, IPSET_ATTR_CMD_MAX, attr,
+				   nlh->nlmsg_len - min_len,
+				   ip_set_setname_policy, NULL);
+	if (ret)
+		return ret;
 
 	cb->args[IPSET_CB_PROTO] = nla_get_u8(cda[IPSET_ATTR_PROTOCOL]);
 	if (cda[IPSET_ATTR_SETNAME]) {
-- 
2.11.0

