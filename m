Return-Path: <SRS0=o7qJ=6G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30AC6C55185
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Apr 2020 21:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01EE420781
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Apr 2020 21:40:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JN6/8z97"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgDVVki (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Apr 2020 17:40:38 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31975 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgDVVkh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Apr 2020 17:40:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587591635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:in-reply-to:
         references:references:references;
        bh=xx+EjAV9D45r5GFEZlIOhsXocUtYPXxPxCOFFaC3wos=;
        b=JN6/8z97ZzbjTTTYuGRUnYUeGc0uoDbY64SdJCEl7DMFbZw69i5+Yh/8/Gqpt0uGNHZRcK
        C4xNXtuDJC0YBDNP56MkOho8ytOiOZle/yVMVKw+u6mJRzuUN/P0WT5Oude/f1LtNofG6I
        ZvaAG8379/ArZD3E8z8v8n9H/DiNDhg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-0Ez5N7UWMz6ESc9Dyx_RYA-1; Wed, 22 Apr 2020 17:40:18 -0400
X-MC-Unique: 0Ez5N7UWMz6ESc9Dyx_RYA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90148DBA3;
        Wed, 22 Apr 2020 21:40:16 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 452305D70A;
        Wed, 22 Apr 2020 21:40:13 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        eparis@parisplace.org, ebiederm@xmission.com, tgraf@infradead.org,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak25 v4 1/3] audit: tidy and extend netfilter_cfg x_tables and ebtables logging
Date:   Wed, 22 Apr 2020 17:39:28 -0400
Message-Id: <97d8dabf45ee191bc4b51dea2ae27d34fd5ea40d.1587500467.git.rgb@redhat.com>
In-Reply-To: <cover.1587500467.git.rgb@redhat.com>
References: <cover.1587500467.git.rgb@redhat.com>
In-Reply-To: <cover.1587500467.git.rgb@redhat.com>
References: <cover.1587500467.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

NETFILTER_CFG record generation was inconsistent for x_tables and
ebtables configuration changes.  The call was needlessly messy and there
were supporting records missing at times while they were produced when
not requested.  Simplify the logging call into a new audit_log_nfcfg
call.  Honour the audit_enabled setting while more consistently
recording information including supporting records by tidying up dummy
checks.

Add an op= field that indicates the operation being performed (register
or replace).

Here is the enhanced sample record:
  type=NETFILTER_CFG msg=audit(1580905834.919:82970): table=filter family=2 entries=83 op=replace

Generate audit NETFILTER_CFG records on ebtables table registration.
Previously this was being done for x_tables registration and replacement
operations and ebtables table replacement only.

See: https://github.com/linux-audit/audit-kernel/issues/25
See: https://github.com/linux-audit/audit-kernel/issues/35
See: https://github.com/linux-audit/audit-kernel/issues/43

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h           | 21 +++++++++++++++++++++
 kernel/auditsc.c                | 24 ++++++++++++++++++++++++
 net/bridge/netfilter/ebtables.c | 12 ++++--------
 net/netfilter/x_tables.c        | 12 +++---------
 4 files changed, 52 insertions(+), 17 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index f9ceae57ca8d..5c7f07a9776d 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -94,6 +94,11 @@ struct audit_ntp_data {
 struct audit_ntp_data {};
 #endif
 
+enum audit_nfcfgop {
+	AUDIT_XT_OP_REGISTER,
+	AUDIT_XT_OP_REPLACE,
+};
+
 extern int is_audit_feature_set(int which);
 
 extern int __init audit_register_class(int class, unsigned *list);
@@ -379,6 +384,8 @@ extern int __audit_log_bprm_fcaps(struct linux_binprm *bprm,
 extern void __audit_fanotify(unsigned int response);
 extern void __audit_tk_injoffset(struct timespec64 offset);
 extern void __audit_ntp_log(const struct audit_ntp_data *ad);
+extern void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
+			      enum audit_nfcfgop op);
 
 static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
 {
@@ -514,6 +521,14 @@ static inline void audit_ntp_log(const struct audit_ntp_data *ad)
 		__audit_ntp_log(ad);
 }
 
+static inline void audit_log_nfcfg(const char *name, u8 af,
+				   unsigned int nentries,
+				   enum audit_nfcfgop op)
+{
+	if (audit_enabled)
+		__audit_log_nfcfg(name, af, nentries, op);
+}
+
 extern int audit_n_rules;
 extern int audit_signals;
 #else /* CONFIG_AUDITSYSCALL */
@@ -646,6 +661,12 @@ static inline void audit_ntp_log(const struct audit_ntp_data *ad)
 
 static inline void audit_ptrace(struct task_struct *t)
 { }
+
+static inline void audit_log_nfcfg(const char *name, u8 af,
+				   unsigned int nentries,
+				   enum audit_nfcfgop op)
+{ }
+
 #define audit_n_rules 0
 #define audit_signals 0
 #endif /* CONFIG_AUDITSYSCALL */
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 814406a35db1..705beac0ce29 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -130,6 +130,16 @@ struct audit_tree_refs {
 	struct audit_chunk *c[31];
 };
 
+struct audit_nfcfgop_tab {
+	enum audit_nfcfgop	op;
+	const char		*s;
+};
+
+const struct audit_nfcfgop_tab audit_nfcfgs[] = {
+	{ AUDIT_XT_OP_REGISTER,	"register"	},
+	{ AUDIT_XT_OP_REPLACE,	"replace"	},
+};
+
 static int audit_match_perm(struct audit_context *ctx, int mask)
 {
 	unsigned n;
@@ -2542,6 +2552,20 @@ void __audit_ntp_log(const struct audit_ntp_data *ad)
 	audit_log_ntp_val(ad, "adjust",	AUDIT_NTP_ADJUST);
 }
 
+void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
+		       enum audit_nfcfgop op)
+{
+	struct audit_buffer *ab;
+
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_NETFILTER_CFG);
+	if (!ab)
+		return;
+	audit_log_format(ab, "table=%s family=%u entries=%u op=%s",
+			 name, af, nentries, audit_nfcfgs[op].s);
+	audit_log_end(ab);
+}
+EXPORT_SYMBOL_GPL(__audit_log_nfcfg);
+
 static void audit_log_task(struct audit_buffer *ab)
 {
 	kuid_t auid, uid;
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 78db58c7aec2..0a148e68b6e1 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1046,14 +1046,8 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 	vfree(table);
 	vfree(counterstmp);
 
-#ifdef CONFIG_AUDIT
-	if (audit_enabled) {
-		audit_log(audit_context(), GFP_KERNEL,
-			  AUDIT_NETFILTER_CFG,
-			  "table=%s family=%u entries=%u",
-			  repl->name, AF_BRIDGE, repl->nentries);
-	}
-#endif
+	audit_log_nfcfg(repl->name, AF_BRIDGE, repl->nentries,
+			AUDIT_XT_OP_REPLACE);
 	return ret;
 
 free_unlock:
@@ -1223,6 +1217,8 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 		*res = NULL;
 	}
 
+	audit_log_nfcfg(repl->name, AF_BRIDGE, repl->nentries,
+			AUDIT_XT_OP_REGISTER);
 	return ret;
 free_unlock:
 	mutex_unlock(&ebt_mutex);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index cd2b034eef59..8f8c5dbf603d 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1408,15 +1408,9 @@ struct xt_table_info *
 		}
 	}
 
-#ifdef CONFIG_AUDIT
-	if (audit_enabled) {
-		audit_log(audit_context(), GFP_KERNEL,
-			  AUDIT_NETFILTER_CFG,
-			  "table=%s family=%u entries=%u",
-			  table->name, table->af, private->number);
-	}
-#endif
-
+	audit_log_nfcfg(table->name, table->af, private->number,
+			!private->number ? AUDIT_XT_OP_REGISTER :
+					   AUDIT_XT_OP_REPLACE);
 	return private;
 }
 EXPORT_SYMBOL_GPL(xt_replace_table);
-- 
1.8.3.1

