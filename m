Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D72C433DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Mar 2021 22:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EA78619A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Mar 2021 22:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhCVW60 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 18:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbhCVW5y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 18:57:54 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E7FDC061574;
        Mon, 22 Mar 2021 15:57:52 -0700 (PDT)
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6D803630C2;
        Mon, 22 Mar 2021 23:57:43 +0100 (CET)
Date:   Mon, 22 Mar 2021 23:57:47 +0100
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
Subject: Re: [PATCH v2] audit: log nftables configuration change events once
 per table
Message-ID: <20210322225747.GA24562@salvia>
References: <2a6d8eb6058a6961cfb6439b31dcfadcce9596a8.1616445965.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2a6d8eb6058a6961cfb6439b31dcfadcce9596a8.1616445965.git.rgb@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Mar 22, 2021 at 04:49:04PM -0400, Richard Guy Briggs wrote:
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index c1eb5cdb3033..42ba44890523 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
[...]
> @@ -8006,12 +7938,47 @@ static void nft_commit_notify(struct net *net, u32 portid)
>  	WARN_ON_ONCE(!list_empty(&net->nft.notify_list));
>  }
>  
> +void nf_tables_commit_audit_collect(struct list_head *adl,
> +				    struct nft_trans *trans) {

nitpick: curly brace starts in the line.

> +	struct nft_audit_data *adp;
> +
> +	list_for_each_entry(adp, adl, list) {
> +		if (adp->table == trans->ctx.table)
> +			goto found;
> +	}
> +	adp = kzalloc(sizeof(*adp), GFP_KERNEL);

        if (!adp)
                ...

> +	adp->table = trans->ctx.table;
> +	INIT_LIST_HEAD(&adp->list);
> +	list_add(&adp->list, adl);
> +found:
> +	adp->entries++;
> +	if (!adp->op || adp->op > trans->msg_type)
> +		adp->op = trans->msg_type;
> +}
> +
> +#define AUNFTABLENAMELEN (NFT_TABLE_MAXNAMELEN + 22)
> +
> +void nf_tables_commit_audit_log(struct list_head *adl, u32 generation) {
                                                                          ^
same thing here

> +	struct nft_audit_data *adp, *adn;
> +	char aubuf[AUNFTABLENAMELEN];
> +
> +	list_for_each_entry_safe(adp, adn, adl, list) {
> +		snprintf(aubuf, AUNFTABLENAMELEN, "%s:%u", adp->table->name,
> +			 generation);
> +		audit_log_nfcfg(aubuf, adp->table->family, adp->entries,
> +				nft2audit_op[adp->op], GFP_KERNEL);
> +		list_del(&adp->list);
> +		kfree(adp);
> +	}
> +}
> +
>  static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>  {
>  	struct nft_trans *trans, *next;
>  	struct nft_trans_elem *te;
>  	struct nft_chain *chain;
>  	struct nft_table *table;
> +	LIST_HEAD(adl);
>  	int err;
>  
>  	if (list_empty(&net->nft.commit_list)) {
> @@ -8206,12 +8173,15 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>  			}
>  			break;
>  		}
> +		nf_tables_commit_audit_collect(&adl, trans);
>  	}
>  
>  	nft_commit_notify(net, NETLINK_CB(skb).portid);
>  	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
>  	nf_tables_commit_release(net);
>  
> +	nf_tables_commit_audit_log(&adl, net->nft.base_seq);
> +

This looks more self-contained and nicer, thanks.
