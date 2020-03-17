Return-Path: <SRS0=psrB=5C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B8AC5ACD6
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Mar 2020 21:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11A2F20714
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Mar 2020 21:31:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dFpf16B8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgCQVbV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Mar 2020 17:31:21 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:59471 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726494AbgCQVbT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Mar 2020 17:31:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584480678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=2WVvdeTWNDlkBf1UYF7ufANAKZfT3CWdgizs+joyuIg=;
        b=dFpf16B8LGsFUT12EXAyNxjQXhwQtYpirb3l7C7uOmXA75Be9vpUy1KFFUx1U6fDP1qi/V
        uJbv7ih0K0ITRLd/fcpTszoI9CcCvAaY2pbjr/4JdvJoFQ/82bQhj+InlITLfzVFd/YnBp
        Ou6ET91YhsLc8w9ftjP0FWrTY3MHbBk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-1LYPfGhpNeeDHQCKnLc0Jw-1; Tue, 17 Mar 2020 17:31:14 -0400
X-MC-Unique: 1LYPfGhpNeeDHQCKnLc0Jw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 063B218B647D;
        Tue, 17 Mar 2020 21:31:13 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28DB619C58;
        Tue, 17 Mar 2020 21:31:00 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        eparis@parisplace.org, ebiederm@xmission.com, tgraf@infradead.org,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak25 v3 0/3] Address NETFILTER_CFG issues
Date:   Tue, 17 Mar 2020 17:30:21 -0400
Message-Id: <cover.1584480281.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There were questions about the presence and cause of unsolicited syscall events
in the logs containing NETFILTER_CFG records and sometimes unaccompanied
NETFILTER_CFG records.

During testing at least the following list of events trigger NETFILTER_CFG
records and the syscalls related (There may be more events that will trigger
this message type.):
	init_module, finit_module: modprobe
	delete_module: rmmod
	setsockopt: iptables-restore, ip6tables-restore, ebtables-restore
	unshare: (h?)ostnamed, updatedb
	clone: libvirtd
	kernel threads garbage collecting empty ebtables

The syscall events unsolicited by any audit rule were found to be caused by a
missing !audit_dummy_context() check before issuing a NETFILTER_CFG
record.  In fact, since this is a configuration change it is required,
and we always want the accompanying syscall record even with no rules
present, so this has been addressed by ghak120.

The vast majority of unaccompanied records are caused by the fedora default
rule: "-a never,task" and the occasional early startup one is I believe caused
by the iptables filter table module hard linked into the kernel rather than a
loadable module.

A couple of other factors should help eliminate unaccompanied records
which include commit cb74ed278f80 ("audit: always enable syscall
auditing when supported and audit is enabled") which makes sure that
when audit is enabled, so automatically is syscall auditing, and ghak66
which addressed initializing audit before PID 1.

Ebtables module initialization to register tables doesn't generate records
because it was never hooked in to audit.  Recommend adding audit hooks to log
this covered by ghak43 covered by patch 1.

Table unregistration was never logged, which is now covered by ghak44 in
patch 2.  Unaccompanied records were caused by kernel threads
automatically unregistering empty ebtables, which necessitates adding
subject credentials covered in patch 3.

Seemingly duplicate records are not actually exact duplicates that are caused
by netfilter table initialization in different network namespaces from the same
syscall.  Recommend adding the network namespace ID (proc inode and dev)
to the record to make this obvious (address later with ghak79 after nsid
patches).

See: https://github.com/linux-audit/audit-kernel/issues/25
See: https://github.com/linux-audit/audit-kernel/issues/35
See: https://github.com/linux-audit/audit-kernel/issues/43
See: https://github.com/linux-audit/audit-kernel/issues/44

Changelog:
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

Richard Guy Briggs (3):
  audit: tidy and extend netfilter_cfg x_tables and ebtables logging
  netfilter: add audit table unregister actions
  audit: add subj creds to NETFILTER_CFG record to cover async
    unregister

 include/linux/audit.h           | 20 +++++++++++++++++++
 kernel/auditsc.c                | 43 +++++++++++++++++++++++++++++++++++++++++
 net/bridge/netfilter/ebtables.c | 14 ++++++--------
 net/netfilter/x_tables.c        | 14 +++++---------
 4 files changed, 74 insertions(+), 17 deletions(-)

-- 
1.8.3.1

