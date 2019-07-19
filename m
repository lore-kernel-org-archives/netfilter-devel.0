Return-Path: <SRS0=2jko=VQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC747C76197
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 16:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 900562186A
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 16:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731873AbfGSQpc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Jul 2019 12:45:32 -0400
Received: from mail.us.es ([193.147.175.20]:49420 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728449AbfGSQpb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 12:45:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CA44CBAEE2
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jul 2019 18:45:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A921DDA704
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jul 2019 18:45:29 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9D853115107; Fri, 19 Jul 2019 18:45:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DBE84DA704;
        Fri, 19 Jul 2019 18:45:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 19 Jul 2019 18:45:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.47.94])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5CF0340705C4;
        Fri, 19 Jul 2019 18:45:24 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 01/14] netfilter: nfnetlink: avoid deadlock due to synchronous request_module
Date:   Fri, 19 Jul 2019 18:45:04 +0200
Message-Id: <20190719164517.29496-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190719164517.29496-1-pablo@netfilter.org>
References: <20190719164517.29496-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Thomas and Juliana report a deadlock when running:

(rmmod nf_conntrack_netlink/xfrm_user)

  conntrack -e NEW -E &
  modprobe -v xfrm_user

They provided following analysis:

conntrack -e NEW -E
    netlink_bind()
        netlink_lock_table() -> increases "nl_table_users"
            nfnetlink_bind()
            # does not unlock the table as it's locked by netlink_bind()
                __request_module()
                    call_usermodehelper_exec()

This triggers "modprobe nf_conntrack_netlink" from kernel, netlink_bind()
won't return until modprobe process is done.

"modprobe xfrm_user":
    xfrm_user_init()
        register_pernet_subsys()
            -> grab pernet_ops_rwsem
                ..
                netlink_table_grab()
                    calls schedule() as "nl_table_users" is non-zero

so modprobe is blocked because netlink_bind() increased
nl_table_users while also holding pernet_ops_rwsem.

"modprobe nf_conntrack_netlink" runs and inits nf_conntrack_netlink:
    ctnetlink_init()
        register_pernet_subsys()
            -> blocks on "pernet_ops_rwsem" thanks to xfrm_user module

both modprobe processes wait on one another -- neither can make
progress.

Switch netlink_bind() to "nowait" modprobe -- this releases the netlink
table lock, which then allows both modprobe instances to complete.

Reported-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Reported-by: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 92077d459109..4abbb452cf6c 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -578,7 +578,7 @@ static int nfnetlink_bind(struct net *net, int group)
 	ss = nfnetlink_get_subsys(type << 8);
 	rcu_read_unlock();
 	if (!ss)
-		request_module("nfnetlink-subsys-%d", type);
+		request_module_nowait("nfnetlink-subsys-%d", type);
 	return 0;
 }
 #endif
-- 
2.11.0


