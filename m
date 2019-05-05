Return-Path: <SRS0=aMTL=TF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49395C004C9
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 23:33:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26F2D206DF
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 23:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbfEEXdr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 May 2019 19:33:47 -0400
Received: from mail.us.es ([193.147.175.20]:34120 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728042AbfEEXdU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 May 2019 19:33:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AC0CA11ED92
        for <netfilter-devel@vger.kernel.org>; Mon,  6 May 2019 01:33:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9AD43DA70B
        for <netfilter-devel@vger.kernel.org>; Mon,  6 May 2019 01:33:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8FBC4DA702; Mon,  6 May 2019 01:33:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 91001DA702;
        Mon,  6 May 2019 01:33:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 May 2019 01:33:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 67E0B4265A31;
        Mon,  6 May 2019 01:33:16 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 08/12] openvswitch: load and reference the NAT helper.
Date:   Mon,  6 May 2019 01:33:01 +0200
Message-Id: <20190505233305.13650-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190505233305.13650-1-pablo@netfilter.org>
References: <20190505233305.13650-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Flavio Leitner <fbl@redhat.com>

This improves the original commit 17c357efe5ec ("openvswitch: load
NAT helper") where it unconditionally tries to load the module for
every flow using NAT, so not efficient when loading multiple flows.
It also doesn't hold any references to the NAT module while the
flow is active.

This change fixes those problems. It will try to load the module
only if it's not present. It grabs a reference to the NAT module
and holds it while the flow is active. Finally, an error message
shows up if either actions above fails.

Fixes: 17c357efe5ec ("openvswitch: load NAT helper")
Signed-off-by: Flavio Leitner <fbl@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/openvswitch/conntrack.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index bded32144619..c4128082f88b 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1307,6 +1307,7 @@ static int ovs_ct_add_helper(struct ovs_conntrack_info *info, const char *name,
 {
 	struct nf_conntrack_helper *helper;
 	struct nf_conn_help *help;
+	int ret = 0;
 
 	helper = nf_conntrack_helper_try_module_get(name, info->family,
 						    key->ip.proto);
@@ -1321,13 +1322,21 @@ static int ovs_ct_add_helper(struct ovs_conntrack_info *info, const char *name,
 		return -ENOMEM;
 	}
 
+#ifdef CONFIG_NF_NAT_NEEDED
+	if (info->nat) {
+		ret = nf_nat_helper_try_module_get(name, info->family,
+						   key->ip.proto);
+		if (ret) {
+			nf_conntrack_helper_put(helper);
+			OVS_NLERR(log, "Failed to load \"%s\" NAT helper, error: %d",
+				  name, ret);
+			return ret;
+		}
+	}
+#endif
 	rcu_assign_pointer(help->helper, helper);
 	info->helper = helper;
-
-	if (info->nat)
-		request_module("ip_nat_%s", name);
-
-	return 0;
+	return ret;
 }
 
 #if IS_ENABLED(CONFIG_NF_NAT)
@@ -1801,8 +1810,13 @@ void ovs_ct_free_action(const struct nlattr *a)
 
 static void __ovs_ct_free_action(struct ovs_conntrack_info *ct_info)
 {
-	if (ct_info->helper)
+	if (ct_info->helper) {
+#ifdef CONFIG_NF_NAT_NEEDED
+		if (ct_info->nat)
+			nf_nat_helper_put(ct_info->helper);
+#endif
 		nf_conntrack_helper_put(ct_info->helper);
+	}
 	if (ct_info->ct) {
 		if (ct_info->timeout[0])
 			nf_ct_destroy_timeout(ct_info->ct);
-- 
2.11.0

