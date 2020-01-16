Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 369B8C33CB1
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 15:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12BA120730
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 15:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgAPPFX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 10:05:23 -0500
Received: from correo.us.es ([193.147.175.20]:32968 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgAPPFX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 10:05:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A2667508CDD
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2020 16:05:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 93E4EDA781
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2020 16:05:21 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9255FDA729; Thu, 16 Jan 2020 16:05:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0FDC6DA712;
        Thu, 16 Jan 2020 16:05:19 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jan 2020 16:05:19 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DADC342EF9E1;
        Thu, 16 Jan 2020 16:05:18 +0100 (CET)
Date:   Thu, 16 Jan 2020 16:05:18 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        sgrubb@redhat.com, omosnace@redhat.com, fw@strlen.de,
        twoerner@redhat.com, eparis@parisplace.org, ebiederm@xmission.com,
        tgraf@infradead.org
Subject: Re: [PATCH ghak25 v2 0/9] Address NETFILTER_CFG issues
Message-ID: <20200116150518.gfmzixoqagmk77rw@salvia>
References: <cover.1577830902.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1577830902.git.rgb@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jan 06, 2020 at 01:54:01PM -0500, Richard Guy Briggs wrote:
> There were questions about the presence and cause of unsolicited syscall events
> in the logs containing NETFILTER_CFG records and sometimes unaccompanied
> NETFILTER_CFG records.
> 
> During testing at least the following list of events trigger NETFILTER_CFG
> records and the syscalls related (There may be more events that will trigger
> this message type.):
> 	init_module, finit_module: modprobe
> 	setsockopt: iptables-restore, ip6tables-restore, ebtables-restore
> 	unshare: (h?)ostnamed
> 	clone: libvirtd
> 
> The syscall events unsolicited by any audit rule were found to be caused by a
> missing !audit_dummy_context() check before creating a NETFILTER_CFG
> record and issuing the record immediately rather than saving the
> information to create the record at syscall exit.
> Check !audit_dummy_context() before creating the NETFILTER_CFG record.
> 
> The vast majority of unaccompanied records are caused by the fedora default
> rule: "-a never,task" and the occasional early startup one is I believe caused
> by the iptables filter table module hard linked into the kernel rather than a
> loadable module. The !audit_dummy_context() check above should avoid them.
> 
> A couple of other factors should help eliminate unaccompanied records
> which include commit cb74ed278f80 ("audit: always enable syscall
> auditing when supported and audit is enabled") which makes sure that
> when audit is enabled, so automatically is syscall auditing, and ghak66
> which addressed initializing audit before PID 1.
> 
> Ebtables module initialization to register tables doesn't generate records
> because it was never hooked in to audit.  Recommend adding audit hooks to log
> this.
> 
> Table unregistration was never logged, which is now covered.
> 
> Seemingly duplicate records are not actually exact duplicates that are caused
> by netfilter table initialization in different network namespaces from the same
> syscall.  Recommend adding the network namespace ID (proc inode and dev)
> to the record to make this obvious (address later with ghak79 after nsid
> patches).
> 
> See: https://github.com/linux-audit/audit-kernel/issues/25
> See: https://github.com/linux-audit/audit-kernel/issues/35
> See: https://github.com/linux-audit/audit-kernel/issues/43
> See: https://github.com/linux-audit/audit-kernel/issues/44

What tree is this batch targeted to?

Thanks.
