Return-Path: <SRS0=7yxH=7C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF702C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 16:52:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE8AC2065F
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 16:52:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qh5PsyJZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgETQwN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 May 2020 12:52:13 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60015 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726729AbgETQwN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 May 2020 12:52:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589993531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=rM7hZmpECL8qLEqrdjdyQimVaHtfW73QhKyl/FZ1pAI=;
        b=Qh5PsyJZpI5i1jzUJYR4wELDpH6QZj+JsPc71EyX3/ki3Xf1p1RysLwJhf4PczqA6CHx7m
        n6zgcfiVTGrjne01THCNKOELxFPLGw4tPoCUh7jVBgHRoDjVW/nOh0xaj83VErrdDdyX7e
        hHrD9GCJZxropndjt1XtT0uUJSNSNlM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-dPQRfS6aNfCV1XUTUYVImA-1; Wed, 20 May 2020 12:52:07 -0400
X-MC-Unique: dPQRfS6aNfCV1XUTUYVImA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DF008015CF;
        Wed, 20 May 2020 16:52:05 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31E3B60BEC;
        Wed, 20 May 2020 16:51:56 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        eparis@parisplace.org, tgraf@infradead.org,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak25 v6] audit: add subj creds to NETFILTER_CFG record to cover async unregister
Date:   Wed, 20 May 2020 12:51:32 -0400
Message-Id: <a585b9933896bc542347d8f3f26b08005344dd84.1589920939.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Some table unregister actions seem to be initiated by the kernel to
garbage collect unused tables that are not initiated by any userspace
actions.  It was found to be necessary to add the subject credentials to
cover this case to reveal the source of these actions.  A sample record:

The uid, auid, tty, ses and exe fields have not been included since they
are in the SYSCALL record and contain nothing useful in the non-user
context.

  type=NETFILTER_CFG msg=audit(2020-03-11 21:25:21.491:269) : table=nat family=bridge entries=0 op=unregister pid=153 subj=system_u:system_r:kernel_t:s0 comm=kworker/u4:2

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
Changelog:
v6
- remove uid, auid fields as duplicates or unset

v5
- rebase on upstreamed ghak28 on audit/next v5.7-rc1
- remove tty, ses and exe fields as duplicates or unset
- drop upstreamed patches 1&2 from set

v4
- rebase on audit/next v5.7-rc1
- fix checkpatch.pl errors/warnings in 1/3 and 2/3

v3
- rebase on v5.6-rc1 audit/next
- change audit_nf_cfg to audit_log_nfcfg
- squash 2,3,4,5 to 1 and update patch descriptions
- add subject credentials to cover garbage collecting kernel threads

v2
- Rebase (audit/next 5.5-rc1) to get audit_context access and ebt_register_table ret code
- Split x_tables and ebtables updates
- Check audit_dummy_context
- Store struct audit_nfcfg params in audit_context, abstract to audit_nf_cfg() call
- Restore back to "table, family, entries" from "family, table, entries"
- Log unregistration of tables
- Add "op=" at the end of the AUDIT_NETFILTER_CFG record
- Defer nsid patch (ghak79) to once nsid patchset upstreamed (ghak32)
- Add ghak refs
- Ditch NETFILTER_CFGSOLO record

 kernel/auditsc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index cfe3486e5f31..e646055adb0b 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2557,12 +2557,21 @@ void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
 		       enum audit_nfcfgop op)
 {
 	struct audit_buffer *ab;
+	const struct cred *cred;
+	struct tty_struct *tty;
+	char comm[sizeof(current->comm)];
 
 	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_NETFILTER_CFG);
 	if (!ab)
 		return;
 	audit_log_format(ab, "table=%s family=%u entries=%u op=%s",
 			 name, af, nentries, audit_nfcfgs[op].s);
+
+	cred = current_cred();
+	audit_log_format(ab, " pid=%u", task_pid_nr(current));
+	audit_log_task_context(ab); /* subj= */
+	audit_log_format(ab, " comm=");
+	audit_log_untrustedstring(ab, get_task_comm(comm, current));
 	audit_log_end(ab);
 }
 EXPORT_SYMBOL_GPL(__audit_log_nfcfg);
-- 
1.8.3.1

