Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 301CCC433DB
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Mar 2021 19:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 095EE619C9
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Mar 2021 19:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhCWTmC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Mar 2021 15:42:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41501 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231326AbhCWTla (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Mar 2021 15:41:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616528489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GkZdetnJ/RGn+Z4pPWWz4Ny+F5nvWflbHDocWOrBQ3Y=;
        b=a05VLcJVX3Hbf7laemX1mTcR8IzqE5JNnVbjhco8h6k8sd9pA+jY+FaqfBUdu8Y4fSvRN0
        8VWmv7hXUbWRu+uLU8rEhF5ZvXHylGtXGu67ZWXkR5X8Dl29dxCfSiF6oQOaMtgNoQ7Hg/
        J6hyMeCSw/dR1F1r3MMJhRZrK6jyXt4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-FOOEddgPPD6lvPahttzEEQ-1; Tue, 23 Mar 2021 15:41:27 -0400
X-MC-Unique: FOOEddgPPD6lvPahttzEEQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9746B84BA40;
        Tue, 23 Mar 2021 19:41:25 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C5FD60BE5;
        Tue, 23 Mar 2021 19:41:17 +0000 (UTC)
Date:   Tue, 23 Mar 2021 15:41:15 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jones Desougi <jones.desougi+netfilter@gmail.com>,
        Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, tgraf@infradead.org,
        dan.carpenter@oracle.com
Subject: Re: [PATCH v2] audit: log nftables configuration change events once
 per table
Message-ID: <20210323194115.GA3112383@madcap2.tricolour.ca>
References: <2a6d8eb6058a6961cfb6439b31dcfadcce9596a8.1616445965.git.rgb@redhat.com>
 <20210322225747.GA24562@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322225747.GA24562@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2021-03-22 23:57, Pablo Neira Ayuso wrote:
> On Mon, Mar 22, 2021 at 04:49:04PM -0400, Richard Guy Briggs wrote:
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index c1eb5cdb3033..42ba44890523 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> [...]
> > @@ -8006,12 +7938,47 @@ static void nft_commit_notify(struct net *net, u32 portid)
> >  	WARN_ON_ONCE(!list_empty(&net->nft.notify_list));
> >  }
> >  
> > +void nf_tables_commit_audit_collect(struct list_head *adl,
> > +				    struct nft_trans *trans) {
> 
> nitpick: curly brace starts in the line.

Duh, whoops!  Brain fart.  Too much muckin' in other codebases...

> > +	struct nft_audit_data *adp;
> > +
> > +	list_for_each_entry(adp, adl, list) {
> > +		if (adp->table == trans->ctx.table)
> > +			goto found;
> > +	}
> > +	adp = kzalloc(sizeof(*adp), GFP_KERNEL);
> 
>         if (!adp)
>                 ...

This will need a bit more work since by the time this is called,
nf_tables_commit() is not prepared to accept any errors, so I'll need to
either ignore the error and continue, or allocate the table entries
before step 3.

> > +	adp->table = trans->ctx.table;
> > +	INIT_LIST_HEAD(&adp->list);
> > +	list_add(&adp->list, adl);
> > +found:
> > +	adp->entries++;
> > +	if (!adp->op || adp->op > trans->msg_type)
> > +		adp->op = trans->msg_type;
> > +}
> > +
> > +#define AUNFTABLENAMELEN (NFT_TABLE_MAXNAMELEN + 22)
> > +
> > +void nf_tables_commit_audit_log(struct list_head *adl, u32 generation) {
>                                                                           ^
> same thing here
> 
> > +	struct nft_audit_data *adp, *adn;
> > +	char aubuf[AUNFTABLENAMELEN];
> > +
> > +	list_for_each_entry_safe(adp, adn, adl, list) {
> > +		snprintf(aubuf, AUNFTABLENAMELEN, "%s:%u", adp->table->name,
> > +			 generation);
> > +		audit_log_nfcfg(aubuf, adp->table->family, adp->entries,
> > +				nft2audit_op[adp->op], GFP_KERNEL);
> > +		list_del(&adp->list);
> > +		kfree(adp);
> > +	}
> > +}
> > +
> >  static int nf_tables_commit(struct net *net, struct sk_buff *skb)
> >  {
> >  	struct nft_trans *trans, *next;
> >  	struct nft_trans_elem *te;
> >  	struct nft_chain *chain;
> >  	struct nft_table *table;
> > +	LIST_HEAD(adl);
> >  	int err;
> >  
> >  	if (list_empty(&net->nft.commit_list)) {
> > @@ -8206,12 +8173,15 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
> >  			}
> >  			break;
> >  		}
> > +		nf_tables_commit_audit_collect(&adl, trans);
> >  	}
> >  
> >  	nft_commit_notify(net, NETLINK_CB(skb).portid);
> >  	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
> >  	nf_tables_commit_release(net);
> >  
> > +	nf_tables_commit_audit_log(&adl, net->nft.base_seq);
> > +
> 
> This looks more self-contained and nicer, thanks.
> 
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://listman.redhat.com/mailman/listinfo/linux-audit

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

