Return-Path: <SRS0=o6T4=AF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3BB7C433E1
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 12:35:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B60920857
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 12:35:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tkll1o2+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403939AbgFXMfL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Jun 2020 08:35:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35116 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2403900AbgFXMen (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jun 2020 08:34:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593002081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9ew0dkmE9sZPBv3Fo0zDcKheH0XoZZSOf+61sV6N3AQ=;
        b=Tkll1o2+sf7oXZcq1Fkx2rC7Z3JQCOKw6QV65w/ZNenEWit5aHQwxCEfk8RhsSoNT/o2Pe
        QR8pM3mn+qlF8ZLWUJBRG+1xN47kx/EdRmDdc5zbsf1uwUrIqpqi+q9u1urpx7MpQqs+JP
        LTF5OrcGW6tVZP4SY1vZxl+DejV3lfo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-JT-F7A01NDWae3BwtJKTow-1; Wed, 24 Jun 2020 08:34:36 -0400
X-MC-Unique: JT-F7A01NDWae3BwtJKTow-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFE77464;
        Wed, 24 Jun 2020 12:34:34 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.28])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C37D100EBB8;
        Wed, 24 Jun 2020 12:34:26 +0000 (UTC)
Date:   Wed, 24 Jun 2020 08:34:23 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        sgrubb@redhat.com, omosnace@redhat.com, fw@strlen.de,
        twoerner@redhat.com, eparis@parisplace.org, tgraf@infradead.org
Subject: Re: [PATCH ghak124 v3] audit: log nftables configuration change
 events
Message-ID: <20200624123423.r2gypsdii6xgiywy@madcap2.tricolour.ca>
References: <f9da8b5dbf2396b621c77c17b5b1123be5aa484e.1591275439.git.rgb@redhat.com>
 <20200624100346.GA11986@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624100346.GA11986@salvia>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-06-24 12:03, Pablo Neira Ayuso wrote:
> On Thu, Jun 04, 2020 at 09:20:49AM -0400, Richard Guy Briggs wrote:
> > iptables, ip6tables, arptables and ebtables table registration,
> > replacement and unregistration configuration events are logged for the
> > native (legacy) iptables setsockopt api, but not for the
> > nftables netlink api which is used by the nft-variant of iptables in
> > addition to nftables itself.
> > 
> > Add calls to log the configuration actions in the nftables netlink api.
> > 
> > This uses the same NETFILTER_CFG record format but overloads the table
> > field.
> > 
> >   type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.878:162) : table=?:0;?:0 family=unspecified entries=2 op=nft_register_gen pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
> >   ...
> >   type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.878:162) : table=firewalld:1;?:0 family=inet entries=0 op=nft_register_table pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
> >   ...
> >   type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.911:163) : table=firewalld:1;filter_FORWARD:85 family=inet entries=8 op=nft_register_chain pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
> >   ...
> >   type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.911:163) : table=firewalld:1;filter_FORWARD:85 family=inet entries=101 op=nft_register_rule pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
> >   ...
> >   type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.911:163) : table=firewalld:1;__set0:87 family=inet entries=87 op=nft_register_setelem pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
> >   ...
> >   type=NETFILTER_CFG msg=audit(2020-05-28 17:46:41.911:163) : table=firewalld:1;__set0:87 family=inet entries=0 op=nft_register_set pid=396 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
> > 
> > For further information please see issue
> > https://github.com/linux-audit/audit-kernel/issues/124
> > 
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> > Changelog:
> > v3:
> > - inline message type rather than table
> > 
> > v2:
> > - differentiate between xtables and nftables
> > - add set, setelem, obj, flowtable, gen
> > - use nentries field as appropriate per type
> > - overload the "tables" field with table handle and chain/set/flowtable
> > 
> >  include/linux/audit.h         |  18 ++++++++
> >  kernel/auditsc.c              |  24 ++++++++--
> >  net/netfilter/nf_tables_api.c | 103 ++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 142 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index 3fcd9ee49734..604ede630580 100644
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
> > @@ -98,6 +99,23 @@ enum audit_nfcfgop {
> >  	AUDIT_XT_OP_REGISTER,
> >  	AUDIT_XT_OP_REPLACE,
> >  	AUDIT_XT_OP_UNREGISTER,
> > +	AUDIT_NFT_OP_TABLE_REGISTER,
> > +	AUDIT_NFT_OP_TABLE_UNREGISTER,
> > +	AUDIT_NFT_OP_CHAIN_REGISTER,
> > +	AUDIT_NFT_OP_CHAIN_UNREGISTER,
> > +	AUDIT_NFT_OP_RULE_REGISTER,
> > +	AUDIT_NFT_OP_RULE_UNREGISTER,
> > +	AUDIT_NFT_OP_SET_REGISTER,
> > +	AUDIT_NFT_OP_SET_UNREGISTER,
> > +	AUDIT_NFT_OP_SETELEM_REGISTER,
> > +	AUDIT_NFT_OP_SETELEM_UNREGISTER,
> > +	AUDIT_NFT_OP_GEN_REGISTER,
> > +	AUDIT_NFT_OP_OBJ_REGISTER,
> > +	AUDIT_NFT_OP_OBJ_UNREGISTER,
> > +	AUDIT_NFT_OP_OBJ_RESET,
> > +	AUDIT_NFT_OP_FLOWTABLE_REGISTER,
> > +	AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
> > +	AUDIT_NFT_OP_INVALID,
> >  };
> >  
> >  extern int is_audit_feature_set(int which);
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index 468a23390457..3a9100e95fda 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -75,6 +75,7 @@
> >  #include <linux/uaccess.h>
> >  #include <linux/fsnotify_backend.h>
> >  #include <uapi/linux/limits.h>
> > +#include <uapi/linux/netfilter/nf_tables.h>
> >  
> >  #include "audit.h"
> >  
> > @@ -136,9 +137,26 @@ struct audit_nfcfgop_tab {
> >  };
> >  
> >  static const struct audit_nfcfgop_tab audit_nfcfgs[] = {
> > -	{ AUDIT_XT_OP_REGISTER,		"register"	},
> > -	{ AUDIT_XT_OP_REPLACE,		"replace"	},
> > -	{ AUDIT_XT_OP_UNREGISTER,	"unregister"	},
> > +	{ AUDIT_XT_OP_REGISTER,			"xt_register"		   },
> > +	{ AUDIT_XT_OP_REPLACE,			"xt_replace"		   },
> > +	{ AUDIT_XT_OP_UNREGISTER,		"xt_unregister"		   },
> > +	{ AUDIT_NFT_OP_TABLE_REGISTER,		"nft_register_table"	   },
> > +	{ AUDIT_NFT_OP_TABLE_UNREGISTER,	"nft_unregister_table"	   },
> > +	{ AUDIT_NFT_OP_CHAIN_REGISTER,		"nft_register_chain"	   },
> > +	{ AUDIT_NFT_OP_CHAIN_UNREGISTER,	"nft_unregister_chain"	   },
> > +	{ AUDIT_NFT_OP_RULE_REGISTER,		"nft_register_rule"	   },
> > +	{ AUDIT_NFT_OP_RULE_UNREGISTER,		"nft_unregister_rule"	   },
> > +	{ AUDIT_NFT_OP_SET_REGISTER,		"nft_register_set"	   },
> > +	{ AUDIT_NFT_OP_SET_UNREGISTER,		"nft_unregister_set"	   },
> > +	{ AUDIT_NFT_OP_SETELEM_REGISTER,	"nft_register_setelem"	   },
> > +	{ AUDIT_NFT_OP_SETELEM_UNREGISTER,	"nft_unregister_setelem"   },
> > +	{ AUDIT_NFT_OP_GEN_REGISTER,		"nft_register_gen"	   },
> > +	{ AUDIT_NFT_OP_OBJ_REGISTER,		"nft_register_obj"	   },
> > +	{ AUDIT_NFT_OP_OBJ_UNREGISTER,		"nft_unregister_obj"	   },
> > +	{ AUDIT_NFT_OP_OBJ_RESET,		"nft_reset_obj"		   },
> > +	{ AUDIT_NFT_OP_FLOWTABLE_REGISTER,	"nft_register_flowtable"   },
> > +	{ AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,	"nft_unregister_flowtable" },
> > +	{ AUDIT_NFT_OP_INVALID,			"nft_invalid"		   },
> >  };
> >  
> >  static int audit_match_perm(struct audit_context *ctx, int mask)
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 3558e76e2733..b9e7440cc87d 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -12,6 +12,7 @@
> >  #include <linux/netlink.h>
> >  #include <linux/vmalloc.h>
> >  #include <linux/rhashtable.h>
> > +#include <linux/audit.h>
> >  #include <linux/netfilter.h>
> >  #include <linux/netfilter/nfnetlink.h>
> >  #include <linux/netfilter/nf_tables.h>
> > @@ -693,6 +694,16 @@ static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
> >  {
> >  	struct sk_buff *skb;
> >  	int err;
> > +	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;?:0",
> > +			      ctx->table->name, ctx->table->handle);
> > +
> > +	audit_log_nfcfg(buf,
> > +			ctx->family,
> > +			ctx->table->use,
> > +			event == NFT_MSG_NEWTABLE ?
> > +				AUDIT_NFT_OP_TABLE_REGISTER :
> > +				AUDIT_NFT_OP_TABLE_UNREGISTER);
> > +	kfree(buf);
> 
> As a follow up: Would you wrap this code into a function?
> 
>         nft_table_audit()
> 
> Same thing for other pieces of code below.

If I'm guessing right, you are asking for a supplementary follow-up
cleanup patch to this one (or are you nacking this patch)?

Also, I gather you would like to see the kasprintf and kfree hidden in
nft_table_audit(), handing this function at least 8 parameters?  This
sounds pretty messy given the format of the table field.

> Thanks.

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

