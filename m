Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0812C83F12
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 18:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238005AbjH2Si4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 14:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238427AbjH2Siy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 14:38:54 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623041A3
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 11:38:50 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qb3c0-0004nu-Cv; Tue, 29 Aug 2023 20:38:48 +0200
Date:   Tue, 29 Aug 2023 20:38:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, linux-audit@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [nf PATCH 1/2] netfilter: nf_tables: Audit log setelem reset
Message-ID: <ZO47OErdLysNiMsA@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, linux-audit@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>
References: <20230829175158.20202-1-phil@nwl.cc>
 <ZO4ytkCaWgprr4ba@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZO4ytkCaWgprr4ba@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 29, 2023 at 08:02:30PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Aug 29, 2023 at 07:51:57PM +0200, Phil Sutter wrote:
> > Since set element reset is not integrated into nf_tables' transaction
> > logic, an explicit log call is needed, similar to NFT_MSG_GETOBJ_RESET
> > handling.
> > 
> > For the sake of simplicity, catchall element reset will always generate
> > a dedicated log entry. This relieves nf_tables_dump_set() from having to
> > adjust the logged element count depending on whether a catchall element
> > was found or not.
> > 
> > Cc: Richard Guy Briggs <rgb@redhat.com>
> > Fixes: 079cd633219d7 ("netfilter: nf_tables: Introduce NFT_MSG_GETSETELEM_RESET")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  include/linux/audit.h         |  1 +
> >  kernel/auditsc.c              |  1 +
> >  net/netfilter/nf_tables_api.c | 31 ++++++++++++++++++++++++++++---
> >  3 files changed, 30 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index 6a3a9e122bb5e..192bf03aacc52 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -117,6 +117,7 @@ enum audit_nfcfgop {
> >  	AUDIT_NFT_OP_OBJ_RESET,
> >  	AUDIT_NFT_OP_FLOWTABLE_REGISTER,
> >  	AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
> > +	AUDIT_NFT_OP_SETELEM_RESET,
> >  	AUDIT_NFT_OP_INVALID,
> >  };
> >  
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index addeed3df15d3..38481e3181975 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -143,6 +143,7 @@ static const struct audit_nfcfgop_tab audit_nfcfgs[] = {
> >  	{ AUDIT_NFT_OP_OBJ_RESET,		"nft_reset_obj"		   },
> >  	{ AUDIT_NFT_OP_FLOWTABLE_REGISTER,	"nft_register_flowtable"   },
> >  	{ AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,	"nft_unregister_flowtable" },
> > +	{ AUDIT_NFT_OP_SETELEM_RESET,		"nft_reset_setelem"        },
> >  	{ AUDIT_NFT_OP_INVALID,			"nft_invalid"		   },
> >  };
> >  
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 1ddbdca4e47d6..a1218ea4e0c3d 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -102,6 +102,7 @@ static const u8 nft2audit_op[NFT_MSG_MAX] = { // enum nf_tables_msg_types
> >  	[NFT_MSG_NEWFLOWTABLE]	= AUDIT_NFT_OP_FLOWTABLE_REGISTER,
> >  	[NFT_MSG_GETFLOWTABLE]	= AUDIT_NFT_OP_INVALID,
> >  	[NFT_MSG_DELFLOWTABLE]	= AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
> > +	[NFT_MSG_GETSETELEM_RESET] = AUDIT_NFT_OP_SETELEM_RESET,
> >  };
> >  
> >  static void nft_validate_state_update(struct nft_table *table, u8 new_validate_state)
> > @@ -5661,13 +5662,25 @@ static int nf_tables_dump_setelem(const struct nft_ctx *ctx,
> >  	return nf_tables_fill_setelem(args->skb, set, elem, args->reset);
> >  }
> >  
> > +static void audit_log_nft_set_reset(const struct nft_table *table,
> > +				    unsigned int base_seq,
> > +				    unsigned int nentries)
> > +{
> > +	char *buf = kasprintf(GFP_ATOMIC, "%s:%u", table->name, base_seq);
> 
> No check for NULL?
> 
> I can see we have more like this in the tree.

Well, I merely copy-pasted that bit. (No excuse, I know.) The pointer is
passed on to audit_log_format() as a string argument and will end at
vsnprintf(), which detects and sanitizes NULL string args.

Cheers, Phil


