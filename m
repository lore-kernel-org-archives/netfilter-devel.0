Return-Path: <SRS0=TL01=WX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3A8CC3A5A6
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Aug 2019 11:31:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA17D205C9
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Aug 2019 11:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbfH0LbJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Aug 2019 07:31:09 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:37590 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725860AbfH0LbJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Aug 2019 07:31:09 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1i2Zgp-0002YX-6R; Tue, 27 Aug 2019 13:31:07 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: [PATCH nf] netfilter: conntrack: make sysctls per-namespace again
Date:   Tue, 27 Aug 2019 13:24:52 +0200
Message-Id: <20190827112452.31479-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190827135754.7d460ef8@pixies>
References: <20190827135754.7d460ef8@pixies>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When I merged the extension sysctl tables with the main one I forgot to
reset them on netns creation.  They currently read/write init_net settings.

Fixes: d912dec12428 ("netfilter: conntrack: merge acct and helper sysctl table with main one")
Fixes: cb2833ed0044 ("netfilter: conntrack: merge ecache and timestamp sysctl tables with main one")
Reported-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Shmulik, could you please check if this fixes the bug for you?
 Thanks!

 net/netfilter/nf_conntrack_standalone.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index e0d392cb3075..0006503d2da9 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -1037,8 +1037,13 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	table[NF_SYSCTL_CT_COUNT].data = &net->ct.count;
 	table[NF_SYSCTL_CT_CHECKSUM].data = &net->ct.sysctl_checksum;
 	table[NF_SYSCTL_CT_LOG_INVALID].data = &net->ct.sysctl_log_invalid;
+	table[NF_SYSCTL_CT_ACCT].data = &net->ct.sysctl_acct;
+	table[NF_SYSCTL_CT_HELPER].data = &net->ct.sysctl_auto_assign_helper;
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	table[NF_SYSCTL_CT_EVENTS].data = &net->ct.sysctl_events;
+#endif
+#ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
+	table[NF_SYSCTL_CT_TIMESTAMP].data = &net->ct.sysctl_tstamp;
 #endif
 	table[NF_SYSCTL_CT_PROTO_TIMEOUT_GENERIC].data = &nf_generic_pernet(net)->timeout;
 	table[NF_SYSCTL_CT_PROTO_TIMEOUT_ICMP].data = &nf_icmp_pernet(net)->timeout;
-- 
2.21.0

