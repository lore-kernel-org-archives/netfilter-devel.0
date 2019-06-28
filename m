Return-Path: <SRS0=rhnh=U3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 917F4C4321A
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 17:41:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7747720828
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 17:41:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfF1Rlj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jun 2019 13:41:39 -0400
Received: from mail.us.es ([193.147.175.20]:52766 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbfF1Rlj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jun 2019 13:41:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8CD8F1B2B69
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2019 19:41:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F496DA7B6
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2019 19:41:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 74A221021A6; Fri, 28 Jun 2019 19:41:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A20CDA4D1;
        Fri, 28 Jun 2019 19:41:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 28 Jun 2019 19:41:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.195.66])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0DCDF4265A32;
        Fri, 28 Jun 2019 19:41:32 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/4] netfilter: ctnetlink: Fix regression in conntrack entry deletion
Date:   Fri, 28 Jun 2019 19:41:24 +0200
Message-Id: <20190628174125.20739-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190628174125.20739-1-pablo@netfilter.org>
References: <20190628174125.20739-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Felix Kaechele <felix@kaechele.ca>

Commit f8e608982022 ("netfilter: ctnetlink: Resolve conntrack
L3-protocol flush regression") introduced a regression in which deletion
of conntrack entries would fail because the L3 protocol information
is replaced by AF_UNSPEC. As a result the search for the entry to be
deleted would turn up empty due to the tuple used to perform the search
is now different from the tuple used to initially set up the entry.

For flushing the conntrack table we do however want to keep the option
for nfgenmsg->version to have a non-zero value to allow for newer
user-space tools to request treatment under the new behavior. With that
it is possible to independently flush tables for a defined L3 protocol.
This was introduced with the enhancements in in commit 59c08c69c278
("netfilter: ctnetlink: Support L3 protocol-filter on flush").

Older user-space tools will retain the behavior of flushing all tables
regardless of defined L3 protocol.

Fixes: f8e608982022 ("netfilter: ctnetlink: Resolve conntrack L3-protocol flush regression")
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Felix Kaechele <felix@kaechele.ca>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 7db79c1b8084..1b77444d5b52 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1256,7 +1256,6 @@ static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
 	struct nf_conntrack_tuple tuple;
 	struct nf_conn *ct;
 	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u_int8_t u3 = nfmsg->version ? nfmsg->nfgen_family : AF_UNSPEC;
 	struct nf_conntrack_zone zone;
 	int err;
 
@@ -1266,11 +1265,13 @@ static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
 
 	if (cda[CTA_TUPLE_ORIG])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG,
-					    u3, &zone);
+					    nfmsg->nfgen_family, &zone);
 	else if (cda[CTA_TUPLE_REPLY])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPLY,
-					    u3, &zone);
+					    nfmsg->nfgen_family, &zone);
 	else {
+		u_int8_t u3 = nfmsg->version ? nfmsg->nfgen_family : AF_UNSPEC;
+
 		return ctnetlink_flush_conntrack(net, cda,
 						 NETLINK_CB(skb).portid,
 						 nlmsg_report(nlh), u3);
-- 
2.11.0


