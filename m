Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AAF1C33CB3
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 21:20:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B9812064C
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 21:20:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mti82Zxl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388783AbgAPVUm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 16:20:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46167 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729211AbgAPVUl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 16:20:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579209640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OWaRr6h+fYNYUWtshSDDFH28gfR7IxTJvOjH91SRqww=;
        b=Mti82Zxlnol8AC4xPAL4CuX28iBmgvYocu4H4SmFlvCFvJVO2Zne8/1m1nvhvT4Wsxupry
        b7531qL9Z27b7WRjaYsQOAN9q8/r9lMxUoQ5i0/TROWAQehBs3xs99iBILoXGsxHREulSQ
        mjme+KkZISr0PcoWzSE03pKfdfS6hsQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-aRIPpYMsNemd0-_0kzL7SQ-1; Thu, 16 Jan 2020 16:20:38 -0500
X-MC-Unique: aRIPpYMsNemd0-_0kzL7SQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 114888017CC;
        Thu, 16 Jan 2020 21:20:36 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-12.phx2.redhat.com [10.3.112.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5ED1B5C545;
        Thu, 16 Jan 2020 21:20:26 +0000 (UTC)
Date:   Thu, 16 Jan 2020 16:20:23 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, ebiederm@xmission.com,
        tgraf@infradead.org
Subject: Re: [PATCH ghak25 v2 0/9] Address NETFILTER_CFG issues
Message-ID: <20200116212023.w2ylqqmf654hwuvq@madcap2.tricolour.ca>
References: <cover.1577830902.git.rgb@redhat.com>
 <20200116150518.gfmzixoqagmk77rw@salvia>
 <CAHC9VhSowSdhwaGNVfj-Paj7=38z1D-p+=EDQNUAwNJpO_tyXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSowSdhwaGNVfj-Paj7=38z1D-p+=EDQNUAwNJpO_tyXg@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-01-16 14:07, Paul Moore wrote:
> On Thu, Jan 16, 2020 at 10:05 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Jan 06, 2020 at 01:54:01PM -0500, Richard Guy Briggs wrote:
> > > There were questions about the presence and cause of unsolicited syscall events
> > > in the logs containing NETFILTER_CFG records and sometimes unaccompanied
> > > NETFILTER_CFG records.
> > >
> > > During testing at least the following list of events trigger NETFILTER_CFG
> > > records and the syscalls related (There may be more events that will trigger
> > > this message type.):
> > >       init_module, finit_module: modprobe
> > >       setsockopt: iptables-restore, ip6tables-restore, ebtables-restore
> > >       unshare: (h?)ostnamed
> > >       clone: libvirtd
> > >
> > > The syscall events unsolicited by any audit rule were found to be caused by a
> > > missing !audit_dummy_context() check before creating a NETFILTER_CFG
> > > record and issuing the record immediately rather than saving the
> > > information to create the record at syscall exit.
> > > Check !audit_dummy_context() before creating the NETFILTER_CFG record.
> > >
> > > The vast majority of unaccompanied records are caused by the fedora default
> > > rule: "-a never,task" and the occasional early startup one is I believe caused
> > > by the iptables filter table module hard linked into the kernel rather than a
> > > loadable module. The !audit_dummy_context() check above should avoid them.
> > >
> > > A couple of other factors should help eliminate unaccompanied records
> > > which include commit cb74ed278f80 ("audit: always enable syscall
> > > auditing when supported and audit is enabled") which makes sure that
> > > when audit is enabled, so automatically is syscall auditing, and ghak66
> > > which addressed initializing audit before PID 1.
> > >
> > > Ebtables module initialization to register tables doesn't generate records
> > > because it was never hooked in to audit.  Recommend adding audit hooks to log
> > > this.
> > >
> > > Table unregistration was never logged, which is now covered.
> > >
> > > Seemingly duplicate records are not actually exact duplicates that are caused
> > > by netfilter table initialization in different network namespaces from the same
> > > syscall.  Recommend adding the network namespace ID (proc inode and dev)
> > > to the record to make this obvious (address later with ghak79 after nsid
> > > patches).
> > >
> > > See: https://github.com/linux-audit/audit-kernel/issues/25
> > > See: https://github.com/linux-audit/audit-kernel/issues/35
> > > See: https://github.com/linux-audit/audit-kernel/issues/43
> > > See: https://github.com/linux-audit/audit-kernel/issues/44
> >
> > What tree is this batch targeted to?
> 
> I believe Richard was targeting this for the audit tree.

Yes, sorry Pablo, it is against audit/next based on v5.5-rc1

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

