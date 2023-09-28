Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE471E80A8A
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 01:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjI1Biu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 21:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjI1Bit (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 21:38:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19EDAC
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 18:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695865079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XttOFD0p7t9x/VHxblIuZYpwuhmFkxFey/Qzulrcy9Y=;
        b=WOurc95RqHYB+DYQDZBnJhOz7QEwoMdDt4/GYUByctRexr+uZZ4W4bCxOax0uIhU2bFwyH
        qNyjS/kntYu9FiGdC7iUPLnat7P0g9QXU6AmJDRN9mWQGvSKi7mPapnWkcA5NfQ3YuRM62
        8N3WA5P5f7Pqyv1TT0ExgPxXCYW0sqc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-FT1x9T_KMje_UI--wgLPRA-1; Wed, 27 Sep 2023 21:37:55 -0400
X-MC-Unique: FT1x9T_KMje_UI--wgLPRA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 031B1811E7E;
        Thu, 28 Sep 2023 01:37:55 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-0-7.rdu2.redhat.com [10.22.0.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B9C02156702;
        Thu, 28 Sep 2023 01:37:53 +0000 (UTC)
Date:   Wed, 27 Sep 2023 21:37:51 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        audit@vger.kernel.org, Paul Moore <paul@paul-moore.com>
Subject: Re: [nf PATCH 2/3] netfilter: nf_tables: Deduplicate
 nft_register_obj audit logs
Message-ID: <ZRTY78uKUuqo4WHP@madcap2.tricolour.ca>
References: <20230923015351.15707-1-phil@nwl.cc>
 <20230923015351.15707-3-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230923015351.15707-3-phil@nwl.cc>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2023-09-23 03:53, Phil Sutter wrote:
> When adding/updating an object, the transaction handler emits suitable
> audit log entries already, the one in nft_obj_notify() is redundant. To
> fix that (and retain the audit logging from objects' 'update' callback),
> Introduce an "audit log free" variant for internal use.
> 
> Fixes: c520292f29b80 ("audit: log nftables configuration change events once per table")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Reviewed-by: Richard Guy Briggs <rgb@redhat.com>

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
>  
>  static void nf_tables_obj_notify(const struct nft_ctx *ctx,
>  				 struct nft_object *obj, int event)
>  {
> -	nft_obj_notify(ctx->net, ctx->table, obj, ctx->portid, ctx->seq, event,
> -		       ctx->flags, ctx->family, ctx->report, GFP_KERNEL);
> +	__nft_obj_notify(ctx->net, ctx->table, obj, ctx->portid,
> +			 ctx->seq, event, ctx->flags, ctx->family,
> +			 ctx->report, GFP_KERNEL);
>  }
>  
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

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
Upstream IRC: SunRaycer
Voice: +1.613.860 2354 SMS: +1.613.518.6570

