Return-Path: <SRS0=o7qJ=6G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A8DC54FCB
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Apr 2020 21:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B83FC20781
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Apr 2020 21:40:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ib7AHgJo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgDVVkg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Apr 2020 17:40:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45859 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726445AbgDVVkg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Apr 2020 17:40:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587591634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:in-reply-to:
         references:references:references;
        bh=DENkatVCQ+jpqkBbLef2D+gdKupZek3QYZiIVYQZ1G0=;
        b=ib7AHgJokVNjiwloZ55UXRyVewYs/AIDTHP8G6Shfazilb1Riiux0Wn/s/LmWT24YtAeB4
        rC7S2L5MsM5wMoAzsviXlVqeXHB4q303FzUeoJBrm+Kd+xJs/LeKPti+UWRczqHG2uyqcU
        Hlhax6SWF5iTelOn4lRehr64P5toC6Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-QxQTvcTBOh6N_kqXIloajg-1; Wed, 22 Apr 2020 17:40:32 -0400
X-MC-Unique: QxQTvcTBOh6N_kqXIloajg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 352261B18BC7;
        Wed, 22 Apr 2020 21:40:31 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F90B5D710;
        Wed, 22 Apr 2020 21:40:16 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        eparis@parisplace.org, ebiederm@xmission.com, tgraf@infradead.org,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak25 v4 2/3] netfilter: add audit table unregister actions
Date:   Wed, 22 Apr 2020 17:39:29 -0400
Message-Id: <e75f9c91a251278979182f0181d3595d3bb3b2b8.1587500467.git.rgb@redhat.com>
In-Reply-To: <cover.1587500467.git.rgb@redhat.com>
References: <cover.1587500467.git.rgb@redhat.com>
In-Reply-To: <cover.1587500467.git.rgb@redhat.com>
References: <cover.1587500467.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Audit the action of unregistering ebtables and x_tables.

See: https://github.com/linux-audit/audit-kernel/issues/44
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h           | 1 +
 kernel/auditsc.c                | 5 +++--
 net/bridge/netfilter/ebtables.c | 2 ++
 net/netfilter/x_tables.c        | 2 ++
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 5c7f07a9776d..1a2351508211 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -97,6 +97,7 @@ struct audit_ntp_data {
 enum audit_nfcfgop {
 	AUDIT_XT_OP_REGISTER,
 	AUDIT_XT_OP_REPLACE,
+	AUDIT_XT_OP_UNREGISTER,
 };
 
 extern int is_audit_feature_set(int which);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 705beac0ce29..d281c18d1771 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -136,8 +136,9 @@ struct audit_nfcfgop_tab {
 };
 
 const struct audit_nfcfgop_tab audit_nfcfgs[] = {
-	{ AUDIT_XT_OP_REGISTER,	"register"	},
-	{ AUDIT_XT_OP_REPLACE,	"replace"	},
+	{ AUDIT_XT_OP_REGISTER,		"register"	},
+	{ AUDIT_XT_OP_REPLACE,		"replace"	},
+	{ AUDIT_XT_OP_UNREGISTER,	"unregister"	},
 };
 
 static int audit_match_perm(struct audit_context *ctx, int mask)
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 0a148e68b6e1..4778db5601b0 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1124,6 +1124,8 @@ static void __ebt_unregister_table(struct net *net, struct ebt_table *table)
 	mutex_lock(&ebt_mutex);
 	list_del(&table->list);
 	mutex_unlock(&ebt_mutex);
+	audit_log_nfcfg(table->name, AF_BRIDGE, table->private->nentries,
+			AUDIT_XT_OP_UNREGISTER);
 	EBT_ENTRY_ITERATE(table->private->entries, table->private->entries_size,
 			  ebt_cleanup_entry, net, NULL);
 	if (table->private->nentries)
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 8f8c5dbf603d..99a468be4a59 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1472,6 +1472,8 @@ void *xt_unregister_table(struct xt_table *table)
 	private = table->private;
 	list_del(&table->list);
 	mutex_unlock(&xt[table->af].mutex);
+	audit_log_nfcfg(table->name, table->af, private->number,
+			AUDIT_XT_OP_UNREGISTER);
 	kfree(table);
 
 	return private;
-- 
1.8.3.1

