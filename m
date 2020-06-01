Return-Path: <SRS0=n5XH=7O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 870C0C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jun 2020 22:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 505C62073B
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jun 2020 22:58:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O2sn8IRA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgFAW6x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Jun 2020 18:58:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56311 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725800AbgFAW6w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Jun 2020 18:58:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591052329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KQYWfj8uLyxoKfXSZak9oNxGL8NYLL/ZT3WXC4WUx7Y=;
        b=O2sn8IRApaUZIxJwRrcc1MBkK482IwCguusLqVDCTeM4gZHCrVC1a3EiQ8ciuJi6Op+fW8
        wj95uVc1Vmn+LVymZVkCkyjkbcVJ4wLx4TZzSSn3G/estvS/IoTksR5KazJPdsNumVYe4I
        /a/eiqA5i8leI48gwGpdjfX6mvLKDEs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-VGwIx79sPo-7OnnSuSc8CA-1; Mon, 01 Jun 2020 18:58:45 -0400
X-MC-Unique: VGwIx79sPo-7OnnSuSc8CA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 063A280B72E;
        Mon,  1 Jun 2020 22:58:44 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DE915D9C9;
        Mon,  1 Jun 2020 22:58:35 +0000 (UTC)
Date:   Mon, 1 Jun 2020 18:58:33 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, sgrubb@redhat.com,
        Ondrej Mosnacek <omosnace@redhat.com>, fw@strlen.de,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        tgraf@infradead.org
Subject: Re: [PATCH ghak124 v2] audit: log nftables configuration change
 events
Message-ID: <20200601225833.ut2wayc6xqefwveo@madcap2.tricolour.ca>
References: <d45d23ba6d58b1513c641dfb24f009cbc1b7aad6.1590716354.git.rgb@redhat.com>
 <CAHC9VhTuUdc565fPU=P1sXEM8hFm5P+ESm3Bv=kyebb19EsQuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhTuUdc565fPU=P1sXEM8hFm5P+ESm3Bv=kyebb19EsQuQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-06-01 12:10, Paul Moore wrote:
> On Thu, May 28, 2020 at 9:44 PM Richard Guy Briggs <rgb@redhat.com> wrote:
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
> > v2:
> > - differentiate between xtables and nftables
> > - add set, setelem, obj, flowtable, gen
> > - use nentries field as appropriate per type
> > - overload the "tables" field with table handle and chain/set/flowtable
> >
> >  include/linux/audit.h         | 52 +++++++++++++++++++++++++
> >  kernel/auditsc.c              | 24 ++++++++++--
> >  net/netfilter/nf_tables_api.c | 89 +++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 162 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index 3fcd9ee49734..d79866a38505 100644
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
> > @@ -98,6 +99,57 @@ enum audit_nfcfgop {
> >         AUDIT_XT_OP_REGISTER,
> >         AUDIT_XT_OP_REPLACE,
> >         AUDIT_XT_OP_UNREGISTER,
> > +       AUDIT_NFT_OP_TABLE_REGISTER,
> > +       AUDIT_NFT_OP_TABLE_UNREGISTER,
> > +       AUDIT_NFT_OP_CHAIN_REGISTER,
> > +       AUDIT_NFT_OP_CHAIN_UNREGISTER,
> > +       AUDIT_NFT_OP_RULE_REGISTER,
> > +       AUDIT_NFT_OP_RULE_UNREGISTER,
> > +       AUDIT_NFT_OP_SET_REGISTER,
> > +       AUDIT_NFT_OP_SET_UNREGISTER,
> > +       AUDIT_NFT_OP_SETELEM_REGISTER,
> > +       AUDIT_NFT_OP_SETELEM_UNREGISTER,
> > +       AUDIT_NFT_OP_GEN_REGISTER,
> > +       AUDIT_NFT_OP_OBJ_REGISTER,
> > +       AUDIT_NFT_OP_OBJ_UNREGISTER,
> > +       AUDIT_NFT_OP_OBJ_RESET,
> > +       AUDIT_NFT_OP_FLOWTABLE_REGISTER,
> > +       AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
> > +       AUDIT_NFT_OP_INVALID,
> > +};
> > +
> > +struct audit_nftcfgop_tab {
> > +       enum nf_tables_msg_types        nftop;
> > +       enum audit_nfcfgop              op;
> > +};
> > +
> > +static const struct audit_nftcfgop_tab audit_nftcfgs[] = {
> > +       { NFT_MSG_NEWTABLE,     AUDIT_NFT_OP_TABLE_REGISTER             },
> > +       { NFT_MSG_GETTABLE,     AUDIT_NFT_OP_INVALID                    },
> > +       { NFT_MSG_DELTABLE,     AUDIT_NFT_OP_TABLE_UNREGISTER           },
> > +       { NFT_MSG_NEWCHAIN,     AUDIT_NFT_OP_CHAIN_REGISTER             },
> > +       { NFT_MSG_GETCHAIN,     AUDIT_NFT_OP_INVALID                    },
> > +       { NFT_MSG_DELCHAIN,     AUDIT_NFT_OP_CHAIN_UNREGISTER           },
> > +       { NFT_MSG_NEWRULE,      AUDIT_NFT_OP_RULE_REGISTER              },
> > +       { NFT_MSG_GETRULE,      AUDIT_NFT_OP_INVALID                    },
> > +       { NFT_MSG_DELRULE,      AUDIT_NFT_OP_RULE_UNREGISTER            },
> > +       { NFT_MSG_NEWSET,       AUDIT_NFT_OP_SET_REGISTER               },
> > +       { NFT_MSG_GETSET,       AUDIT_NFT_OP_INVALID                    },
> > +       { NFT_MSG_DELSET,       AUDIT_NFT_OP_SET_UNREGISTER             },
> > +       { NFT_MSG_NEWSETELEM,   AUDIT_NFT_OP_SETELEM_REGISTER           },
> > +       { NFT_MSG_GETSETELEM,   AUDIT_NFT_OP_INVALID                    },
> > +       { NFT_MSG_DELSETELEM,   AUDIT_NFT_OP_SETELEM_UNREGISTER         },
> > +       { NFT_MSG_NEWGEN,       AUDIT_NFT_OP_GEN_REGISTER               },
> > +       { NFT_MSG_GETGEN,       AUDIT_NFT_OP_INVALID                    },
> > +       { NFT_MSG_TRACE,        AUDIT_NFT_OP_INVALID                    },
> > +       { NFT_MSG_NEWOBJ,       AUDIT_NFT_OP_OBJ_REGISTER               },
> > +       { NFT_MSG_GETOBJ,       AUDIT_NFT_OP_INVALID                    },
> > +       { NFT_MSG_DELOBJ,       AUDIT_NFT_OP_OBJ_UNREGISTER             },
> > +       { NFT_MSG_GETOBJ_RESET, AUDIT_NFT_OP_OBJ_RESET                  },
> > +       { NFT_MSG_NEWFLOWTABLE, AUDIT_NFT_OP_FLOWTABLE_REGISTER         },
> > +       { NFT_MSG_GETFLOWTABLE, AUDIT_NFT_OP_INVALID                    },
> > +       { NFT_MSG_DELFLOWTABLE, AUDIT_NFT_OP_FLOWTABLE_UNREGISTER       },
> > +       { NFT_MSG_MAX,          AUDIT_NFT_OP_INVALID                    },
> >  };
> 
> I didn't check every "op" defined above to match with the changes in
> nf_tables_api.c, but is there a reason why we can't simply hardcode
> the AUDIT_NFT_OP_* values in the audit_log_nfcfg() calls in
> nf_tables_api.c?  If we can, let's do that.

Yes, to distinguish between x/ebtables and nftables.  The first three
overlap (as suggested by the first comment in the changelog above).

> If we can't do that, we need to add some build-time protection to
> catch if NFT_MSG_MAX increases without this table being updated.

I would have liked to do that, but it would then have meant making a new
function name, say audit_log_nftcfg vs the original audit_log_nfcfg so
that the overlapping values could be translated appropriately with the
correct prefix.

Well, considering the buildbot error, I had to restructure it so that
the table was moved from include/linux/audit.h to
net/netfilter/nf_tables_api.c where it would be a bit more evident.

At first I thought the bot was complaining about the first field not
being used, but it turned out it was ptrace that was including it and
not using it.

> >  static int audit_match_perm(struct audit_context *ctx, int mask)
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 4471393da6d8..7a386eca6e04 100644
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
> > @@ -693,6 +694,14 @@ static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
> >  {
> >         struct sk_buff *skb;
> >         int err;
> > +       char *buf = kasprintf(GFP_KERNEL, "%s:%llu;?:0",
> > +                             ctx->table->name, ctx->table->handle);
> > +
> > +       audit_log_nfcfg(buf,
> > +                       ctx->family,
> > +                       ctx->table->use,
> > +                       audit_nftcfgs[event].op);
> 
> As an example, the below would work, yes?
> 
> audit_log_nfcfg(...,
>  (event == NFT_MSG_NEWTABLE ?
>   AUDIT_NFT_OP_TABLE_REGISTER :
>   AUDIT_NFT_OP_TABLE_UNREGISTER)

Ok, I see what you are getting at now...  Yes, it could be done this
way, but it seems noisier to me.

> > +       kfree(buf);
> >
> >         if (!ctx->report &&
> >             !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
> 
> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

