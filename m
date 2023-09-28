Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42CD5E732DE
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 14:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjI1Os2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 10:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbjI1OsR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 10:48:17 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E53CFD;
        Thu, 28 Sep 2023 07:48:14 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qlsJH-0003EJ-Bv; Thu, 28 Sep 2023 16:48:11 +0200
Date:   Thu, 28 Sep 2023 16:48:11 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        audit@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [nf PATCH 2/3] netfilter: nf_tables: Deduplicate
 nft_register_obj audit logs
Message-ID: <ZRWSKxKXjzlFHl7G@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        audit@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Richard Guy Briggs <rgb@redhat.com>
References: <20230923015351.15707-1-phil@nwl.cc>
 <20230923015351.15707-3-phil@nwl.cc>
 <ZRSFgQA+P9/L2uUb@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRSFgQA+P9/L2uUb@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Wed, Sep 27, 2023 at 09:41:53PM +0200, Pablo Neira Ayuso wrote:
> On Sat, Sep 23, 2023 at 03:53:50AM +0200, Phil Sutter wrote:
> > When adding/updating an object, the transaction handler emits suitable
> > audit log entries already, the one in nft_obj_notify() is redundant. To
> > fix that (and retain the audit logging from objects' 'update' callback),
> > Introduce an "audit log free" variant for internal use.
> > 
> > Fixes: c520292f29b80 ("audit: log nftables configuration change events once per table")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  net/netfilter/nf_tables_api.c                 | 44 ++++++++++++-------
> >  .../testing/selftests/netfilter/nft_audit.sh  | 20 +++++++++
> >  2 files changed, 48 insertions(+), 16 deletions(-)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 0e5d9bdba82b8..48d50df950a18 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -8046,24 +8046,14 @@ static int nf_tables_delobj(struct sk_buff *skb, const struct nfnl_info *info,
> >  	return nft_delobj(&ctx, obj);
> >  }
> >  
> > -void nft_obj_notify(struct net *net, const struct nft_table *table,
> > -		    struct nft_object *obj, u32 portid, u32 seq, int event,
> > -		    u16 flags, int family, int report, gfp_t gfp)
> > +static void
> > +__nft_obj_notify(struct net *net, const struct nft_table *table,
> > +		 struct nft_object *obj, u32 portid, u32 seq, int event,
> > +		 u16 flags, int family, int report, gfp_t gfp)
> >  {
> >  	struct nftables_pernet *nft_net = nft_pernet(net);
> >  	struct sk_buff *skb;
> >  	int err;
> > -	char *buf = kasprintf(gfp, "%s:%u",
> > -			      table->name, nft_net->base_seq);
> > -
> > -	audit_log_nfcfg(buf,
> > -			family,
> > -			obj->handle,
> > -			event == NFT_MSG_NEWOBJ ?
> > -				 AUDIT_NFT_OP_OBJ_REGISTER :
> > -				 AUDIT_NFT_OP_OBJ_UNREGISTER,
> > -			gfp);
> > -	kfree(buf);
> >  
> >  	if (!report &&
> >  	    !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
> > @@ -8086,13 +8076,35 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
> >  err:
> >  	nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
> >  }
> > +
> > +void nft_obj_notify(struct net *net, const struct nft_table *table,
> > +		    struct nft_object *obj, u32 portid, u32 seq, int event,
> > +		    u16 flags, int family, int report, gfp_t gfp)
> > +{
> > +	struct nftables_pernet *nft_net = nft_pernet(net);
> > +	char *buf = kasprintf(gfp, "%s:%u",
> > +			      table->name, nft_net->base_seq);
> > +
> > +	audit_log_nfcfg(buf,
> > +			family,
> > +			obj->handle,
> > +			event == NFT_MSG_NEWOBJ ?
> > +				 AUDIT_NFT_OP_OBJ_REGISTER :
> > +				 AUDIT_NFT_OP_OBJ_UNREGISTER,
> > +			gfp);
> > +	kfree(buf);
> > +
> > +	__nft_obj_notify(net, table, obj, portid, seq, event,
> > +			 flags, family, report, gfp);
> > +}
> >  EXPORT_SYMBOL_GPL(nft_obj_notify);
> 
> OK, so nft_obj_notify() is called from nft_quota to notify that the
> quota is depleted and the audit log is still there in this case.

Exactly. I needed an internal __nft_obj_notify() which just serves
notify_list but not audit.

> >  static void nf_tables_obj_notify(const struct nft_ctx *ctx,
> >  				 struct nft_object *obj, int event)
> >  {
> > -	nft_obj_notify(ctx->net, ctx->table, obj, ctx->portid, ctx->seq, event,
> > -		       ctx->flags, ctx->family, ctx->report, GFP_KERNEL);
> > +	__nft_obj_notify(ctx->net, ctx->table, obj, ctx->portid,
> > +			 ctx->seq, event, ctx->flags, ctx->family,
> > +			 ctx->report, GFP_KERNEL);
> >  }
> 
> This function is called from the commit path to send the event
> notification, and it should send the audit log?
> 
> Is this nf_tables_commit_audit_log() that provides the redundant log,
> right?

It's easier to to make nf_tables_obj_notify() skip the audit log and
not introduce special casing in nf_tables_commit_audit_log() or call
nf_tables_commit_audit_collect() for all transaction entries but NEWOBJ
and DELOBJ.

Cheers, Phil
