Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 587ACC33C8C
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 18:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D5362070E
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 18:55:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XPVtjVJQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgAFSz1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 13:55:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53761 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726721AbgAFSz1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 13:55:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578336926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:in-reply-to:
         references:references:references;
        bh=mOTsYra7hwKjPKyO6CGxOhNHLDXcto4fmRUDWd5T7qE=;
        b=XPVtjVJQ0XyUEOHNr27p+KfLKUNM4fdMzGl+f39sFIBFmBz8r69Bffai8HfAIpJIHe4LZ5
        V1YYJez+ixlpNm0p2exIUK8JuDp0/Fy0Lki3hJjgqGs54q16PxiebYFt3HRuCHBAlaT16v
        t0s26F3HfIFfufVLsQQTYsKzyWtarS0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-NikjEjsuPyu8SpU23id_Lw-1; Mon, 06 Jan 2020 13:55:25 -0500
X-MC-Unique: NikjEjsuPyu8SpU23id_Lw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 264458EB6C0;
        Mon,  6 Jan 2020 18:55:24 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-34.phx2.redhat.com [10.3.112.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 890FD5DA81;
        Mon,  6 Jan 2020 18:54:59 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        eparis@parisplace.org, ebiederm@xmission.com, tgraf@infradead.org,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak25 v2 4/9] audit: record nfcfg params
Date:   Mon,  6 Jan 2020 13:54:05 -0500
Message-Id: <b1b2e6f917816c4ae85b53d7f93c10c3d1df4a53.1577830902.git.rgb@redhat.com>
In-Reply-To: <cover.1577830902.git.rgb@redhat.com>
References: <cover.1577830902.git.rgb@redhat.com>
In-Reply-To: <cover.1577830902.git.rgb@redhat.com>
References: <cover.1577830902.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Record the auditable parameters of any non-empty netfilter table
configuration change.

See: https://github.com/linux-audit/audit-kernel/issues/25
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h | 11 +++++++++++
 kernel/auditsc.c      | 16 ++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index f9ceae57ca8d..96cabb095eed 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -379,6 +379,7 @@ extern int __audit_log_bprm_fcaps(struct linux_binprm *bprm,
 extern void __audit_fanotify(unsigned int response);
 extern void __audit_tk_injoffset(struct timespec64 offset);
 extern void __audit_ntp_log(const struct audit_ntp_data *ad);
+extern void __audit_nf_cfg(const char *name, u8 af, int nentries);
 
 static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
 {
@@ -514,6 +515,12 @@ static inline void audit_ntp_log(const struct audit_ntp_data *ad)
 		__audit_ntp_log(ad);
 }
 
+static inline void audit_nf_cfg(const char *name, u8 af, int nentries)
+{
+	if (!audit_dummy_context())
+		__audit_nf_cfg(name, af, nentries);
+}
+
 extern int audit_n_rules;
 extern int audit_signals;
 #else /* CONFIG_AUDITSYSCALL */
@@ -646,6 +653,10 @@ static inline void audit_ntp_log(const struct audit_ntp_data *ad)
 
 static inline void audit_ptrace(struct task_struct *t)
 { }
+
+static inline void audit_nf_cfg(const char *name, u8 af, int nentries)
+{ }
+
 #define audit_n_rules 0
 #define audit_signals 0
 #endif /* CONFIG_AUDITSYSCALL */
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 4effe01ebbe2..4e1df4233cd3 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2545,6 +2545,22 @@ void __audit_ntp_log(const struct audit_ntp_data *ad)
 	audit_log_ntp_val(ad, "adjust",	AUDIT_NTP_ADJUST);
 }
 
+void __audit_nf_cfg(const char *name, u8 af, int nentries)
+{
+	struct audit_buffer *ab;
+	struct audit_context *context = audit_context();
+
+	if (!nentries)
+		return;
+	ab = audit_log_start(context, GFP_KERNEL, AUDIT_NETFILTER_CFG);
+	if (!ab)
+		return;	/* audit_panic or being filtered */
+	audit_log_format(ab, "table=%s family=%u entries=%u",
+			 name, af, nentries);
+	audit_log_end(ab);
+}
+EXPORT_SYMBOL_GPL(__audit_nf_cfg);
+
 static void audit_log_task(struct audit_buffer *ab)
 {
 	kuid_t auid, uid;
-- 
1.8.3.1

