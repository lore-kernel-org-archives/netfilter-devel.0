Return-Path: <SRS0=tvQP=ST=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A0AC282DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 14:46:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B56A2173C
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 14:46:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732586AbfDQOqn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 10:46:43 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35345 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732268AbfDQOql (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 10:46:41 -0400
Received: by mail-qt1-f193.google.com with SMTP id h39so27657041qte.2
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Apr 2019 07:46:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3Pu1ziQBUqzj5vtCik/DXnEbTIHGkJ5s+gKThqG4eEA=;
        b=ccmg9KDwxMvjx1mASoMgPy7TRXD6en8kXbIZYaLRq93WiVwqt7gGgFDJJxWAlTEojA
         w9TqAZwn+gFPrE4Chn62iD8sAdYPBlgH+h63cADmqfdLXawKm5sZu2/uiXhxKCOJ7uPE
         tZQ3w8RQB4k0GFx9oDGIKiGwhHRmSfiYKQpVNgL3PG+6PrKgCRmVq555f510eWAENODu
         7Vlsme/W7DfQ0VxW308vxSjDRkjPCP9Z+fN/1o8prpk1XCDcr+/aj0eWNaQAEKIo1zjj
         +R2N1RHXYsttwtDh7mvNWGEBR6JWNbNxvkC83/xcl+kTKsTpYUUm6mRXX+uPTU25UGvy
         M0cg==
X-Gm-Message-State: APjAAAUTd3/S+NrN55+oZWw1tPklA0oj+/SRI1XpUI52fE+PLIbfM5WL
        tWu+CRGudmjHPywKV3R8xn6R7N0LFZs=
X-Google-Smtp-Source: APXvYqwu7uabZmGJhyhpXUwu1bQ1X9qPfyBv/IVnpJN9vyH7zBrrzGMTgARO73zV1zJ5pbSbXzrn8A==
X-Received: by 2002:a0c:b0c7:: with SMTP id p7mr71362707qvc.142.1555512400352;
        Wed, 17 Apr 2019 07:46:40 -0700 (PDT)
Received: from localhost ([177.183.215.200])
        by smtp.gmail.com with ESMTPSA id h29sm35286146qtk.32.2019.04.17.07.46.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Apr 2019 07:46:39 -0700 (PDT)
From:   Flavio Leitner <fbl@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next v3 4/4] openvswitch: load and reference the NAT helper.
Date:   Wed, 17 Apr 2019 11:46:17 -0300
Message-Id: <20190417144617.14922-5-fbl@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190417144617.14922-1-fbl@redhat.com>
References: <20190417144617.14922-1-fbl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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
---
 net/openvswitch/conntrack.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

v3
   - replaced 'err' with 'error' in the msg.
v2
   - updated with new functions names.

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 0be3ab5bde26..4cc4dd948969 100644
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
 
 #ifdef CONFIG_NF_NAT_NEEDED
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
2.20.1

