Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF4C1C43461
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 17:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8524761077
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 17:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236301AbhDZRMx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 13:12:53 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51578 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235892AbhDZRL6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 13:11:58 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 51BD36412F;
        Mon, 26 Apr 2021 19:10:36 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 16/22] netfilter: nf_log_syslog: Unset bridge logger in pernet exit
Date:   Mon, 26 Apr 2021 19:10:50 +0200
Message-Id: <20210426171056.345271-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426171056.345271-1-pablo@netfilter.org>
References: <20210426171056.345271-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Without this, a stale pointer remains in pernet loggers after module
unload causing a kernel oops during dereference. Easily reproduced by:

| # modprobe nf_log_syslog
| # rmmod nf_log_syslog
| # cat /proc/net/netfilter/nf_log

Fixes: 77ccee96a6742 ("netfilter: nf_log_bridge: merge with nf_log_syslog")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_log_syslog.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 2518818ed479..13234641cdb3 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -1011,6 +1011,7 @@ static void __net_exit nf_log_syslog_net_exit(struct net *net)
 	nf_log_unset(net, &nf_arp_logger);
 	nf_log_unset(net, &nf_ip6_logger);
 	nf_log_unset(net, &nf_netdev_logger);
+	nf_log_unset(net, &nf_bridge_logger);
 }
 
 static struct pernet_operations nf_log_syslog_net_ops = {
-- 
2.30.2

