Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DE73C433DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Feb 2021 23:43:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA75764E63
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Feb 2021 23:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbhBQXnV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Feb 2021 18:43:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48474 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233730AbhBQXnN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Feb 2021 18:43:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613605306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J3M2KhFv949MzTChyZ6whg+sl8JiaihVgRYmFFexUMY=;
        b=gJnF7y7W4PRgDZD4RiZdvdDcPI885OxvhDjyxPuSW14uPYXTqz5CiP8mm2oYWB419sS64i
        Yk92G5NEqQS3SHlruH2hYx28rGrnr+xbR4VCR2pksxY8bOcgc57G0fg5xemWQo1kAIYajC
        fnuS+HtLEfYvrmTAjMa+IkRTB/nfPf0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-jzJXKHZYOXi5LExsQ0q2iA-1; Wed, 17 Feb 2021 18:41:44 -0500
X-MC-Unique: jzJXKHZYOXi5LExsQ0q2iA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91A26BBEE2;
        Wed, 17 Feb 2021 23:41:42 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DC8F648A2;
        Wed, 17 Feb 2021 23:41:34 +0000 (UTC)
Date:   Wed, 17 Feb 2021 18:41:31 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, LKML <linux-kernel@vger.kernel.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, tgraf@infradead.org
Subject: Re: [PATCH ghak124 v3] audit: log nftables configuration change
 events
Message-ID: <20210217234131.GN3141668@madcap2.tricolour.ca>
References: <f9da8b5dbf2396b621c77c17b5b1123be5aa484e.1591275439.git.rgb@redhat.com>
 <20210211151606.GX3158@orbyte.nwl.cc>
 <CAHC9VhTNQW9d=8GCW-70vAEMh8-LXviP+JHFC2-YkuitokLLMQ@mail.gmail.com>
 <20210211202628.GP2015948@madcap2.tricolour.ca>
 <20210211220930.GC2766@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211220930.GC2766@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2021-02-11 23:09, Florian Westphal wrote:
> Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > I personally would notify once per transaction. This is easy and quick.
> > 
> > This was the goal.  iptables was atomic.  nftables appears to no longer
> > be so.  If I have this wrong, please show how that works.
> 
> nftables transactions are atomic, either the entire batch takes effect or not
> at all.
> 
> The audit_log_nfcfg() calls got added to the the nft monitor infra which
> is designed to allow userspace to follow the entire content of the
> transaction log.
> 
> So, if its just a 'something was changed' event that is needed all of
> them can be removed. ATM the audit_log_nfcfg() looks like this:
> 
>         /* step 3. Start new generation, rules_gen_X now in use. */
>         net->nft.gencursor = nft_gencursor_next(net);
> 
>         list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
>                 switch (trans->msg_type) {
>                 case NFT_MSG_NEWTABLE:
> 			audit_log_nfcfg();
> 			...
> 		case NFT_MSG_...
> 			audit_log_nfcfg();
> 	..
> 	       	}
> 
> which gives an audit_log for every single change in the batch.
> 
> So, if just a summary is needed a single audit_log_nfcfg()
> after 'step 3' and outside of the list_for_each_entry_safe() is all
> that is needed.

Ok, so it should not matter if it is before or after that
list_for_each_entry_safe(), which could be used to collect that summary.

> If a summary is wanted as well one could fe. count the number of
> transaction types in the batch, e.g. table adds, chain adds, rule
> adds etc. and then log a summary count instead.

The current fields are "table", "family", "entries", "op".

Could one batch change more than one table?  (I think it could?)

It appears it can change more than one family.
"family" is currently a single integer, so that might need to be changed
to a list, or something to indicate multi-family.

A batch can certainly change more than one chain, but that was already a
bonus.

"entries" would be the obvious place for the summary count.

Listing all the ops seems a bit onerous.  Is there a hierarchy to the
ops and if so, are they in that order in a batch or in nf_tables_commit()?
It seems I'd need to filter out the NFT_MSG_GET_* ops.


- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

