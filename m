Return-Path: <SRS0=LpWG=7J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED02C433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 13:54:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F9422078C
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 13:54:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GhmUNWaG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388954AbgE0Ny0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 May 2020 09:54:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28395 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387581AbgE0NyZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 May 2020 09:54:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590587664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=iDf5zmc1e1S6JUF2vessjVDEGmlryExcIRrBg0GxbAU=;
        b=GhmUNWaG4Js93uffQuqjFmT4CFjRdjtOrihL37SMV0wH+cFFUwMktylpjUNzmlqggN/sDz
        6L3hJ6zfmW2NzvlLCTU1fSLgW+2WwS+6aTDgEkOZQaKzQMuKJII8rIjhc4PZXf6t2s6bHt
        T0rbMjBJ6mGjRQUbCvN+4fvDS/3/iVk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-ElORiSJoM6m2FkbCrnf4qw-1; Wed, 27 May 2020 09:54:04 -0400
X-MC-Unique: ElORiSJoM6m2FkbCrnf4qw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A045835B47;
        Wed, 27 May 2020 13:54:03 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 920CB1001268;
        Wed, 27 May 2020 13:53:54 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        eparis@parisplace.org, tgraf@infradead.org,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak124 v1] audit: log nftables configuration change events
Date:   Wed, 27 May 2020 09:53:31 -0400
Message-Id: <d92a718b54269f426acc18f28e561031da66d3ca.1590579994.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

iptables, ip6tables, arptables and ebtables table registration,
replacement and unregistration configuration events are logged for the
native (legacy) iptables setsockopt api, but not for the
nftables netlink api which is used by the nft-variant of iptables in
addition to nftables itself.

Add calls to log the configuration actions in the nftables netlink api.

This uses the same NETFILTER_CFG record format.

For further information please see issue
https://github.com/linux-audit/audit-kernel/issues/124

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
This is an RFC patch.
Note: I have questions about the "entries" count.  Is there a more
appropriate or relevant item to report here?
Note: It might make sense to differentiate in the op= field that this
was a legacy call vs an nft call.  At the moment, legacy calls overlap
with nft table calls, which are similar calls.

 include/linux/audit.h         |  7 +++++++
 kernel/auditsc.c              | 12 +++++++++---
 net/netfilter/nf_tables_api.c | 14 ++++++++++++++
 3 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 3fcd9ee49734..b10f54103a82 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -12,6 +12,7 @@
 #include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <uapi/linux/audit.h>
+#include <uapi/linux/netfilter/nf_tables.h>
 
 #define AUDIT_INO_UNSET ((unsigned long)-1)
 #define AUDIT_DEV_UNSET ((dev_t)-1)
@@ -98,6 +99,12 @@ enum audit_nfcfgop {
 	AUDIT_XT_OP_REGISTER,
 	AUDIT_XT_OP_REPLACE,
 	AUDIT_XT_OP_UNREGISTER,
+	AUDIT_XT_OP_CHAIN_REGISTER	= NFT_MSG_NEWCHAIN,
+	AUDIT_XT_OP_CHAIN_NOOP		= NFT_MSG_GETCHAIN,
+	AUDIT_XT_OP_CHAIN_UNREGISTER	= NFT_MSG_DELCHAIN,
+	AUDIT_XT_OP_RULE_REGISTER	= NFT_MSG_NEWRULE,
+	AUDIT_XT_OP_RULE_NOOP		= NFT_MSG_GETRULE,
+	AUDIT_XT_OP_RULE_UNREGISTER	= NFT_MSG_DELRULE,
 };
 
 extern int is_audit_feature_set(int which);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 468a23390457..eedce8fa4067 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -136,9 +136,15 @@ struct audit_nfcfgop_tab {
 };
 
 static const struct audit_nfcfgop_tab audit_nfcfgs[] = {
-	{ AUDIT_XT_OP_REGISTER,		"register"	},
-	{ AUDIT_XT_OP_REPLACE,		"replace"	},
-	{ AUDIT_XT_OP_UNREGISTER,	"unregister"	},
+	{ AUDIT_XT_OP_REGISTER,		"register"		},
+	{ AUDIT_XT_OP_REPLACE,		"replace"		},
+	{ AUDIT_XT_OP_UNREGISTER,	"unregister"		},
+	{ AUDIT_XT_OP_CHAIN_REGISTER,	"register_chain"	},
+	{ AUDIT_XT_OP_CHAIN_NOOP,	"noop_chain"		},
+	{ AUDIT_XT_OP_CHAIN_UNREGISTER,	"unregister_chain"	},
+	{ AUDIT_XT_OP_RULE_REGISTER,	"register_rule"		},
+	{ AUDIT_XT_OP_RULE_NOOP,	"noop_rule"		},
+	{ AUDIT_XT_OP_RULE_UNREGISTER,	"unregister_rule"	},
 };
 
 static int audit_match_perm(struct audit_context *ctx, int mask)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4471393da6d8..c8dc954685f2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -12,6 +12,7 @@
 #include <linux/netlink.h>
 #include <linux/vmalloc.h>
 #include <linux/rhashtable.h>
+#include <linux/audit.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
@@ -7344,6 +7345,19 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		switch (trans->msg_type) {
 		case NFT_MSG_NEWTABLE:
+		case NFT_MSG_DELTABLE:
+		case NFT_MSG_NEWCHAIN:
+		case NFT_MSG_DELCHAIN:
+		case NFT_MSG_NEWRULE:
+		case NFT_MSG_DELRULE:
+			audit_log_nfcfg(trans->ctx.table->name,
+					trans->ctx.family,
+					atomic_read(&trans->ctx.table->chains_ht.ht.nelems),
+					trans->msg_type);
+			break;
+		}
+		switch (trans->msg_type) {
+		case NFT_MSG_NEWTABLE:
 			if (nft_trans_table_update(trans)) {
 				if (!nft_trans_table_enable(trans)) {
 					nf_tables_table_disable(net,
-- 
1.8.3.1

