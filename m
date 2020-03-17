Return-Path: <SRS0=psrB=5C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E10ABC2BB1D
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Mar 2020 21:31:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4BC620714
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Mar 2020 21:31:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QWRu/KWR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgCQVb2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Mar 2020 17:31:28 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:54296 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727001AbgCQVb1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Mar 2020 17:31:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584480686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:in-reply-to:
         references:references:references;
        bh=Xx17PcBLPJdRQpm6K/Ykr3FR4auY4XV74j5fucy2QsE=;
        b=QWRu/KWRNk1FKUwgoDT19lgoWp5R3y7K0kapkY4ppWUqFeb/LojnNqNgYBkVIN/2oZ9vGI
        mBxkefP3E8fGcFargmRZCqGljzCkkRRpLxda7yDZGws9ksU89x6V4cahiJn6WHRzgWnabz
        jSVUBCQ4C09DFAlP9jDgG1PpZZiRI+k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-08fXe8sVMPqsSrtWRpGLnA-1; Tue, 17 Mar 2020 17:31:22 -0400
X-MC-Unique: 08fXe8sVMPqsSrtWRpGLnA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC31F1005513;
        Tue, 17 Mar 2020 21:31:20 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC9D819C4F;
        Tue, 17 Mar 2020 21:31:13 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        eparis@parisplace.org, ebiederm@xmission.com, tgraf@infradead.org,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak25 v3 1/3] audit: tidy and extend netfilter_cfg x_tables and ebtables logging
Date:   Tue, 17 Mar 2020 17:30:22 -0400
Message-Id: <3d591dc49fcb643890b93e5b9a8169612b1c96e1.1584480281.git.rgb@redhat.com>
In-Reply-To: <cover.1584480281.git.rgb@redhat.com>
References: <cover.1584480281.git.rgb@redhat.com>
In-Reply-To: <cover.1584480281.git.rgb@redhat.com>
References: <cover.1584480281.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
 include/linux/audit.h           | 19 +++++++++++++++++++
 kernel/auditsc.c                | 24 ++++++++++++++++++++++++
 net/bridge/netfilter/ebtables.c | 12 ++++--------
 net/netfilter/x_tables.c        | 12 +++---------
 4 files changed, 50 insertions(+), 17 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index f9ceae57ca8d..f4aed2b9be8d 100644
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
@@ -514,6 +521,13 @@ static inline void audit_ntp_log(const struct audit_ntp_data *ad)
 		__audit_ntp_log(ad);
 }
 
+static inline void audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
+				   enum audit_nfcfgop op)
+{
+	if (audit_enabled)
+		__audit_log_nfcfg(name, af, nentries, op);
+}
+
 extern int audit_n_rules;
 extern int audit_signals;
 #else /* CONFIG_AUDITSYSCALL */
@@ -646,6 +660,11 @@ static inline void audit_ntp_log(const struct audit_ntp_data *ad)
 
 static inline void audit_ptrace(struct task_struct *t)
 { }
+
+static inline void audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
+				   enum audit_nfcfgop op)
+{ }
+
 #define audit_n_rules 0
 #define audit_signals 0
 #endif /* CONFIG_AUDITSYSCALL */
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 814406a35db1..f4e342125dd9 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -130,6 +130,16 @@ struct audit_tree_refs {
 	struct audit_chunk *c[31];
 };
 
+struct audit_nfcfgop_tab {
+	enum audit_nfcfgop	op;
+	const char 		*s;
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
index e1256e03a9a8..55f9409c3ee0 100644
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
index e27c6c5ba9df..db5cbcf43748 100644
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
+		        !private->number ? AUDIT_XT_OP_REGISTER :
+					   AUDIT_XT_OP_REPLACE);
 	return private;
 }
 EXPORT_SYMBOL_GPL(xt_replace_table);
-- 
1.8.3.1

