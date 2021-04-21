Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31718C433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Apr 2021 10:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDD0361425
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Apr 2021 10:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbhDUKfH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Apr 2021 06:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237744AbhDUKfG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Apr 2021 06:35:06 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F43C06174A
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Apr 2021 03:34:33 -0700 (PDT)
Received: from localhost ([::1]:41684 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lZABh-0007XI-Js; Wed, 21 Apr 2021 12:34:29 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [PATCH] netfilter: nf_log_syslog: Unset bridge logger in pernet exit
Date:   Wed, 21 Apr 2021 12:34:21 +0200
Message-Id: <20210421103421.6168-1-phil@nwl.cc>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Without this, a stale pointer remains in pernet loggers after module
unload causing a kernel oops during dereference. Easily reproduced by:

| # modprobe nf_log_syslog
| # rmmod nf_log_syslog
| # cat /proc/net/netfilter/nf_log

Fixes: 77ccee96a6742 ("netfilter: nf_log_bridge: merge with nf_log_syslog")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_log_syslog.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 025ab9c66d13e..5391eec0a44c5 100644
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
2.31.0

