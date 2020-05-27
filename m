Return-Path: <SRS0=LpWG=7J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 527EDC433E1
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 15:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 298B4207D3
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 15:25:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YFODXYRp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730265AbgE0PZD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 May 2020 11:25:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38475 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730245AbgE0PZC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 May 2020 11:25:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590593100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fn+6b4qyDIsOgniKcST0/GkaHzrvrLEuKr2L+M9NLhk=;
        b=YFODXYRpuGq5TZrYuzVk3YWztPRHe/ZraEx3WNL+ZsYKE3TvOcYxNfHGul6Iibz6aWZRme
        lxcwUm+zv8CvSzD4eNrGujl0pTKQZQQMJGt2yuoawH735KVscLzNgLXEBzsCu8BhmMb5bH
        ON8jQH3V0+rM8ID03fCZY26u9HW/2BU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-s67B6LPtO_WIL_Sj8j60Bw-1; Wed, 27 May 2020 11:24:56 -0400
X-MC-Unique: s67B6LPtO_WIL_Sj8j60Bw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12ED11855A0D;
        Wed, 27 May 2020 15:24:55 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 775C15C1B0;
        Wed, 27 May 2020 15:24:46 +0000 (UTC)
Date:   Wed, 27 May 2020 11:24:43 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        sgrubb@redhat.com, omosnace@redhat.com, twoerner@redhat.com,
        eparis@parisplace.org, tgraf@infradead.org
Subject: Re: [PATCH ghak124 v1] audit: log nftables configuration change
 events
Message-ID: <20200527152443.7axktc2im3zpvk37@madcap2.tricolour.ca>
References: <d92a718b54269f426acc18f28e561031da66d3ca.1590579994.git.rgb@redhat.com>
 <20200527145317.GI2915@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527145317.GI2915@breakpoint.cc>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-05-27 16:53, Florian Westphal wrote:
> Richard Guy Briggs <rgb@redhat.com> wrote:
> > iptables, ip6tables, arptables and ebtables table registration,
> > replacement and unregistration configuration events are logged for the
> > native (legacy) iptables setsockopt api, but not for the
> > nftables netlink api which is used by the nft-variant of iptables in
> > addition to nftables itself.
> > 
> > Add calls to log the configuration actions in the nftables netlink api.
> > 
> > This uses the same NETFILTER_CFG record format.
> 
> I know little about audit records.  Does this allow the user to figure
> out that this record is created via nf_tables/netlink rather than xtables?

No, which is why I added that note below.  It shouldn't be hard to
change but I took the easy way to program it and now that I reflect on
it more, it sounds like it should be a basic requriement.

> > For further information please see issue
> > https://github.com/linux-audit/audit-kernel/issues/124
> > 
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> > This is an RFC patch.
> > Note: I have questions about the "entries" count.  Is there a more
> > appropriate or relevant item to report here?
> > Note: It might make sense to differentiate in the op= field that this
> > was a legacy call vs an nft call.  At the moment, legacy calls overlap
> > with nft table calls, which are similar calls.
> > 
> >  include/linux/audit.h         |  7 +++++++
> >  kernel/auditsc.c              | 12 +++++++++---
> >  net/netfilter/nf_tables_api.c | 14 ++++++++++++++
> >  3 files changed, 30 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index 3fcd9ee49734..b10f54103a82 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -12,6 +12,7 @@
> >  #include <linux/sched.h>
> >  #include <linux/ptrace.h>
> >  #include <uapi/linux/audit.h>
> > +#include <uapi/linux/netfilter/nf_tables.h>
> >  
> >  #define AUDIT_INO_UNSET ((unsigned long)-1)
> >  #define AUDIT_DEV_UNSET ((dev_t)-1)
> > @@ -98,6 +99,12 @@ enum audit_nfcfgop {
> >  	AUDIT_XT_OP_REGISTER,
> >  	AUDIT_XT_OP_REPLACE,
> >  	AUDIT_XT_OP_UNREGISTER,
> > +	AUDIT_XT_OP_CHAIN_REGISTER	= NFT_MSG_NEWCHAIN,
> 
> Hmm, this means AUDIT_XT_OP_CHAIN_REGISTER overlaps with the 4th
> audit_nfcfgop value...?

There was no 4th value, so the overlap is just the first three, which
are all table operations that more or less line up.

> > +	AUDIT_XT_OP_CHAIN_NOOP		= NFT_MSG_GETCHAIN,
> 
> GETCHAIN can't appear in the commit path (its not changing anything).
> Same for all other NFT_MSG_FOO that use ".call_rcu" action.

Again, I was a bit lazy in selecting the actions, and the GET actions
are of no interest since they don't change the configuration.

> Futhermore, I wonder what is to be logged by audit.

NEW and DEL of TABLEs, CHAINs and RULEs.

> The fact that there was 'some change'? If so, its enough to log
> the increment of the generation count during the commit phase.

Well, we are only logging "some change", so is it necessary to log the
generation count to show that?  Is the generation count of specific
interest?

> (After that, kernel can't back down anymore, i.e. all errors are
>  caught/handled beforehand).

I did think of recording all failed attempts too, but coding that would
be more effort.  It is worth doing if it is deemed important,
particularly for permission issues (as opposed to resource limits or
packet format errors.  This would be more of interest to a security
officer rather than a network technician, but the latter may find it
useful for debugging.

> If its 'any config change', then you also need to handle adds
> or delete from sets/maps, since that may allow something that wasn't
> allowed before, e.g. consider
> 
> ip saddr @trused accept
> 
> and then, later on,
> nft add element ip filter @trusted { 10.0.0.0/8, 192.168.0.1 }
> 
> This would not add a table, or chain, or set, but it does implicitly
> alter the ruleset.

Ah, ok, so yes, we would need that too.  I see family and table in
there, op is evident.  Is there a useful value we can use in the
"entries" field?

> > +		case NFT_MSG_DELRULE:
> > +			audit_log_nfcfg(trans->ctx.table->name,
> > +					trans->ctx.family,
> > +					atomic_read(&trans->ctx.table->chains_ht.ht.nelems),
> > +					trans->msg_type);
> > +			break;
> 
> Is that record format expected to emit the current number of chains?

I was aiming for a relevant value such as perhaps the new rule number or
the rule number being deleted.

> I'm not sure if that info is meaningful.

Can you suggest something meaningful?  This field may need to get
different information for each operation.

> Since table names can be anything in nf_tables (they have no special
> properties anymore), the table name is interesting from a informational
> pov, but not super interesting.

I don't think we need to be able to completely reconstruct the
tables/chains/rules from the information in the audit log, but be aware
of who is changing what when.

> This will also emit the same message/record multiple times, with only
> difference being the msg_type.  I'm not sure thats interesting.

I do think it is interesting.

> Consider a batch update that commits 100 new rules in chain x,
> this would result in 100 audit_log_nfcfg() calls, each with the
> same information.

So rule number would be a useful differentiator here.

> There are test cases in nftables.git, you could run them to see what
> kind of audit events are generated and how redundant they might be.

As a first pass, simply booting a test system and running the
audit-testsuite has provided some useful fodder.

Florian, thanks for your review and input.

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

