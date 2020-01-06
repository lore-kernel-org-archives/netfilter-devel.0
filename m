Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50699C33C8C
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 18:54:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2363F208C4
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 18:54:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JwctZzld"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgAFSyz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 13:54:55 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48180 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726657AbgAFSyz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 13:54:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578336893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=zUi4N5K5yW5gkKkEx9fAnGxorkBR0dJVBcurzQJwTuk=;
        b=JwctZzldfn+z8TO/cf0bY+nkf46HiQe/Ug5SvOjb5mk0pYY2UaOTH8sTWbxJxvhGDy0eRN
        oMipnJnesMaVwOzhhVJNAOVFGRi4A/PJ2gCL0tSx7YcrBYQhRCzCV+6sUejAzoVxAYEXG1
        jcPYCXYAb9DwI2puyKv9VORD/qgOYws=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-tlzUX1MoMjOHblyFlKcliA-1; Mon, 06 Jan 2020 13:54:50 -0500
X-MC-Unique: tlzUX1MoMjOHblyFlKcliA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39AF5800D48;
        Mon,  6 Jan 2020 18:54:49 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-34.phx2.redhat.com [10.3.112.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76E3A5D9E5;
        Mon,  6 Jan 2020 18:54:40 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        eparis@parisplace.org, ebiederm@xmission.com, tgraf@infradead.org,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak25 v2 0/9] Address NETFILTER_CFG issues
Date:   Mon,  6 Jan 2020 13:54:01 -0500
Message-Id: <cover.1577830902.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
	setsockopt: iptables-restore, ip6tables-restore, ebtables-restore
	unshare: (h?)ostnamed
	clone: libvirtd

The syscall events unsolicited by any audit rule were found to be caused by a
missing !audit_dummy_context() check before creating a NETFILTER_CFG
record and issuing the record immediately rather than saving the
information to create the record at syscall exit.
Check !audit_dummy_context() before creating the NETFILTER_CFG record.

The vast majority of unaccompanied records are caused by the fedora default
rule: "-a never,task" and the occasional early startup one is I believe caused
by the iptables filter table module hard linked into the kernel rather than a
loadable module. The !audit_dummy_context() check above should avoid them.

A couple of other factors should help eliminate unaccompanied records
which include commit cb74ed278f80 ("audit: always enable syscall
auditing when supported and audit is enabled") which makes sure that
when audit is enabled, so automatically is syscall auditing, and ghak66
which addressed initializing audit before PID 1.

Ebtables module initialization to register tables doesn't generate records
because it was never hooked in to audit.  Recommend adding audit hooks to log
this.

Table unregistration was never logged, which is now covered.

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

Richard Guy Briggs (9):
  netfilter: normalize x_table function declarations
  netfilter: normalize ebtables function declarations
  netfilter: normalize ebtables function declarations II
  audit: record nfcfg params
  netfilter: x_tables audit only on syscall rule
  netfilter: ebtables audit only on syscall rule
  netfilter: ebtables audit table registration
  netfilter: add audit operation field
  netfilter: audit table unregister actions

 include/linux/audit.h           |  11 ++++
 kernel/auditsc.c                |  18 +++++
 net/bridge/netfilter/ebtables.c | 142 ++++++++++++++++++++--------------------
 net/netfilter/x_tables.c        |  56 +++++++---------
 4 files changed, 124 insertions(+), 103 deletions(-)

-- 
1.8.3.1

