Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61561C433ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 20:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2062760BBB
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 20:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhCaUxr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 16:53:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55750 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232771AbhCaUxk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 16:53:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617224019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xgbyKFWQqZbg2Gy7gmQQyJMfhuaX+Jv3XqHiA6Dpe28=;
        b=a+V1qjD9hY9ijGco8BiYqvokd18J2F0tz/8blPy8GGoE+Rh4xERfYEiVDcawomwpjWFa0J
        +PNBIoeIjvA/FPmf0M/+uSC0x9+YmAIZI05jCen/MTLg/GdrdpVK2rFm9h5AajF7Fk5Dh6
        +Sn8sg5Rh2NYkqEPhAdHb2ZPGT4ldnA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-sgfKZxsEP7qAfqAt2QBDkQ-1; Wed, 31 Mar 2021 16:53:25 -0400
X-MC-Unique: sgfKZxsEP7qAfqAt2QBDkQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38B71801814;
        Wed, 31 Mar 2021 20:53:23 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 717156A8FA;
        Wed, 31 Mar 2021 20:53:13 +0000 (UTC)
Date:   Wed, 31 Mar 2021 16:53:10 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        twoerner@redhat.com, tgraf@infradead.org, dan.carpenter@oracle.com,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
Subject: Re: [PATCH v5] audit: log nftables configuration change events once
 per table
Message-ID: <20210331205310.GA3141668@madcap2.tricolour.ca>
References: <28de34275f58b45fd4626a92ccae96b6d2b4e287.1616702731.git.rgb@redhat.com>
 <20210331202230.GA4109@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331202230.GA4109@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2021-03-31 22:22, Pablo Neira Ayuso wrote:
> On Fri, Mar 26, 2021 at 01:38:59PM -0400, Richard Guy Briggs wrote:
> > Reduce logging of nftables events to a level similar to iptables.
> > Restore the table field to list the table, adding the generation.
> > 
> > Indicate the op as the most significant operation in the event.
> 
> There's a UAF, Florian reported. I'm attaching an incremental fix.
> 
> nf_tables_commit_audit_collect() refers to the trans object which
> might have been already released.

Got it.  Thanks Pablo.  I didn't see it when running nft-test.py Where
was it reported?  Here I tried to stay out of the way by putting that
call at the end of the loop but that was obviously a mistake in
hindsight.  :-)

> commit e4d272948d25b66d86fc241cefd95281bfb1079e
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:   Wed Mar 31 22:19:51 2021 +0200
> 
>     netfilter: nf_tables: use-after-free
>     
>     Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 5dd4bb7cabf5..01674c0d9103 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -8063,6 +8063,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>  	net->nft.gencursor = nft_gencursor_next(net);
>  
>  	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
> +		nf_tables_commit_audit_collect(&adl, trans->ctx.table,
> +					       trans->msg_type);
>  		switch (trans->msg_type) {
>  		case NFT_MSG_NEWTABLE:
>  			if (nft_trans_table_update(trans)) {
> @@ -8211,8 +8213,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>  			}
>  			break;
>  		}
> -		nf_tables_commit_audit_collect(&adl, trans->ctx.table,
> -					       trans->msg_type);
>  	}
>  
>  	nft_commit_notify(net, NETLINK_CB(skb).portid);


- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

