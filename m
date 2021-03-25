Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82D72C433DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Mar 2021 03:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56BBA61A18
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Mar 2021 03:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbhCYDQV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 23:16:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48229 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231693AbhCYDPv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 23:15:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616642150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HUMRt/wsR7njAnroDYg1kIdMlW4yIA+1xmu98fOBeas=;
        b=KtFJMsg3jyAQN+Np5qomOrS2nMqOez2qEA2pPn1BYci753BtdJAHc2we7HgpS1DAIHHPn5
        9KJYr2rSZoUejKu4ibdf7z/yKsDRYVSld9WwUIOTRbtKX2XzQU6yyFvdH6hLFfZw+DHQfm
        uJBqZ8N5vsT6jEdDf9r/Z2EpLTmlQuc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-yaGMiU1jP-65lELx1Rzgeg-1; Wed, 24 Mar 2021 23:15:46 -0400
X-MC-Unique: yaGMiU1jP-65lELx1Rzgeg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18C048189CD;
        Thu, 25 Mar 2021 03:15:44 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 172DA19C93;
        Thu, 25 Mar 2021 03:15:34 +0000 (UTC)
Date:   Wed, 24 Mar 2021 23:15:32 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        twoerner@redhat.com, tgraf@infradead.org, dan.carpenter@oracle.com,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
Subject: Re: [PATCH v3] audit: log nftables configuration change events once
 per table
Message-ID: <20210325031532.GU3141668@madcap2.tricolour.ca>
References: <3d15fa1f0c54335f9258d90ea0d11050e780ba70.1616529248.git.rgb@redhat.com>
 <CAHC9VhTtkar8zt9JP2o0EX5R5bpHaX45=tNtCLuaDNcwtV8baQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhTtkar8zt9JP2o0EX5R5bpHaX45=tNtCLuaDNcwtV8baQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2021-03-24 12:32, Paul Moore wrote:
> On Tue, Mar 23, 2021 at 4:05 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >
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
> > ---
> > Changelog:
> > v3:
> > - fix function braces, reduce parameter scope
> > - pre-allocate nft_audit_data per table in step 1, bail on ENOMEM
> >
> > v2:
> > - convert NFT ops to array indicies in nft2audit_op[]
> > - use linux lists
> > - use functions for each of collection and logging of audit data
> > ---
> >  include/linux/audit.h         |  28 ++++++
> >  net/netfilter/nf_tables_api.c | 160 ++++++++++++++++------------------
> >  2 files changed, 105 insertions(+), 83 deletions(-)
> 
> ...
> 
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index 82b7c1116a85..5fafcf4c13de 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -118,6 +118,34 @@ enum audit_nfcfgop {
> >         AUDIT_NFT_OP_INVALID,
> >  };
> >
> > +static const u8 nft2audit_op[NFT_MSG_MAX] = { // enum nf_tables_msg_types
> > +       [NFT_MSG_NEWTABLE]      = AUDIT_NFT_OP_TABLE_REGISTER,
> > +       [NFT_MSG_GETTABLE]      = AUDIT_NFT_OP_INVALID,
> > +       [NFT_MSG_DELTABLE]      = AUDIT_NFT_OP_TABLE_UNREGISTER,
> > +       [NFT_MSG_NEWCHAIN]      = AUDIT_NFT_OP_CHAIN_REGISTER,
> > +       [NFT_MSG_GETCHAIN]      = AUDIT_NFT_OP_INVALID,
> > +       [NFT_MSG_DELCHAIN]      = AUDIT_NFT_OP_CHAIN_UNREGISTER,
> > +       [NFT_MSG_NEWRULE]       = AUDIT_NFT_OP_RULE_REGISTER,
> > +       [NFT_MSG_GETRULE]       = AUDIT_NFT_OP_INVALID,
> > +       [NFT_MSG_DELRULE]       = AUDIT_NFT_OP_RULE_UNREGISTER,
> > +       [NFT_MSG_NEWSET]        = AUDIT_NFT_OP_SET_REGISTER,
> > +       [NFT_MSG_GETSET]        = AUDIT_NFT_OP_INVALID,
> > +       [NFT_MSG_DELSET]        = AUDIT_NFT_OP_SET_UNREGISTER,
> > +       [NFT_MSG_NEWSETELEM]    = AUDIT_NFT_OP_SETELEM_REGISTER,
> > +       [NFT_MSG_GETSETELEM]    = AUDIT_NFT_OP_INVALID,
> > +       [NFT_MSG_DELSETELEM]    = AUDIT_NFT_OP_SETELEM_UNREGISTER,
> > +       [NFT_MSG_NEWGEN]        = AUDIT_NFT_OP_GEN_REGISTER,
> > +       [NFT_MSG_GETGEN]        = AUDIT_NFT_OP_INVALID,
> > +       [NFT_MSG_TRACE]         = AUDIT_NFT_OP_INVALID,
> > +       [NFT_MSG_NEWOBJ]        = AUDIT_NFT_OP_OBJ_REGISTER,
> > +       [NFT_MSG_GETOBJ]        = AUDIT_NFT_OP_INVALID,
> > +       [NFT_MSG_DELOBJ]        = AUDIT_NFT_OP_OBJ_UNREGISTER,
> > +       [NFT_MSG_GETOBJ_RESET]  = AUDIT_NFT_OP_OBJ_RESET,
> > +       [NFT_MSG_NEWFLOWTABLE]  = AUDIT_NFT_OP_FLOWTABLE_REGISTER,
> > +       [NFT_MSG_GETFLOWTABLE]  = AUDIT_NFT_OP_INVALID,
> > +       [NFT_MSG_DELFLOWTABLE]  = AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
> > +};
> 
> The previously reported problem with this as a static still exists,
> correct?  It does seem like this should live in nf_tables_api.c
> doesn't it?

Yes.  Thank you.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

