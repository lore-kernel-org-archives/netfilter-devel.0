Return-Path: <SRS0=uN83=25=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85294C33CA1
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jan 2020 23:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 662B4206DB
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jan 2020 23:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbgAHXR3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jan 2020 18:17:29 -0500
Received: from correo.us.es ([193.147.175.20]:43224 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727552AbgAHXR0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jan 2020 18:17:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 85E27FF9B7
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 00:17:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B3E5DA703
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 00:17:24 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7A57ADA709; Thu,  9 Jan 2020 00:17:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B397DA703;
        Thu,  9 Jan 2020 00:17:22 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 09 Jan 2020 00:17:22 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 35E34426CCB9;
        Thu,  9 Jan 2020 00:17:22 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 8/9] netfilter: conntrack: dccp, sctp: handle null timeout argument
Date:   Thu,  9 Jan 2020 00:17:12 +0100
Message-Id: <20200108231713.100458-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200108231713.100458-1-pablo@netfilter.org>
References: <20200108231713.100458-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The timeout pointer can be NULL which means we should modify the
per-nets timeout instead.

All do this, except sctp and dccp which instead give:

general protection fault: 0000 [#1] PREEMPT SMP KASAN
net/netfilter/nf_conntrack_proto_dccp.c:682
 ctnl_timeout_parse_policy+0x150/0x1d0 net/netfilter/nfnetlink_cttimeout.c:67
 cttimeout_default_set+0x150/0x1c0 net/netfilter/nfnetlink_cttimeout.c:368
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477

Reported-by: syzbot+46a4ad33f345d1dd346e@syzkaller.appspotmail.com
Fixes: c779e849608a8 ("netfilter: conntrack: remove get_timeout() indirection")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_dccp.c | 3 +++
 net/netfilter/nf_conntrack_proto_sctp.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index b6b14db3955b..b3f4a334f9d7 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -677,6 +677,9 @@ static int dccp_timeout_nlattr_to_obj(struct nlattr *tb[],
 	unsigned int *timeouts = data;
 	int i;
 
+	if (!timeouts)
+		 timeouts = dn->dccp_timeout;
+
 	/* set default DCCP timeouts. */
 	for (i=0; i<CT_DCCP_MAX; i++)
 		timeouts[i] = dn->dccp_timeout[i];
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index fce3d93f1541..0399ae8f1188 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -594,6 +594,9 @@ static int sctp_timeout_nlattr_to_obj(struct nlattr *tb[],
 	struct nf_sctp_net *sn = nf_sctp_pernet(net);
 	int i;
 
+	if (!timeouts)
+		timeouts = sn->timeouts;
+
 	/* set default SCTP timeouts. */
 	for (i=0; i<SCTP_CONNTRACK_MAX; i++)
 		timeouts[i] = sn->timeouts[i];
-- 
2.11.0

