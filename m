From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2 nf] netfilter: cthelper: Fix memory leak
Date: Tue, 21 Mar 2017 13:41:34 +0100
Message-ID: <1490100094-32269-2-git-send-email-pablo@netfilter.org>
References: <1490100094-32269-1-git-send-email-pablo@netfilter.org>
Cc: zlpnobody@gmail.com, jeffy.chen@rock-chips.com,
        dianders@chromium.org, briannorris@chromium.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52246 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932549AbdCUMsn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 08:48:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3D4081324C7
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 13:41:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2723BDA86E
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 13:41:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E87F0BAC35
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 13:41:37 +0100 (CET)
In-Reply-To: <1490100094-32269-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jeffy Chen <jeffy.chen@rock-chips.com>

We have memory leaks of nf_conntrack_helper & expect_policy.

Signed-off-by: Jeffy Chen <jeffy.chen@rock-chips.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Heavily based on your original patch, so I'm keeping you as original author
for this fix.

 net/netfilter/nfnetlink_cthelper.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index ffb51b91e646..bc43d8635cb8 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -214,7 +214,7 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 
 	ret = nfnl_cthelper_parse_expect_policy(helper, tb[NFCTH_POLICY]);
 	if (ret < 0)
-		goto err;
+		goto err1;
 
 	strncpy(helper->name, nla_data(tb[NFCTH_NAME]), NF_CT_HELPER_NAME_LEN);
 	helper->data_len = ntohl(nla_get_be32(tb[NFCTH_PRIV_DATA_LEN]));
@@ -245,10 +245,12 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 
 	ret = nf_conntrack_helper_register(helper);
 	if (ret < 0)
-		goto err;
+		goto err2;
 
 	return 0;
-err:
+err2:
+	kfree(helper->expect_policy);
+err1:
 	kfree(helper);
 	return ret;
 }
@@ -676,6 +678,8 @@ static int nfnl_cthelper_del(struct net *net, struct sock *nfnl,
 
 			found = true;
 			nf_conntrack_helper_unregister(cur);
+			kfree(cur->expect_policy);
+			kfree(cur);
 		}
 	}
 	/* Make sure we return success if we flush and there is no helpers */
@@ -739,6 +743,8 @@ static void __exit nfnl_cthelper_exit(void)
 				continue;
 
 			nf_conntrack_helper_unregister(cur);
+			kfree(cur->expect_policy);
+			kfree(cur);
 		}
 	}
 }
-- 
2.1.4

