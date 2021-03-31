Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD785C433ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 20:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F0F661073
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 20:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbhCaU41 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 16:56:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55084 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232290AbhCaUz4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 16:55:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617224156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mT4tluRBtnUt1Hht/N0b0oYTLjqFC49X/aal5xVWArY=;
        b=YGGyfCdBv2l3LLgVE60v/J2rc5FG/1sm3s0CR2j2DmyZncOj9acZg4/qiaFXyaLf2+Tnmo
        wr4urRmzXcbYomL40bm/kkyUnas55M9bWqrvN+/aOgUr+xkxpyS04xZAkSmLIfeKnh3+Uz
        cyBD+EOjI9/0CqcravghWiH4NA0XHzs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-4BfBflQfNcWGzJsvFQzhxQ-1; Wed, 31 Mar 2021 16:55:52 -0400
X-MC-Unique: 4BfBflQfNcWGzJsvFQzhxQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 162188189F1;
        Wed, 31 Mar 2021 20:55:50 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CEC3B19C59;
        Wed, 31 Mar 2021 20:55:40 +0000 (UTC)
Date:   Wed, 31 Mar 2021 16:55:38 -0400
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
Message-ID: <20210331205538.GJ3112383@madcap2.tricolour.ca>
References: <28de34275f58b45fd4626a92ccae96b6d2b4e287.1616702731.git.rgb@redhat.com>
 <20210331204635.GA4634@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331204635.GA4634@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2021-03-31 22:46, Pablo Neira Ayuso wrote:
> On Fri, Mar 26, 2021 at 01:38:59PM -0400, Richard Guy Briggs wrote:
> > @@ -8006,12 +7966,65 @@ static void nft_commit_notify(struct net *net, u32 portid)
> >  	WARN_ON_ONCE(!list_empty(&net->nft.notify_list));
> >  }
> >  
> > +static int nf_tables_commit_audit_alloc(struct list_head *adl,
> > +				 struct nft_table *table)
> > +{
> > +	struct nft_audit_data *adp;
> > +
> > +	list_for_each_entry(adp, adl, list) {
> > +		if (adp->table == table)
> > +			return 0;
> > +	}
> > +	adp = kzalloc(sizeof(*adp), GFP_KERNEL);
> > +	if (!adp)
> > +		return -ENOMEM;
> > +	adp->table = table;
> > +	INIT_LIST_HEAD(&adp->list);
> 
> This INIT_LIST_HEAD is not required for an object that is going to be
> inserted into the 'adl' list.
> 
> > +	list_add(&adp->list, adl);
> 
> If no objections, I'll amend this patch. I'll include the UAF fix and
> remove this unnecessary INIT_LIST_HEAD.

Ok, so it is harmless other than being code noise and overhead, thanks again.

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

