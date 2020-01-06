Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C96EEC33C8C
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 18:56:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A09042072A
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 18:56:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YFQfg+kE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgAFS40 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 13:56:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54710 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727128AbgAFS40 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 13:56:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578336985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:in-reply-to:
         references:references:references;
        bh=DWXFKSOUzkRcgpCgfN3PkqlzQm42xZwQFxY49CXWt+A=;
        b=YFQfg+kEJ8RJMkegNWz+dx8KVvQ8m1HXy89wtzuebOwuiNiTnY0jKX5vkLE4bPjT3he4Pm
        g3LUH4LcJ4SQ5/aTkh4L4sLEKQBvio39GPM1RJLyWroix0juZyueaOifd7nvRKjdgtC7Md
        JCc2swZV/QdY+bm2MKw/H8R9waLdJsk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-g7QKIePsM42r8CFLX5OFyg-1; Mon, 06 Jan 2020 13:56:22 -0500
X-MC-Unique: g7QKIePsM42r8CFLX5OFyg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CEE9B102C867;
        Mon,  6 Jan 2020 18:56:20 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-34.phx2.redhat.com [10.3.112.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D7B165D9E1;
        Mon,  6 Jan 2020 18:56:15 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        eparis@parisplace.org, ebiederm@xmission.com, tgraf@infradead.org,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak25 v2 9/9] netfilter: audit table unregister actions
Date:   Mon,  6 Jan 2020 13:54:10 -0500
Message-Id: <65974a7254dffe53b5084bedfd60c95a29a41e08.1577830902.git.rgb@redhat.com>
In-Reply-To: <cover.1577830902.git.rgb@redhat.com>
References: <cover.1577830902.git.rgb@redhat.com>
In-Reply-To: <cover.1577830902.git.rgb@redhat.com>
References: <cover.1577830902.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Audit the action of unregistering ebtables and x_tables.

See: https://github.com/linux-audit/audit-kernel/issues/44
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/auditsc.c                | 3 ++-
 net/bridge/netfilter/ebtables.c | 3 +++
 net/netfilter/x_tables.c        | 4 +++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 999ac184246b..2644130a9e66 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2557,7 +2557,8 @@ void __audit_nf_cfg(const char *name, u8 af, int nentries, int op)
 		return;	/* audit_panic or being filtered */
 	audit_log_format(ab, "table=%s family=%u entries=%u op=%s",
 			 name, af, nentries,
-			 op ? "replace" : "register");
+			 op == 1 ? "replace" :
+				   (op ? "unregister" : "register"));
 	audit_log_end(ab);
 }
 EXPORT_SYMBOL_GPL(__audit_nf_cfg);
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index baff2f05af43..3dd4eb5b13fd 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1126,6 +1126,9 @@ static void __ebt_unregister_table(struct net *net, struct ebt_table *table)
 	mutex_lock(&ebt_mutex);
 	list_del(&table->list);
 	mutex_unlock(&ebt_mutex);
+	if (audit_enabled)
+		audit_nf_cfg(table->name, AF_BRIDGE, table->private->nentries,
+			     2);
 	EBT_ENTRY_ITERATE(table->private->entries, table->private->entries_size,
 			  ebt_cleanup_entry, net, NULL);
 	if (table->private->nentries)
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 4ae4f7bf8946..e4852a0cb62f 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1403,7 +1403,7 @@ struct xt_table_info *xt_replace_table(struct xt_table *table,
 
 	if (audit_enabled)
 		audit_nf_cfg(table->name, table->af, private->number,
-			     private->number);
+			     !!private->number);
 
 	return private;
 }
@@ -1466,6 +1466,8 @@ void *xt_unregister_table(struct xt_table *table)
 	private = table->private;
 	list_del(&table->list);
 	mutex_unlock(&xt[table->af].mutex);
+	if (audit_enabled)
+		audit_nf_cfg(table->name, table->af, private->number, 2);
 	kfree(table);
 
 	return private;
-- 
1.8.3.1

