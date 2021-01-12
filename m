Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 961AEC433E9
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Jan 2021 22:21:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 783F12312A
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Jan 2021 22:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404850AbhALWVd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Jan 2021 17:21:33 -0500
Received: from correo.us.es ([193.147.175.20]:49912 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404795AbhALWV1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Jan 2021 17:21:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 97E14D28CE
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Jan 2021 23:20:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 86034DA78E
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Jan 2021 23:20:00 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7BA69DA78A; Tue, 12 Jan 2021 23:20:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2FA5FDA73F;
        Tue, 12 Jan 2021 23:19:58 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Jan 2021 23:19:58 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.lan (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id DFFCC42EF528;
        Tue, 12 Jan 2021 23:19:57 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/3] netfilter: conntrack: fix reading nf_conntrack_buckets
Date:   Tue, 12 Jan 2021 23:20:32 +0100
Message-Id: <20210112222033.9732-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210112222033.9732-1-pablo@netfilter.org>
References: <20210112222033.9732-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

The old way of changing the conntrack hashsize runtime was through changing
the module param via file /sys/module/nf_conntrack/parameters/hashsize. This
was extended to sysctl change in commit 3183ab8997a4 ("netfilter: conntrack:
allow increasing bucket size via sysctl too").

The commit introduced second "user" variable nf_conntrack_htable_size_user
which shadow actual variable nf_conntrack_htable_size. When hashsize is
changed via module param this "user" variable isn't updated. This results in
sysctl net/netfilter/nf_conntrack_buckets shows the wrong value when users
update via the old way.

This patch fix the issue by always updating "user" variable when reading the
proc file. This will take care of changes to the actual variable without
sysctl need to be aware.

Fixes: 3183ab8997a4 ("netfilter: conntrack: allow increasing bucket size via sysctl too")
Reported-by: Yoel Caspersen <yoel@kviknet.dk>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_standalone.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 46c5557c1fec..0ee702d374b0 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -523,6 +523,9 @@ nf_conntrack_hash_sysctl(struct ctl_table *table, int write,
 {
 	int ret;
 
+	/* module_param hashsize could have changed value */
+	nf_conntrack_htable_size_user = nf_conntrack_htable_size;
+
 	ret = proc_dointvec(table, write, buffer, lenp, ppos);
 	if (ret < 0 || !write)
 		return ret;
-- 
2.20.1

