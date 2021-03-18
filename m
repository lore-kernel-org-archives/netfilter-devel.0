Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92AA8C433E6
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Mar 2021 16:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66AA464DDD
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Mar 2021 16:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbhCRQaB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Mar 2021 12:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhCRQ3y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Mar 2021 12:29:54 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F54AC06174A;
        Thu, 18 Mar 2021 09:29:54 -0700 (PDT)
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7D9C862BC4;
        Thu, 18 Mar 2021 17:29:47 +0100 (CET)
Date:   Thu, 18 Mar 2021 17:29:47 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        twoerner@redhat.com, tgraf@infradead.org, dan.carpenter@oracle.com,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
Subject: Re: [PATCH] audit: log nftables configuration change events once per
 table
Message-ID: <20210318162947.GA9330@salvia>
References: <7e73ce4aa84b2e46e650b5727ee7a8244ec4a0ac.1616078123.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7e73ce4aa84b2e46e650b5727ee7a8244ec4a0ac.1616078123.git.rgb@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 18, 2021 at 11:39:52AM -0400, Richard Guy Briggs wrote:
> Reduce logging of nftables events to a level similar to iptables.
> Restore the table field to list the table, adding the generation.
> 
> Indicate the op as the most significant operation in the event.
> 
> A couple of sample events:
> 
> type=PROCTITLE msg=audit(2021-03-18 09:30:49.801:143) : proctitle=/usr/bin/python3 -s /usr/sbin/firewalld --nofork --nopid
> type=SYSCALL msg=audit(2021-03-18 09:30:49.801:143) : arch=x86_64 syscall=sendmsg success=yes exit=172 a0=0x6 a1=0x7ffdcfcbe650 a2=0x0 a3=0x7ffdcfcbd52c items=0 ppid=1 pid=367 auid=unset uid=root gid=root euid=root suid=root fsuid=root egid=roo
> t sgid=root fsgid=root tty=(none) ses=unset comm=firewalld exe=/usr/bin/python3.9 subj=system_u:system_r:firewalld_t:s0 key=(null)
> type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.801:143) : table=firewalld:2 family=ipv6 entries=1 op=nft_register_table pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
> type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.801:143) : table=firewalld:2 family=ipv4 entries=1 op=nft_register_table pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
> type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.801:143) : table=firewalld:2 family=inet entries=1 op=nft_register_table pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
> 
> type=PROCTITLE msg=audit(2021-03-18 09:30:49.839:144) : proctitle=/usr/bin/python3 -s /usr/sbin/firewalld --nofork --nopid
> type=SYSCALL msg=audit(2021-03-18 09:30:49.839:144) : arch=x86_64 syscall=sendmsg success=yes exit=22792 a0=0x6 a1=0x7ffdcfcbe650 a2=0x0 a3=0x7ffdcfcbd52c items=0 ppid=1 pid=367 auid=unset uid=root gid=root euid=root suid=root fsuid=root egid=r
> oot sgid=root fsgid=root tty=(none) ses=unset comm=firewalld exe=/usr/bin/python3.9 subj=system_u:system_r:firewalld_t:s0 key=(null)
> type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.839:144) : table=firewalld:3 family=ipv6 entries=30 op=nft_register_chain pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
> type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.839:144) : table=firewalld:3 family=ipv4 entries=30 op=nft_register_chain pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
> type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.839:144) : table=firewalld:3 family=inet entries=165 op=nft_register_chain pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
> 
> The issue was originally documented in
> https://github.com/linux-audit/audit-kernel/issues/124
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h         |  29 ++++++++
>  net/netfilter/nf_tables_api.c | 132 +++++++++++++---------------------
>  2 files changed, 78 insertions(+), 83 deletions(-)
> 
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 82b7c1116a85..bba6a0386742 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -118,6 +118,35 @@ enum audit_nfcfgop {
>  	AUDIT_NFT_OP_INVALID,
>  };
>  
> +static const u8 nft2audit_op[] = { // enum nf_tables_msg_types
> +	/* NFT_MSG_NEWTABLE	*/	AUDIT_NFT_OP_TABLE_REGISTER,
> +	/* NFT_MSG_GETTABLE	*/	AUDIT_NFT_OP_INVALID,
> +	/* NFT_MSG_DELTABLE	*/	AUDIT_NFT_OP_TABLE_UNREGISTER,
> +	/* NFT_MSG_NEWCHAIN	*/	AUDIT_NFT_OP_CHAIN_REGISTER,
> +	/* NFT_MSG_GETCHAIN	*/	AUDIT_NFT_OP_INVALID,
> +	/* NFT_MSG_DELCHAIN	*/	AUDIT_NFT_OP_CHAIN_UNREGISTER,
> +	/* NFT_MSG_NEWRULE	*/	AUDIT_NFT_OP_RULE_REGISTER,
> +	/* NFT_MSG_GETRULE	*/	AUDIT_NFT_OP_INVALID,
> +	/* NFT_MSG_DELRULE	*/	AUDIT_NFT_OP_RULE_UNREGISTER,
> +	/* NFT_MSG_NEWSET	*/	AUDIT_NFT_OP_SET_REGISTER,
> +	/* NFT_MSG_GETSET	*/	AUDIT_NFT_OP_INVALID,
> +	/* NFT_MSG_DELSET	*/	AUDIT_NFT_OP_SET_UNREGISTER,
> +	/* NFT_MSG_NEWSETELEM	*/	AUDIT_NFT_OP_SETELEM_REGISTER,
> +	/* NFT_MSG_GETSETELEM	*/	AUDIT_NFT_OP_INVALID,
> +	/* NFT_MSG_DELSETELEM	*/	AUDIT_NFT_OP_SETELEM_UNREGISTER,
> +	/* NFT_MSG_NEWGEN	*/	AUDIT_NFT_OP_GEN_REGISTER,
> +	/* NFT_MSG_GETGEN	*/	AUDIT_NFT_OP_INVALID,
> +	/* NFT_MSG_TRACE	*/	AUDIT_NFT_OP_INVALID,
> +	/* NFT_MSG_NEWOBJ	*/	AUDIT_NFT_OP_OBJ_REGISTER,
> +	/* NFT_MSG_GETOBJ	*/	AUDIT_NFT_OP_INVALID,
> +	/* NFT_MSG_DELOBJ	*/	AUDIT_NFT_OP_OBJ_UNREGISTER,
> +	/* NFT_MSG_GETOBJ_RESET	*/	AUDIT_NFT_OP_OBJ_RESET,
> +	/* NFT_MSG_NEWFLOWTABLE	*/	AUDIT_NFT_OP_FLOWTABLE_REGISTER,
> +	/* NFT_MSG_GETFLOWTABLE	*/	AUDIT_NFT_OP_INVALID,
> +	/* NFT_MSG_DELFLOWTABLE	*/	AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
> +	/* NFT_MSG_MAX		*/	AUDIT_NFT_OP_INVALID,
> +};
> +
>  extern int is_audit_feature_set(int which);
>  
>  extern int __init audit_register_class(int class, unsigned *list);
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 8d5aa0ac45f4..ad31d8876169 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -709,17 +709,6 @@ static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
>  {
>  	struct sk_buff *skb;
>  	int err;
> -	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;?:0",
> -			      ctx->table->name, ctx->table->handle);
> -
> -	audit_log_nfcfg(buf,
> -			ctx->family,
> -			ctx->table->use,
> -			event == NFT_MSG_NEWTABLE ?
> -				AUDIT_NFT_OP_TABLE_REGISTER :
> -				AUDIT_NFT_OP_TABLE_UNREGISTER,
> -			GFP_KERNEL);
> -	kfree(buf);
>  
>  	if (!ctx->report &&
>  	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
> @@ -1476,18 +1465,6 @@ static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
>  {
>  	struct sk_buff *skb;
>  	int err;
> -	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;%s:%llu",
> -			      ctx->table->name, ctx->table->handle,
> -			      ctx->chain->name, ctx->chain->handle);
> -
> -	audit_log_nfcfg(buf,
> -			ctx->family,
> -			ctx->chain->use,
> -			event == NFT_MSG_NEWCHAIN ?
> -				AUDIT_NFT_OP_CHAIN_REGISTER :
> -				AUDIT_NFT_OP_CHAIN_UNREGISTER,
> -			GFP_KERNEL);
> -	kfree(buf);
>  
>  	if (!ctx->report &&
>  	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
> @@ -2838,18 +2815,6 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
>  {
>  	struct sk_buff *skb;
>  	int err;
> -	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;%s:%llu",
> -			      ctx->table->name, ctx->table->handle,
> -			      ctx->chain->name, ctx->chain->handle);
> -
> -	audit_log_nfcfg(buf,
> -			ctx->family,
> -			rule->handle,
> -			event == NFT_MSG_NEWRULE ?
> -				AUDIT_NFT_OP_RULE_REGISTER :
> -				AUDIT_NFT_OP_RULE_UNREGISTER,
> -			GFP_KERNEL);
> -	kfree(buf);
>  
>  	if (!ctx->report &&
>  	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
> @@ -3882,18 +3847,6 @@ static void nf_tables_set_notify(const struct nft_ctx *ctx,
>  	struct sk_buff *skb;
>  	u32 portid = ctx->portid;
>  	int err;
> -	char *buf = kasprintf(gfp_flags, "%s:%llu;%s:%llu",
> -			      ctx->table->name, ctx->table->handle,
> -			      set->name, set->handle);
> -
> -	audit_log_nfcfg(buf,
> -			ctx->family,
> -			set->field_count,
> -			event == NFT_MSG_NEWSET ?
> -				AUDIT_NFT_OP_SET_REGISTER :
> -				AUDIT_NFT_OP_SET_UNREGISTER,
> -			gfp_flags);
> -	kfree(buf);
>  
>  	if (!ctx->report &&
>  	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
> @@ -5067,18 +5020,6 @@ static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
>  	u32 portid = ctx->portid;
>  	struct sk_buff *skb;
>  	int err;
> -	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;%s:%llu",
> -			      ctx->table->name, ctx->table->handle,
> -			      set->name, set->handle);
> -
> -	audit_log_nfcfg(buf,
> -			ctx->family,
> -			set->handle,
> -			event == NFT_MSG_NEWSETELEM ?
> -				AUDIT_NFT_OP_SETELEM_REGISTER :
> -				AUDIT_NFT_OP_SETELEM_UNREGISTER,
> -			GFP_KERNEL);
> -	kfree(buf);
>  
>  	if (!ctx->report && !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
>  		return;
> @@ -6278,12 +6219,11 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
>  			    filter->type != NFT_OBJECT_UNSPEC &&
>  			    obj->ops->type->type != filter->type)
>  				goto cont;
> -
>  			if (reset) {
>  				char *buf = kasprintf(GFP_ATOMIC,
> -						      "%s:%llu;?:0",
> +						      "%s:%u",
>  						      table->name,
> -						      table->handle);
> +						      net->nft.base_seq);
>  
>  				audit_log_nfcfg(buf,
>  						family,
> @@ -6404,8 +6344,8 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
>  		reset = true;
>  
>  	if (reset) {
> -		char *buf = kasprintf(GFP_ATOMIC, "%s:%llu;?:0",
> -				      table->name, table->handle);
> +		char *buf = kasprintf(GFP_ATOMIC, "%s:%u",
> +				      table->name, net->nft.base_seq);
>  
>  		audit_log_nfcfg(buf,
>  				family,
> @@ -6492,15 +6432,15 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
>  {
>  	struct sk_buff *skb;
>  	int err;
> -	char *buf = kasprintf(gfp, "%s:%llu;?:0",
> -			      table->name, table->handle);
> +	char *buf = kasprintf(gfp, "%s:%u",
> +			      table->name, net->nft.base_seq);
>  
>  	audit_log_nfcfg(buf,
>  			family,
>  			obj->handle,
>  			event == NFT_MSG_NEWOBJ ?
> -				AUDIT_NFT_OP_OBJ_REGISTER :
> -				AUDIT_NFT_OP_OBJ_UNREGISTER,
> +				 AUDIT_NFT_OP_OBJ_REGISTER :
> +				 AUDIT_NFT_OP_OBJ_UNREGISTER,
>  			gfp);
>  	kfree(buf);
>  
> @@ -7300,18 +7240,6 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
>  {
>  	struct sk_buff *skb;
>  	int err;
> -	char *buf = kasprintf(GFP_KERNEL, "%s:%llu;%s:%llu",
> -			      flowtable->table->name, flowtable->table->handle,
> -			      flowtable->name, flowtable->handle);
> -
> -	audit_log_nfcfg(buf,
> -			ctx->family,
> -			flowtable->hooknum,
> -			event == NFT_MSG_NEWFLOWTABLE ?
> -				AUDIT_NFT_OP_FLOWTABLE_REGISTER :
> -				AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
> -			GFP_KERNEL);
> -	kfree(buf);
>  
>  	if (!ctx->report &&
>  	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
> @@ -7432,9 +7360,6 @@ static void nf_tables_gen_notify(struct net *net, struct sk_buff *skb,
>  	struct sk_buff *skb2;
>  	int err;
>  
> -	audit_log_nfcfg("?:0;?:0", 0, net->nft.base_seq,
> -			AUDIT_NFT_OP_GEN_REGISTER, GFP_KERNEL);
> -
>  	if (!nlmsg_report(nlh) &&
>  	    !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
>  		return;
> @@ -7979,6 +7904,14 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>  	struct nft_trans_elem *te;
>  	struct nft_chain *chain;
>  	struct nft_table *table;
> +	struct audit_log_nftdata {
> +		struct nft_table *table;
> +		int entries;
> +		int op;
> +		struct audit_log_nftdata *next;

Use linux lists instead?

> +	} ad = { NULL, 0, 0, NULL }, *adp, *adnext;
> +#define AUNFTABLENAMELEN (NFT_TABLE_MAXNAMELEN + 22)
> +	char aubuf[AUNFTABLENAMELEN];
>  	int err;
>  
>  	if (list_empty(&net->nft.commit_list)) {
> @@ -8173,12 +8106,45 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>  			}
>  			break;
>  		}
> +		adp = &ad;
> +		if (!adp->table) {
> +			adp->table = trans->ctx.table;
> +			adp->entries = 1;
> +			adp->op = trans->msg_type;
> +		} else {
> +			adnext = &ad;
> +			do {
> +				adp = adnext;
> +				if (adp->table == trans->ctx.table)
> +					goto found;
> +				adnext = adp->next;
> +			} while (adnext);
> +			adp->next = kzalloc(sizeof(*adp->next), GFP_KERNEL);
> +			adp = adp->next;
> +			adp->table = trans->ctx.table;
> +found:
> +			adp->entries++;
> +			if (!adp->op || adp->op > trans->msg_type)
> +				adp->op = trans->msg_type;
> +		}

Would you wrap this code in a function?

>  	}
>  
>  	nft_commit_notify(net, NETLINK_CB(skb).portid);
>  	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
>  	nf_tables_commit_release(net);
>  
> +	adp = &ad;
> +	while (adp && adp->table) {
> +		snprintf(aubuf, AUNFTABLENAMELEN, "%s:%u", adp->table->name,
> +			 net->nft.base_seq);
> +		audit_log_nfcfg(aubuf, adp->table->family, adp->entries,
> +				nft2audit_op[adp->op], GFP_KERNEL);
> +		adnext = adp->next;
> +		if (adp != &ad)
> +			kfree(adp);
> +		adp = adnext;
> +	}

Same thing here.

Thanks.
