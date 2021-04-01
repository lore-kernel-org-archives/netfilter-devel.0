Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C4EC43603
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 17:41:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4BA061165
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 17:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbhDARlq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:41:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36739 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234000AbhDARgR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 13:36:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617298570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bW7B9w+Q68Urxu39Qi9brljMKrW7wGi7AN397dg60A4=;
        b=HJPGA4D/4ZElSFsMy9EJthu535fi3KOz8bgwr9a/ksjtUu8VDjWciCkVVfgBrVomt6BpPC
        nq1X8Uqd8ApFYhfVcrPR5X3mug9T05nRQTj3YuYM5ww9xBjPP18cfH5k0uRg3Ll7zK1KaP
        YN+3zCEDCVvHgQUGYlo64fyA3YND6z0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-99AJc0sRM-C4SBQXrwmKUw-1; Thu, 01 Apr 2021 09:35:04 -0400
X-MC-Unique: 99AJc0sRM-C4SBQXrwmKUw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B70716B9D7;
        Thu,  1 Apr 2021 13:35:02 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 84C395D76F;
        Thu,  1 Apr 2021 13:34:50 +0000 (UTC)
Date:   Thu, 1 Apr 2021 09:34:47 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Phil Sutter <phil@nwl.cc>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Florian Westphal <fw@strlen.de>, twoerner@redhat.com,
        tgraf@infradead.org, dan.carpenter@oracle.com,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
Subject: Re: [PATCH v5] audit: log nftables configuration change events once
 per table
Message-ID: <20210401133447.GB3141668@madcap2.tricolour.ca>
References: <28de34275f58b45fd4626a92ccae96b6d2b4e287.1616702731.git.rgb@redhat.com>
 <20210401132444.GX3158@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401132444.GX3158@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2021-04-01 15:24, Phil Sutter wrote:
> On Fri, Mar 26, 2021 at 01:38:59PM -0400, Richard Guy Briggs wrote:
> > Reduce logging of nftables events to a level similar to iptables.
> > Restore the table field to list the table, adding the generation.
> > 
> > Indicate the op as the most significant operation in the event.
> > 
> > A couple of sample events:
> > 
> > type=PROCTITLE msg=audit(2021-03-18 09:30:49.801:143) : proctitle=/usr/bin/python3 -s /usr/sbin/firewalld --nofork --nopid
> > type=SYSCALL msg=audit(2021-03-18 09:30:49.801:143) : arch=x86_64 syscall=sendmsg success=yes exit=172 a0=0x6 a1=0x7ffdcfcbe650 a2=0x0 a3=0x7ffdcfcbd52c items=0 ppid=1 pid=367 auid=unset uid=root gid=root euid=root suid=root fsuid=root egid=roo
> > t sgid=root fsgid=root tty=(none) ses=unset comm=firewalld exe=/usr/bin/python3.9 subj=system_u:system_r:firewalld_t:s0 key=(null)
> > type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.801:143) : table=firewalld:2 family=ipv6 entries=1 op=nft_register_table pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
> > type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.801:143) : table=firewalld:2 family=ipv4 entries=1 op=nft_register_table pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
> > type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.801:143) : table=firewalld:2 family=inet entries=1 op=nft_register_table pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
> > 
> > type=PROCTITLE msg=audit(2021-03-18 09:30:49.839:144) : proctitle=/usr/bin/python3 -s /usr/sbin/firewalld --nofork --nopid
> > type=SYSCALL msg=audit(2021-03-18 09:30:49.839:144) : arch=x86_64 syscall=sendmsg success=yes exit=22792 a0=0x6 a1=0x7ffdcfcbe650 a2=0x0 a3=0x7ffdcfcbd52c items=0 ppid=1 pid=367 auid=unset uid=root gid=root euid=root suid=root fsuid=root egid=r
> > oot sgid=root fsgid=root tty=(none) ses=unset comm=firewalld exe=/usr/bin/python3.9 subj=system_u:system_r:firewalld_t:s0 key=(null)
> > type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.839:144) : table=firewalld:3 family=ipv6 entries=30 op=nft_register_chain pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
> > type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.839:144) : table=firewalld:3 family=ipv4 entries=30 op=nft_register_chain pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
> > type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.839:144) : table=firewalld:3 family=inet entries=165 op=nft_register_chain pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
> > 
> > The issue was originally documented in
> > https://github.com/linux-audit/audit-kernel/issues/124
> > 
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> 
> Tested this patch to make sure it eliminates the slowdown of
> iptables-nft when auditd is running. With this applied, neither
> iptables-nft-restore nor 'iptables-nft -F' show a significant
> difference in run-time between running or stopped auditd, at least for
> large rulesets. Individual calls suffer from added audit logging, but
> that's expected of course.
> 
> Tested-by: Phil Sutter <phil@nwl.cc>

Excellent, thanks Phil for helping nail this one down and confirming the
fix.

> Thanks, Phil

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

