Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA26E82CC3
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 19:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjI0TmC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 15:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjI0TmB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 15:42:01 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECBA10A;
        Wed, 27 Sep 2023 12:41:59 -0700 (PDT)
Received: from [78.30.34.192] (port=42106 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qlaPy-00ENqH-4L; Wed, 27 Sep 2023 21:41:56 +0200
Date:   Wed, 27 Sep 2023 21:41:53 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        audit@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [nf PATCH 2/3] netfilter: nf_tables: Deduplicate
 nft_register_obj audit logs
Message-ID: <ZRSFgQA+P9/L2uUb@calendula>
References: <20230923015351.15707-1-phil@nwl.cc>
 <20230923015351.15707-3-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230923015351.15707-3-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Sat, Sep 23, 2023 at 03:53:50AM +0200, Phil Sutter wrote:
> When adding/updating an object, the transaction handler emits suitable
> audit log entries already, the one in nft_obj_notify() is redundant. To
> fix that (and retain the audit logging from objects' 'update' callback),
> Introduce an "audit log free" variant for internal use.
> 
> Fixes: c520292f29b80 ("audit: log nftables configuration change events once per table")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  net/netfilter/nf_tables_api.c                 | 44 ++++++++++++-------
>  .../testing/selftests/netfilter/nft_audit.sh  | 20 +++++++++
>  2 files changed, 48 insertions(+), 16 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 0e5d9bdba82b8..48d50df950a18 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -8046,24 +8046,14 @@ static int nf_tables_delobj(struct sk_buff *skb, const struct nfnl_info *info,
>  	return nft_delobj(&ctx, obj);
>  }
>  
> -void nft_obj_notify(struct net *net, const struct nft_table *table,
> -		    struct nft_object *obj, u32 portid, u32 seq, int event,
> -		    u16 flags, int family, int report, gfp_t gfp)
> +static void
> +__nft_obj_notify(struct net *net, const struct nft_table *table,
> +		 struct nft_object *obj, u32 portid, u32 seq, int event,
> +		 u16 flags, int family, int report, gfp_t gfp)
>  {
>  	struct nftables_pernet *nft_net = nft_pernet(net);
>  	struct sk_buff *skb;
>  	int err;
> -	char *buf = kasprintf(gfp, "%s:%u",
> -			      table->name, nft_net->base_seq);
> -
> -	audit_log_nfcfg(buf,
> -			family,
> -			obj->handle,
> -			event == NFT_MSG_NEWOBJ ?
> -				 AUDIT_NFT_OP_OBJ_REGISTER :
> -				 AUDIT_NFT_OP_OBJ_UNREGISTER,
> -			gfp);
> -	kfree(buf);
>  
>  	if (!report &&
>  	    !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
> @@ -8086,13 +8076,35 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
>  err:
>  	nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
>  }
> +
> +void nft_obj_notify(struct net *net, const struct nft_table *table,
> +		    struct nft_object *obj, u32 portid, u32 seq, int event,
> +		    u16 flags, int family, int report, gfp_t gfp)
> +{
> +	struct nftables_pernet *nft_net = nft_pernet(net);
> +	char *buf = kasprintf(gfp, "%s:%u",
> +			      table->name, nft_net->base_seq);
> +
> +	audit_log_nfcfg(buf,
> +			family,
> +			obj->handle,
> +			event == NFT_MSG_NEWOBJ ?
> +				 AUDIT_NFT_OP_OBJ_REGISTER :
> +				 AUDIT_NFT_OP_OBJ_UNREGISTER,
> +			gfp);
> +	kfree(buf);
> +
> +	__nft_obj_notify(net, table, obj, portid, seq, event,
> +			 flags, family, report, gfp);
> +}
>  EXPORT_SYMBOL_GPL(nft_obj_notify);

OK, so nft_obj_notify() is called from nft_quota to notify that the
quota is depleted and the audit log is still there in this case.

>  static void nf_tables_obj_notify(const struct nft_ctx *ctx,
>  				 struct nft_object *obj, int event)
>  {
> -	nft_obj_notify(ctx->net, ctx->table, obj, ctx->portid, ctx->seq, event,
> -		       ctx->flags, ctx->family, ctx->report, GFP_KERNEL);
> +	__nft_obj_notify(ctx->net, ctx->table, obj, ctx->portid,
> +			 ctx->seq, event, ctx->flags, ctx->family,
> +			 ctx->report, GFP_KERNEL);
>  }

This function is called from the commit path to send the event
notification, and it should send the audit log?

Is this nf_tables_commit_audit_log() that provides the redundant log,
right?

>  /*
> diff --git a/tools/testing/selftests/netfilter/nft_audit.sh b/tools/testing/selftests/netfilter/nft_audit.sh
> index 0b3255e7b3538..bb34329e02a7f 100755
> --- a/tools/testing/selftests/netfilter/nft_audit.sh
> +++ b/tools/testing/selftests/netfilter/nft_audit.sh
> @@ -85,6 +85,26 @@ do_test "nft add set t1 s2 $setblock; add set t1 s3 { $settype; }" \
>  do_test "nft add element t1 s3 $setelem" \
>  "table=t1 family=2 entries=3 op=nft_register_setelem"
>  
> +# adding counters
> +
> +do_test 'nft add counter t1 c1' \
> +'table=t1 family=2 entries=1 op=nft_register_obj'
> +
> +do_test 'nft add counter t2 c1; add counter t2 c2' \
> +'table=t2 family=2 entries=2 op=nft_register_obj'
> +
> +# adding/updating quotas
> +
> +do_test 'nft add quota t1 q1 { 10 bytes }' \
> +'table=t1 family=2 entries=1 op=nft_register_obj'
> +
> +do_test 'nft add quota t2 q1 { 10 bytes }; add quota t2 q2 { 10 bytes }' \
> +'table=t2 family=2 entries=2 op=nft_register_obj'
> +
> +# changing the quota value triggers obj update path
> +do_test 'nft add quota t1 q1 { 20 bytes }' \
> +'table=t1 family=2 entries=1 op=nft_register_obj'
> +
>  # resetting rules
>  
>  do_test 'nft reset rules t1 c2' \
> -- 
> 2.41.0
> 
