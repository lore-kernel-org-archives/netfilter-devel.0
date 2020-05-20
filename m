Return-Path: <SRS0=7yxH=7C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E9EEC433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 18:48:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CB392072C
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 18:48:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IFXkmBFu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgETSr5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 May 2020 14:47:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49700 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726851AbgETSrx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 May 2020 14:47:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590000472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=FbstOtZHjkI5WT/d0lTEZRtt+wY/I8Pmam5TWWakNYU=;
        b=IFXkmBFugo3bbhA4djINt4b1HZ74ZByF/vrQdRLdBYDMBEmK+S8TdVYvjr7yNwXOrm1Q9N
        p14xr/T9doDfssj1VDk6be5FmVrYQWurYrLTKcpmwW+KqA8Ny+6prtwx4dPdEpPQpUjOpx
        Jy6MSCfxxR2idjOBw6nJXqmqQcy+230=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-kNT_esMuNGqglWWRk1wHxw-1; Wed, 20 May 2020 14:47:47 -0400
X-MC-Unique: kNT_esMuNGqglWWRk1wHxw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E597E107ACCA;
        Wed, 20 May 2020 18:47:45 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 833435C1BE;
        Wed, 20 May 2020 18:47:37 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        eparis@parisplace.org, tgraf@infradead.org,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak25 v6a] audit: add subj creds to NETFILTER_CFG record to cover async unregister
Date:   Wed, 20 May 2020 14:47:13 -0400
Message-Id: <6404938413ca29b0e0196dd74bacb9b0c1cb6f42.1589993784.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

Here are two sample orphaned records:

  type=NETFILTER_CFG msg=audit(2020-05-20 12:14:36.505:5) : table=filter family=ipv4 entries=0 op=register pid=1 subj=kernel comm=swapper/0

  type=NETFILTER_CFG msg=audit(2020-05-20 12:15:27.701:301) : table=nat family=bridge entries=0 op=unregister pid=30 subj=system_u:system_r:kernel_t:s0 comm=kworker/u4:1

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
Changelog:
v6
- remove uid, auid fields as duplicates or unset
- update sample records in patch description

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

 kernel/auditsc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index cfe3486e5f31..468a23390457 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2557,12 +2557,18 @@ void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
 		       enum audit_nfcfgop op)
 {
 	struct audit_buffer *ab;
+	char comm[sizeof(current->comm)];
 
 	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_NETFILTER_CFG);
 	if (!ab)
 		return;
 	audit_log_format(ab, "table=%s family=%u entries=%u op=%s",
 			 name, af, nentries, audit_nfcfgs[op].s);
+
+	audit_log_format(ab, " pid=%u", task_pid_nr(current));
+	audit_log_task_context(ab); /* subj= */
+	audit_log_format(ab, " comm=");
+	audit_log_untrustedstring(ab, get_task_comm(comm, current));
 	audit_log_end(ab);
 }
 EXPORT_SYMBOL_GPL(__audit_log_nfcfg);
-- 
1.8.3.1

