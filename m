Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32418E732F4
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 17:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbjI1RDX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 13:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjI1RDW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 13:03:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A63AC
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Sep 2023 10:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695920556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D4jGMheYI/ylOZ/WbaLBSPfRFCuKdZTp++iYBHyAKp4=;
        b=XTo/XQdQclyhXA/hSfLoZW+0Mg0FZ/KhsrtwnOAsl1kl5CxD9VxhPoZl/c9l3tj4/CmS39
        yDRdRATUJ1ZDpmHYSHW4tjdSfPI2YIdB2aqKdMdfm6DfNwpC11fvLu9BJnlEa962hjeXCE
        8YEW7kLi3JN75YFLpc9MppZhlwQvH/w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-322-MTVpC4n9MseRqyyijGwhbQ-1; Thu, 28 Sep 2023 13:02:33 -0400
X-MC-Unique: MTVpC4n9MseRqyyijGwhbQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92FDA858281;
        Thu, 28 Sep 2023 17:02:32 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-0-7.rdu2.redhat.com [10.22.0.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 570F42156702;
        Thu, 28 Sep 2023 17:02:31 +0000 (UTC)
Date:   Thu, 28 Sep 2023 13:02:29 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        audit@vger.kernel.org, Paul Moore <paul@paul-moore.com>
Subject: Re: [nf PATCH 3/3] netfilter: nf_tables: Audit log object reset once
 per table
Message-ID: <ZRWxpZJTh0NOwenR@madcap2.tricolour.ca>
References: <20230923015351.15707-1-phil@nwl.cc>
 <20230923015351.15707-4-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230923015351.15707-4-phil@nwl.cc>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2023-09-23 03:53, Phil Sutter wrote:
> When resetting multiple objects at once (via dump request), emit a log
> message per table (or filled skb) and resurrect the 'entries' parameter
> to contain the number of objects being logged for.
> 
> With the above in place, all audit logs for op=nft_register_obj have a
> predictable value in 'entries', so drop the value zeroing for them in
> audit_logread.c.
> 
> To test the skb exhaustion path, perform some bulk counter and quota
> adds in the kselftest.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

(Resend, forgot to include other addressees.)
Reviewed-by: Richard Guy Briggs <rgb@redhat.com>

> ---
>  net/netfilter/nf_tables_api.c                 | 51 ++++++++++---------
>  .../testing/selftests/netfilter/nft_audit.sh  | 46 +++++++++++++++++
>  2 files changed, 74 insertions(+), 23 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 48d50df950a18..e04ef2c451be4 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -7733,6 +7733,16 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
>  	return -1;
>  }
>  
> +static void audit_log_obj_reset(const struct nft_table *table,
> +				unsigned int base_seq, unsigned int nentries)
> +{
> +	char *buf = kasprintf(GFP_ATOMIC, "%s:%u", table->name, base_seq);
> +
> +	audit_log_nfcfg(buf, table->family, nentries,
> +			AUDIT_NFT_OP_OBJ_RESET, GFP_ATOMIC);
> +	kfree(buf);
> +}
> +
>  struct nft_obj_dump_ctx {
>  	unsigned int	s_idx;
>  	char		*table;
> @@ -7748,8 +7758,10 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
>  	int family = nfmsg->nfgen_family;
>  	struct nftables_pernet *nft_net;
>  	const struct nft_table *table;
> +	unsigned int entries = 0;
>  	struct nft_object *obj;
>  	unsigned int idx = 0;
> +	int rc = 0;
>  
>  	rcu_read_lock();
>  	nft_net = nft_pernet(net);
> @@ -7759,6 +7771,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
>  		if (family != NFPROTO_UNSPEC && family != table->family)
>  			continue;
>  
> +		entries = 0;
>  		list_for_each_entry_rcu(obj, &table->objects, list) {
>  			if (!nft_is_active(net, obj))
>  				goto cont;
> @@ -7769,34 +7782,27 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
>  			if (ctx->type != NFT_OBJECT_UNSPEC &&
>  			    obj->ops->type->type != ctx->type)
>  				goto cont;
> -			if (ctx->reset) {
> -				char *buf = kasprintf(GFP_ATOMIC,
> -						      "%s:%u",
> -						      table->name,
> -						      nft_net->base_seq);
> -
> -				audit_log_nfcfg(buf,
> -						family,
> -						obj->handle,
> -						AUDIT_NFT_OP_OBJ_RESET,
> -						GFP_ATOMIC);
> -				kfree(buf);
> -			}
>  
> -			if (nf_tables_fill_obj_info(skb, net, NETLINK_CB(cb->skb).portid,
> -						    cb->nlh->nlmsg_seq,
> -						    NFT_MSG_NEWOBJ,
> -						    NLM_F_MULTI | NLM_F_APPEND,
> -						    table->family, table,
> -						    obj, ctx->reset) < 0)
> -				goto done;
> +			rc = nf_tables_fill_obj_info(skb, net,
> +						     NETLINK_CB(cb->skb).portid,
> +						     cb->nlh->nlmsg_seq,
> +						     NFT_MSG_NEWOBJ,
> +						     NLM_F_MULTI | NLM_F_APPEND,
> +						     table->family, table,
> +						     obj, ctx->reset);
> +			if (rc < 0)
> +				break;
>  
> +			entries++;
>  			nl_dump_check_consistent(cb, nlmsg_hdr(skb));
>  cont:
>  			idx++;
>  		}
> +		if (ctx->reset && entries)
> +			audit_log_obj_reset(table, nft_net->base_seq, entries);
> +		if (rc < 0)
> +			break;
>  	}
> -done:
>  	rcu_read_unlock();
>  
>  	ctx->s_idx = idx;
> @@ -7977,8 +7983,7 @@ static int nf_tables_getobj_reset(struct sk_buff *skb,
>  		return PTR_ERR(skb2);
>  
>  	buf = kasprintf(GFP_ATOMIC, "%s:%u", table->name, nft_net->base_seq);
> -	audit_log_nfcfg(buf, family, obj->handle,
> -			AUDIT_NFT_OP_OBJ_RESET, GFP_ATOMIC);
> +	audit_log_nfcfg(buf, family, 1, AUDIT_NFT_OP_OBJ_RESET, GFP_ATOMIC);
>  	kfree(buf);
>  
>  	return nfnetlink_unicast(skb2, net, portid);
> diff --git a/tools/testing/selftests/netfilter/nft_audit.sh b/tools/testing/selftests/netfilter/nft_audit.sh
> index bb34329e02a7f..e94a80859bbdb 100755
> --- a/tools/testing/selftests/netfilter/nft_audit.sh
> +++ b/tools/testing/selftests/netfilter/nft_audit.sh
> @@ -93,6 +93,12 @@ do_test 'nft add counter t1 c1' \
>  do_test 'nft add counter t2 c1; add counter t2 c2' \
>  'table=t2 family=2 entries=2 op=nft_register_obj'
>  
> +for ((i = 3; i <= 500; i++)); do
> +	echo "add counter t2 c$i"
> +done >$rulefile
> +do_test "nft -f $rulefile" \
> +'table=t2 family=2 entries=498 op=nft_register_obj'
> +
>  # adding/updating quotas
>  
>  do_test 'nft add quota t1 q1 { 10 bytes }' \
> @@ -101,6 +107,12 @@ do_test 'nft add quota t1 q1 { 10 bytes }' \
>  do_test 'nft add quota t2 q1 { 10 bytes }; add quota t2 q2 { 10 bytes }' \
>  'table=t2 family=2 entries=2 op=nft_register_obj'
>  
> +for ((i = 3; i <= 500; i++)); do
> +	echo "add quota t2 q$i { 10 bytes }"
> +done >$rulefile
> +do_test "nft -f $rulefile" \
> +'table=t2 family=2 entries=498 op=nft_register_obj'
> +
>  # changing the quota value triggers obj update path
>  do_test 'nft add quota t1 q1 { 20 bytes }' \
>  'table=t1 family=2 entries=1 op=nft_register_obj'
> @@ -150,6 +162,40 @@ done
>  do_test 'nft reset set t1 s' \
>  'table=t1 family=2 entries=3 op=nft_reset_setelem'
>  
> +# resetting counters
> +
> +do_test 'nft reset counter t1 c1' \
> +'table=t1 family=2 entries=1 op=nft_reset_obj'
> +
> +do_test 'nft reset counters t1' \
> +'table=t1 family=2 entries=1 op=nft_reset_obj'
> +
> +do_test 'nft reset counters t2' \
> +'table=t2 family=2 entries=342 op=nft_reset_obj
> +table=t2 family=2 entries=158 op=nft_reset_obj'
> +
> +do_test 'nft reset counters' \
> +'table=t1 family=2 entries=1 op=nft_reset_obj
> +table=t2 family=2 entries=341 op=nft_reset_obj
> +table=t2 family=2 entries=159 op=nft_reset_obj'
> +
> +# resetting quotas
> +
> +do_test 'nft reset quota t1 q1' \
> +'table=t1 family=2 entries=1 op=nft_reset_obj'
> +
> +do_test 'nft reset quotas t1' \
> +'table=t1 family=2 entries=1 op=nft_reset_obj'
> +
> +do_test 'nft reset quotas t2' \
> +'table=t2 family=2 entries=315 op=nft_reset_obj
> +table=t2 family=2 entries=185 op=nft_reset_obj'
> +
> +do_test 'nft reset quotas' \
> +'table=t1 family=2 entries=1 op=nft_reset_obj
> +table=t2 family=2 entries=314 op=nft_reset_obj
> +table=t2 family=2 entries=186 op=nft_reset_obj'
> +
>  # deleting rules
>  
>  readarray -t handles < <(nft -a list chain t1 c1 | \
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

